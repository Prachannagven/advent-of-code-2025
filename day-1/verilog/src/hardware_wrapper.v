module hardware_wrapper #(parameter INPUT_WIDTH=4)
(
    input wire                      sys_clk,
    input wire                      rst,
    input wire [INPUT_WIDTH-1:0]    data_in, 
    input wire                      dir_r,    
    output reg [3:0]                data_out,
    output reg                      input_rec,
    output reg                      sending_output
);
    //Register to store the 8 bit inputs as 32 bits
    reg [31:0] in_data_reg = 32'b0;
    reg dir_r_reg = 1'b0;

    //We make a internal clock due to data in delay
    localparam CLK_COUNT = 4'b0100; // 8 clock cycles
    reg int_clk = 1'b0;
    reg [3:0] count = 3'b0;

    always @(posedge sys_clk or posedge rst) begin
        if(rst) begin
            count <= 4'b0100;
            int_clk <= 1'b0;
        end
        else begin
            if(count == CLK_COUNT) begin
                count <= 4'd1;
                int_clk <= ~int_clk;
                in_data_reg <= {in_data_reg[27:0], data_in};
            end
            else if(count == 4'b0010) begin
                dir_r_reg = dir_r;
                in_data_reg <= {in_data_reg[27:0], data_in};
                count <= count + 1'b1;
            end
            else begin
                count <= count + 1'b1;
                in_data_reg <= {in_data_reg[27:0], data_in};
            end
        end
    end

    //Instantiate the top module that we made
    wire [31:0] zero_count;
    wire [7:0] curr_pos;

    aoc_day1 top_module(
        .in_data(in_data_reg),
        .clk(int_clk),
        .rst(rst),
        .dir_r(dir_r_reg),
        .zero_count(zero_count),
        .curr_pos_op(curr_pos)
    );

    //Output logic
    reg [3:0] count_op = 4'b0;
    reg [31:0] data_out_reg = 32'b0;
    always @(posedge sys_clk or negedge rst) begin
        if(rst) begin
            data_out <= 4'b0;
        end
        else begin
            if(count_op == 2*CLK_COUNT) begin
                count_op <= 3'b0;
                data_out <= zero_count[31:28];
                data_out_reg <= zero_count;
                sending_output <= 1'b1;
            end
            else begin
                count_op <= count_op + 1'b1;
                data_out <= data_out_reg[31:28];
                data_out_reg <= {data_out_reg[27:0], 4'b0};
                sending_output <= 1'b0;
            end
        end
    end

endmodule
