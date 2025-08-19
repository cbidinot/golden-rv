`timescale 1ns / 1ns

interface datapath_if;
    logic [31:0] data_in;
    logic [31:0] inst_in;
    logic [1:0] read_en;
    logic [1:0] write_en;
    logic [31:0] data_addr;
    logic [31:0] inst_addr;
    logic [31:0] data_out;
endinterface

module riscv_tb();

    logic clk = 0;
    always #5 clk = ~clk;
    datapath_if if0();

    datapath uut (
        .clk,
        .data_in(if0.data_in),
        .inst_in(if0.inst_in),
        .read_en(if0.read_en),
        .write_en(if0.write_en),
        .data_addr(if0.data_addr),
        .inst_addr(if0.inst_addr),
        .data_out(if0.data_out)
    );

    ram mem (
        .clk,
        .write_en(if0.write_en),
        .read_en(if0.read_en),
        .data_addr(if0.data_addr),
        .inst_addr(if0.inst_addr),
        .inst_out(if0.inst_in),
        .data_in(if0.data_out),
        .data_out(if0.data_in)
    );



    initial begin
        $readmemh("test.mem", mem.mem);
        #200;
        $stop;
    end



endmodule
