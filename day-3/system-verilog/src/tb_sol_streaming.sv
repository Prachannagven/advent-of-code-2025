`timescale 1ns/1ps

module tb_sol_streaming;

    localparam DEPTH      = 3;
    localparam DIGITS_PER_NUMBER = 15;
    localparam FIFO_DEPTH = 64;  // Large enough for multiple numbers
    localparam NUM_NUMBERS = 3;  // Test with 3 numbers

    logic clk;
    logic rst;
    logic [3:0] digit_in;
    logic digit_valid;
    logic [63:0] sum_out;
    logic error;

    // DUT
    aoc_day3 #(
        .DEPTH(DEPTH),
        .DIGITS_PER_NUM(DIGITS_PER_NUMBER),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .digit_in(digit_in),
        .digit_valid(digit_valid),
        .sum_out(sum_out),
        .error(error)
    );

    // Clock: 100 MHz
    always #5 clk = ~clk;

    // Test vectors: 3 numbers of 15 digits each
    integer test_digits [0:NUM_NUMBERS*DIGITS_PER_NUMBER-1];

    initial begin
        // Number 1: 364789365846344
        test_digits[0]  = 3; test_digits[1]  = 6; test_digits[2]  = 4;
        test_digits[3]  = 7; test_digits[4]  = 8; test_digits[5]  = 9;
        test_digits[6]  = 3; test_digits[7]  = 6; test_digits[8]  = 5;
        test_digits[9]  = 8; test_digits[10] = 4; test_digits[11] = 6;
        test_digits[12] = 3; test_digits[13] = 4; test_digits[14] = 4;

        // Number 2: 987654321012345
        test_digits[15] = 9; test_digits[16] = 8; test_digits[17] = 7;
        test_digits[18] = 6; test_digits[19] = 5; test_digits[20] = 4;
        test_digits[21] = 3; test_digits[22] = 2; test_digits[23] = 1;
        test_digits[24] = 0; test_digits[25] = 1; test_digits[26] = 2;
        test_digits[27] = 3; test_digits[28] = 4; test_digits[29] = 5;

        // Number 3: 111222333444555
        test_digits[30] = 1; test_digits[31] = 1; test_digits[32] = 1;
        test_digits[33] = 2; test_digits[34] = 2; test_digits[35] = 2;
        test_digits[36] = 3; test_digits[37] = 3; test_digits[38] = 3;
        test_digits[39] = 4; test_digits[40] = 4; test_digits[41] = 4;
        test_digits[42] = 5; test_digits[43] = 5; test_digits[44] = 5;
    end

    initial begin
        $dumpfile("tb_sol_streaming.vcd");
        $dumpvars(0, tb_sol_streaming);
        $display("=== Starting streaming testbench ===");
        $display("Testing with DEPTH=%0d, DIGITS_PER_NUMBER=%0d", DEPTH, DIGITS_PER_NUMBER);

        clk = 0;
        rst = 1;
        digit_in = 0;
        digit_valid = 0;

        // Reset
        #20;
        rst = 0;
        #10;

        // Stream all digits continuously
        for (int i = 0; i < NUM_NUMBERS * DIGITS_PER_NUMBER; i++) begin
            @(posedge clk);
            digit_in = test_digits[i];
            digit_valid = 1;
            $display("t=%0t: Sending digit[%2d] = %d, state=%0d, digit_count=%0d, fifo_count=%0d", 
                     $time, i, test_digits[i], dut.state, dut.digit_count, dut.fifo_count);
            
            if ((i+1) % DIGITS_PER_NUMBER == 0) begin
                $display(">>> Finished sending number %0d (digits %0d-%0d)", 
                         (i/DIGITS_PER_NUMBER)+1, i-DIGITS_PER_NUMBER+1, i);
            end
        end

        // Stop driving input
        @(posedge clk);
        digit_valid = 0;
        digit_in = 0;

        // Wait for DUT to finish processing all numbers
        repeat (1000) @(posedge clk);

        $display("\n=== Results ===");
        $display("Final state: %0d, FIFO count: %0d, digit_count: %0d", dut.state, dut.fifo_count, dut.digit_count);
        $display("Stack: [%0d, %0d, %0d], sp=%0d", dut.stack[0], dut.stack[1], dut.stack[2], dut.sp);
        $display("current_result: %0d, result_idx: %0d", dut.current_result, dut.result_idx);
        $display("Number 1: 364789365846344 -> Max sub-number of length %0d = 986", DEPTH);
        $display("Number 2: 987654321012345 -> Max sub-number of length %0d = 987", DEPTH);
        $display("Number 3: 111222333444555 -> Max sub-number of length %0d = 555", DEPTH);
        $display("Expected sum: 986 + 987 + 555 = 2528");
        $display("\nActual sum_out = %0d", sum_out);
        $display("Error flag = %0b", error);
        
        if (!error && sum_out == 2528)
            $display("\n✅ TEST PASSED");
        else
            $display("\n❌ TEST FAILED");

        $finish;
    end

    // Timeout watchdog
    initial begin
        #50000;
        $display("ERROR: Timeout!");
        $finish;
    end

endmodule
