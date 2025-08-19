`timescale 1ns / 1ns

module datapath (
    input clk,
    input [31:0] data_in,
    input [31:0] inst_in,
    output [1:0] read_en,
    output [1:0] write_en,
    output [31:0] data_addr,
    output reg [31:0] inst_addr,
    output reg [31:0] data_out
);
    // Regfile

    wire regfile_we;
    wire [4:0] rs1, rs2, rd;
    wire [31:0] rd_in, rs1_out, rs2_out;

    reg_file regfile (
        .clk(clk),
        .we(regfile_we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .rd_in(rd_in),
        .rs1_out(rs1_out),
        .rs2_out(rs2_out)
    );


    // F Stage
    wire pc_sel;
    reg [31:0] pc = 0, inst_reg, pc_wire, fd_pc;

    always @(posedge clk) begin
        if (branch) begin
            pc <= branch_target + 4;
            inst_reg <= inst_in;
            fd_pc <= branch_target;
        end else if (stall) begin
            pc <= pc;
            inst_reg <= inst_reg;
            fd_pc <= pc;
        end else begin
            pc <= pc + 4;
            inst_reg <= inst_in;
            fd_pc <= pc;
        end
    end

    // "forward" branch target
    always @(*) begin
        if (branch) inst_addr = branch_target;
        else inst_addr = pc;
    end

    // D Stage

    wire stall;
    wire [31:0] opr1, opr2, imm, de_pc;
    wire [8:0] de_e_con;
    wire [7:0] de_m_con;
    wire [6:0] de_w_con;
    wire [4:0] de_rs1, de_rs2;

    d_stage decode (
        .clk(clk),
        .flush(branch),
        .inst(inst_reg),
        .rs1_out(rs1_out),
        .rs2_out(rs2_out),
        .pc(fd_pc),
        .opr1(opr1),
        .opr2(opr2),
        .imm(imm),
        .pc_out(de_pc),
        .rs1(rs1),
        .rs2(rs2),
        .e_con(de_e_con),
        .m_con(de_m_con),
        .w_con(de_w_con),
        .de_rs1(de_rs1),
        .de_rs2(de_rs2),
        .stall(stall)
    );

    // E Stage

    wire [31:0] alu_result, branch_target, em_pc, write_data_wire;
    wire [6:0] em_m_con;
    wire [5:0] em_w_con;
    wire [4:0] em_rs2;
    wire branch;

    e_stage execute (
        .clk(clk),
        .opr1(opr1),
        .opr2(opr2),
        .imm(imm),
        .pc(de_pc),
        .e_con(de_e_con),
        .m_con_in(de_m_con),
        .w_con_in(de_w_con),
        .em_regfile_we(em_w_con[5]),
        .em_rd(em_w_con[4:0]),
        .mw_regfile_we(mw_w_con[5]),
        .mw_rd(mw_w_con[4:0]),
        .rs1(de_rs1),
        .rs2(de_rs2),
        .em_data(alu_result),
        .mw_data(rd_in),
        .branch(branch),
        .alu_result(alu_result),
        .branch_target(branch_target),
        .write_data(write_data_wire),
        .pc_out(em_pc),
        .m_con_out(em_m_con),
        .w_con_out(em_w_con),
        .em_rs2(em_rs2)
    );

    // M Stage

    wire [5:0] mw_w_con;

    m_stage memory (
        .clk(clk),
        .alu_result(alu_result),
        .pc(em_pc),
        .m_con(em_m_con),
        .w_con_in(em_w_con),
        .data_addr(data_addr),
        .mem_read_en(read_en),
        .mem_write_en(write_en),
        .mem_data_l(data_in),
        .reg_write_data(rd_in),
        .w_con_out(mw_w_con)
    );

    // load-store special forward
    always @(*) begin
        if (regfile_we & rd == em_rs2) data_out = rd_in;
        else data_out = write_data_wire;
    end

    // W Stage

    assign rd = mw_w_con[4:0];
    assign regfile_we = mw_w_con[5];

endmodule
