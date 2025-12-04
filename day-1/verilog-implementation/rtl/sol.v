// zero_counter.v
module zero_counter(
    input  wire [31:0] data_in,
    input  wire        dir_r,
    input  wire        clk,
    input  wire        rst,
    output reg  [15:0] zero_count,   // number of times final pos == 0 (truncated)
    output reg  [15:0] zero_cross    // number of times we crossed position 0 (truncated)
);

    // ----------------------------------------------------------------------------
    // Internal registers (wider for safety)
    // ----------------------------------------------------------------------------
    reg [7:0]  pos;            // current position in 0..99 (use 8 bits)
    reg [31:0] internal_count; // full internal counter for "final pos == 0"
    reg [31:0] internal_cross; // full internal counter for "crossing zero"

    // ----------------------------------------------------------------------------
    // Combinational helpers: rotation decomposition
    // ----------------------------------------------------------------------------
    // full_wraps = data_in / 100  (how many full 0..99 cycles are in data_in)
    // rot_by     = data_in % 100  (remainder rotation within 0..99)
    wire [31:0] full_wraps;
    wire [6:0]  rot_by;          // 0..99 fits in 7 bits
    assign full_wraps = data_in / 100;
    assign rot_by     = data_in % 100;

    // For addition: pos + rot_by may be up to 198 -> use 9 bits to detect >=100
    wire [8:0] sum_add = pos + rot_by;
    wire       add_wrap = (sum_add >= 9'd100);
    wire [6:0] pos_next_add = add_wrap ? (sum_add - 9'd100) : sum_add[6:0];

    // For subtraction: if pos < rot_by, we wrap backwards once (and possibly more via full_wraps)
    wire       sub_wrap = (pos < rot_by);
    wire [6:0] pos_next_sub = sub_wrap ? (pos + 7'd100 - rot_by) : (pos - rot_by);

    // Compute total zero-cross events caused by this rotation:
    // - Each full 100 contributes one crossing.
    // - The remainder (rot_by) contributes at most one extra crossing:
    //   * for forward (dir_r): if add_wrap is true -> +1
    //   * for backward (!dir_r): if sub_wrap is true -> +1
    wire [31:0] extra_wrap_forward = add_wrap ? 32'd1 : 32'd0;
    wire [31:0] extra_wrap_backward = sub_wrap ? 32'd1 : 32'd0;

    // final next-pos (7-bit) depends on direction; compute combinationally
    wire [6:0] next_pos = dir_r ? pos_next_add : pos_next_sub;

    // ----------------------------------------------------------------------------
    // Synchronous update (all non-blocking) — update pos, internal counters and outputs
    // ----------------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pos            = 8'd50;
            internal_count = 32'd0;
            internal_cross = 32'd0;
            zero_count     = 16'd0;
            zero_cross     = 16'd0;
        end else begin
            // Add full_wraps and the possible extra wrap
            if (dir_r) begin
                internal_cross = internal_cross + full_wraps + extra_wrap_forward;
            end else begin
                internal_cross = internal_cross + full_wraps + extra_wrap_backward;
            end

            // Update position (mod 100)
            pos <= {1'b0, next_pos}; // extend to 8 bits safely

            // Update internal_count: increment by 1 if new position equals 0
            if (next_pos == 7'd0)
                internal_count = internal_count + 32'd1;

            // Drive truncated outputs synchronously (lowest 16 bits)
            zero_count = internal_count[15:0];
            zero_cross = internal_cross[15:0];
        end
    end

endmodule

