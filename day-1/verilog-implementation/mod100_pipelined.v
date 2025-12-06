module mod100_pipelined (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] in_data,
    output reg  [7:0]  rot_by   // valid 3 cycles after input
);

    // constant = floor(2^32 / 100)
    localparam MAGIC = 32'd42949673;

    // ---------- Pipeline Stage Registers ----------
    reg [31:0] in_s0;
    reg [63:0] mult_s1;
    reg [31:0] in_s1;
    reg [31:0] q_s2;
    reg [31:0] in_s2;
    reg [31:0] r_s3;

    // ---------- Stage 0: Register Input ----------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            in_s0 <= 0;
        end else begin
            in_s0 <= in_data;
        end
    end

    // ---------- Stage 1: Multiply ----------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mult_s1 <= 0;
            in_s1   <= 0;
        end else begin
            mult_s1 <= in_s0 * MAGIC;
            in_s1   <= in_s0;
        end
    end

    // ---------- Stage 2: Compute q ----------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q_s2 <= 0;
            in_s2 <= 0;
        end else begin
            q_s2 <= mult_s1 >> 32;
            in_s2 <= in_s1;
        end
    end

    // ---------- Stage 3: Compute remainder ----------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rot_by <= 0;
            r_s3 <= 0;
        end else begin
            r_s3 <= (in_s2 - (q_s2 * 8'd100));
            rot_by = r_s3[7:0];
        end
    end

endmodule
