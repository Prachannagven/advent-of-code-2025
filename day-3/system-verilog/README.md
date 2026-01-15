# Advent of Code 2025 - Day 3 - SystemVerilog

Monotonic stack implementation for finding the lexicographically largest k-digit subsequence.

## Problem

Given a 15-digit number, find the largest k-digit subsequence (where k is configurable via `DEPTH`).

Example with DEPTH=5: `123456789012345` → `92345`

## Algorithm

For each incoming digit:
1. While stack is not empty AND current digit > stack top AND we have enough remaining digits: pop
2. If stack not full: push current digit

The "enough remaining" check ensures we don't pop too aggressively and end up with fewer than k digits.

## Files

```
src/sol.sv              - working implementation
src/pipelined_sol.sv    - experimental pipelined version (incomplete)
sim/tb_sol_streaming.sv - testbench with streaming input
```

## Building & Running

```bash
make          # compile and simulate
make clean    # remove generated files
make view     # open waveform in gtkwave
```

## Parameters

In `sol.sv`:
- `DEPTH` - number of digits to select (default: 5)
- `DIGITS_PER_NUM` - digits per input number (default: 15)
- `FIFO_DEPTH` - input buffer size (default: 16)

## Architecture

```
digit_in → [FIFO] → [State Machine] → sum_out
                         ↓
                      [Stack]
```

States: IDLE → RUN → WAIT → POP → DONE → (repeat)

The FIFO decouples input from processing, allowing continuous streaming at one digit per clock even when the pop loop takes multiple cycles.

## Pipelined Version (WIP)

`pipelined_sol.sv` was an attempt to pipeline the pop comparisons so each digit could be processed in a fixed number of cycles regardless of how many pops are needed. The idea was to have DEPTH pipeline stages, each performing one comparison/pop decision.

Issues encountered:
- Pipeline hazards when multiple digits want to pop the same stack element
- Tracking which pops actually committed vs were speculative
- Result ordering when digits finish out-of-order

The sequential version works fine for the problem size, so the pipelined version was shelved. Might revisit if targeting higher throughput or deeper stacks.
