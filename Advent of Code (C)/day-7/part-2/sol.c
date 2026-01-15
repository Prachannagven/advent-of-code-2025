// tachyon.c
// Compile: gcc -O2 -std=c11 tachyon.c -lgmp -o tachyon

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <gmp.h>

#define MAX_W 10000
#define MAX_H 10000

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <manifold-file>\n", argv[0]);
        return 1;
    }

    // Read the whole file into vector of strings (grid)
    FILE *f = fopen(argv[1], "r");
    if (!f) { perror("open"); return 1; }

    size_t cap = 0;
    char *line = NULL;
    size_t rows = 0, cols = 0;
    char **grid = NULL;

    while (getline(&line, &cap, f) != -1) {
        // strip newline
        size_t L = strlen(line);
        while (L > 0 && (line[L-1] == '\n' || line[L-1] == '\r')) { line[--L] = '\0'; }

        // ignore totally empty trailing lines? keep them as rows
        if (L > cols) cols = L;

        grid = realloc(grid, (rows + 1) * sizeof(char*));
        grid[rows] = malloc(cols + 1);
        // copy and pad with '.'
        strcpy(grid[rows], line);
        // pad if needed
        if (strlen(grid[rows]) < cols) {
            for (size_t i = strlen(grid[rows]); i < cols; ++i) grid[rows][i] = '.';
            grid[rows][cols] = '\0';
        }
        rows++;
    }
    free(line);
    fclose(f);

    if (rows == 0) {
        fprintf(stderr, "Empty input\n");
        return 1;
    }

    // find S (the source)
    ssize_t src_r = -1, src_c = -1;
    for (size_t r = 0; r < rows; ++r) {
        for (size_t c = 0; c < cols; ++c) {
            if (grid[r][c] == 'S') {
                src_r = (ssize_t)r;
                src_c = (ssize_t)c;
                break;
            }
        }
        if (src_r != -1) break;
    }
    if (src_r == -1) { fprintf(stderr, "No source 'S' found\n"); return 1; }

    // prepare arrays of mpz_t counts (current row and next row)
    mpz_t *curr = calloc(cols, sizeof(mpz_t));
    mpz_t *next = calloc(cols, sizeof(mpz_t));
    for (size_t c = 0; c < cols; ++c) {
        mpz_init(curr[c]);
        mpz_init(next[c]);
    }

    // initialize beam at the row below S? Problem statement: beam enters at S and moves downward.
    // Put initial beam count = 1 at column src_c on the row immediately below S (i.e., process starting at row src_r+1).
    // Alternatively put beam on S row and start processing from src_r (both equivalent if S cell isn't a splitter).
    if ((size_t)src_r >= rows) { fprintf(stderr,"source row out of range\n"); return 1; }

    mpz_set_ui(curr[src_c], 1);

    mpz_t total_splits;
    mpz_init(total_splits);
    mpz_set_ui(total_splits, 0);

    // iterate row by row, starting from src_r (so S row will be processed)
    for (ssize_t r = src_r; r < (ssize_t)rows; ++r) {
        // clear next row
        for (size_t c = 0; c < cols; ++c) mpz_set_ui(next[c], 0);

        for (size_t c = 0; c < cols; ++c) {
            if (mpz_sgn(curr[c]) == 0) continue; // no beams here
            // copy current count
            // if splitter:
            if (grid[r][c] == '^') {
                // increment total_splits by curr[c]
                mpz_add(total_splits, total_splits, curr[c]);

                // distribute to left and right in next row (r+1)
                if (c > 0) mpz_add(next[c - 1], next[c - 1], curr[c]);
                if (c + 1 < cols) mpz_add(next[c + 1], next[c + 1], curr[c]);

                // beam is stopped vertically (do not propagate to next[c])
            } else {
                // beam continues downward at same column
                mpz_add(next[c], next[c], curr[c]);
            }
        }

        // move next -> curr
        for (size_t c = 0; c < cols; ++c) {
            mpz_set(curr[c], next[c]);
        }
    }

    // after processing all rows, sum curr[] to get timelines (beams that remain at bottom / exits)
    mpz_t total_timelines;
    mpz_init(total_timelines);
    mpz_set_ui(total_timelines, 0);
    for (size_t c = 0; c < cols; ++c) {
        mpz_add(total_timelines, total_timelines, curr[c]);
    }

    // print answers
    gmp_printf("total_splits: %Zd\n", total_splits);
    gmp_printf("total_timelines: %Zd\n", total_timelines);

    // cleanup
    for (size_t c = 0; c < cols; ++c) {
        mpz_clear(curr[c]);
        mpz_clear(next[c]);
        free(grid[c]);
    }
    free(curr);
    free(next);
    free(grid);
    mpz_clear(total_splits);
    mpz_clear(total_timelines);
    return 0;
}

