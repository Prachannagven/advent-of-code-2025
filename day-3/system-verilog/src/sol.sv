module aoc_day3 #(
    parameter DEPTH = 5, 
    parameter DIGITS_PER_NUMBER = 15,
    parameter FIFO_DEPTH = 16
)(
    input  logic        clk,
    input  logic        rst,
    input  logic [3:0]  digit_in,
    input  logic        digit_valid,  // New: indicates when digit_in is valid
    output logic [63:0] sum_out,      // Running sum of all max sub-numbers
    output logic        error
);

    logic [3:0] fifo_mem [FIFO_DEPTH-1:0];
    logic [$clog2(FIFO_DEPTH)-1:0] fifo_wr_ptr, fifo_rd_ptr;
    logic [$clog2(FIFO_DEPTH+1)-1:0] fifo_count;

    logic fifo_empty, fifo_full;

    assign fifo_empty = (fifo_count == 0);
    assign fifo_full  = (fifo_count == FIFO_DEPTH);

    logic [3:0] stack [DEPTH-1:0];
    logic [$clog2(DEPTH+1)-1:0] sp;
    logic [$clog2(DIGITS_PER_NUMBER+1)-1:0] digit_count;  // Count digits in current number
    logic [3:0] digit_reg;

    logic can_pop, better, feasible, pop_cond;

    assign can_pop  = (sp > 0);
    assign better   = (digit_reg > stack[sp-1]);
    assign feasible = ((sp - 1 + (DIGITS_PER_NUMBER - digit_count)) >= DEPTH);
    assign pop_cond = can_pop && better && feasible;

    logic [$clog2(DEPTH+1)-1:0] result_idx;
    logic [63:0] current_result;  // Result for current number
    logic [63:0] sum_reg;         // Running sum of all results

    typedef enum logic [2:0] {
        IDLE  = 3'b000,  // Waiting for first digit or between numbers
        RUN   = 3'b001,  // Reading from FIFO
        WAIT  = 3'b010,  // Wait state before POP
        POP   = 3'b011,  // Processing digit
        DONE  = 3'b100,  // Computing result for current number
        ERR   = 3'b101
    } state_t;

    state_t state;

    assign sum_out = sum_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            sp            <= '0;
            digit_count   <= '0;
            current_result <= '0;
            sum_reg       <= '0;
            error         <= 1'b0;
            fifo_wr_ptr   <= '0;
            fifo_rd_ptr   <= '0;
            fifo_count    <= '0;
            digit_reg     <= '0;
            result_idx    <= '0;
        end
        else begin
            logic fifo_wr_en;
            logic fifo_rd_en;

            // Write to FIFO when digit_valid is high and FIFO not full
            fifo_wr_en = (!fifo_full && digit_valid);
            fifo_rd_en = (state == RUN && !fifo_empty && digit_count < DIGITS_PER_NUMBER);

            if (fifo_wr_en) begin
                fifo_mem[fifo_wr_ptr] <= digit_in;
                fifo_wr_ptr <= (fifo_wr_ptr == FIFO_DEPTH-1) ? '0 : fifo_wr_ptr + 1;
            end

            if (fifo_rd_en) begin
                digit_reg <= fifo_mem[fifo_rd_ptr];
                fifo_rd_ptr <= (fifo_rd_ptr == FIFO_DEPTH-1) ? '0 : fifo_rd_ptr + 1;
            end

            case ({fifo_wr_en, fifo_rd_en})
                2'b10: fifo_count <= fifo_count + 1;
                2'b01: fifo_count <= fifo_count - 1;
                default: fifo_count <= fifo_count;
            endcase

            case (state)
                IDLE: begin
                    // Wait for data in FIFO, then start processing
                    if (!fifo_empty) begin
                        state <= RUN;
                    end
                end

                RUN: begin
                    if (digit_count < DIGITS_PER_NUMBER) begin
                        if (!fifo_empty)
                            state <= WAIT;
                        else
                            state <= RUN;  // Wait for more data
                    end
                    else begin
                        // Finished collecting DIGITS_PER_NUMBER digits
                        state <= DONE;
                    end
                end

                WAIT: begin
                    state <= POP;
                end

                POP: begin
                    if (pop_cond) begin
                        sp <= sp - 1;
                    end
                    else begin
                        if (sp < DEPTH) begin
                            stack[sp] <= digit_reg;
                            sp <= sp + 1;
                        end
                        digit_count <= digit_count + 1;
                        state <= RUN;
                    end
                end

                DONE: begin
                    // Build the result from the stack
                    if (result_idx < DEPTH) begin
                        current_result <= current_result * 10 + stack[result_idx];
                        result_idx <= result_idx + 1;
                    end
                    else begin
                        // Add current result to sum and reset for next number
                        sum_reg <= sum_reg + current_result;
                        current_result <= '0;
                        result_idx <= '0;
                        digit_count <= '0;
                        sp <= '0;
                        // Check if there's more data to process
                        if (!fifo_empty)
                            state <= RUN;
                        else
                            state <= IDLE;
                    end
                end

                ERR: begin
                    error <= 1'b1;
                end
            endcase
        end
    end

endmodule
