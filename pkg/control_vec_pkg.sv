package control_vec_pkg;
    import d_stage_types_pkg::*;

    control_vec_t control_vec_arr[] = '{
        '{
            inst: 32'h01008503,
            rs1: 5'd1,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, ADD},
            m_con: {SIGNED, W_NONE, R_BYTE, RWRITE_MEM},
            w_con: {1'b1, 5'd10},
            desc: "lb x10, 16(x1)"
        },
        '{
            inst: 32'h01009583,
            rs1: 5'd1,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, ADD},
            m_con: {SIGNED, W_NONE, R_HALF, RWRITE_MEM},
            w_con: {1'b1, 5'd11},
            desc: "lh x11, 16(x1)"
        },
        '{
            inst: 32'h0100a603,
            rs1: 5'd1,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, ADD},
            m_con: {SIGNED, W_NONE, R_WORD, RWRITE_MEM},
            w_con: {1'b1, 5'd12},
            desc: "lw x12, 16(x1)"
        },
        '{
            inst: 32'h0100c503,
            rs1: 5'd1,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, ADD},
            m_con: {UNSIGNED, W_NONE, R_BYTE, RWRITE_MEM},
            w_con: {1'b1, 5'd10},
            desc: "lbu x10, 16(x1)"
        },
        '{
            inst: 32'h0100d583,
            rs1: 5'd1,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, ADD},
            m_con: {UNSIGNED, W_NONE, R_HALF, RWRITE_MEM},
            w_con: {1'b1, 5'd11},
            desc: "lhu x11, 16(x1)"
        },
        '{
            inst: 32'h01010093,
            rs1: 5'd2,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, ADD},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd1},
            desc: "addi x1, x2, 16"
        },
        '{
            inst: 32'h01021193,
            rs1: 5'd4,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, SLL},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd3},
            desc: "slli x3, x4, 16"
        },
        '{
            inst: 32'h01032293,
            rs1: 5'd6,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, SLT},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd5},
            desc: "slti x5, x6, 16"
        },
        '{
            inst: 32'h01043393,
            rs1: 5'd8,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, SLTU},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd7},
            desc: "sltiu x7, x8, 16"
        },
        '{
            inst: 32'h01054493,
            rs1: 5'd10,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, XOR},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd9},
            desc: "xori x9, x10, 16"
        },
        '{
            inst: 32'h01065593,
            rs1: 5'd12,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, SRL},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd11},
            desc: "srli x11, x12, 16"
        },
        '{
            inst: 32'h41075693,
            rs1: 5'd14,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, SRA},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd13},
            desc: "srai x13, x14, 16"
        },
        '{
            inst: 32'h01086793,
            rs1: 5'd16,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, OR},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd15},
            desc: "ori x15, x16, 16"
        },
        '{
            inst: 32'h01097893,
            rs1: 5'd18,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, AND},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd17},
            desc: "andi x17, x18, 16"
        },
        '{
            inst: 32'h00010097,
            rs1: 1'bx,
            rs2: 1'bx,
            imm_type: U_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_PC, ADD},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd1},
            desc: "auipc x1, 16"
        },
        '{
            inst: 32'h00a08823,
            rs1: 5'd1,
            rs2: 5'd10,
            imm_type: S_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, ADD},
            m_con: {1'bx, W_BYTE, R_NONE, 1'bx},
            w_con: {1'b0, 5'dx},
            desc: "sb x10, 16(x1)"
        },
        '{
            inst: 32'h00b09823,
            rs1: 5'd1,
            rs2: 5'd11,
            imm_type: S_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, ADD},
            m_con: {1'bx, W_HALF, R_NONE, 1'bx},
            w_con: {1'b0, 5'dx},
            desc: "sh x11, 16(x1)"
        },
        '{
            inst: 32'h00c0a823,
            rs1: 5'd1,
            rs2: 5'd12,
            imm_type: S_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_IMM, OPR1_RS1, ADD},
            m_con: {1'bx, W_WORD, R_NONE, 1'bx},
            w_con: {1'b0, 5'dx},
            desc: "sw x12, 16(x1)"
        },
        '{
            inst: 32'h003100b3,
            rs1: 5'd2,
            rs2: 5'd3,
            imm_type: 1'bx,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, ADD},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd1},
            desc: "add x1, x2, x3"
        },
        '{
            inst: 32'h40628233,
            rs1: 5'd5,
            rs2: 5'd6,
            imm_type: 1'bx,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, SUB},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd4},
            desc: "sub x4, x5, x6"
        },
        '{
            inst: 32'h009413b3,
            rs1: 5'd8,
            rs2: 5'd9,
            imm_type: 1'bx,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, SLL},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd7},
            desc: "sll x7, x8, x9"
        },
        '{
            inst: 32'h00c5a533,
            rs1: 5'd11,
            rs2: 5'd12,
            imm_type: 1'bx,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, SLT},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd10},
            desc: "slt x10, x11, x12"
        },
        '{
            inst: 32'h00f736b3,
            rs1: 5'd14,
            rs2: 5'd15,
            imm_type: 1'bx,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, SLTU},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd13},
            desc: "sltu x13, x14, x15"
        },
        '{
            inst: 32'h0128c833,
            rs1: 5'd17,
            rs2: 5'd18,
            imm_type: 1'bx,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, XOR},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd16},
            desc: "xor x16, x17, x18"
        },
        '{
            inst: 32'h015a59b3,
            rs1: 5'd20,
            rs2: 5'd21,
            imm_type: 1'bx,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, SRL},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd19},
            desc: "srl x19, x20, x21"
        },
        '{
            inst: 32'h418bdb33,
            rs1: 5'd23,
            rs2: 5'd24,
            imm_type: 1'bx,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, SRA},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd22},
            desc: "sra x22, x23, x24"
        },
        '{
            inst: 32'h01bd6cb3,
            rs1: 5'd26,
            rs2: 5'd27,
            imm_type: 1'bx,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, OR},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd25},
            desc: "or x25, x26, x27"
        },
        '{
            inst: 32'h01eefe33,
            rs1: 5'd29,
            rs2: 5'd30,
            imm_type: 1'bx,
            e_con: {1'bx, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, AND},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd28},
            desc: "and x28, x29, x30"
        },
        '{
            inst: 32'hfffff0b7,
            rs1: 1'bx,
            rs2: 1'bx,
            imm_type: U_TYPE,
            e_con: {1'bx, NO_JUMP, WRITE_IMM, 1'bx, 1'bx, 1'bx},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_RESULT},
            w_con: {1'b1, 5'd1},
            desc: "lui x1, 0xfffff"
        },
        '{
            inst: 32'h02208063,
            rs1: 5'd1,
            rs2: 5'd2,
            imm_type: B_TYPE,
            e_con: {BR_IMM, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, BEQ},
            m_con: {1'bx, W_NONE, R_NONE, 1'bx},
            w_con: {1'b0, 5'dx},
            desc: "beq x1, x2, 32"
        },
        '{
            inst: 32'h04419063,
            rs1: 5'd3,
            rs2: 5'd4,
            imm_type: B_TYPE,
            e_con: {BR_IMM, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, BNE},
            m_con: {1'bx, W_NONE, R_NONE, 1'bx},
            w_con: {1'b0, 5'dx},
            desc: "bne x3, x4, 64"
        },
        '{
            inst: 32'h0862c063,
            rs1: 5'd5,
            rs2: 5'd6,
            imm_type: B_TYPE,
            e_con: {BR_IMM, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, BLT},
            m_con: {1'bx, W_NONE, R_NONE, 1'bx},
            w_con: {1'b0, 5'dx},
            desc: "blt x5, x6, 128"
        },
        '{
            inst: 32'h1083d063,
            rs1: 5'd7,
            rs2: 5'd8,
            imm_type: B_TYPE,
            e_con: {BR_IMM, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, BGE},
            m_con: {1'bx, W_NONE, R_NONE, 1'bx},
            w_con: {1'b0, 5'dx},
            desc: "bge x7, x8, 256"
        },
        '{
            inst: 32'h00a4e263,
            rs1: 5'd9,
            rs2: 5'd10,
            imm_type: B_TYPE,
            e_con: {BR_IMM, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, BLTU},
            m_con: {1'bx, W_NONE, R_NONE, 1'bx},
            w_con: {1'b0, 5'dx},
            desc: "bltu x9, x10, 16"
        },
        '{
            inst: 32'h00c5f463,
            rs1: 5'd11,
            rs2: 5'd12,
            imm_type: B_TYPE,
            e_con: {BR_IMM, NO_JUMP, WRITE_ALU, OPR2_RS2, OPR1_RS1, BGEU},
            m_con: {1'bx, W_NONE, R_NONE, 1'bx},
            w_con: {1'b0, 5'dx},
            desc: "bgeu x11, x12, 8"
        },
        '{
            inst: 32'h080100e7,
            rs1: 5'd2,
            rs2: 1'bx,
            imm_type: I_TYPE,
            e_con: {1'bx, JUMP, WRITE_ALU, OPR2_IMM, OPR1_PC, ADD},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_PC},
            w_con: {1'b1, 5'd1},
            desc: "jalr x1, 128(x2)"
        },
        '{
            inst: 32'h100000ef,
            rs1: 1'bx,
            rs2: 1'bx,
            imm_type: J_TYPE,
            e_con: {1'bx, JUMP, WRITE_ALU, OPR2_IMM, OPR1_PC, ADD},
            m_con: {1'bx, W_NONE, R_NONE, RWRITE_PC},
            w_con: {1'b1, 5'd1},
            desc: "jal x1, 256"
        }

    };
endpackage
