module aoc_day1(
    input  wire [31:0] in_data,
    input  wire        clk,
    input  wire        rst,
    input  wire        dir_r,
    output reg  [31:0] zero_count,
    output reg  [31:0] zero_crossings,
    output reg  [7:0]  curr_pos_op
);

    //Instantiate the mod100 module that I built seperately
    wire [9:0] quotient;
    wire [7:0] rot_by;
    wire [1:0] test;

    mod100_pipelined mod_unit (
        .clk(clk),
        .rst(rst),
        .in_data(in_data),
        .rot_by(rot_by),
        .quotient(quotient)
    );

    //To make this work, we need the current and next for arithmatic.
    //The next will then be assigned out to the output
    reg [7:0] curr_pos = 8'd50;
    reg [7:0] next_pos;
    reg [8:0] next_pos_raw;
    reg [3:0] dir_r_reg;

    reg [31:0] test_reg;
    reg zero_crossing_detected = 1'b0;
    reg [11:0] count_cycles= 1'b0;

    //Latency of 4 clock cycles exists because of the mod100 pipeline.
    //Dir_r needs to be delayed the same amount to line up correctly.
    always @(posedge clk or posedge rst) begin
        test_reg <= in_data;
        if (rst) begin
            dir_r_reg <= 5'b0;
        end
        else begin
            dir_r_reg <= {dir_r_reg[3:0], dir_r};
            count_cycles <= count_cycles + 1;
        end
    end

    //Next state logic using comb because it's easier.
    always @(*) begin
        if (dir_r_reg[3]) begin
            next_pos = curr_pos + rot_by;
            next_pos_raw = next_pos;
            if((next_pos_raw > 100 ) & (curr_pos != 0)) begin
                zero_crossing_detected = 1;
                //zero_crossings = zero_crossings + 1; 
            end
            else begin
                zero_crossing_detected = 0;
            end
        end
        else begin
            next_pos_raw = curr_pos - rot_by;
            next_pos = curr_pos + (8'd100 - rot_by);
            if((next_pos_raw[8]) & (curr_pos != 0)) begin
                zero_crossing_detected = 1;
                //zero_crossings = zero_crossings + 1; 
            end
            else begin
                zero_crossing_detected = 0;
            end
        end
        if (next_pos >= 8'd100)
            next_pos = next_pos - 8'd100;
    end

    //Tadaaa, the final sequential block to update state.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            curr_pos    <= 8'd50;
            zero_count  <= 0;
            curr_pos_op <= 8'd50;
            zero_crossing_detected <= 1'b0;
            zero_crossings <= 0;
        end
        else begin
            curr_pos    <= next_pos;
            curr_pos_op <= next_pos;
            zero_count  <= (next_pos == 0) ? zero_count + 1 : zero_count;
            zero_crossings <= zero_crossings + quotient + zero_crossing_detected;
        end
    end

endmodule

