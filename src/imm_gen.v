`timescale 1ns / 1ns

module imm_gen (
    input [31:0] inst,
    input [2:0] imm_type,
    output reg [31:0] imm
);
    /* IMMEDIATE TYPE DOUBLE CHECK FIRST THREE
        - 000: I-immediate
        - 001: S-immediate
        - 010: B-immediate
        - 011: U-immediate
        - 100: J-immediate
    */

    always @(*) begin

        case (imm_type)
            3'b000:  imm = {{21{inst[31]}}, inst[30:25], inst[24:20]};
            3'b001:  imm = {{21{inst[31]}}, inst[30:25], inst[11:7]};
            3'b010:  imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
            3'b011:  imm = {inst[31:12], 12'b0};
            3'b100:  imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
            default: imm = 0;
        endcase

    end

endmodule
