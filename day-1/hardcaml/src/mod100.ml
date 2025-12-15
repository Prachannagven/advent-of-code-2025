open! Hardcaml
open! Signal

let in_bits = 32
let rot_bits = 8
let magic = of_int_trunc ~width:64 42949673
let hundred = of_int_trunc ~width:32 100

(* Input Side *)
module I = struct
    type 'a t = {
        clk : 'a;
        rst : 'a;
        data_in : 'a [@bits in_bits];
    }
    [@@deriving hardcaml]
end

(* Output Side *)
module O = struct
    type 'a t = {
        rot_by : 'a [@bits rot_bits];
    }
    [@@deriving hardcaml]
end

(* The Pipeline Itself *)
let create (i : _ I.t) : _ O.t = 
    (* The general specification of all the registers in this particular... environment? *)
    let spec = Reg_spec.create ~clock:i.clk ~clear:i.rst () in

    (* Stage 0 - Register input *)
    let in_s0   = reg spec i.data_in in

    (* Stage 1 - Multiply by the predefined magic constant *)
    let mult_s1 = reg spec (in_s0 *: magic) in
    let in_s1   = reg spec in_s0 in

    (* Stage 2 - Extract quotient from bits [63:32] of the 64-bit multiplication result *)
    let q_s2    = reg spec (select mult_s1 ~high:63 ~low:32) in
    let in_s2   = reg spec in_s1 in

    (* Stage 3 - Compute remainder: input - quotient*100 *)
    let r_s3    = reg spec (sel_bottom ~width:32 (uresize ~width:64 in_s2 -: (q_s2 *: hundred))) in

    { O.rot_by = (sel_bottom ~width:8 r_s3)}


let hierarchical scope =
  let module Scoped = Hierarchy.In_scope (I) (O) in
  Scoped.hierarchical
    ~scope
    ~name:"mod100"
    (fun _scope i -> create i)
;;


