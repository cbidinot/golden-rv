`timescale 1ns / 1ns

module controller (
    input  [31:0] inst,
    output [ 2:0] d_con,
    output [ 8:0] e_con,
    output [ 6:0] m_con,
    output [ 5:0] w_con
);

    wire [6:0] opcode, funct7;
    wire [2:0] funct3;

    assign opcode = inst[6:0];
    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];

    // D stage control
    reg [2:0] imm_type;
    assign d_con = imm_type;

    // E stage control
    reg [3:0] alu_opcode;
    reg alu_pc, alu_imm, write_imm, jalx;
    assign e_con[3:0] = alu_opcode;
    assign e_con[4]   = alu_pc;
    assign e_con[5]   = alu_imm;
    assign e_con[6]   = write_imm;
    assign e_con[7]   = jalx;
    assign e_con[8]   = branch_target_sel;

    // M stage control
    reg [1:0] reg_write_sel, mem_read_en;
    reg branch_target_sel, mem_write_en, mem_sign;
    assign m_con[1:0] = reg_write_sel;
    assign m_con[3:2] = mem_read_en;
    assign m_con[5:4] = mem_write_en;
    assign m_con [6] = mem_sign;

    // W Stage control
    reg regfile_we;
    assign w_con[4:0] = inst[11:7];
    assign w_con[5] = regfile_we;


    always @(*) begin
        case (opcode)
            7'b0000011: begin  // loads
                imm_type   = 3'b000;
                alu_opcode = 0;
                alu_pc = 0;
                alu_imm = 1;
                write_imm = 0;
                jalx = 0;
                reg_write_sel = 2'b10;
                branch_target_sel = 0;
                mem_write_en = 0;
                regfile_we = 1;
                case (funct3)
                    3'b000: begin // lb
                        mem_read_en = 2'b01;
                        mem_sign = 1;
                    end
                    3'b001: begin // lh
                        mem_read_en = 2'b10;
                        mem_sign = 1;
                    end
                    3'b010: begin // lw
                        mem_read_en = 2'b11;
                        mem_sign = 1;
                    end
                    3'b100: begin // lbu
                        mem_read_en = 2'b01;
                        mem_sign = 0;
                    end
                    3'b101: begin // lhu
                        mem_read_en = 2'b10;
                        mem_sign = 0;
                    end
                    default: begin
                        mem_read_en = 0;
                        mem_sign = 0;
                    end
                endcase
            end

            7'b0001111: begin  // fences
                imm_type   = 0;
                alu_opcode = 0;
                alu_pc = 0;
                alu_imm = 0;
                write_imm = 0;
                jalx = 0;
                reg_write_sel = 0;
                branch_target_sel = 0;
                mem_read_en = 0;
                mem_write_en = 0;
                regfile_we = 0;
                mem_sign = 0;
                case (funct3)
                    3'b000:  ;  // fence
                    3'b001:  ;  // fence.i
                    default: ;
                endcase
            end

            7'b0010011: begin  // ALU imm instructions
                imm_type = 3'b000;
                alu_pc = 0;
                alu_imm = 1;
                write_imm = 0;
                jalx = 0;
                reg_write_sel = 2'b01;
                branch_target_sel = 0;
                mem_read_en = 0;
                mem_write_en = 0;
                regfile_we = 1;
                mem_sign = 0;

                case (funct3)
                    3'b000: alu_opcode = 0;  // addi
                    3'b001: alu_opcode = 5;  // slli
                    3'b010: alu_opcode = 8;  // slti
                    3'b011: alu_opcode = 9;  // sltiu
                    3'b100: alu_opcode = 4;  // xori
                    3'b101:
                    case (funct7)
                        7'b0000000: alu_opcode = 7;  // srli
                        7'b0100000: alu_opcode = 6;  // srai
                        default: alu_opcode = 0;
                    endcase
                    3'b110: alu_opcode = 3;  // ori
                    3'b111: alu_opcode = 2;  // andi
                endcase
            end

            7'b0010111: begin  // auipc
                imm_type   = 3'b011;
                alu_opcode = 0;
                alu_pc = 1;
                alu_imm = 1;
                write_imm = 0;
                jalx = 0;
                reg_write_sel = 2'b01;
                branch_target_sel = 0;
                mem_read_en = 0;
                mem_write_en = 0;
                regfile_we = 1;
                mem_sign = 0;
            end

            7'b0100011: begin  // stores
                imm_type   = 3'b001;
                alu_opcode = 0;
                alu_pc = 0;
                alu_imm = 1;
                write_imm = 0;
                jalx = 0;
                reg_write_sel = 0;
                branch_target_sel = 0;
                mem_read_en = 0;
                regfile_we = 0;
                mem_sign = 1;
                case (funct3)
                    3'b000: mem_write_en = 2'b11; // sb
                    3'b001: mem_write_en = 2'b10; // sh
                    3'b010: mem_write_en = 2'b01; // sw
                    default: mem_write_en = 0;
                endcase
            end

            7'b0110011: begin  // ALU R instructions
                imm_type = 0;
                alu_pc = 0;
                alu_imm = 0;
                write_imm = 0;
                jalx = 0;
                reg_write_sel = 2'b01;
                branch_target_sel = 0;
                mem_read_en = 0;
                mem_write_en = 0;
                regfile_we = 1;
                mem_sign = 0;
                case (funct3)
                    3'b000:
                    case (funct7)
                        7'b0000000: alu_opcode = 0;  // add
                        7'b0100000: alu_opcode = 1;  // sub
                        default: alu_opcode = 0;
                    endcase
                    3'b001: alu_opcode = 5;  // sll
                    3'b010: alu_opcode = 8;  // slt
                    3'b011: alu_opcode = 9;  // sltu
                    3'b100: alu_opcode = 4;  // xor
                    3'b101:
                    case (funct7)
                        7'b0000000: alu_opcode = 7;  // srl
                        7'b0100000: alu_opcode = 6;  // sra
                        default: alu_opcode = 0;
                    endcase
                    3'b110: alu_opcode = 3;  // or
                    3'b111: alu_opcode = 2;  // and
                endcase
            end

            7'b0110111: begin  // lui
                imm_type   = 3'b011;
                alu_opcode = 0;
                alu_pc = 0;
                alu_imm = 0;
                write_imm = 1;
                jalx = 0;
                reg_write_sel = 2'b01;
                branch_target_sel = 0;
                mem_read_en = 0;
                mem_write_en = 0;
                regfile_we = 1;
                mem_sign = 0;
            end

            7'b1100011: begin  // branches
                imm_type = 3'b010;
                alu_pc = 0;
                alu_imm = 0;
                write_imm = 0;
                jalx = 0;
                reg_write_sel = 0;
                branch_target_sel = 1;
                mem_read_en = 0;
                mem_write_en = 0;
                regfile_we = 0;
                mem_sign = 0;
                case (funct3)
                    3'b000:  alu_opcode = 4'ha;  // beq
                    3'b001:  alu_opcode = 4'hb;  // bne
                    3'b100:  alu_opcode = 4'he;  // blt
                    3'b101:  alu_opcode = 4'hc;  // bge
                    3'b110:  alu_opcode = 4'hf;  // bltu
                    3'b111:  alu_opcode = 4'hd;  // bgeu
                    default: alu_opcode = 0;
                endcase
            end

            7'b1100111: begin  // jalr
                imm_type   = 3'b000;
                alu_opcode = 0;
                alu_pc = 0;
                alu_imm = 1;
                write_imm = 0;
                jalx = 1;
                reg_write_sel = 2'b00;
                branch_target_sel = 0;
                mem_read_en = 0;
                mem_write_en = 0;
                regfile_we = 1;
                mem_sign = 0;
            end

            7'b1101111: begin  // jal
                imm_type   = 3'b100;
                alu_opcode = 0;
                alu_pc = 0;
                alu_imm = 0;
                write_imm = 0;
                jalx = 1;
                reg_write_sel = 2'b00;
                branch_target_sel = 0;
                mem_read_en = 0;
                mem_write_en = 0;
                regfile_we = 1;
                mem_sign = 0;
            end

            7'b1110011: begin  // system instructions
                imm_type   = 3'b000;
                alu_opcode = 0;
                alu_pc = 0;
                alu_imm = 0;
                write_imm = 0;
                jalx = 0;
                reg_write_sel = 0;
                branch_target_sel = 0;
                mem_read_en = 0;
                mem_write_en = 0;
                regfile_we = 0;
                mem_sign = 0;
                case (funct3)
                    3'b000:
                    case (funct7)
                        7'b0000000: ;  // ecall
                        7'b0000001: ;  // ebreak
                        default: ;
                    endcase
                    3'b001: ;  // CSRRW
                    3'b010: ;  // CSRRS
                    3'b011: ;  // CSRRC
                    3'b101: ;  // CSRRWI
                    3'b110: ;  // CSRRSI
                    3'b111: ;  // CSRRCI
                    default: ;
                endcase
            end

            default begin
                imm_type   = 3'b000;
                alu_opcode = 0;
                alu_pc = 0;
                alu_imm = 0;
                write_imm = 0;
                jalx = 0;
                reg_write_sel = 0;
                branch_target_sel = 0;
                mem_read_en = 0;
                mem_write_en = 0;
                regfile_we = 0;
                mem_sign = 0;
            end
        endcase
    end



endmodule
