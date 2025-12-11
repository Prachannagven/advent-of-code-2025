module mod100_pipelined (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] in_data,
    output reg  [7:0]  rot_by 
);

    // constant = floor(2^32 / 100) = magic number for fast division
    localparam MAGIC = 32'd42949673;
    
    // Since we're pipelining, we need pipeline register to store data
    reg [31:0] in_s0;

    reg [63:0] mult_s1;
    reg [31:0] in_s1;

    reg [31:0] q_s2;
    reg [31:0] in_s2;

    reg [31:0] r_s3;

    // -Stage 1 - Taking the data in
    always @(posedge clk or posedge rst) begin
        if (rst)
            in_s0 <= 0;
        else
            in_s0 <= in_data;
    end

    // Stage 2 - Multiplying the magic number and storing into S1
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mult_s1 <= 0;
            in_s1   <= 0;
        end else begin
            mult_s1 <= in_s0 * MAGIC;   // 64-bit product
            in_s1   <= in_s0;
        end
    end

    // Stage 3 - Bit shifting down to get the approximate quotient
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q_s2 <= 0;
            in_s2 <= 0;
        end else begin
            q_s2 <= mult_s1 >> 32;      // approximate quotient
            in_s2 <= in_s1;
        end
    end

    // Getting the final output by pushing it into the correct range.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_s3   <= 0;
            rot_by <= 0;
        end else begin
            // compute remainder
            rot_by <= (in_s2 - (q_s2 * 32'd100)) & 32'h000000FF;
        end
    end

endmodule
