#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ROWS 5          /* number of lines per puzzle block (change if needed) */
#define MAX_LINE 10000  /* maximum allowed line length */
#define MAX_ROWS 10000  /* safety cap on lines (unused here) */

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <inputfile>\n", argv[0]);
        return 1;
    }

    const char *fname = argv[1];
    FILE *f = fopen(fname, "r");
    if (!f) {
        perror("fopen");
        return 2;
    }

    /* Read up to ROWS lines into a buffer array of strings */
    char *lines[ROWS];
    size_t maxlen = 0;
    for (int r = 0; r < ROWS; ++r) {
        lines[r] = NULL;
    }

    char buf[MAX_LINE];
    int r = 0;
    while (r < ROWS && fgets(buf, sizeof(buf), f)) {
        /* Remove trailing newline but preserve any other whitespace */
        size_t L = strlen(buf);
        while (L > 0 && (buf[L-1] == '\n' || buf[L-1] == '\r')) {
            buf[--L] = '\0';
        }
        lines[r] = malloc(L + 1);
        if (!lines[r]) {
            fprintf(stderr, "malloc failed\n");
            return 3;
        }
        strcpy(lines[r], buf);
        if (L > maxlen) maxlen = L;
        r++;
    }
    fclose(f);

    if (r != ROWS) {
        fprintf(stderr, "Expected %d lines but read %d lines. Aborting.\n", ROWS, r);
        for (int i = 0; i < ROWS; ++i) free(lines[i]);
        return 4;
    }

    /* Create a rectangular grid with padding spaces */
    size_t len = maxlen;
    char **grid = malloc(ROWS * sizeof(char *));
    if (!grid) { perror("malloc"); return 5; }
    for (int i = 0; i < ROWS; ++i) {
        grid[i] = malloc(len + 1);
        if (!grid[i]) { perror("malloc"); return 6; }
        /* copy and pad with spaces */
        size_t L = strlen(lines[i]);
        memcpy(grid[i], lines[i], L);
        for (size_t j = L; j < len; ++j) grid[i][j] = ' ';
        grid[i][len] = '\0';
    }

    /* Optionally free the original line buffers */
    for (int i = 0; i < ROWS; ++i) {
        free(lines[i]);
    }

    /* Print basic info and the grid (so you can inspect) */
    printf("Read %d rows; max line length = %zu\n\n", ROWS, len);
    for (int i = 0; i < ROWS; ++i) {
        printf("|%s|\n", grid[i]); /* '|' markers show leading/trailing spaces */
    }

    /* Example: access character at row r, column c as grid[r][c]
       Note: rows indexed 0..ROWS-1, columns 0..len-1
    */

    /* Optional: write the rectangular grid to a file for inspection */
    FILE *out = fopen("grid_dump.txt", "w");
    if (out) {
        for (int i = 0; i < ROWS; ++i) {
            fwrite(grid[i], 1, len, out);
            fputc('\n', out);
        }
        fclose(out);
        printf("\nWrote rectangular grid to grid_dump.txt\n");
    } else {
        perror("fopen grid_dump.txt");
    }

    /* Example API: if you want to refer to this as a len x ROWS array,
       you can copy it into a single contiguous block or use grid[row][col].
       Here's an example access loop that prints columns right-to-left:
    */
    printf("\nColumns printed right-to-left (row0..row%d per column):\n", ROWS-1);
    for (int c = (int)len - 1; c >= 0; --c) {
        for (int rr = 0; rr < ROWS; ++rr)
            putchar(grid[rr][c]);
        putchar('\n');
    }

    /* Cleanup */
    for (int i = 0; i < ROWS; ++i) free(grid[i]);
    free(grid);

    return 0;
}

