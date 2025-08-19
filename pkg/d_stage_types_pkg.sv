package d_stage_types_pkg;

    typedef enum logic [2:0] {
        I_TYPE = 3'b000,
        S_TYPE = 3'b001,
        B_TYPE = 3'b010,
        U_TYPE = 3'b011,
        J_TYPE = 3'b100
    } imm_type_t;

    typedef enum logic [3:0] {
        ADD  = 4'h0,
        SUB  = 4'h1,
        AND  = 4'h2,
        OR   = 4'h3,
        XOR  = 4'h4,
        SLL  = 4'h5,
        SRA  = 4'h6,
        SRL  = 4'h7,
        SLT  = 4'h8,
        SLTU = 4'h9,
        BEQ  = 4'ha,
        BNE  = 4'hb,
        BGE  = 4'hc,
        BGEU = 4'hd,
        BLT  = 4'he,
        BLTU = 4'hf
    } alu_opcode_t;

    typedef enum logic {
        OPR1_RS1,
        OPR1_PC
    } alu_pc_t;

    typedef enum logic {
        OPR2_RS2,
        OPR2_IMM
    } alu_imm_t;

    typedef enum logic {
        WRITE_ALU,
        WRITE_IMM
    } write_imm_t;

    typedef enum logic {
        NO_JUMP,
        JUMP
    } jalx_t;

    typedef enum logic {
        BR_ALU,
        BR_IMM
    } branch_target_sel_t;

    typedef enum logic [1:0] {
        RWRITE_PC = 2'b00,
        RWRITE_RESULT = 2'b01,
        RWRITE_MEM = 2'b10
    } reg_write_sel_t;

    typedef enum logic [1:0] {
        W_WORD = 2'b11,
        W_HALF = 2'b10,
        W_BYTE = 2'b01,
        W_NONE = 2'b00
    } mem_write_en_t;

    typedef enum logic [1:0] {
        R_WORD = 2'b11,
        R_HALF = 2'b10,
        R_BYTE = 2'b01,
        R_NONE = 2'b00
    } mem_read_en_t;

    typedef enum logic {
        UNSIGNED,
        SIGNED
    } mem_sign_t;

    typedef struct packed {
        branch_target_sel_t branch_target_sel;
        jalx_t jalx;
        write_imm_t write_imm;
        alu_imm_t alu_imm;
        alu_pc_t alu_pc;
        alu_opcode_t alu_op;
    } e_con_t;

    typedef struct packed {
        mem_sign_t mem_sign;
        mem_write_en_t mem_write_en;
        mem_read_en_t mem_read_en;
        reg_write_sel_t reg_write_sel;
    } m_con_t;

    typedef struct packed {
        logic regfile_we;
        logic [4:0] rd;
    } w_con_t;

    typedef struct {
        logic [31:0] inst;
        logic [4:0] rs1;
        logic [4:0] rs2;
        imm_type_t imm_type;
        e_con_t e_con;
        m_con_t m_con;
        w_con_t w_con;
        string desc;
    } control_vec_t;

endpackage
