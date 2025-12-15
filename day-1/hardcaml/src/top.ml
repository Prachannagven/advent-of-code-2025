open! Hardcaml
open! Signal

(* Input *)
module I = struct
    type 'a t = {
        clk     : 'a;
        rst     : 'a;
        dir_r   : 'a;
        in_data : 'a [@bits 32]
    }
    [@@deriving hardcaml]
end

(* Output*)
module O = struct
    type 'a t = {
        zero_count     : 'a [@bits 32];
        curr_pos_op    : 'a [@bits 8];
        dir_r_reg      : 'a [@bits 4];
        zero_crossings : 'a [@bits 32];
    }
    [@@deriving hardcaml]
end

(* Main Running Loop *)
let create (scope : Scope.t) (i : _ I.t) : _ O.t =
    let spec = Reg_spec.create ~clock:i.clk ~clear:i.rst () in
    let spec_with_reset = Reg_spec.create ~clock:i.clk ~reset:i.rst () in
        
    (* We instantiate the module first, only inputs, then output *)
    let mod100_out = Mod100.hierarchical scope {
        clk     = i.clk;
        rst     = i.rst;
        data_in = i.in_data;
    }
    in
    let rot_by = mod100_out.rot_by in

    (* Delay Shift Register for dir_r *)
    let dir_r_reg = reg_fb spec ~width:4 ~f:(fun out -> 
            ((select out ~high:2 ~low:0) @: i.dir_r)
        ) 
    in  
    let dir_r_del = select dir_r_reg ~high:3 ~low:3 in

    (* A nice little register that computes both forward and backward and then selects which way to go to reduce latency.*)
    let curr_pos = reg_fb spec_with_reset ~width:8 ~reset_to:(Bits.of_int_trunc ~width:8 50) ~initialize_to:(Bits.of_int_trunc ~width:8 50) ~f:(fun out ->
            let rot_forward = out +: rot_by in
            let rot_backward = out -: rot_by +: (of_int_trunc ~width:8 100) in
            let raw = mux2 dir_r_del rot_forward rot_backward in
            mux2 (raw >=: (of_int_trunc ~width:8 100)) (raw -: (of_int_trunc ~width:8 100)) (raw)
        )
    in
    

    let rot_forward_raw = uresize ~width:9 curr_pos +: uresize ~width:9 rot_by in
    let rot_backward_raw = curr_pos -: rot_by in
    
    let zero_crossing_detected = 
        let curr_pos_not_zero = curr_pos <>:. 0 in
        let forward_crossing = (rot_forward_raw >: (of_int_trunc ~width:9 100)) &: curr_pos_not_zero in
        let backward_crossing = (msb rot_backward_raw) &: curr_pos_not_zero in  (* Check sign bit for negative *)
        mux2 dir_r_del forward_crossing backward_crossing
    in
    
    (* This divides by 100, and is also pipelined to the same speed as Mod100, so works parallelly *)
    let magic_div = of_int_trunc ~width:64 42949672 in
    let in_data_64 = uresize ~width:64 i.in_data in
    let mult_result = in_data_64 *: magic_div in
    let quotient = uresize ~width:32 (select mult_result ~high:63 ~low:32) in
    
    (* Incremenets by quotient and zero crossing detected if found, just like I made in the verilog code *)
    let zero_crossings = reg_fb spec ~width:32 ~f:(fun out ->
            let crossing_increment = mux2 zero_crossing_detected (of_int_trunc ~width:32 1) (of_int_trunc ~width:32 0) in
            out +: quotient +: crossing_increment
        )
    in
    
    let next_pos = curr_pos in
    
    (* For output visibility *)
    let curr_pos_op = next_pos in
    
    let zero_count = reg_fb spec ~width:32 ~f:(fun out ->
            mux2 (next_pos ==:. 0)
                (out +:. 1)
                out
        )
    in

    {O.curr_pos_op; zero_count; dir_r_reg; zero_crossings}
;;
    
        
let hierarchical scope =
  let module Scoped = Hierarchy.In_scope (I) (O) in
  Scoped.hierarchical
    ~scope
    ~name:"top"
    (fun scope i -> create scope i)
;;
