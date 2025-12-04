`timescale 1ns/1ps

module zero_counter_tb;

    // DUT inputs
    reg  [31:0] data_in;
    reg         dir_r;
    reg         clk;
    reg         rst;

    // DUT output
    wire [15:0] zero_count;
    wire [15:0] zero_cross;

    // Instantiate DUT
    zero_counter dut (
        .data_in(data_in),
        .dir_r(dir_r),
        .clk(clk),
        .rst(rst),
        .zero_count(zero_count),
        .zero_cross(zero_cross)
    );

    // Clock: 10ns period = 100MHz
    always #5 clk = ~clk;

    // MAIN TEST
    initial begin
        // VCD dump for waveforms
        $dumpfile("zero_counter.vcd");
        $dumpvars(0, zero_counter_tb);

        $display("=== ZERO COUNTER TESTBENCH START ===");

        // Initialize signals
        clk     = 0;
        rst     = 0;
        data_in = 0;
        dir_r   = 0;

        // Reset pulse
        rst = 1;
        #20;
        rst = 0;

        // === BEGIN INPUT SEQUENCE ===
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
        // === END INPUT SEQUENCE ===

        // Print final result
        #20;
        $display("=== TEST COMPLETE ===");
        $display("Final zero_count = %d", zero_count);
        $display("Final zero_cros = %d", zero_cross);

        $finish;
    end

endmodule

