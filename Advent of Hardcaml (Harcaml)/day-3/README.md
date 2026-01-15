# Introduction
## Preliminary Note
I did actually use AI to help me out with this solution. I don't like the language enough to spend enough time to learn it fully between college, projects and everything else, so I used AI for a bunch of parts to help me generate different blocks. The logic and systemverilog code is entirely mine, but claude opus 4.5 from copilot definitely had a hand in making the aoc_day3.ml and test_aoc_day3.ml files.

## Advent of Code 2025 - Day 3 - Hardcaml Implementation

Hardware description in [Hardcaml](https://github.com/janestreet/hardcaml) for AoC 2025 Day 3. Implements a monotonic stack algorithm to find the lexicographically largest k-digit subsequence from a 15-digit input number.

See `../system-verilog/` for the original SystemVerilog version.

> **Note**: Hardcaml continues to be a language that makes you question your life choices. This implementation required extensive debugging of bit-width truncation issues that would have been obvious in Verilog. Still doing this for the learning experience.


# What's Here
## Algorithm

Given a 15-digit number, find the largest 5-digit subsequence (configurable via `Config.depth`). Uses a monotonic stack approach:
- For each digit, pop from stack while: current digit > stack top AND we have enough remaining digits to fill the stack
- Push current digit if stack isn't full

Example: `123456789012345` → `92345` (the 9 is the largest, then we need to take the last 4 digits to fill the remaining slots)

## Module

**`Aoc_day3`** (`src/aoc_day3.ml`) - Main module with:
- Input FIFO (mux-based register array for combinational read)
- Monotonic stack for finding largest subsequence
- State machine: IDLE → RUN → WAIT → POP → DONE
- Accumulator for summing results across multiple numbers

## Configuration

In `src/aoc_day3.ml`:
```ocaml
module Config = struct
    let depth = 5           (* Number of digits to select *)
    let digits_per_num = 15 (* Digits per input number *)
    let fifo_depth = 16     (* Input FIFO depth *)
end
```

## Building

```bash
dune build       # Compile the project
dune runtest     # Run the tests 
dune exec bin/generate.exe > aoc_day3.v  # Generate Verilog
```

## How It Works

### State Machine
1. **IDLE**: Wait for input in FIFO
2. **RUN**: Read digit from FIFO if available
3. **WAIT**: Capture digit into register (1 cycle latency)
4. **POP**: Check pop condition, pop or push, repeat
5. **DONE**: Extract result from stack, accumulate sum

### Pop Condition
```
pop_cond = can_pop AND better AND feasible
```
- `can_pop`: stack pointer > 0
- `better`: current digit > stack top
- `feasible`: (stack_depth - 1) + remaining_digits >= required_depth

### Key Bug Fixed
The `feasible` calculation had a bit-width truncation issue where `remaining_positions` (4 bits) was being truncated to `sp_bits` (3 bits), causing values like 14 to become 6. Fixed by using the maximum width for the addition.

## Testing

```bash
dune runtest
```

Tests verify correct output for:
- Decreasing sequences: `987654321111111` → `98765`
- Increasing sequences: `123456789012345` → `92345`
- Mixed patterns: `234234234234278` → `44478`

## File Layout

```
src/aoc_day3.ml  - main implementation
bin/generate.ml  - verilog generator  
test/            - expect tests
input-parser/    - input parsing utility
```

## The Input Parser
Input parser is a simple C file that reads the AOC input and converts it into digit form for the testbench.

```bash
gcc -o input-parser/input_parser input-parser/input_parser.c
./input-parser/input_parser ../input
```

## Dependencies

- OCaml 5.2.0+
- Hardcaml, ppx_hardcaml, ppx_jane
- Dune 3.9+


