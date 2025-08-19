`timescale 1ns / 1ns

module ram #(
    parameter integer RAM_MSB   = 65535,
    parameter integer ADDR_MSB = 15
) (
    input clk,
    input [1:0] write_en,
    input [1:0] read_en,
    input [31:0] inst_addr,
    input [31:0] data_addr,
    output reg [31:0] inst_out,
    output reg [31:0] data_out,
    input [31:0] data_in
);

    reg [31:0] mem[0:RAM_MSB];
    reg [31:0] read_wire, inst_wire;

    always @(posedge clk) begin
        case (write_en)
            2'b11: mem[data_addr[ADDR_MSB:2]] <= data_in;
            2'b10: begin
                if (data_addr[1]) mem[data_addr[ADDR_MSB:2]][31:16] <= data_in[15:0];
                else mem[data_addr[ADDR_MSB:2]][15:0] <= data_in[15:0];
            end
            2'b01: begin
                case (data_addr[1:0])
                    2'b11: mem[data_addr[ADDR_MSB:2]][31:24] <= data_in[7:0];
                    2'b10: mem[data_addr[ADDR_MSB:2]][23:16] <= data_in[7:0];
                    2'b01: mem[data_addr[ADDR_MSB:2]][15:8] <= data_in[7:0];
                    2'b00: mem[data_addr[ADDR_MSB:2]][7:0] <= data_in[7:0];
                endcase
            end
            2'b00: mem[data_addr[ADDR_MSB:2]] <= mem[data_addr[ADDR_MSB:2]];
        endcase
    end

    always @(*) begin
        read_wire = mem[data_addr[ADDR_MSB:2]];
        inst_wire = mem[inst_addr[ADDR_MSB:2]];
        inst_out = inst_wire;
        case (read_en)
            2'b11: data_out = read_wire;
            2'b10: begin
                if (data_addr[1]) data_out = {16'b0, read_wire[31:16]};
                else data_out = {16'b0, read_wire[15:0]};
            end
            2'b01: begin
                case (data_addr[1:0])
                    2'b11: data_out = {24'b0, read_wire[31:24]};
                    2'b10: data_out = {24'b0, read_wire[23:16]};
                    2'b01: data_out = {24'b0, read_wire[15:8]};
                    2'b00: data_out = {24'b0, read_wire[7:0]};
                endcase
            end
            2'b00: data_out = 0;
        endcase
    end

endmodule
