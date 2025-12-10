module aoc_day1(
    input  wire [31:0] in_data,
    input  wire        clk,
    input  wire        rst,
    input  wire        dir_r,
    output reg  [31:0] zero_count,
    output reg  [7:0]  curr_pos_op,
    output reg         busy
);

    wire [7:0] rot_by;  // modulo result after 4 cycles

    mod100_pipelined mod_unit (
        .clk(clk),
        .rst(rst),
        .in_data(in_data),
        .rot_by(rot_by)
    );

    reg [7:0]  curr_pos = 8'd50;
    reg [31:0] zero_count_int;

    // local combinational next state
    reg [9:0] temp_pos_next = 8'd50;
    reg [7:0] curr_pos_next = 8'd50;

    //States
    reg [1:0] state;
    localparam IDLE1 = 2'b00;
    localparam IDLE2 = 2'b00;
    localparam IDLE3 = 2'b00;
    localparam WORKI = 2'b00;

    //Making a small FIFO to delay the dir_r operation
    reg [3:0] dir_r_fifo = 4'b0000;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dir_r_fifo <= 4'b0000;
        end
        else begin
            dir_r_fifo <= {dir_r_fifo[2:0], dir_r};
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            busy <= 1'b0;
            curr_pos       <= 8'd50;
            zero_count_int <= 0;
            zero_count     <= 0;
        end
        else begin
            dir_r_use <= dir_r_fifo[3];
            busy <= 1'b1;
            if (dir_r_use) begin
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
    end


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            curr_pos <= 8'd50;
            curr_pos_op <= 8'd50;
        end
        else begin
            curr_pos <= curr_pos_next;
            curr_pos_op <= curr_pos_next;
            if (curr_pos_next == 0) begin
                zero_count_int <= zero_count_int + 1;
                zero_count <= zero_count_int;
            end
        end
    end

endmodule
