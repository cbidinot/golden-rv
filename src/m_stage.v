`timescale 1ns / 1ns

module m_stage (
    input clk,
    input [31:0] alu_result,
    input [31:0] pc,
    input [6:0] m_con,
    input [5:0] w_con_in,
    output [31:0] data_addr,
    output [1:0] mem_read_en,
    output [1:0] mem_write_en,
    input [31:0] mem_data_l,
    output reg [31:0] reg_write_data,
    output reg [5:0] w_con_out
);

    wire mem_sign;
    wire [1:0] reg_write_sel;
    assign reg_write_sel = m_con[1:0];
    assign mem_read_en = m_con[3:2];
    assign mem_write_en = m_con[5:4];
    assign mem_sign = m_con[6];

    assign data_addr = alu_result;

    always @(posedge clk) begin
        case (reg_write_sel)
            2'b00:   reg_write_data <= pc + 4;
            2'b01:   reg_write_data <= alu_result;
            2'b10:   begin
                if (mem_sign) begin
                    case (mem_read_en)
                        2'b11: reg_write_data <= mem_data_l;
                        2'b10: reg_write_data <= {{16{mem_data_l[15]}}, mem_data_l[15:0]};
                        2'b01: reg_write_data <= {{24{mem_data_l[7]}}, mem_data_l[7:0]};
                        2'b00: reg_write_data <= 0;
                    endcase
                end else reg_write_data <= mem_data_l;
            end
            default: reg_write_data <= 0;
        endcase
        w_con_out <= w_con_in;
    end

endmodule
