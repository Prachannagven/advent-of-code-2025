module aoc_day1(
    input wire  [31:0] in_data,
    input wire  clk,
    input wire  rst,
    input wire  dir_r,
    output reg [31:0] zero_count 
);

    //Modulo must be synthesizable, so we need some magic.
    localparam DIV100_MOD_CONST = 32'd42949673; // floor(2^32 / 100)
    reg [63:0] mult = 64'b0;
    reg [31:0] q = 32'b0;
    reg [31:0] r = 32'b0;

    //FIFO of width 32 and depth 4 required to hold

    reg [9:0] temp_pos = 8'd50;
    reg [7:0] curr_pos = 8'd50;
    reg [31:0] zero_count_int = 32'd0;

    reg [7:0] rot_by;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            curr_pos = 8'd0;
            zero_count = 16'd0;
        end
        else begin
            mult = in_data * DIV100_MOD_CONST;
            q = mult >> 32;
            r = in_data - q * 8'd100;
            rot_by = r[7:0];
            if(dir_r) begin
                temp_pos = (curr_pos + rot_by);
                if(temp_pos >= 8'd100) begin
                    curr_pos = temp_pos - 8'd100;
                end
                else begin
                    curr_pos = temp_pos;
                end
            end
            else begin
                temp_pos = (curr_pos + (100 - rot_by));
                if(temp_pos >= 8'd100) begin
                    curr_pos = temp_pos - 8'd100;  
                end
            end
        end
        if(curr_pos == 8'd0) begin
            zero_count_int = zero_count_int + 1;
        end
        zero_count = zero_count_int;
    end
endmodule
