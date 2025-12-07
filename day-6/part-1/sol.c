#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_LINE_LENGTH 2048 
#define MAX_PROBLEMS 2048
#define NUM_LINES 5

static void rtrim(char *s) {
    int L = strlen(s);
    while (L > 0 && (s[L-1] == '\n' || s[L-1] == '\r')) { s[--L] = '\0'; }
}

static void trim(char *s) {
    // trim both ends in-place
    char *p = s;
    while (*p && isspace((unsigned char)*p)) p++;
    if (p != s) memmove(s, p, strlen(p) + 1);
    size_t L = strlen(s);
    while (L > 0 && isspace((unsigned char)s[L-1])) s[--L] = '\0';
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <worksheet-file>\n", argv[0]);
        return 2;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) { perror("fopen"); return 3; }

    char lines[NUM_LINES][MAX_LINE_LENGTH];
    int i;
    for (i = 0; i < NUM_LINES; ++i) {
        if (!fgets(lines[i], sizeof(lines[i]), fp)) {
            fprintf(stderr, "Invalid file: expected %d lines for a single worksheet block\n", NUM_LINES);
            fclose(fp);
            return 4;
        }
        rtrim(lines[i]);
    }
    fclose(fp);

    // find maximum length and pad lines with spaces
    int maxlen = 0;
    for (i = 0; i < NUM_LINES; ++i) {
        int L = (int)strlen(lines[i]);
        if (L > maxlen) maxlen = L;
    }
    // pad with spaces so all lines are same length
    for (i = 0; i < NUM_LINES; ++i) {
        int L = (int)strlen(lines[i]);
        if (L < maxlen) {
            memset(lines[i] + L, ' ', maxlen - L);
            lines[i][maxlen] = '\0';
        }
    }

    // Identify contiguous column blocks that contain at least one non-space
    // in the top NUM_LINES rows (i.e., columns that belong to a problem).
    int start = -1;
    int nblocks = 0;
    int block_start[MAX_PROBLEMS];
    int block_end[MAX_PROBLEMS]; // inclusive

    for (int col = 0; col < maxlen; ++col) {
        int col_all_space = 1;
        for (i = 0; i < NUM_LINES; ++i) {
            if (lines[i][col] != ' ') { col_all_space = 0; break; }
        }
        if (!col_all_space) {
            if (start == -1) start = col;
        } else {
            if (start != -1) {
                if (nblocks >= MAX_PROBLEMS) {
                    fprintf(stderr, "Too many problems (>%d)\n", MAX_PROBLEMS);
                    return 5;
                }
                block_start[nblocks] = start;
                block_end[nblocks] = col - 1;
                nblocks++;
                start = -1;
            }
        }
    }
    if (start != -1) { // trailing block
        if (nblocks >= MAX_PROBLEMS) {
            fprintf(stderr, "Too many problems (>%d)\n", MAX_PROBLEMS);
            return 5;
        }
        block_start[nblocks] = start;
        block_end[nblocks] = maxlen - 1;
        nblocks++;
    }

    long grand_total = 0;

    // For each block: parse the up-to-4 numbers from the first 4 lines, using the substring of the block
    for (int b = 0; b < nblocks; ++b) {
        int s = block_start[b];
        int e = block_end[b];

        // Extract operator from last (5th) line's substring
        char opbuf[MAX_LINE_LENGTH];
        int op_len = e - s + 1;
        if (op_len >= (int)sizeof(opbuf)) op_len = (int)sizeof(opbuf) - 1;
        memcpy(opbuf, lines[4] + s, op_len);
        opbuf[op_len] = '\0';
        trim(opbuf);
        if (strlen(opbuf) == 0) {
            // No operator found (shouldn't happen), skip
            continue;
        }
        char op = opbuf[0]; // '+' or '*'

        long values[NUM_LINES-1];
        int vcount = 0;
        for (i = 0; i < NUM_LINES-1; ++i) {
            char buf[MAX_LINE_LENGTH];
            int seglen = e - s + 1;
            if (seglen >= (int)sizeof(buf)) seglen = (int)sizeof(buf) - 1;
            memcpy(buf, lines[i] + s, seglen);
            buf[seglen] = '\0';
            trim(buf);
            if (strlen(buf) == 0) continue; // maybe fewer numbers in some rows
            // parse integer (allow leading/trailing spaces)
            long val = strtol(buf, NULL, 10);
            values[vcount++] = val;
        }

        if (vcount == 0) continue; // nothing to do

        long ans;
        if (op == '+') {
            ans = 0;
            for (int k = 0; k < vcount; ++k) ans += values[k];
        } else if (op == '*') {
            ans = 1;
            for (int k = 0; k < vcount; ++k) ans *= values[k];
        } else {
            // unknown operator; skip
            continue;
        }

        grand_total += ans;
    }

    printf("%ld\n", grand_total);
    return 0;
}

