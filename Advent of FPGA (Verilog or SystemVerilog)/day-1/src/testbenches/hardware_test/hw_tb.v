`timescale 1ns / 1ps

module aoc_day1_tb();

    // Instantiation
    reg         clk = 1'b0;
    reg         rst = 1'b0;
    reg [3:0]   data_in = 4'b0;
    reg         dir_r = 1'b0;
    wire [3:0]  data_out;
    wire        sending_output;

    // Instantiate DUT
    hardware_wrapper hardware_wrapper(
        .sys_clk(clk),
        .rst(rst),
        .data_in(data_in),
        .dir_r(dir_r),
        .data_out(data_out),
        .sending_output(sending_output)
    );

    //Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10 time units clock period

    initial begin
        $dumpfile("hardware_wrapper_test.vcd");
        $dumpvars(0, aoc_day1_tb);
        
        @(posedge clk)
        rst = 1;
        data_in = 4'b0;
        dir_r = 1'b0;
        @(posedge clk)
        rst = 0;

        //Now the actual data
        //Send 32'h4321ABCD
        @(posedge clk); dir_r = 1; data_in = 4'h0;
        @(posedge clk); dir_r = 1; data_in = 4'h0;
        @(posedge clk); dir_r = 1; data_in = 4'h0;
        @(posedge clk); dir_r = 1; data_in = 4'h0;
        @(posedge clk); dir_r = 1; data_in = 4'h0;
        @(posedge clk); dir_r = 1; data_in = 4'h0;
        @(posedge clk); dir_r = 1; data_in = 4'h3;
        @(posedge clk); dir_r = 0; data_in = 4'h2;
        @(posedge clk); dir_r = 0; data_in = 4'h4;
        @(posedge clk); dir_r = 0; data_in = 4'h4;
        @(posedge clk); dir_r = 0; data_in = 4'h4;
        @(posedge clk); dir_r = 0; data_in = 4'h4;
        @(posedge clk); dir_r = 0; data_in = 4'h4;
        @(posedge clk); dir_r = 0; data_in = 4'h3;
        @(posedge clk); dir_r = 0; data_in = 4'h2;
        @(posedge clk); dir_r = 1; data_in = 4'h1;
        @(posedge clk); dir_r = 1; data_in = 4'hA;
        @(posedge clk); dir_r = 1; data_in = 4'hB;
        @(posedge clk); dir_r = 1; data_in = 4'hC;
        @(posedge clk); dir_r = 1; data_in = 4'hD;
        @(posedge clk); dir_r = 1; data_in = 4'h3;
        @(posedge clk); dir_r = 1; data_in = 4'h3;
        @(posedge clk); dir_r = 1; data_in = 4'h2;
        @(posedge clk); dir_r = 0; data_in = 4'h1;
        @(posedge clk); dir_r = 0; data_in = 4'hA;
        @(posedge clk); dir_r = 0; data_in = 4'hB;
        @(posedge clk); dir_r = 0; data_in = 4'hC;
        @(posedge clk); dir_r = 0; data_in = 4'h3;
        @(posedge clk); dir_r = 0; data_in = 4'h2;
        @(posedge clk); dir_r = 0; data_in = 4'h1;
        @(posedge clk); dir_r = 0; data_in = 4'hA;
        @(posedge clk); dir_r = 0; data_in = 4'h2;
        @(posedge clk); dir_r = 0; data_in = 4'h1;
        @(posedge clk); dir_r = 0; data_in = 4'hA;
        @(posedge clk); dir_r = 0; data_in = 4'hB;
        @(posedge clk); dir_r = 0; data_in = 4'hC;
        @(posedge clk); dir_r = 0; data_in = 4'h3;
        @(posedge clk); dir_r = 0; data_in = 4'h2;
        @(posedge clk); dir_r = 0; data_in = 4'h1;
        @(posedge clk); dir_r = 0; data_in = 4'hA;
        @(posedge clk); dir_r = 0; data_in = 4'hB;
        @(posedge clk); dir_r = 0; data_in = 4'hC;
        @(posedge clk); dir_r = 0; data_in = 4'h3;
        @(posedge clk); dir_r = 0; data_in = 4'h2;
        @(posedge clk); dir_r = 0; data_in = 4'h1;
        @(posedge clk); dir_r = 0; data_in = 4'hA;
        @(posedge clk); dir_r = 0; data_in = 4'hB;
        @(posedge clk); dir_r = 0; data_in = 4'hC;
        @(posedge clk); dir_r = 0; data_in = 4'hD;
        @(posedge clk); dir_r = 0; data_in = 4'h3;
        @(posedge clk); dir_r = 0; data_in = 4'h2;
        @(posedge clk); dir_r = 0; data_in = 4'h1;
        @(posedge clk); dir_r = 0; data_in = 4'hA;
        @(posedge clk); dir_r = 0; data_in = 4'hB;
        @(posedge clk); dir_r = 0; data_in = 4'hC;
        @(posedge clk); dir_r = 0; data_in = 4'hD;
        @(posedge clk); dir_r = 0; data_in = 4'h3;
        @(posedge clk); dir_r = 0; data_in = 4'h2;
        @(posedge clk); dir_r = 0; data_in = 4'h1;
        @(posedge clk); dir_r = 0; data_in = 4'hA;
        @(posedge clk); dir_r = 0; data_in = 4'hB;
        @(posedge clk); dir_r = 0; data_in = 4'hC;
        @(posedge clk); dir_r = 0; data_in = 4'h3;
        @(posedge clk); dir_r = 0; data_in = 4'h2;
        @(posedge clk); dir_r = 0; data_in = 4'h1;
        @(posedge clk); dir_r = 0; data_in = 4'hA;

        //Ending the simulation
        repeat(30) @(posedge clk);
        $display("Simulation Ended");

        $finish;
    end

endmodule
