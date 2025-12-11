module aoc_day1_part1(
    input  wire [31:0] in_data,
    input  wire        clk,
    input  wire        rst,
    input  wire        dir_r,
    output reg  [31:0] zero_count,
    output reg  [7:0]  curr_pos_op,
    output reg         busy
);

    wire [7:0] rot_by;
    wire [1:0] test;

    mod100_pipelined mod_unit (
        .clk(clk),
        .rst(rst),
        .in_data(in_data),
        .rot_by(rot_by)
    );

    reg [7:0] curr_pos = 8'd50;
    reg [7:0] next_pos;
    reg [4:0] dir_r_reg;

    //Register to store the dir_r values so they can be used at the
    //appropriate times
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dir_r_reg <= 5'b0;
        end
        else begin
            dir_r_reg <= {dir_r_reg[3:0], dir_r};
        end
    end

    always @(*) begin
        // pure combinational next-state logic
        if (dir_r_reg[4]) 
            next_pos = curr_pos + rot_by;
        else
            next_pos = curr_pos + (8'd100 - rot_by);

        if (next_pos >= 8'd100)
            next_pos = next_pos - 8'd100;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            curr_pos    <= 8'd50;
            zero_count  <= 0;
            curr_pos_op <= 8'd50;
            busy        <= 0;
        end
        else begin
            curr_pos    <= next_pos;
            curr_pos_op <= next_pos;
            zero_count  <= (next_pos == 0) ? zero_count + 1 : zero_count;
            busy        <= 1'b1;
        end
    end

endmodule

