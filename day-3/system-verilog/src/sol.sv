module aoc_day3 #(
    parameter DEPTH = 5,
    parameter DIGITS_PER_NUM = 15,
    parameter FIFO_DEPTH = 16
)(
    input  logic        clk,
    input  logic        rst,
    input  logic [3:0]  digit_in,
    input  logic        digit_valid,
    output logic [63:0] sum_out,
    output logic        error
);

    //FIFO for stability
    logic [3:0] fifo_mem [FIFO_DEPTH-1:0];
    logic [$clog2(FIFO_DEPTH)-1:0] fifo_wr_ptr, fifo_rd_ptr;
    logic [$clog2(FIFO_DEPTH+1)-1:0] fifo_count;
    logic fifo_full, fifo_empty;
    assign fifo_full = (fifo_count == FIFO_DEPTH);
    assign fifo_empty =(fifo_count == 0);

    //Building my stack
    logic [3:0] stack [DEPTH-1:0];
    logic [$clog2(DEPTH+1)-1:0] sp;
    logic [$clog2(DIGITS_PER_NUM+1)-1:0] digit_count;
    logic [3:0] digit_reg;
    logic can_pop, better, feasible, pop_cond;
    assign can_pop = (sp > 0);
    assign better  = (digit_reg > stack[sp-1]);
    assign feasible = (sp + (DIGITS_PER_NUM - digit_count) > DEPTH);
    assign pop_cond = can_pop && better && feasible;

    //States
    typedef enum logic[2:0]{
        IDLE = 3'b000,
        RUN  = 3'b001,
        WAIT = 3'b010,
        POP  = 3'b011,
        DONE = 3'b100
    } state_t;
    state_t state;

    //Additional Resources for sum tracking
    logic [60:0] sum_reg;
    logic [40:0] current_result;
    logic [$clog2(DEPTH+1)-1:0] result_idx;
    assign sum_out = sum_reg;
    assign error = 1'b0;  // No error conditions implemented

    //State machine
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            sp <= '0;
            digit_count <= '0;
            digit_reg <= '0;
            state <= '0;
            result_idx <= '0;
            current_result <= '0;
            sum_reg <= '0;
            fifo_wr_ptr <= '0;
            fifo_rd_ptr <= '0;
            fifo_count <= '0;
        end
        else begin
            //Write to fifo every clock cycle so that if processing
            //increases/decreases for a clock cycle, we can still continue
            //streaming input at once digit per clock cycle. Wohoo stability.
            //TODO: Try and pipeline this using pipeline registers for
            //comparison. Might get too complex for 12, but should be possible
            //for 2.
            if(!fifo_full && digit_valid) begin
                fifo_mem[fifo_wr_ptr] <= digit_in;
                fifo_wr_ptr <= (fifo_wr_ptr == FIFO_DEPTH-1) ? '0 : fifo_wr_ptr + 1;
            end

            if(!fifo_empty && state == RUN && digit_count < DIGITS_PER_NUM) begin
                digit_reg <= fifo_mem[fifo_rd_ptr];
                fifo_rd_ptr <= (fifo_rd_ptr == FIFO_DEPTH-1) ? '0 : fifo_rd_ptr + 1;
            end

            case ({(!fifo_full && digit_valid), (!fifo_empty && state == RUN && digit_count < DIGITS_PER_NUM)})
                2'b10: fifo_count <= fifo_count + 1;
                2'b01: fifo_count <= fifo_count - 1;
                default: fifo_count <= fifo_count;
            endcase

            //The state machine itsefl
            case (state)
                IDLE: begin
                    if(!fifo_empty) begin
                        state <= RUN;
                    end
                end
                RUN: begin
                    if (digit_count < DIGITS_PER_NUM) begin
                        if(!fifo_empty) 
                            state  <= WAIT;
                        else
                            state <= RUN;
                    end
                    else begin
                        state <= DONE;
                    end
                end
                WAIT: begin
                    state <= POP;
                end
                POP: begin
                    if(pop_cond) begin
                        sp <= sp - 1;
                    end
                    else begin
                        if(sp < DEPTH) begin
                            stack[sp] <= digit_reg;
                            sp <= sp  +1;
                        end
                        digit_count <= digit_count + 1;
                        state <= RUN;
                    end
                end

                DONE: begin
                    if(result_idx < DEPTH) begin
                        current_result <= current_result * 10 + stack[result_idx];
                        result_idx <= result_idx + 1;
                    end
                    else begin
                        sum_reg <= sum_reg + current_result;
                        result_idx <= '0;
                        digit_count <= '0;
                        current_result <= '0;
                        sp <= '0;
                        if(!fifo_empty)
                            state <= RUN;
                        else
                            state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule

