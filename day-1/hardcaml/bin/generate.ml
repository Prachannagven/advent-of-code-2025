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

let range_finder_rtl_command =
  Command.basic
    ~summary:""
    [%map_open.Command
      let () = return () in
      fun () -> generate_range_finder_rtl ()]
;;

let () =
  Command_unix.run
    (Command.group ~summary:"" [ "mod100", range_finder_rtl_command ])
;;

