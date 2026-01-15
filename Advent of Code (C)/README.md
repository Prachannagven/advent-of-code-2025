README AI GENERATED FOR SPEED

# Advent of Code 2025 - C Solutions

Traditional software solutions for Advent of Code 2025, primarily written in **C** with occasional Python helpers for complex problems.

## Structure

Each day has its own folder containing:
- `input` - The full puzzle input
- `input_test` - Sample/test input from the problem description
- Solution code in subdirectories (`c_sol/`, `part-1/`, `part-2/`)

```
day-X/
├── input           # Full puzzle input
├── input_test      # Sample test input
├── c_sol/          # C solution (some days)
│   ├── part-1/
│   │   └── sol.c
│   └── part-2/
│       └── sol.c
├── part-1/         # Alternative structure (some days)
│   └── sol.c
└── part-2/
    └── sol.c
```

## Completed Days

| Day | Part 1 | Part 2 | Notes |
|:---:|:------:|:------:|-------|
| 1   | ✅     | ✅     | Position tracking with mod-100 |
| 2   | ✅     | ✅     | |
| 3   | ✅     | ✅     | |
| 4   | ✅     | ✅     | |
| 5   | ✅     | ✅     | |
| 6   | ✅     | ✅     | Includes debug grid dump |
| 7   | ✅     | ✅     | Python helper for Part 2 |
| 8   | ✅     | ✅     | |
| 9   | ✅     | ✅     | Includes README with notes |
| 10  | 🚧     |        | In progress |

## Building & Running

```bash
# Navigate to the day's solution directory
cd day-X/c_sol/part-1/   # or day-X/part-1/ depending on structure

# Compile
gcc -o sol sol.c

# Run (reads input from expected location)
./sol
```

Some solutions may require the input file to be in a specific relative path - check the source code for the expected location.

## Notes

- Solutions are written for correctness first, optimization second
- Some days have multiple solution approaches (`sol.c`, `sol2.c`)
- Day 7 Part 2 includes a Python solution (`pysol.py`) for comparison
- Day 10 includes a reusable file parsing module (`fileparse.c`, `fileparse.h`)
