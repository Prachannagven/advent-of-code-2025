#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

static char *trim_copy(const char *s, size_t start, size_t end) {
    while (start < end && isspace((unsigned char)s[start])) start++;
    while (end > start && isspace((unsigned char)s[end-1])) end--;
    size_t len = end - start;
    char *out = malloc(len + 1);
    if (!out) { perror("malloc"); exit(1); }
    memcpy(out, s + start, len);
    out[len] = '\0';
    return out;
}

static long parse_long_or_die(const char *s) {
    char *end;
    long v = strtol(s, &end, 10);
    if (end == s) {
        fprintf(stderr, "Failed to parse integer from \"%s\"\n", s);
        exit(1);
    }
    return v;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <worksheet-file>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) { perror("fopen"); return 1; }

    /* Read all lines into a dynamic array */
    char *line = NULL;
    size_t cap = 0;
    ssize_t n;
    char **lines = NULL;
    size_t lines_count = 0, lines_cap = 0;
    while ((n = getline(&line, &cap, fp)) != -1) {
        /* remove trailing newline */
        if (n > 0 && line[n-1] == '\n') { line[n-1] = '\0'; n--; }
        if (lines_count + 1 > lines_cap) {
            size_t nc = lines_cap ? lines_cap * 2 : 64;
            char **tmp = realloc(lines, nc * sizeof(char*));
            if (!tmp) { perror("realloc"); return 1; }
            lines = tmp; lines_cap = nc;
        }
        lines[lines_count++] = strdup(line);
    }
    free(line);
    fclose(fp);

    if (lines_count == 0) {
        fprintf(stderr, "Empty file\n");
        return 1;
    }
    if (lines_count % 5 != 0) {
        fprintf(stderr, "Warning: number of lines (%zu) is not a multiple of 5. "
                        "Processing as many full 5-line blocks as possible.\n", lines_count);
    }

    long long grand_total = 0;

    /* Process every 5-line block */
    for (size_t base = 0; base + 4 < lines_count; base += 5) {
        char *r0 = lines[base + 0];
        char *r1 = lines[base + 1];
        char *r2 = lines[base + 2];
        char *r3 = lines[base + 3];
        char *r4 = lines[base + 4];

        /* find max width */
        size_t w0 = strlen(r0), w1 = strlen(r1), w2 = strlen(r2), w3 = strlen(r3), w4 = strlen(r4);
        size_t width = w0;
        if (w1 > width) width = w1;
        if (w2 > width) width = w2;
        if (w3 > width) width = w3;
        if (w4 > width) width = w4;

        /* pad shorter lines conceptually (we just check bounds) */

        /* A column is "empty" if every row has a space (or it's past end) at that column */
        size_t col = 0;
        while (col < width) {
            /* skip empty separator columns */
            int all_space = 1;
            for (int r = 0; r < 5; r++) {
                char *row = lines[base + r];
                if (col < strlen(row) && !isspace((unsigned char)row[col])) { all_space = 0; break; }
            }
            if (all_space) { col++; continue; }

            /* found start of a problem segment: find end */
            size_t start = col;
            size_t end = start;
            while (end < width) {
                int col_all_space = 1;
                for (int r = 0; r < 5; r++) {
                    char *row = lines[base + r];
                    if (end < strlen(row) && !isspace((unsigned char)row[end])) { col_all_space = 0; break; }
                }
                if (col_all_space) break;
                end++;
            }

            /* extract substrings for each of the first 4 rows */
            char *s0 = trim_copy(r0, start, end);
            char *s1 = trim_copy(r1, start, end);
            char *s2 = trim_copy(r2, start, end);
            char *s3 = trim_copy(r3, start, end);
            char *sop = trim_copy(r4, start, end);

            /* parse numbers (skip empty strings) */
            long vals[4];
            int val_count = 0;
            if (s0[0] != '\0') vals[val_count++] = parse_long_or_die(s0);
            if (s1[0] != '\0') vals[val_count++] = parse_long_or_die(s1);
            if (s2[0] != '\0') vals[val_count++] = parse_long_or_die(s2);
            if (s3[0] != '\0') vals[val_count++] = parse_long_or_die(s3);

            if (val_count == 0) {
                /* nothing in this segment (shouldn't happen) */
                free(s0); free(s1); free(s2); free(s3); free(sop);
                col = end;
                continue;
            }

            /* find operator: first '+' or '*' in sop */
            char op = 0;
            for (size_t k = 0; sop[k] != '\0'; k++) {
                if (sop[k] == '+' || sop[k] == '*') { op = sop[k]; break; }
            }
            if (!op) {
                /* default to + if not found (but ideally input has + or *) */
                op = '+';
            }

            long long problem_result;
            if (op == '+') {
                problem_result = 0;
                for (int i = 0; i < val_count; i++) problem_result += vals[i];
            } else {
                problem_result = 1;
                for (int i = 0; i < val_count; i++) problem_result *= vals[i];
            }

            grand_total += problem_result;

            free(s0); free(s1); free(s2); free(s3); free(sop);

            col = end;
        } /* while col < width */
    } /* block loop */

    printf("%lld\n", grand_total);

    for (size_t i = 0; i < lines_count; i++) free(lines[i]);
    free(lines);
    return 0;
}

