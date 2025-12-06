//Width of FIFO 
module FIFO #(
    parameter DEPTH = 3, 
    parameter DWIDTH = 32
)(
    //General inputs to FIFO
    input wire          clk,
    input wire          rst_n,
    //Input side of synchronous FIFO
    input wire [DWIDTH-1:0]   data_in,
    input wire          w_en,
    output reg          full,
    //Output side of FIFO
    input wire          r_en,
    output reg [DWIDTH-:0]   data_out,
    output reg          empty
);

    reg [$clog2(DEPTH)-1:0] wptr;
    reg [$clog2(DEPTH)-1:0] rptr;

    reg [DWIDTH-1:0] fifo_data [DEPTH];

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wptr <= 1'b0;
        end
        else begin
            if(wr_en & !full) begin
                fifo [wptr] <= din;
                wptr <= wptr + 1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rptr <= 1'b0;
        end
        else begin
            if(rd_en & !empty) begin
                dout <= fifo[rptr];
                rptr <= rptr + 1;
            end
        end
    end

    assign full = (wptr + 1) == rptr;
    assign empty = wptr == rptr;
    
endmodule
    

    