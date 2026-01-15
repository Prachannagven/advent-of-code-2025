open! Core
open! Hardcaml
open! Aoc_day3_lib.Aoc_day3

let%expect_test "Test monotonic stack with simple sequence" =
    let module Sim = Cyclesim.With_interface (I) (O) in
    
    let sim = Sim.create ~config:Cyclesim.Config.trace_all (create (Scope.create ~auto_label_hierarchical_ports:true ())) in
    
    let inputs = Cyclesim.inputs sim in
    let outputs = Cyclesim.outputs sim in
    
    (* Reset the circuit *)
    inputs.rst := Bits.vdd;
    inputs.digit_valid := Bits.gnd;
    inputs.digit_in := Bits.of_int ~width:4 0;
    Cyclesim.cycle sim;
    
    inputs.rst := Bits.gnd;
    Cyclesim.cycle sim;
    
    (* Test sequence: 987654321111111 (15 digits) *)
    (* For DEPTH=5, we want the 5 largest digits that maintain monotonicity: 98765 *)
    let test_digits = [9; 8; 7; 6; 5; 4; 3; 2; 1; 1; 1; 1; 1; 1; 1] in
    
    (* Feed digits *)
    List.iter test_digits ~f:(fun digit ->
        inputs.digit_in := Bits.of_int ~width:4 digit;
        inputs.digit_valid := Bits.vdd;
        Cyclesim.cycle sim;
    );
    
    (* Stop feeding *)
    inputs.digit_valid := Bits.gnd;
    
    (* Let it process for many cycles *)
    for _i = 0 to 200 do
        Cyclesim.cycle sim;
    done;
    
    (* Check result - with DEPTH=5 from Config, we should get 98765 *)
    let sum_out = Bits.to_int !(outputs.sum_out) in
    printf "Sum output: %d\n" sum_out;
    [%expect {|
        Sum output: 98765
    |}]
;;

let%expect_test "Test with test input data" =
    let module Sim = Cyclesim.With_interface (I) (O) in
    
    let sim = Sim.create ~config:Cyclesim.Config.trace_all (create (Scope.create ~auto_label_hierarchical_ports:true ())) in
    
    let inputs = Cyclesim.inputs sim in
    let outputs = Cyclesim.outputs sim in
    
    (* Reset *)
    inputs.rst := Bits.vdd;
    inputs.digit_valid := Bits.gnd;
    inputs.digit_in := Bits.of_int ~width:4 0;
    Cyclesim.cycle sim;
    
    inputs.rst := Bits.gnd;
    Cyclesim.cycle sim;
    
    (* Test simple decreasing: 54321 -> should get 54321 *)
    let test_digits = [5;4;3;2;1;0;0;0;0;0;0;0;0;0;0] in
    printf "Testing: 543210000000000\n";
    
    (* Feed all digits at once *)
    List.iter test_digits ~f:(fun digit ->
        inputs.digit_in := Bits.of_int ~width:4 digit;
        inputs.digit_valid := Bits.vdd;
        Cyclesim.cycle sim;
    );
    
    (* Stop feeding and let it process *)
    inputs.digit_valid := Bits.gnd;
    for _i = 0 to 200 do Cyclesim.cycle sim; done;
    
    let sum_out = Bits.to_int !(outputs.sum_out) in
    printf "Result: %d (expected 54321)\n" sum_out;
    
    [%expect {|
        Testing: 543210000000000
        Result: 54321 (expected 54321)
    |}]
;;

