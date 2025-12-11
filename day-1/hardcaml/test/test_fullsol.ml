open! Core
open! Hardcaml
open! Hardcaml_waveterm
open! Hardcaml_test_harness

module Top = Aoc_day1_part1.Top

module Harness = Cyclesim_harness.Make (Top.I) (Top.O)

let ( <--. ) = Bits.( <--. )

(* Test with input data values - these will be mod 100'd and used as movement *)
let tv_in = [ 125; 27; 783; 1089; 7779 ]
let tv_mod100 = List.map tv_in ~f:(fun x -> x mod 100) (* Expected rot_by values *)

let simple_testbench (sim : Harness.Sim.t) =
  let inputs = Cyclesim.inputs sim in
  let outputs = Cyclesim.outputs sim in
  let cycle ?n () = Cyclesim.cycle ?n sim in

  (* Reset *)
  cycle();
  inputs.rst := Bits.vdd;
  cycle ();
  inputs.rst := Bits.gnd;
  cycle ();

  (* Set direction - let's test forward (1) *)
  inputs.dir_r := Bits.vdd;

  (* Apply inputs, one per cycle, and sample outputs throughout *)
  let observed_pos = ref [] in
  let observed_zero = ref [] in
  
  List.iter tv_in ~f:(fun v ->
    inputs.in_data <--. v;
    observed_pos := !observed_pos @ [ Bits.to_unsigned_int !(outputs.curr_pos_op) ];
    observed_zero := !observed_zero @ [ Bits.to_unsigned_int !(outputs.zero_count) ];
    cycle ()
  );

  (* drive zeros and let pipeline flush, continue sampling *)
  inputs.in_data <--. 0;
  for _ = 1 to 10 do
    observed_pos := !observed_pos @ [ Bits.to_unsigned_int !(outputs.curr_pos_op) ];
    observed_zero := !observed_zero @ [ Bits.to_unsigned_int !(outputs.zero_count) ];
    cycle ()
  done;

  (* Print all observations *)
  Stdio.printf "Cycle | Input     | Position | Zero Count\n";
  Stdio.printf "-------------------------------------------\n";
  List.iteri !observed_pos ~f:(fun i pos ->
    let input_val = if i < List.length tv_in then List.nth_exn tv_in i else 0 in
    let zero_cnt = List.nth_exn !observed_zero i in
    Stdio.printf "%5d | %9d | %8d | %10d\n" i input_val pos zero_cnt
  )
;;

let waves_config = 
    Waves_config.to_directory "/tmp/"
    |> Waves_config.as_wavefile_format ~format:Vcd
;;

let%expect_test "Top module test - feed data and observe position" =
  Harness.run_advanced ~waves_config ~create:Top.hierarchical simple_testbench;
  [%expect {|
    Cycle | Input     | Position | Zero Count
    -------------------------------------------
        0 |       125 |        0 |          1
        1 |        27 |        0 |          2
        2 |       783 |        0 |          3
        3 |      1089 |        0 |          4
        4 |      7779 |        0 |          5
        5 |         0 |       75 |          6
        6 |         0 |        2 |          6
        7 |         0 |       85 |          6
        8 |         0 |       74 |          6
        9 |         0 |       53 |          6
       10 |         0 |       53 |          6
       11 |         0 |       53 |          6
       12 |         0 |       53 |          6
       13 |         0 |       53 |          6
       14 |         0 |       53 |          6
    Saved waves to /tmp/test_fullsol_ml_Top_module_test___feed_data_and_observe_position.vcd
    |}]
;;
