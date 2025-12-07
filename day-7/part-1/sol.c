#include <stdio.h>
#include <string.h>

#define MAX 2000

typedef struct {
    int r, c;
} Beam;

char grid[MAX][MAX];
int visited[MAX][MAX];
Beam queue[MAX * MAX];
int R, C;

int main(int argc, char **argv) {
	// Check for two inputs
	if(argc < 2){
		fprintf(stderr, "Usage: %s < inputfile\n", argv[0]);
		return 1;
	}

	FILE *fp = fopen(argv[1], "r");
	if(fp == NULL){
		fprintf(stderr, "Error opening file %s\n", argv[1]);
		return 1;
	}

    char line[4096];
    R = 0;
    while (fgets(line, sizeof(line), fp)) {
        int len = strlen(line);
        if (line[len-1] == '\n') line[len-1] = '\0';
        strcpy(grid[R], line);
        R++;
    }
    C = strlen(grid[0]);

    // --- Find S ---
    int sr = -1, sc = -1;
    for (int r = 0; r < R; r++) {
        for (int c = 0; c < C; c++) {
            if (grid[r][c] == 'S') {
                sr = r;
                sc = c;
            }
        }
    }
    if (sr < 0) {
        fprintf(stderr, "No S found.\n");
        return 1;
    }
    int head = 0, tail = 0;
    int splits = 0;

    if (sr + 1 < R) {
        queue[tail++] = (Beam){sr + 1, sc};
        visited[sr + 1][sc] = 1;
    }

    while (head < tail) {
        Beam b = queue[head++];
        int r = b.r, c = b.c;

        if (r < 0 || r >= R || c < 0 || c >= C)
            continue;

        char cell = grid[r][c];

        if (cell == '.') {
            if (r + 1 < R && !visited[r+1][c]) {
                visited[r+1][c] = 1;
                queue[tail++] = (Beam){r+1, c};
            }
        }
        else if (cell == '^') {
            splits++;
            if (c - 1 >= 0 && !visited[r][c-1]) {
                visited[r][c-1] = 1;
                queue[tail++] = (Beam){r, c-1};
            }
            if (c + 1 < C && !visited[r][c+1]) {
                visited[r][c+1] = 1;
                queue[tail++] = (Beam){r, c+1};
            }

        }
    }

    printf("Number of splits is: %d\n", splits);

	fclose(fp);
    return 0;
}

