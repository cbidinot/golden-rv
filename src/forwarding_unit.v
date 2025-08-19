`timescale 1ns / 1ns

module forwarding_unit (
    input em_regfile_we,
    input [4:0] em_rd,
    input mw_regfile_we,
    input [4:0] mw_rd,
    input [4:0] rs1,
    input [4:0] rs2,
    output reg [1:0] forward1,
    output reg [1:0] forward2
);

    always @(*) begin
        forward1 = 0;
        forward2 = 0;
        if (em_regfile_we && |em_rd && em_rd == rs1) forward1 = 2'b10;
        else if (mw_regfile_we && |mw_rd && mw_rd == rs1) forward1 = 2'b01;
        if (em_regfile_we && |em_rd && em_rd == rs2) forward2 = 2'b10;
        else if (mw_regfile_we && |mw_rd && mw_rd == rs2) forward2 = 2'b01;
    end

endmodule
