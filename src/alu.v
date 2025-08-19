`timescale 1ns / 1ns

module alu (
    input [3:0] op_code,
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] result,
    output reg branch
);

    /*
    ADD  -> op_code = 0
    SUB  -> op_code = 1
    AND  -> op_code = 2
    OR   -> op_code = 3
    XOR  -> op_code = 4
    SLL  -> op_code = 5
    SRA  -> op_code = 6
    SRL  -> op_code = 7
    SLT  -> op_code = 8
    SLTU -> op_code = 9
    BEQ  -> op_code = a
    BNE  -> op_code = b
    BGE  -> op_code = c
    BGEU -> op_code = d
    BLT  -> op_code = e
    BLTU -> op_code = f
    */

    always @(*) begin
        result = 32'h0;
        branch = 0;
        case (op_code)
            4'h0: result = operand1 + operand2;
            4'h1: result = operand1 - operand2;
            4'h2: result = operand1 & operand2;
            4'h3: result = operand1 | operand2;
            4'h4: result = operand1 ^ operand2;
            4'h5: result = operand1 << operand2;
            4'h6: result = $signed(operand1) >>> operand2;
            4'h7: result = operand1 >> operand2;
            4'h8: if ($signed(operand1) < $signed(operand2)) result = 32'h1;
            4'h9: if (operand1 < operand2) result = 32'h1;
            4'ha: if (operand1 == operand2) branch = 1;
            4'hb: if (operand1 != operand2) branch = 1;
            4'hc: if ($signed(operand1) >= $signed(operand2)) branch = 1;
            4'hd: if (operand1 >= operand2) branch = 1;
            4'he: if ($signed(operand1) < $signed(operand2)) branch = 1;
            4'hf: if (operand1 < operand2) branch = 1;
        endcase
    end

endmodule
