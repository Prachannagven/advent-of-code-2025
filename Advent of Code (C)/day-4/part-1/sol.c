#include <stdio.h>
#include <string.h>

#define MAXW  1024
#define MAXH  1024

char grid[MAXH][MAXW];
int height = 0, width = 0;

int dr[8] = {-1,-1,-1, 0,0, 1,1,1};
int dc[8] = {-1, 0, 1,-1,1,-1,0,1};

int main(int argc, char **argv) {
    FILE *fp;
    if (argc >= 2) {
        fp = fopen(argv[1], "r");
        if (!fp) {
            perror("Error opening file");
            return 1;
        }
    } else {
        fp = stdin;
    }

    // Read grid line-by-line
    char buf[MAXW+5];
    while (fgets(buf, sizeof(buf), fp) && height < MAXH) {
        int len = strlen(buf);

        // Remove trailing newline
        if (len > 0 && buf[len-1] == '\n') {
            buf[len-1] = '\0';
            len--;
        }

        if (len > width) width = len;

        // Copy into grid row, pad with '.'
        for (int i = 0; i < len; i++)
            grid[height][i] = buf[i];
        for (int i = len; i < MAXW; i++)
            grid[height][i] = '.';

        height++;
    }

    // Count accessible rolls
    int result = 0;

    for (int r = 0; r < height; r++) {
        for (int c = 0; c < width; c++) {
            if (grid[r][c] != '@') continue;

            int count = 0;

            for (int k = 0; k < 8; k++) {
                int rr = r + dr[k];
                int cc = c + dc[k];

                if (rr >= 0 && rr < height &&
                    cc >= 0 && cc < width &&
                    grid[rr][cc] == '@')
                {
                    count++;
                }
            }

            if (count < 4)
                result++;
        }
    }

    printf("%d\n", result);
    return 0;
}

