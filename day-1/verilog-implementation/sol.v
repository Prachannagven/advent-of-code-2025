module aoc_day1(
    input  wire [31:0] in_data,
    input  wire        clk,
    input  wire        rst,
    input  wire        dir_r,
    output reg  [31:0] zero_count
);

    wire [7:0] rot_by;  // modulo result after 3 cycles

    mod100_pipelined mod_unit (
        .clk(clk),
        .rst(rst),
        .in_data(in_data),
        .rot_by(rot_by)
    );

    reg [7:0]  curr_pos = 8'd50;
    reg [31:0] zero_count_int;

    // local combinational next state
    reg [9:0] temp_pos_next;
    reg [7:0] curr_pos_next;

    always @(*) begin
        // compute next position based on rot_by
        if (dir_r) begin
            temp_pos_next = curr_pos + rot_by;
            if (temp_pos_next >= 10'd100)
                curr_pos_next = temp_pos_next - 10'd100;
            else
                curr_pos_next = temp_pos_next[7:0];
        end else begin
            temp_pos_next = curr_pos + (8'd100 - rot_by);
            if (temp_pos_next >= 10'd100)
                curr_pos_next = temp_pos_next - 10'd100;
            else
                curr_pos_next = temp_pos_next[7:0];
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            curr_pos       <= 8'd50;
            zero_count_int <= 0;
            zero_count     <= 0;
        end else begin
            curr_pos <= curr_pos_next;

            if (curr_pos_next == 0)
                zero_count_int <= zero_count_int + 1;

            zero_count <= zero_count_int;
        end
    end

endmodule
