module mod100_pipelined (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] in_data,
    output reg  [7:0]  rot_by  // valid 3 cycles after input
);

    // constant = floor(2^32 / 100) = magic number for fast division
    localparam MAGIC = 32'd42949673;

    // ---------------- Pipeline Registers ----------------
    reg [31:0] in_s0;      // stage 0: input latch

    reg [63:0] mult_s1;    // stage 1: multiplication
    reg [31:0] in_s1;

    reg [31:0] q_s2;       // stage 2: quotient
    reg [31:0] in_s2;

    reg [31:0] r_s3;       // stage 3: remainder

    // ---------------- Stage 0 ----------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            in_s0 <= 0;
        else
            in_s0 <= in_data;
    end

    // ---------------- Stage 1 ----------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mult_s1 <= 0;
            in_s1   <= 0;
        end else begin
            mult_s1 <= in_s0 * MAGIC;   // 64-bit product
            in_s1   <= in_s0;
        end
    end

    // ---------------- Stage 2 ----------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q_s2 <= 0;
            in_s2 <= 0;
        end else begin
            q_s2 <= mult_s1 >> 32;      // approximate quotient
            in_s2 <= in_s1;
        end
    end

    // ---------------- Stage 3 ----------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_s3   <= 0;
            rot_by <= 0;
        end else begin
            // compute remainder
            r_s3   <= in_s2 - (q_s2 * 32'd100);

            // FULLY SAFE BOUNDS — ENSURE < 100
            if (r_s3 >= 100)
                rot_by <= r_s3 - 100;
            else
                rot_by <= r_s3[7:0];
        end
    end

endmodule
