# Advent of Code 2025 - Multi-Language Solutions

A collection of solutions for [Advent of Code 2025](https://adventofcode.com/2025) implemented in multiple languages and paradigms, including traditional programming (C/Python), hardware description languages (Verilog/SystemVerilog), and functional HDL (Hardcaml).

## Repository Structure

This repository is organized into three main solution tracks:

### 📁 `Advent of Code (C)/`
Traditional software solutions primarily written in **C**, with occasional Python helpers. Each day has its own folder containing the puzzle input files and solution code organized by parts.

### 📁 `Advent of FPGA (Verilog or SystemVerilog)/`
Hardware implementations using **Verilog** and **SystemVerilog**. These solutions are designed to be synthesizable and can run on actual FPGA hardware (tested on SiSpeed Tang Nano 9k). Includes testbenches, waveform files, and Makefiles for simulation.

### 📁 `Advent of Hardcaml (Harcaml)/`
Functional hardware descriptions using **Hardcaml** (Jane Street's OCaml-based HDL). These generate Verilog output and include comprehensive test suites. A more experimental approach to hardware design.

---

## Progress Tracker

| Day | Advent of Code (C) | Advent of FPGA (Verilog/SV) | Advent of Hardcaml |
|:---:|:------------------:|:---------------------------:|:------------------:|
| 1   | ✅ Part 1 & 2      | ✅ Verilog                   | ✅                  |
| 2   | ✅ Part 1 & 2      | ❌ Not worth it (CPU > HDL)  |                    |
| 3   | ✅ Part 1 & 2      | ✅ SystemVerilog             | ✅                  |
| 4   | ✅ Part 1 & 2      |                             |                    |
| 5   | ✅ Part 1 & 2      |                             |                    |
| 6   | ✅ Part 1 & 2      |                             |                    |
| 7   | ✅ Part 1 & 2      |                             |                    |
| 8   | ✅ Part 1 & 2      |                             |                    |
| 9   | ✅ Part 1 & 2      |                             |                    |
| 10  | 🚧 In Progress     |                             |                    |
| 11  |                    |                             |                    |
| 12  |                    |                             |                    |

**Legend:** ✅ Complete | 🚧 In Progress | ❌ Skipped

---

## Quick Start

### C Solutions
```bash
cd "Advent of Code (C)/day-X/c_sol"   # or part-1, part-2 depending on structure
gcc -o sol sol.c
./sol
```

### Verilog/SystemVerilog Simulations
```bash
cd "Advent of FPGA (Verilog or SystemVerilog)/day-X"
make          # Compile and simulate
make view     # View waveforms in GTKWave
```

### Hardcaml Solutions
```bash
cd "Advent of Hardcaml (Harcaml)/day-X"
dune build
dune runtest
dune exec bin/generate.exe > verilog/output.v  # Generate Verilog
```

---

## Tools & Dependencies

- **C Solutions**: GCC compiler
- **Verilog/SV**: Icarus Verilog, GTKWave
- **Hardcaml**: OCaml 5.2.0+, Dune, Hardcaml library
- **FPGA Target**: SiSpeed Tang Nano 9k (Gowin GW1NSR-4C4C6N144I)

---

## Why Multiple Implementations?

This project explores the same algorithmic challenges across different paradigms:
- **C** for quick, straightforward solutions
- **Verilog/SystemVerilog** to understand hardware-level thinking and parallel execution
- **Hardcaml** to experiment with functional approaches to hardware design

Each approach offers unique insights into problem-solving and computational thinking.

---

## License

See [LICENSE](LICENSE) for details.
