`timescale 1ns / 1ns

interface ram_if;
    logic [ 1:0] write_en;
    logic [ 1:0] read_en;
    logic [31:0] data_in;
    logic [31:0] data_out;
    logic [31:0] inst_out;
    logic [31:0] data_addr;
    logic [31:0] inst_addr;
endinterface

typedef struct {
    logic [1:0] write_en;
    logic [31:0] data_addr;
    logic [31:0] data_in;
    logic [31:0] expected_word;
    string description;
} data_write_vec_t;

typedef struct {
    logic [1:0] read_en;
    logic [31:0] data_addr;
    logic [31:0] data_out;
    logic [31:0] inst_addr;
    logic [31:0] inst_out;
    string description;
} read_vec_t;

module ram_tb ();

    logic clk = 0;

    ram_if if0 ();

    ram uut (
        .clk(clk),
        .write_en(if0.write_en),
        .read_en(if0.read_en),
        .inst_addr(if0.inst_addr),
        .data_addr(if0.data_addr),
        .inst_out(if0.inst_out),
        .data_out(if0.data_out),
        .data_in(if0.data_in)
    );

    always #5 clk = ~clk;

    data_write_vec_t write_vec_arr[] = '{
        '{2'b11, 32'hf0, 32'hff00ff, 32'hff00ff, "write word"},
        '{2'b00, 32'hf0, 32'h00ff00, 32'hff00ff, "write disabled"},
        '{2'b10, 32'hf0, 32'h122200, 32'hff2200, "write lower half word"},
        '{2'b01, 32'hf0, 32'hff11, 32'hff2211, "write first byte"},
        '{2'b01, 32'hf2, 32'h999933, 32'h332211, "write third byte"},
        '{2'b10, 32'hf2, 32'h991111, 32'h11112211, "write upper half word"},
        '{2'b11, 32'hf00, 32'h1234, 32'h1234, "write word"},
        '{2'b11, 32'hab0, 32'hababa, 32'hababa, "write word"}
    };

    read_vec_t read_vec_arr[] = '{
        '{2'b11, 32'hf0, 32'h11112211, 32'hf0, 32'h11112211, "read word"},
        '{2'b00, 32'hf0, 32'h0, 32'hf0, 32'h11112211, "read disabled"},
        '{2'b10, 32'hf0, 32'h2211, 32'hf00, 32'h1234, "read lower half word"},
        '{2'b01, 32'hf0, 32'h11, 32'hab0, 32'hababa, "read first byte"},
        '{2'b01, 32'hf1, 32'h22, 32'hab0, 32'hababa, "read second byte"},
        '{2'b10, 32'hf2, 32'h1111, 32'hf00, 32'h1234, "read upper half word"}
    };

    task automatic check_write(input data_write_vec_t vec);
        if0.read_en   = 0;
        if0.write_en  = vec.write_en;
        if0.data_addr = vec.data_addr;
        if0.data_in   = vec.data_in;
        @(posedge clk) #1;
        assert (uut.mem[vec.data_addr[uut.ADDR_MSB:2]] == vec.expected_word)
        else
            $error(
                "[%s] failed: write_en = %b, data_addr = 0x%h, data_in = 0x%h => mem@addr = 0x%h (expected 0x%h)",
                vec.description,
                vec.write_en,
                vec.data_addr,
                vec.data_in,
                uut.mem[vec.data_addr[uut.ADDR_MSB:2]],
                vec.expected_word
            );

    endtask

    task automatic check_read(input read_vec_t vec);
        if0.write_en  = 0;
        if0.read_en   = vec.read_en;
        if0.data_addr = vec.data_addr;
        if0.inst_addr = vec.inst_addr;
        #2;
        assert (if0.data_out == vec.data_out)
        else
            $error(
                "[%s] failed: read_en = %b, data_addr = 0x%h => data_out = 0x%h (expected 0x%h)",
                vec.description,
                vec.read_en,
                vec.data_addr,
                if0.data_out,
                vec.data_out
            );
        assert (if0.inst_out == vec.inst_out)
        else
            $error(
                "[%s] failed: inst_addr = 0x%h => inst_out = 0x%h (expected 0x%h)",
                vec.description,
                vec.inst_addr,
                if0.inst_out,
                vec.inst_out
            );
    endtask

    initial begin
        foreach (write_vec_arr[i]) check_write(write_vec_arr[i]);
        $display("All write tests completed!");
        foreach (read_vec_arr[i]) check_read(read_vec_arr[i]);
        $display("All read tests completed!");
        $stop;
    end

endmodule
