open! Hardcaml
open! Signal

(* Mod100 is a sibling module in the same library *)

module I = struct
    type 'a t = {
        clk     : 'a;
        rst     : 'a;
        dir_r   : 'a;
        in_data : 'a [@bits 32];
    }
    [@@deriving hardcaml]
end

module O = struct
    type 'a t = {
        zero_count  : 'a [@bits 32];
        curr_pos_op : 'a [@bits 8];
    }
    [@@deriving hardcaml]
end

let create (i : _ I.t) : _ O.t =
    let spec = Reg_spec.create ~clock:i.clk ~clear:i.rst () in
        
    (* We instantiate the module first, only inputs, then output *)
    let mod100_out = Mod100.create{
        clk     = i.clk;
        rst     = i.rst;
        data_in = i.in_data;
    }
    in
    let rot_by = mod100_out.rot_by in

    (* Delay Shift Register for dir_r *)
    let dir_r_reg = reg_fb spec ~width:5 ~f:(fun out -> 
            ((select out ~high:3 ~low:0) @: i.dir_r)
        ) 
    in  
    let dir_r_del = select dir_r_reg ~high:4 ~low:4 in

    (* curr_pos and next_pos implementation *)
    (* initially setting current position to 50 *)
    let curr_pos = reg_fb spec ~width:8 ~f:(fun out ->
            (* Precompute both forward and backward rotation *)
            let rot_forward = out +: rot_by in
            let rot_backward = out -: rot_by +: (of_int_trunc ~width:8 100) in
            (* Figure out which one (forward or backward) is needed and assign that *)
            let raw = mux2 dir_r_del rot_forward rot_backward in
            (* Wrap Around to 100 *)
            mux2 (raw >=: (of_int_trunc ~width:8 100)) (raw -: (of_int_trunc ~width:8 100)) (raw)
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

    {O.curr_pos_op; zero_count}
;;
    
        
let hierarchical scope =
  let module Scoped = Hierarchy.In_scope (I) (O) in
  Scoped.hierarchical
    ~scope
    ~name:"aoc_day1_part1"
    (fun _scope i -> create i)
;;
