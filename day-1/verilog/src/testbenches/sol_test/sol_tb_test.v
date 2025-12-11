`timescale 1ns / 1ps

module aoc_day1_tb();

    // Instantiate DUT inputs
    reg  [31:0] data_in = 32'b0;
    reg         clk     = 1'b0;
    reg         rst     = 1'b0;
    reg         dir_r   = 1'b0;

    wire [7:0]  curr_pos_op;
    wire [31:0] zero_count;

    // Instantiate DUT
    aoc_day1 uut (
        .in_data(data_in),
        .clk(clk),
        .rst(rst),
        .dir_r(dir_r),
        .zero_count(zero_count),
        .curr_pos_op(curr_pos_op)
    );

    //Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10 time units clock period

    initial begin
        $dumpfile("aoc_day1_part1_test.vcd");
        $dumpvars(0, aoc_day1_tb);
        
        @(posedge clk)
        rst = 1;
        data_in = 32'b0;
        dir_r = 1'b0;

        @(posedge clk)
        rst = 0;

        //Now the actual data
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

        //Ending the simulation
        repeat(6) @(posedge clk);
        $display("Simulation Ended. Final Zero Count = %0d", zero_count);

        $finish;
    end

endmodule
