`timescale 1ns / 1ns
import d_stage_types_pkg::*;
import control_vec_pkg::*;

    interface d_stage_if (
        input logic clk
    );
        logic flush;
        logic [31:0] inst;
        logic [31:0] rs1_out;
        logic [31:0] rs2_out;
        logic [31:0] pc;
        logic [31:0] opr1;
        logic [31:0] opr2;
        imm_type_t imm_type;
        logic [31:0] imm;
        logic [31:0] pc_out;
        logic [4:0] rs1;
        logic [4:0] rs2;
        w_con_t w_con;
        e_con_t e_con;
        m_con_t m_con;
        logic [4:0] de_rs1;
        logic [4:0] de_rs2;
        logic stall;
        default clocking cb @(posedge clk);
            default input #2;
            input #7 rs1;
            input #7 rs2;
            input opr1;
            input opr2;
            input #5 imm_type;
            input imm;
            input pc_out;
            input de_rs1;
            input de_rs2;
            input w_con;
            input m_con;
            input e_con;
            output inst;
            output #4 rs1_out;
            output #4 rs2_out;
            output pc;
        endclocking
    endinterface

module d_stage_tb ();

    logic clk = 0;
    always #5 clk = ~clk;
    d_stage_if if0 (clk);

    d_stage uut (
        .clk(if0.clk),
        .flush(if0.flush),
        .inst(if0.inst),
        .rs1_out(if0.rs1_out),
        .rs2_out(if0.rs2_out),
        .pc(if0.pc),
        .opr1(if0.opr1),
        .opr2(if0.opr2),
        .imm(if0.imm),
        .pc_out(if0.pc_out),
        .rs1(if0.rs1),
        .rs2(if0.rs2),
        .w_con(if0.w_con),
        .e_con(if0.e_con),
        .m_con(if0.m_con),
        .de_rs1(if0.de_rs1),
        .de_rs2(if0.de_rs2),
        .stall(if0.stall)
    );
    assign if0.imm_type = uut.imm_type;

    function automatic bit check_con(input logic [31:0] con, input logic [31:0] expected, int len);
        for (int i = 0; i < len; i++) begin
            if (expected[i] !== 1'bx && expected[i] != con[i]) return 0;
        end
        return 1;
    endfunction

    task automatic check_control(input control_vec_t vec);
        if0.cb.inst <= vec.inst;
        @(if0.cb);
        if (vec.rs1)
            assert (vec.rs1 == if0.cb.rs1)
            else $error("[%s] rs1 = %0d (expected %0d)", vec.desc, if0.cb.rs1, vec.rs1);
        if (vec.rs2)
            assert (vec.rs2 == if0.cb.rs2)
            else $error("[%s] rs2 = %0d (expected %0d)", vec.desc, if0.cb.rs2, vec.rs2);
        // D CON
        if (vec.imm_type)
            assert (vec.imm_type == if0.cb.imm_type)
            else
                $error("[%s] imm_type = %b (expected %b)", vec.desc, if0.cb.imm_type, vec.imm_type);
        @(if0.cb);
        // E CON
        assert (check_con(if0.cb.e_con, vec.e_con, $bits(e_con_t)))
        else $error("[%s] e_con = %b (expected %b)", vec.desc, if0.cb.e_con, vec.e_con);
        // M CON
        assert (check_con(if0.cb.m_con, vec.m_con, $bits(m_con_t)))
        else $error("[%s] m_con = %b (expected %b)", vec.desc, if0.cb.m_con, vec.m_con);
        // W CON
        assert (check_con(if0.cb.w_con, vec.w_con, $bits(w_con_t)))
        else $error("[%s] w_con = %b (expected %b)", vec.desc, if0.cb.w_con, vec.w_con);
    endtask

    initial begin
        @(if0.cb);
        foreach (control_vec_arr[i]) check_control(control_vec_arr[i]);
        $stop;
    end

endmodule
