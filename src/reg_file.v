`timescale 1ns / 1ns

module reg_file (
    input clk,
    input we,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] rd_in,
    output reg [31:0] rs1_out,
    output reg [31:0] rs2_out
);

    reg [31:0] regfile[1:31];

    always @(posedge clk) if (we && rd != 0) regfile[rd] <= rd_in;

    always @(*) begin
        if (|rs1) begin
            if (we && rs1 == rd) rs1_out = rd_in;
            else rs1_out = regfile[rs1];
        end else rs1_out = 0;
        if (|rs2) begin
            if (we && rs2 == rd) rs2_out = rd_in;
            else rs2_out = regfile[rs2];
        end else rs2_out = 0;
    end

endmodule
