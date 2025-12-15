open! Core
open! Hardcaml
open! Aoc_day1_part1

let generate_range_finder_rtl () =
  let module C = Circuit.With_interface (Mod100.I) (Mod100.O) in
  let scope = Scope.create ~auto_label_hierarchical_ports:true () in
  let circuit = C.create_exn ~name:"mod100_top" (Mod100.hierarchical scope) in
  let rtl_circuits =
    Rtl.create ~database:(Scope.circuit_database scope) Verilog [ circuit ]
  in
  let rtl = Rtl.full_hierarchy rtl_circuits |> Rope.to_string in
  print_endline rtl
;;

let generate_top_rtl () =
  let module C = Circuit.With_interface (Top.I) (Top.O) in
  let scope = Scope.create ~auto_label_hierarchical_ports:true () in
  let circuit = C.create_exn ~name:"aoc_day1_part1" (Top.hierarchical scope) in
  let rtl_circuits =
    Rtl.create ~database:(Scope.circuit_database scope) Verilog [ circuit ]
  in
  let rtl = Rtl.full_hierarchy rtl_circuits |> Rope.to_string in
  print_endline rtl
;;

let range_finder_rtl_command =
  Command.basic
    ~summary:"Generate Verilog for Mod100 module"
    [%map_open.Command
      let () = return () in
      fun () -> generate_range_finder_rtl ()]
;;

let top_rtl_command =
  Command.basic
    ~summary:"Generate Verilog for Top module"
    [%map_open.Command
      let () = return () in
      fun () -> generate_top_rtl ()]
;;

let () =
  Command_unix.run
    (Command.group ~summary:"Generate Verilog RTL" 
      [ "mod100", range_finder_rtl_command
      ; "top", top_rtl_command
      ])
;;

