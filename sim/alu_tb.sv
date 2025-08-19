`timescale 1ns / 1ns

interface alu_if;
    logic [31:0] op1;
    logic [31:0] op2;
    logic [3:0] op_code;
    logic [31:0] result;
    logic branch;
endinterface

typedef struct {
    logic [31:0] op1;
    logic [31:0] op2;
    logic [3:0] op_code;
    logic [31:0] expected_result;
    logic expected_branch;
    string description;
} alu_test_vec_t;

module alu_tb ();

    alu_if if0 ();

    alu_test_vec_t vec_arr[] = '{
        '{20, 21, 4'h0, 41, 0, "add"},
        '{20, 21, 4'h1, -1, 0, "sub"},
        '{32'hff, 32'hf0, 4'h2, 32'hf0, 0, "and"},
        '{32'hf0, 32'h0f, 4'h3, 32'hff, 0, "or"},
        '{32'hf0, 32'hff, 4'h4, 32'h0f, 0, "xor"},
        '{32'h0f, 4, 4'h5, 32'hf0, 0, "sll"},
        '{32'hf0000000, 4, 4'h6, 32'hff000000, 0, "sra"},
        '{32'hf0000000, 4, 4'h7, 32'h0f000000, 0, "srl"},
        '{-2, 2, 4'h8, 1, 0, "slt"},
        '{2, 1, 4'h8, 0, 0, "slt"},
        '{1, 2, 4'h9, 1, 0, "sltu"},
        '{-2, 1, 4'h9, 0, 0, "sltu"},
        '{2, 2, 4'ha, 0, 1, "beq"},
        '{1, 2, 4'ha, 0, 0, "beq"},
        '{1, 2, 4'hb, 0, 1, "bne"},
        '{1, 1, 4'hb, 0, 0, "bne"},
        '{2, -2, 4'hc, 0, 1, "bge"},
        '{2, 2, 4'hc, 0, 1, "bge"},
        '{1, 2, 4'hc, 0, 0, "bge"},
        '{2, -3, 4'hd, 0, 0, "bgeu"},
        '{4294967294, -2, 4'hd, 0, 1, "bgeu"},
        '{4, 2, 4'hd, 0, 1, "bgeu"},
        '{-2, 2, 4'he, 0, 1, "blt"},
        '{2, 2, 4'he, 0, 0, "blt"},
        '{4, 2, 4'he, 0, 0, "blt"},
        '{-4, 2, 4'hf, 0, 0, "bltu"},
        '{2, 4, 4'hf, 0, 1, "bltu"},
        '{2, 2, 4'hf, 0, 0, "bltu"}
    };

    alu uut (
        .operand1(if0.op1),
        .operand2(if0.op2),
        .op_code (if0.op_code),
        .result  (if0.result),
        .branch  (if0.branch)

    );

    task automatic check_alu(input alu_test_vec_t vec);
        if0.op1 = vec.op1;
        if0.op2 = vec.op2;
        if0.op_code = vec.op_code;
        #10;
        assert (if0.result == vec.expected_result)
        else
            $error(
                "[%s] failed: op1 = %0d/0x%h, op2 = %0d/0x%h, op_code = 0x%h => result = %0d/0x%h (expected %0d/0x%0h)",
                vec.description,
                vec.op1,
                vec.op1,
                vec.op2,
                vec.op2,
                vec.op_code,
                if0.result,
                if0.result,
                vec.expected_result,
                vec.expected_result
            );
        assert (if0.branch == vec.expected_branch)
        else
            $error(
                "[%s] failed: p1 = %0d/0x%h, op2 = %0d/0x%h, op_code = 0x%h => branch = %b (expected %b)",
                vec.description,
                vec.op1,
                vec.op1,
                vec.op2,
                vec.op2,
                vec.op_code,
                if0.branch,
                vec.expected_branch
            );
    endtask

    initial begin
        foreach (vec_arr[i]) check_alu(vec_arr[i]);
        $display("All ALU tests completed!");
        $stop;
    end

endmodule
