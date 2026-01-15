module pipelined_aoc_day3 #(
    parameter DEPTH = 3, 
    parameter TOTAL_IN = 12,
    parameter FIFO_DEPTH = 16
)(
    input  logic        clk,
    input  logic        rst,
    input  logic [3:0]  digit_in,
    output logic [15:0] result_out,
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
    logic [$clog2(TOTAL_IN+1)-1:0] received;
    logic [$clog2(TOTAL_IN+1)-1:0] input_count;

    typedef struct packed {
        logic [3:0] digit;
        logic valid;
        logic [$clog2(TOTAL_IN+1)-1:0] seq_num;
        logic [$clog2(DEPTH+1)-1:0] pops_done;
    } pipeline_reg_t;

    pipeline_reg_t pipe_stages [DEPTH+1:0];

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        PROCESSING = 2'b01,
        DONE = 2'b10,
        ERR = 2'b11
    } state_t;

    state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sp <= '0;
            received <= '0;
            input_count <= '0;
            result_out <= '0;
            error <= 1'b0;
            fifo_wr_ptr <= '0;
            fifo_rd_ptr <= '0;
            fifo_count <= '0;
            
            for (int i = 0; i <= DEPTH+1; i++) begin
                pipe_stages[i].valid <= 1'b0;
                pipe_stages[i].digit <= '0;
                pipe_stages[i].seq_num <= '0;
                pipe_stages[i].pops_done <= '0;
            end
        end
        else begin
            logic fifo_wr_en;
            logic fifo_rd_en;

            fifo_wr_en = (!fifo_full && input_count < TOTAL_IN);
            
            if (fifo_wr_en) begin
                fifo_mem[fifo_wr_ptr] <= digit_in;
                fifo_wr_ptr <= (fifo_wr_ptr == FIFO_DEPTH-1) ? '0 : fifo_wr_ptr + 1;
                fifo_count <= fifo_count + 1;
                input_count <= input_count + 1;
            end

            case (state)
                IDLE: begin
                    if (!fifo_empty) begin
                        state <= PROCESSING;
                    end
                    else if (input_count >= TOTAL_IN) begin
                        state <= DONE;
                    end
                end

                PROCESSING: begin
                    fifo_rd_en = (!fifo_empty && !pipe_stages[0].valid && received < TOTAL_IN);
                    
                    if (fifo_rd_en) begin
                        pipe_stages[0].digit <= fifo_mem[fifo_rd_ptr];
                        pipe_stages[0].valid <= 1'b1;
                        pipe_stages[0].seq_num <= received;
                        pipe_stages[0].pops_done <= '0;
                        fifo_rd_ptr <= (fifo_rd_ptr == FIFO_DEPTH-1) ? '0 : fifo_rd_ptr + 1;
                        fifo_count <= fifo_count - 1;
                    end

                    for (int stage = 1; stage <= DEPTH; stage++) begin
                        if (pipe_stages[stage-1].valid && pipe_stages[stage-1].pops_done < DEPTH) begin
                            pipe_stages[stage] <= pipe_stages[stage-1];
                            pipe_stages[stage].pops_done <= pipe_stages[stage-1].pops_done + 1;
                            
                            if (sp > 0 && pipe_stages[stage-1].digit > stack[sp-1]) begin
                                logic [$clog2(TOTAL_IN+1)-1:0] remaining;
                                remaining = TOTAL_IN - pipe_stages[stage-1].seq_num;
                                if ((sp - 1 + remaining) >= DEPTH) begin
                                    sp <= sp - 1;
                                end
                            end
                        end
                        else if (pipe_stages[stage-1].valid) begin
                            pipe_stages[stage] <= pipe_stages[stage-1];
                        end
                        else begin
                            pipe_stages[stage].valid <= 1'b0;
                        end
                    end

                    if (pipe_stages[DEPTH].valid && pipe_stages[DEPTH].pops_done >= DEPTH) begin
                        pipe_stages[DEPTH+1] <= pipe_stages[DEPTH];
                    end
                    else begin
                        pipe_stages[DEPTH+1].valid <= 1'b0;
                    end

                    if (pipe_stages[DEPTH+1].valid) begin
                        if (sp < DEPTH) begin
                            stack[sp] <= pipe_stages[DEPTH+1].digit;
                            sp <= sp + 1;
                        end
                        received <= received + 1;
                        pipe_stages[DEPTH+1].valid <= 1'b0;
                    end

                    if (received >= TOTAL_IN) begin
                        logic all_empty;
                        all_empty = 1'b1;
                        for (int i = 0; i <= DEPTH+1; i++) begin
                            if (pipe_stages[i].valid)
                                all_empty = 1'b0;
                        end
                        if (all_empty)
                            state <= DONE;
                    end
                end

                DONE: begin
                    if (result_out == 0) begin
                        result_out <= '0;
                        for (int i = 0; i < DEPTH; i++) begin
                            result_out <= result_out * 10 + stack[i];
                        end
                    end
                end

                ERR: begin
                    error <= 1'b1;
                end
            endcase
        end
    end

endmodule
