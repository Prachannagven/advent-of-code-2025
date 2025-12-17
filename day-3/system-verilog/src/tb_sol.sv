`timescale 1ns/1ps

module tb_sol;

    localparam DEPTH      = 3;
    localparam TOTAL_IN   = 14;
    localparam FIFO_DEPTH = 16;

    logic clk;
    logic rst;
    logic [3:0] digit_in;
    logic [40:0] result_out;
    logic error;

    // DUT
    aoc_day3 #(
        .DEPTH(DEPTH),
        .TOTAL_IN(TOTAL_IN),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .digit_in(digit_in),
        .result_out(result_out),
        .error(error)
    );

    // Clock: 100 MHz
    always #5 clk = ~clk;

    // Test vector storage
    integer digits [0:TOTAL_IN-1];

    initial begin
        // Manual initialization (Icarus-friendly)
        digits[0]  = 3;
        digits[1]  = 6;
        digits[2]  = 4;
        digits[3]  = 7;
        digits[4]  = 8;
        digits[5]  = 9;
        digits[6]  = 3;
        digits[7]  = 6;
        digits[8]  = 5;
        digits[9]  = 8;
        digits[10] = 4;
        digits[11] = 6;
        digits[12] = 3;
        digits[13] = 4;
        digits[14] = 4;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_sol);
        $display("=== Starting testbench ===");

        clk = 0;
        rst = 1;
        digit_in = 0;

        // Reset
        #20;
        rst = 0;

        // Feed digits
        for (int i = 0; i < TOTAL_IN; i++) begin
            @(posedge clk);
            digit_in = digits[i];
            //$display("t=%0t digit_in=%0d", $time, digit_in);
        end

        // Stop driving input
        @(posedge clk);
        digit_in = 0;

        // Wait for DUT to finish
        repeat (50) @(posedge clk);

        $display("Original Number = %0d", 
            digits[0]*10**13 + digits[1]*10**12 + digits[2]*10**11 + digits[3]*10**10 +
            digits[4]*10**9  + digits[5]*10**8  + digits[6]*10**7  + digits[7]*10**6  +
            digits[8]*10**5  + digits[9]*10**4  + digits[10]*10**3 + digits[11]*10**2 +
            digits[12]*10**1 + digits[13]*10**0
        );

        $display("Result out for depth %0d = %0d", DEPTH, result_out);
        $display("Error      = %0b", error);
        
        /*
        $display("Stack contents:");
        for (int i = 0; i < DEPTH; i++) begin
            $display("  stack[%0d] = %0d", i, dut.stack[i]);
        end
        $display("Stack pointer (sp) = %0d", dut.sp);
        

        if (!error && result_out == 98654)
            $display("✅ TEST PASSED");
        else
            $display("❌ TEST FAILED");
        */

        $finish;
    end

endmodule

