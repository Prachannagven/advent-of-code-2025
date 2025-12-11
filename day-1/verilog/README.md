# Verilog Implementation
The verilog implementation followed the same logic as the C implementation, with the only issue now being the synthesizability of the code.

## IO Definitions
The verilog module takes in a 32 bit wide "data_in" input, and returns back a 16 bit wide "zero_count" output.
``` Verilog
module aoc_day1_part(
    input  wire [31:0] in_data,
    input  wire        clk,
    input  wire        rst,
    input  wire        dir_r,
    output reg  [31:0] zero_count,
    output reg  [7:0]  curr_pos_op,
);
```
For debugging purposes, the current position of the dial was also output. The entire system was clocked with an asynchronous reset.

## Implementation Details
The verilog implementation was mainly harder due to the lack of a synthesizable modulo operator. As such, I had to build my own modulo operator block.
I used the magic number implementation, and pipelined it to get the output 4 clock cycles after data entry.

To deal with the delayed data entry point to the evaluation module, the input fo the `dir_r` signal was pushed through a 5 length FIFO to align it with the data. 

Thus, with all clocking issues fixed, a simple combination block was used to evaluate the next state position, as it was just an addition or subtraction based on the MSB of the direction register.

From there, a final check was done to ensure that the output was wrapped around to fit within the 0 to 99 numerical range.

## Testbenches
Two testbenches for the solution are present. One on the sample test that was provided in the problem statement, and one on my full input data stream.

[Gtkwave Waveform of the Sample Input](./res/test_waveforms.png)

The sample is useful for opening up in gtkwave for debugging purposes. Since the testbench prints out the total zero count at the end of the simulation, you can simply use that instead.

[Printout of zero count from testbench usage](./res/part1_result.png)

# Conversion from input to testbench
The testbench used a simple line to convert actually send in the data, shown below:
``` Verilog
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
```

Which simply contains the direction right or left as well as the data input in decimal format. To generate these lines, I wrote a simple C script that scrapes the input file and generates these lines.

The output was piped into a .txt file which was then copied over into the testbench.

