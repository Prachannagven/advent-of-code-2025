import sys
sys.setrecursionlimit(1000000)

def count_timelines(grid):
    R = len(grid)
    C = len(grid[0])

    # find S
    for c in range(C):
        if grid[0][c] == 'S':
            start_col = c
            break

    memo = {}   # memoize: (r,c) → timeline count

    def dfs(r, c):
        # out of bounds -> 1 timeline ends here
        if r >= R:
            return 1

        if (r, c) in memo:
            return memo[(r, c)]

        cell = grid[r][c]

        # splitter
        if cell == '^':
            # left and right beams
            left_t  = dfs(r, c-1) if c > 0 else 1
            right_t = dfs(r, c+1) if c < C-1 else 1
            memo[(r, c)] = left_t + right_t
            return memo[(r, c)]

        else:
            # empty space or S → continue down
            memo[(r, c)] = dfs(r+1, c)
            return memo[(r, c)]

    return dfs(0, start_col)

# ----------------------------------------------------------

if __name__ == "__main__":
    with open(sys.argv[1]) as f:
        grid = [list(line.rstrip("\n")) for line in f]

    result = count_timelines(grid)
    print("TOTAL TIMELINES:", result)

