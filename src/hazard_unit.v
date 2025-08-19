`timescale 1ns / 1ns

module hazard_unit (
    input de_mem_read_en,
    input rs2_valid,
    input [4:0] de_rd,
    input [4:0] rs1,
    input [4:0] rs2,
    output stall
);

    assign stall = de_mem_read_en & (de_rd == rs1 | (de_rd == rs2 & rs2_valid));

endmodule
