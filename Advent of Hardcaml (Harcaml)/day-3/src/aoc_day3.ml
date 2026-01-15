open! Core
open Hardcaml
open Signal

module Config = struct
    let depth = 5
    let digits_per_num = 15
    let fifo_depth = 16
end

module I = struct
    type 'a t = {
        clk         : 'a;
        rst         : 'a;
        digit_in    : 'a [@bits 4];
        digit_valid : 'a;
    }
    [@@deriving hardcaml]
end

module O = struct
    type 'a t = {
        sum_out     : 'a [@bits 64];
        error       : 'a;
    }
    [@@deriving hardcaml]
end

let create (_scope : Scope.t) (i : Signal.t I.t) : Signal.t O.t =
    let spec = Reg_spec.create ~clock:i.clk ~clear:i.rst () in
    
    let fifo_wr_ptr_bits = address_bits_for Config.fifo_depth in
    let fifo_count_bits = address_bits_for (Config.fifo_depth + 1) in
    let sp_bits = address_bits_for (Config.depth + 1) in
    let digit_count_bits = address_bits_for (Config.digits_per_num + 1) in
    
    let next_fifo_wr_ptr = wire fifo_wr_ptr_bits in
    let next_fifo_rd_ptr = wire fifo_wr_ptr_bits in
    let next_fifo_count = wire fifo_count_bits in
    let next_sp = wire sp_bits in
    let next_digit_count = wire digit_count_bits in
    let next_digit_reg = wire 4 in
    let next_state = wire 3 in
    let next_result_idx = wire sp_bits in
    let next_current_result = wire 64 in
    let next_sum_reg = wire 64 in
    
    let fifo_wr_ptr = reg spec ~enable:vdd next_fifo_wr_ptr in
    let fifo_rd_ptr = reg spec ~enable:vdd next_fifo_rd_ptr in
    let fifo_count = reg spec ~enable:vdd next_fifo_count in
    let sp = reg spec ~enable:vdd next_sp in
    let digit_count = reg spec ~enable:vdd next_digit_count in
    let digit_reg = reg spec ~enable:vdd next_digit_reg in
    let state = reg spec ~enable:vdd next_state in
    let result_idx = reg spec ~enable:vdd next_result_idx in
    let current_result = reg spec ~enable:vdd next_current_result in
    let sum_reg = reg spec ~enable:vdd next_sum_reg in
    
    let fifo_empty = fifo_count ==:. 0 in
    let fifo_full = fifo_count ==:. Config.fifo_depth in
    
    let next_stack = List.init Config.depth ~f:(fun _ -> wire 4) in
    let stack = List.map next_stack ~f:(fun next_val -> reg spec ~enable:vdd next_val) in
    
    let next_fifo_mem = List.init Config.fifo_depth ~f:(fun _ -> wire 4) in
    let fifo_mem = List.map next_fifo_mem ~f:(fun next_val -> reg spec ~enable:vdd next_val) in
    let fifo_read_data = mux fifo_rd_ptr fifo_mem in
    
    let error_reg = reg spec ~enable:vdd gnd in
    
    let fifo_wr_en = ~:fifo_full &: i.digit_valid in
    let fifo_rd_en = wire 1 in
    
    let state_idle = of_int ~width:3 0 in
    let state_run = of_int ~width:3 1 in
    let state_wait = of_int ~width:3 2 in
    let state_pop = of_int ~width:3 3 in
    let state_done = of_int ~width:3 4 in
    let _state_err = of_int ~width:3 5 in
    
    (* pop condition: can we pop, is current digit better, do we have enough remaining? *)
    let can_pop = sp >:. 0 in
    let stack_top_idx = mux2 can_pop (sp -:. 1) (zero sp_bits) in
    let stack_top_data = mux stack_top_idx stack in
    let better = can_pop &: (digit_reg >: stack_top_data) in
    let remaining_positions = of_int ~width:digit_count_bits Config.digits_per_num -: digit_count in
    let after_pop_depth = mux2 can_pop (sp -:. 1) (zero sp_bits) in
    let feasible_width = max sp_bits digit_count_bits in (* avoid truncation bug *)
    let feasible = ((uresize after_pop_depth feasible_width) +: (uresize remaining_positions feasible_width)) >=:. Config.depth in
    let pop_cond = can_pop &: better &: feasible in
    
    fifo_rd_en <== ((state ==: state_run) &: ~:fifo_empty &: (digit_count <:. Config.digits_per_num));
    
    List.iteri next_fifo_mem ~f:(fun idx next_val ->
        let current_val = List.nth_exn fifo_mem idx in
        let is_write = fifo_wr_en &: (fifo_wr_ptr ==:. idx) in
        next_val <== mux2 is_write i.digit_in current_val
    );
    
    next_fifo_wr_ptr <== mux2 fifo_wr_en
        (mux2 (fifo_wr_ptr ==:. (Config.fifo_depth - 1)) (zero fifo_wr_ptr_bits) (fifo_wr_ptr +:. 1))
        fifo_wr_ptr;
    
    next_fifo_rd_ptr <== mux2 fifo_rd_en
        (mux2 (fifo_rd_ptr ==:. (Config.fifo_depth - 1)) (zero fifo_wr_ptr_bits) (fifo_rd_ptr +:. 1))
        fifo_rd_ptr;
    
    next_fifo_count <==
        mux2 (fifo_wr_en &: ~:fifo_rd_en) (fifo_count +:. 1)
            (mux2 (~:fifo_wr_en &: fifo_rd_en) (fifo_count -:. 1) fifo_count);
    
    next_digit_reg <== mux2 fifo_rd_en fifo_read_data digit_reg;
    
    (* state machine *)
    next_state <== mux state [
        mux2 ~:fifo_empty state_run state_idle;                                           (* IDLE *)
        mux2 (digit_count <:. Config.digits_per_num)
            (mux2 ~:fifo_empty state_wait state_run) state_done;                          (* RUN *)
        state_pop;                                                                        (* WAIT *)
        mux2 pop_cond state_pop state_run;                                                (* POP *)
        mux2 (result_idx <:. Config.depth) state_done
            (mux2 ~:fifo_empty state_run state_idle);                                     (* DONE *)
        state;                                                                            (* ERR *)
    ];
    
    next_sp <== mux state [
        sp;
        sp;
        sp;
        mux2 pop_cond (sp -:. 1) (mux2 (sp <:. Config.depth) (sp +:. 1) sp);
        mux2 (result_idx >=:. Config.depth) (zero sp_bits) sp;
        sp;
    ];
    
    next_digit_count <== mux state [
        digit_count;
        digit_count;
        digit_count;
        mux2 pop_cond digit_count (digit_count +:. 1);
        mux2 (result_idx >=:. Config.depth) (zero digit_count_bits) digit_count;
        digit_count;
    ];
    
    List.iteri next_stack ~f:(fun idx next_s ->
        let s_val = List.nth_exn stack idx in
        let is_push = (state ==: state_pop) &: ~:pop_cond &: (sp ==:. idx) &: (sp <:. Config.depth) in
        next_s <== mux2 is_push digit_reg s_val
    );
    
    let stack_value = mux result_idx stack in
    next_current_result <== mux state [
        current_result;
        current_result;
        current_result;
        current_result;
        mux2 (result_idx <:. Config.depth)
            ((sel_bottom (current_result *: (of_int ~width:64 10)) 64) +: (uresize stack_value 64))
            (mux2 (result_idx >=:. Config.depth) (zero 64) current_result);
        current_result;
    ];
    
    next_result_idx <== mux state [
        result_idx;
        result_idx;
        result_idx;
        result_idx;
        mux2 (result_idx <:. Config.depth) (result_idx +:. 1)
            (mux2 (result_idx >=:. Config.depth) (zero sp_bits) result_idx);
        result_idx;
    ];
    
    next_sum_reg <== mux state [
        sum_reg;
        sum_reg;
        sum_reg;
        sum_reg;
        mux2 (result_idx >=:. Config.depth) (sum_reg +: current_result) sum_reg;
        sum_reg;
    ];
    
    { O. sum_out = sum_reg; error = error_reg }
;;

let hierarchical scope =
    let module Scoped = Hierarchy.In_scope (I) (O) in
    Scoped.hierarchical ~scope ~name:"aoc_day3" (fun scope i -> create scope i)
;;



