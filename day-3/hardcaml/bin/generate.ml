open! Core
open! Hardcaml
open Aoc_day3_lib

let () =
  let module C = Circuit.With_interface (Aoc_day3.I) (Aoc_day3.O) in
  let scope = Scope.create ~auto_label_hierarchical_ports:true () in
  let circuit = C.create_exn ~name:"aoc_day3" (Aoc_day3.create scope) in
  Rtl.output ~database:(Scope.circuit_database scope) ~output_mode:(To_file "verilog/aoc_day3.v") Verilog circuit
;;

