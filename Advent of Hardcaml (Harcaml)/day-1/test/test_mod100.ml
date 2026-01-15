(* test/test_mod100.ml *)
open! Core
open! Hardcaml
open! Hardcaml_waveterm
open! Hardcaml_test_harness

(* IMPORTANT: This refers to the library namespace from src/dune (name aoc_day1_part1).
   The module file src/mod100.ml becomes Mod100 inside the aoc_day1_part1 library.
*)
module Mod100 = Aoc_day1_part1.Mod100

module Harness = Cyclesim_harness.Make (Mod100.I) (Mod100.O)

let ( <--. ) = Bits.( <--. )

let tv_in = [ 125; 27; 783; 1089; 7779 ]
let tv_expected = List.map tv_in ~f:(fun x -> x mod 100)

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

  (* Apply inputs, one per cycle, and sample outputs throughout *)
  let observed = ref [] in
  
  List.iter tv_in ~f:(fun v ->
    inputs.data_in <--. v;
    observed := !observed @ [ Bits.to_unsigned_int !(outputs.rot_by) ];
    cycle ()
  );

  (* drive zeros and let pipeline flush, continue sampling *)
  inputs.data_in <--. 0;
  for _ = 1 to 10 do
    observed := !observed @ [ Bits.to_unsigned_int !(outputs.rot_by) ];
    cycle ()
  done;

  (* Align by latency *)
  let latency = 4 in
  let obs_window = List.drop !observed latency |> Fn.flip List.take (List.length tv_in) in

  (* print and assert *)
  List.iter2_exn obs_window tv_expected ~f:(fun obs exp ->
    if obs = exp then Stdio.printf "OK: observed %d expected %d\n%!" obs exp
    else Stdio.printf "ERROR: observed %d expected %d\n%!" obs exp
  );

  let mismatches =
    List.zip_exn obs_window tv_expected |> List.filter ~f:(fun (o,e) -> o <> e)
  in
  if not (List.is_empty mismatches) then
    raise_s [%message "Test failed" (mismatches : (int * int) list)]
;;

(*let waves_config = Waves_config.no_waves*)

let waves_config = 
    Waves_config.to_directory "/tmp/"
    |> Waves_config.as_wavefile_format ~format:Vcd
;;

let%expect_test "Simple test, optionally saving waveforms to disk" =
  Harness.run_advanced ~waves_config ~create:Mod100.hierarchical simple_testbench;
  [%expect {|
    OK: observed 25 expected 25
    OK: observed 27 expected 27
    OK: observed 83 expected 83
    OK: observed 89 expected 89
    OK: observed 79 expected 79
    Saved waves to /tmp/test_mod100_ml_Simple_test__optionally_saving_waveforms_to_disk.vcd
    |}]
;;
