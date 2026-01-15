# Advent of Code 2025 - Hardcaml Solutions

Hardware implementations for Advent of Code 2025 using **Hardcaml**, Jane Street's OCaml-based hardware description library. These generate synthesizable Verilog output.

For the record, I do not like this language. I significantly prefer systemverilog, verilog, and even VHDL simply because they are more efficient languages in describing the hardware to engineers. However, I do see the perks of hardcaml, and perhaps some more exposure to strongly typed languages like ocaml might make me change my view.

## Structure

```
day-X/
├── src/              # Hardcaml source modules
│   └── *.ml
├── bin/
│   └── generate.ml   # Verilog generation script
├── test/
│   └── *.ml          # Expect tests
├── verilog/          # Generated Verilog output
├── input-parser/     # C utility for parsing AoC input
├── dune-project
└── README.md
```

## Completed Days

| Day | Status | Description |
|:---:|:------:|-------------|
| 1   | ✅     | Position tracking with pipelined mod-100, zero-crossing detection |
| 3   | ✅     | Monotonic stack for largest k-digit subsequence (AI-assisted) |

## Building & Running

```bash
cd day-X/

# Build the project
dune build

# Run tests
dune runtest

# Generate Verilog
dune exec bin/generate.exe > verilog/output.v

# Promote test output (if satisfied with results)
dune promote
```

## Input Parser

Each day includes a C-based input parser to convert AoC input into a format suitable for the Hardcaml testbenches:

```bash
gcc -o input-parser/input_parser input-parser/input_parser.c
./input-parser/input_parser ../../"Advent of Code (C)"/day-X/input
```

## VCD Waveforms

Test runs generate VCD files for waveform analysis. Open with GTKWave:
```bash
gtkwave test_*.vcd
```

## Design Notes

### Day 1
- 4-stage pipelined mod-100 using magic constant multiplication
- Direction pipeline for cycle alignment
- Zero-crossing detection for both forward and backward motion

### Day 3
- Monotonic stack algorithm for subsequence selection
- State machine: IDLE → RUN → WAIT → POP → DONE
- Configurable parameters for digit count and selection depth

## Dependencies

- OCaml 5.2.0+
- Dune build system
- Hardcaml library (`opam install hardcaml`)
- GTKWave (for viewing waveforms)

## A Note on Hardcaml

> These solutions represent an exploration of functional hardware design. While Hardcaml offers type safety and powerful abstractions, the generated Verilog is not as readable as hand-written HDL. Each day's README contains more candid thoughts on the experience.

The Verilog implementations in the sibling `Advent of FPGA` folder may be more accessible for understanding the underlying algorithms.
