#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define INITIAL_LINES 128

int dr[8] = {-1,-1,-1, 0,0, 1,1,1};
int dc[8] = {-1, 0, 1,-1,1,-1,0,1};

int main(int argc, char **argv) {
    FILE *fp = stdin;
    if (argc >= 2) {
        fp = fopen(argv[1], "r");
        if (!fp) {
            fprintf(stderr, "Error opening %s: %s\n", argv[1], strerror(errno));
            return 1;
        }
    }

    // Read lines using getline into a dynamic array
    char **lines = NULL;
    size_t lines_cap = 0;
    size_t lines_len = 0;
    char *buf = NULL;
    size_t bufcap = 0;
    ssize_t linelen;

    while ((linelen = getline(&buf, &bufcap, fp)) != -1) {
        // strip newline(s)
        while (linelen > 0 && (buf[linelen-1] == '\n' || buf[linelen-1] == '\r')) {
            buf[--linelen] = '\0';
        }
        if (lines_len + 1 > lines_cap) {
            size_t newcap = lines_cap ? lines_cap * 2 : INITIAL_LINES;
            char **tmp = realloc(lines, newcap * sizeof(*tmp));
            if (!tmp) { perror("realloc"); return 2; }
            lines = tmp;
            lines_cap = newcap;
        }
        lines[lines_len] = strdup(buf);
        if (!lines[lines_len]) { perror("strdup"); return 2; }
        lines_len++;
    }
    free(buf);
    if (fp != stdin) fclose(fp);

    if (lines_len == 0) {
        fprintf(stderr, "No input\n");
        return 1;
    }

    // compute width and height
    int h = (int)lines_len;
    int w = 0;
    for (size_t i = 0; i < lines_len; ++i) {
        int L = (int)strlen(lines[i]);
        if (L > w) w = L;
    }

    // create grid padded with '.'
    char **grid = malloc(h * sizeof(*grid));
    if (!grid) { perror("malloc"); return 2; }
    for (int r = 0; r < h; ++r) {
        grid[r] = malloc(w + 1);
        if (!grid[r]) { perror("malloc"); return 2; }
        int L = (int)strlen(lines[r]);
        for (int c = 0; c < w; ++c) {
            if (c < L) grid[r][c] = lines[r][c];
            else grid[r][c] = '.';
        }
        grid[r][w] = '\0';
        free(lines[r]);
    }
    free(lines);

    long total_removed = 0;

    // temporary array to mark removals (1 = remove)
    char *mark = malloc(w * h);
    if (!mark) { perror("malloc"); return 2; }

    while (1) {
        // clear marks
        memset(mark, 0, w * h);

        int any = 0;
        for (int r = 0; r < h; ++r) {
            for (int c = 0; c < w; ++c) {
                if (grid[r][c] != '@') continue;
                int neigh = 0;
                for (int k = 0; k < 8; ++k) {
                    int rr = r + dr[k];
                    int cc = c + dc[k];
                    if (rr >= 0 && rr < h && cc >= 0 && cc < w && grid[rr][cc] == '@')
                        neigh++;
                }
                if (neigh < 4) {
                    mark[r * w + c] = 1;
                    any = 1;
                }
            }
        }

        if (!any) break; // no more removable rolls

        // remove all marked simultaneously
        for (int r = 0; r < h; ++r) {
            for (int c = 0; c < w; ++c) {
                if (mark[r * w + c]) {
                    grid[r][c] = '.';
                    total_removed++;
                }
            }
        }
    }

    // print total removed
    printf("%ld\n", total_removed);

    // Optionally print final grid (comment out if not wanted)
    // for (int r = 0; r < h; ++r) puts(grid[r]);

    // cleanup
    for (int r = 0; r < h; ++r) free(grid[r]);
    free(grid);
    free(mark);

    return 0;
}

