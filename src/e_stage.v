`timescale 1ns / 1ns

module e_stage (
    input clk,
    input [31:0] opr1,
    input [31:0] opr2,
    input [31:0] imm,
    input [31:0] pc,
    input [8:0] e_con,
    input [6:0] m_con_in,
    input [5:0] w_con_in,
    input em_regfile_we,
    input [4:0] em_rd,
    input mw_regfile_we,
    input [4:0] mw_rd,
    input [4:0] rs1,
    input [4:0] rs2,
    input [31:0] em_data,
    input [31:0] mw_data,
    output reg branch,
    output reg [31:0] alu_result,
    output reg [31:0] branch_target,
    output reg [31:0] write_data,
    output reg [31:0] pc_out,
    output reg [5:0] w_con_out,
    output reg [6:0] m_con_out,
    output reg [4:0] em_rs2
);

    wire [3:0] alu_opcode;
    wire alu_pc, alu_imm, branch_wire, write_imm, jalx, branch_target_sel;
    wire [1:0] forward1, forward2;
    wire [31:0] result_wire;
    reg [31:0] operand1, operand2, opr1_wire, opr2_wire;

    assign alu_opcode = e_con[3:0];
    assign alu_pc = e_con[4];
    assign alu_imm = e_con[5];
    assign write_imm = e_con[6];
    assign jalx = e_con[7];
    assign branch_target_sel = e_con[8];

    forwarding_unit forwarding_unit_0 (
        .em_regfile_we(em_regfile_we),
        .em_rd(em_rd),
        .mw_regfile_we(mw_regfile_we),
        .mw_rd(mw_rd),
        .rs1(rs1),
        .rs2(rs2),
        .forward1(forward1),
        .forward2(forward2)
    );

    always @(*) begin
        case (forward1)
            2'b00: opr1_wire = opr1;
            2'b10: opr1_wire = em_data;
            2'b01: opr1_wire = mw_data;
            default opr1_wire = opr1;
        endcase
        case (forward2)
            2'b00: opr2_wire = opr2;
            2'b10: opr2_wire = em_data;
            2'b01: opr2_wire = mw_data;
            default: opr2_wire = opr2;
        endcase
        if (alu_pc) operand1 = pc;
        else operand1 = opr1_wire;
        if (alu_imm) operand2 = imm;
        else operand2 = opr2_wire;
        // branches
        branch = jalx | branch_wire;
        if (branch_target_sel) branch_target = result_wire;
        else branch_target = imm + pc;
    end

    alu alu_0 (
        .op_code (alu_opcode),
        .operand1(operand1),
        .operand2(operand2),
        .result  (result_wire),
        .branch  (branch_wire)
    );

    always @(posedge clk) begin
        m_con_out <= m_con_in;
        w_con_out <= w_con_in;
        write_data <= opr2_wire;
        pc_out <= pc;
        em_rs2 <= rs2;
        if (write_imm) alu_result <= imm;
        else alu_result <= result_wire;
    end

endmodule