let%expect_test "Test increasing sequence with pops" =
    let module Sim = Cyclesim.With_interface (I) (O) in
    
    let sim = Sim.create ~config:Cyclesim.Config.trace_all (create (Scope.create ~auto_label_hierarchical_ports:true ())) in
    
    let inputs = Cyclesim.inputs sim in
    let outputs = Cyclesim.outputs sim in
    
    (* Reset *)
    inputs.rst := Bits.vdd;
    inputs.digit_valid := Bits.gnd;
    inputs.digit_in := Bits.of_int ~width:4 0;
    Cyclesim.cycle sim;
    
    inputs.rst := Bits.gnd;
    Cyclesim.cycle sim;
    
    (* Test: just feed 2 digits slowly: 1, then 2 *)
    (* After digit 1: stack=[1], sp=1 *)
    (* After digit 2: 2>1, pop 1, push 2, stack=[2], sp=1 *)
    printf "Testing: 2 digits (1 then 2)\n";
    
    inputs.digit_in := Bits.of_int ~width:4 1;
    inputs.digit_valid := Bits.vdd;
    Cyclesim.cycle sim;
    inputs.digit_valid := Bits.gnd;
    
    for _ = 0 to 20 do Cyclesim.cycle sim; done;
    
    inputs.digit_in := Bits.of_int ~width:4 2;
    inputs.digit_valid := Bits.vdd;
    Cyclesim.cycle sim;
    inputs.digit_valid := Bits.gnd;
    
    for _ = 0 to 20 do Cyclesim.cycle sim; done;
    
    (* Now feed 13 more zeros to complete 15 digits *)
    for _ = 0 to 12 do
        inputs.digit_in := Bits.of_int ~width:4 0;
        inputs.digit_valid := Bits.vdd;
        Cyclesim.cycle sim;
        inputs.digit_valid := Bits.gnd;
        for _ = 0 to 5 do Cyclesim.cycle sim; done;
    done;
    
    for _ = 0 to 100 do Cyclesim.cycle sim; done;
    
    let sum1 = Bits.to_int !(outputs.sum_out) in
    (* If pop worked: stack=[2,0,0,0,0] = 20000 *)
    (* If pop didn't work: stack=[1,2,0,0,0] = 12000 *)
    printf "Result: %d (expected 20000)\n" sum1;
    
    [%expect {|
        Testing: 2 digits (1 then 2)
        Result: 20000 (expected 20000)
    |}]
;;

let%expect_test "Test full input file" =
    let module Sim = Cyclesim.With_interface (I) (O) in
    
    let sim = Sim.create ~config:Cyclesim.Config.trace_all (create (Scope.create ~auto_label_hierarchical_ports:true ())) in
    
    let inputs = Cyclesim.inputs sim in
    let outputs = Cyclesim.outputs sim in
    
    (* Reset *)
    inputs.rst := Bits.vdd;
    inputs.digit_valid := Bits.gnd;
    inputs.digit_in := Bits.of_int ~width:4 0;
    Cyclesim.cycle sim;
    inputs.rst := Bits.gnd;
    Cyclesim.cycle sim;
    
    (* Test all 4 lines from input_test with depth=5:
       987654321111111 -> 98765
       811111111111119 -> 81119
       234234234234278 -> 44478
       818181911112111 -> 92111
       Total: 316473 *)
    let test_lines = [
        ([9;8;7;6;5;4;3;2;1;1;1;1;1;1;1], "987654321111111", 98765);
        ([8;1;1;1;1;1;1;1;1;1;1;1;1;1;9], "811111111111119", 81119);
        ([2;3;4;2;3;4;2;3;4;2;3;4;2;7;8], "234234234234278", 44478);
        ([8;1;8;1;8;1;9;1;1;1;1;2;1;1;1], "818181911112111", 92111);
    ] in
    
    let running_sum = ref 0 in
    
    List.iter test_lines ~f:(fun (digits, name, expected) ->
        printf "Testing: %s (expected %d)\n" name expected;
        
        List.iter digits ~f:(fun digit ->
            inputs.digit_in := Bits.of_int ~width:4 digit;
            inputs.digit_valid := Bits.vdd;
            Cyclesim.cycle sim;
            inputs.digit_valid := Bits.gnd;
            for _ = 0 to 10 do Cyclesim.cycle sim; done;
        );
        
        for _ = 0 to 50 do Cyclesim.cycle sim; done;
        
        let sum_out = Bits.to_int !(outputs.sum_out) in
        running_sum := !running_sum + expected;
        printf "Sum so far: %d (expected %d)\n" sum_out !running_sum;
    );
    
    let final_sum = Bits.to_int !(outputs.sum_out) in
    printf "Final sum: %d (expected 316473)\n" final_sum;
    
    [%expect {|
      Testing: 987654321111111 (expected 98765)
      Sum so far: 98765 (expected 98765)
      Testing: 811111111111119 (expected 81119)
      Sum so far: 179884 (expected 179884)
      Testing: 234234234234278 (expected 44478)
      Sum so far: 224362 (expected 224362)
      Testing: 818181911112111 (expected 92111)
      Sum so far: 316473 (expected 316473)
      Final sum: 316473 (expected 316473)
    |}]
;;

let%expect_test "Test error conditions" =
    let module Sim = Cyclesim.With_interface (I) (O) in
    
    let sim = Sim.create (create (Scope.create ~auto_label_hierarchical_ports:true ())) in
    
    let inputs = Cyclesim.inputs sim in
    let outputs = Cyclesim.outputs sim in
    
    (* Reset *)
    inputs.rst := Bits.vdd;
    inputs.digit_valid := Bits.gnd;
    inputs.digit_in := Bits.of_int ~width:4 0;
    Cyclesim.cycle sim;
    
    inputs.rst := Bits.gnd;
    Cyclesim.cycle sim;
    
    (* Should not have error initially *)
    let error = Bits.to_bool !(outputs.error) in
    printf "Initial error state: %b\n" error;
    
    [%expect {|
        Initial error state: false
    |}]
;;
