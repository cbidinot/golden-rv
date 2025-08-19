`timescale 1ns / 1ns

module d_stage (
    input clk,
    input flush,
    input [31:0] inst,
    input [31:0] rs1_out,
    input [31:0] rs2_out,
    input [31:0] pc,
    output reg [31:0] opr1,
    output reg [31:0] opr2,
    output reg [31:0] imm,
    output reg [31:0] pc_out,
    output [4:0] rs1,
    output [4:0] rs2,
    output reg [5:0] w_con,
    output reg [8:0] e_con,
    output reg [6:0] m_con,
    output reg [4:0] de_rs1,
    output reg [4:0] de_rs2,
    output stall
);

    wire [2:0] imm_type;
    wire [8:0] e_con_wire;
    wire [6:0] m_con_wire;
    wire [5:0] w_con_wire;
    wire [31:0] imm_wire;

    assign rs1 = inst[19:15];
    assign rs2 = inst[24:20];


    controller controller_0 (
        .inst (inst),
        .d_con(imm_type),
        .e_con(e_con_wire),
        .m_con(m_con_wire),
        .w_con(w_con_wire)
    );

    hazard_unit hazard_detector (
        .de_mem_read_en(w_con[5]),
        .rs2_valid(~e_con_wire[5]),
        .de_rd(w_con[4:0]),
        .rs1(rs1),
        .rs2(rs2),
        .stall(stall)
    );

    imm_gen imm_generator (
        .inst(inst),
        .imm_type(imm_type),
        .imm(imm_wire)
    );

    always @(posedge clk) begin
        if (stall | flush) begin
            e_con <= 0;
            m_con <= 0;
            w_con <= 0;
        end else begin
            e_con <= e_con_wire;
            m_con <= m_con_wire;
            w_con <= w_con_wire;
        end
        opr1 <= rs1_out;
        opr2 <= rs2_out;
        imm <= imm_wire;
        pc_out <= pc;
        de_rs1 <= rs1;
        de_rs2 <= rs2;
    end

endmodule
