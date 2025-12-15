# Advent of Code 2025 - Day 1 - Hardcaml Implementation

Hardware description in [Hardcaml](https://github.com/janestreet/hardcaml) for AoC 2025 Day 1. Position tracker with mod-100 arithmetic and zero-crossing detection.

See `../verilog/` for the original Verilog version (which was way easier to write, btw).

> **Note**: Hardcaml is a language that makes you question your life choices. Every semicolon, every type error, every cryptic compiler message makes me want to stab something. If you're reading this and considering using Hardcaml, maybe just... don't? Write Verilog like a normal person. I'm doing this only for the t-shirt, and I'm kind of curious to see how this might be, especially having never done any kind of functional language before.

## What's Here

**`Mod100`** (`src/mod100.ml`) - 4-stage pipelined mod-100 using magic constant multiplication. Took way too long to get the types right.

**`Top`** (`src/top.ml`) - Main module with:
- Position tracking (0-99, starts at 50)
- Direction pipeline (because everything needs to be delayed by 4 cycles)
- Zero-crossing detection 
- Counting things

## Building

```bash
opam exec -- dune build          # pray it compiles
opam exec -- dune runtest        # probably fails
opam exec -- dune promote        # accept the pain
```

## Verilog Generation

```bash
# Actually useful output
opam exec -- dune exec ./bin/generate.exe top > verilog/top.v
```

Generates proper Verilog hierarchy with `mod100`, `top`, and `aoc_day1_part1` modules. Be warned though, this generated verilog file has all the modules in a single file, unlike a sane verilog project. Regardless, this isn't the biggest issue. The worst part is it's MASSIVE AND HORRIBLE inefficency... and incredibly anti-human readibility.

Variables and processes are named random machine variables, and the code overall is very inefficiently written in comparison to a human. Maybe this is the goal of Hardcaml, with coders that want to build projects in functional code and don't care about the final verilog, but I don't see the point.

## How It Works

### Position Tracking
Starts at 50. Forward adds `rot_by`, backward subtracts it. Wraps at 100. Had to use both `~reset_to` and `~initialize_to` because apparently one isn't enough for this god-forsaken language.

### Zero Crossing Detection
Forward: crosses zero if `(pos + rot) > 100` and `pos != 0`  
Backward: crosses if result goes negative (check the sign bit)

This was kind of annoying, but overall not as bad as I expected.

### Quotient Calculation
Magic constant division by 100 (constant: 42949672). Same trick as mod-100 but for the quotient. Works in parallel with the mod computation.

## Testing

```bash
opam exec -- dune runtest
```

Runs full AoC dataset, saves VCD to `/tmp/`. Open with gtkwave if you want to see pretty waveforms. You do want to see pretty waveforms. It's much easier than the text simulator.

## File Layout

```
src/mod100.ml    - mod 100 module (4 cycles latency)
src/top.ml       - everything else
bin/generate.ml  - verilog generator
test/            - tests with real data
verilog/         - generated .v files
```

## Pain Points

- **Type errors**: OCaml's type system is both a blessing and a curse. Mostly curse.
- **Label hell**: `~f:`, `~width:`, `~reset_to:`, `~initialize_to:` - miss one and enjoy the compiler poetry.
- **Pipeline matching**: Direction register needs exactly 4 stages to match mod100 latency. Off by one? Good luck debugging.
- **Signal width mismatches**: The error messages are... not helpful.
- **Documentation**: Sparse. Stack Overflow? Empty. Pain? Abundant.

## Why Hardcaml?

Good question. I ask myself that daily. Something about "type safety" and "formal methods" but honestly I could've written the Verilog in an afternoon and been done. Instead I spent [REDACTED] hours fighting the compiler.

If you're new to Hardcaml: turn back now. Save yourself.

If you're experienced with Hardcaml: teach me your ways, please.

## Dependencies

- OCaml 5.2.0+ (because of course it needs the latest)
- Hardcaml, ppx_hardcaml, ppx_jane (Jane Street ecosystem)
- Dune 3.9+
- Patience (not in opam, unfortunately)
