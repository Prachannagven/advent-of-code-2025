`timescale 1ns / 1ps

module aoc_day1_tb_test();

    // Instantiate DUT inputs
    reg  [31:0] data_in = 32'b0;
    reg         clk     = 1'b0;
    reg         rst     = 1'b0;
    reg         dir_r   = 1'b0;

    wire [31:0] zero_count;

    // Instantiate DUT
    aoc_day1 uut (
        .in_data(data_in),
        .clk(clk),
        .rst(rst),
        .dir_r(dir_r),
        .zero_count(zero_count)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // VCD DUMP
        $dumpfile("aoc_day1_test.vcd");
        $dumpvars(0, aoc_day1_tb_test);

        // Reset sequence
        @(posedge clk);
        rst     = 1;
        data_in = 0;
        dir_r   = 0;

        @(posedge clk);
        rst = 0;

        // Apply test vectors
        @(posedge clk); dir_r = 0; data_in = 68;
        @(posedge clk); dir_r = 0; data_in = 30;
        @(posedge clk); dir_r = 1; data_in = 48;
        @(posedge clk); dir_r = 0; data_in = 5;
        @(posedge clk); dir_r = 1; data_in = 60;
        @(posedge clk); dir_r = 0; data_in = 55;
        @(posedge clk); dir_r = 0; data_in = 1;
        @(posedge clk); dir_r = 0; data_in = 99;
        @(posedge clk); dir_r = 1; data_in = 14;
        @(posedge clk); dir_r = 0; data_in = 82;

        // Allow pipeline to flush
        repeat (10) @(posedge clk);

        $display("Simulation Ended. Final Zero Count = %0d", zero_count);
        $finish;
    end

endmodule
