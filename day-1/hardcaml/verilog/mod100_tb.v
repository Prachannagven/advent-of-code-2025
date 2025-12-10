`timescale 1ns/1ps

module mod100_tb();
    
    //Inputs to the module
    reg         clk;
    reg         rst;
    reg [31:0]  in_data;
    wire [7:0]  rot_by;


    //Instantiating the Module
    mod100_top uut(
        .clk(clk),
        .rst(rst),
        .data_in(in_data),
        .rot_by(rot_by)
    );

    //Clock generation
    initial begin
        clk = 0;
        rst = 0;
    end
    always #5 clk = ~clk;

    initial begin
        $dumpfile("mod100_tb.vcd");
        $dumpvars(0, mod100_tb);

        //Reset sequence
        @(posedge clk);
        rst = 1;
        in_data = 0;

        @(posedge clk);
        rst = 0;

        //Test Vectors
        @(posedge clk); in_data = 31'd125; 
        @(posedge clk); in_data = 31'd27; 
        @(posedge clk); in_data = 31'd783; 
        @(posedge clk); in_data = 31'd1089; 
        @(posedge clk); in_data = 31'd7779; 

        //Allow pipeline to flush
        repeat (10) @(posedge clk);

        $display("Simulation Done");
        $finish;
    end

endmodule
