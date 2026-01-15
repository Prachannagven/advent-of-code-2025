#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define ROWS 5
#define MAXLEN 5000   // enough for full puzzle width

int main(int argc, char *argv[]) {

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <file>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        perror("Error opening file");
        return 1;
    }

    char grid[ROWS][MAXLEN];
    int len = 0;

    // --- Read exactly 5 lines, preserving spaces ---
    for (int i = 0; i < ROWS; i++) {
        if (!fgets(grid[i], MAXLEN, fp)) {
            fprintf(stderr, "File has fewer than 5 lines!\n");
            return 1;
        }

        int L = strlen(grid[i]);
        while (L > 0 && (grid[i][L-1] == '\n' || grid[i][L-1] == '\r'))
            grid[i][--L] = '\0';

        if (L > len)
            len = L;
    }

    fclose(fp);

    long long grand_total = 0;

    // --- Scan right-to-left, column by column ---
    int col = len - 1;

    while (col >= 0) {

        // Skip separator columns (columns of only spaces)
        int is_blank = 1;
        for (int r = 0; r < ROWS; r++)
            if (grid[r][col] != ' ')
                is_blank = 0;

        if (is_blank) {
            col--;
            continue;
        }

        // We have a problem starting at this column.
        // Bottom row contains operator.
        char op = grid[ROWS-1][col];
        if (op != '+' && op != '*') {
            fprintf(stderr, "Invalid operator '%c' at col %d\n", op, col);
            return 1;
        }

        long long result;
        if (op == '+') result = 0;
        else result = 1;

        // Read DOWNWARD each non-blank digit
        for (int r = 0; r < ROWS-1; r++) {
            if (isdigit(grid[r][col])) {

                long long value = 0;

                // Collect a vertical number (digits contiguous downward)
                while (r < ROWS-1 && isdigit(grid[r][col])) {
                    value = value * 10 + (grid[r][col] - '0');
                    r++;
                }

                // Apply operation
                if (op == '+') result += value;
                else result *= value;
            }
        }

        grand_total += result;

        col--; // move left to next problem
    }

    printf("Grand total = %lld\n", grand_total);
    return 0;
}

