#include <stdio.h>
#include <stdlib.h>

typedef struct { long x, y; } Point;
typedef struct { int x, y; } Cell;

/* Flood-fill outside region */
void flood_outside(int sx, int sy, int W, int H,
                   char **allowed, char **outside)
{
    Cell *stack = malloc(W * H * sizeof(Cell));
    int top = 0;
    stack[top++] = (Cell){sx, sy};

    while (top) {
        Cell c = stack[--top];
        int x = c.x, y = c.y;

        if (x < 0 || x >= W || y < 0 || y >= H) continue;
        if (outside[y][x]) continue;
        if (allowed[y][x]) continue;

        outside[y][x] = 1;

        stack[top++] = (Cell){x+1,y};
        stack[top++] = (Cell){x-1,y};
        stack[top++] = (Cell){x,y+1};
        stack[top++] = (Cell){x,y-1};
    }
    free(stack);
}

int forbidden_count(int x1, int y1, int x2, int y2, int **bad)
{
    return bad[y2][x2] - bad[y1][x2]
         - bad[y2][x1] + bad[y1][x1];
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr,"Usage: %s <input>\n",argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1],"r");
    if (!fp) { perror("fopen"); return 1; }

    Point *pts = NULL;
    int n = 0, cap = 0;

    while (1) {
        long long x,y;
        if (fscanf(fp,"%lld,%lld",&x,&y) != 2) break;
        if (n == cap) {
            cap = cap ? cap*2 : 8;
            pts = realloc(pts, cap*sizeof(Point));
        }
        pts[n++] = (Point){x,y};
    }
    fclose(fp);

    long min_x = pts[0].x, max_x = pts[0].x;
    long min_y = pts[0].y, max_y = pts[0].y;
    for (int i=1;i<n;i++) {
        if (pts[i].x < min_x) min_x = pts[i].x;
        if (pts[i].x > max_x) max_x = pts[i].x;
        if (pts[i].y < min_y) min_y = pts[i].y;
        if (pts[i].y > max_y) max_y = pts[i].y;
    }

    /* PAD THE GRID */
    min_x--; min_y--;
    max_x++; max_y++;

    int W = max_x - min_x + 1;
    int H = max_y - min_y + 1;

    char **allowed = malloc(H*sizeof(char*));
    char **outside = malloc(H*sizeof(char*));
    for (int y=0;y<H;y++) {
        allowed[y] = calloc(W,1);
        outside[y] = calloc(W,1);
    }

    /* Mark red tiles */
    for (int i=0;i<n;i++) {
        int x = pts[i].x - min_x;
        int y = pts[i].y - min_y;
        allowed[y][x] = 1;
    }

    /* Draw boundary segments */
    for (int i=0;i<n;i++) {
        Point a = pts[i];
        Point b = pts[(i+1)%n];

        if (a.x == b.x) {
            int x = a.x - min_x;
            long y1 = a.y < b.y ? a.y : b.y;
            long y2 = a.y > b.y ? a.y : b.y;
            for (long y=y1;y<=y2;y++)
                allowed[y-min_y][x] = 1;
        } else {
            int y = a.y - min_y;
            long x1 = a.x < b.x ? a.x : b.x;
            long x2 = a.x > b.x ? a.x : b.x;
            for (long x=x1;x<=x2;x++)
                allowed[y][x-min_x] = 1;
        }
    }

    /* Flood outside */
    flood_outside(0,0,W,H,allowed,outside);

    /* Fill interior */
    for (int y=0;y<H;y++)
        for (int x=0;x<W;x++)
            if (!allowed[y][x] && !outside[y][x])
                allowed[y][x] = 1;

    /* Prefix sum */
    int **bad = malloc((H+1)*sizeof(int*));
    for (int y=0;y<=H;y++)
        bad[y] = calloc(W+1,sizeof(int));

    for (int y=1;y<=H;y++)
        for (int x=1;x<=W;x++)
            bad[y][x] = bad[y-1][x] + bad[y][x-1]
                      - bad[y-1][x-1]
                      + (allowed[y-1][x-1] ? 0 : 1);

    long long best = 0;
    Point A={0,0}, B={0,0};

    for (int i=0;i<n;i++)
        for (int j=i+1;j<n;j++) {
            int x1 = pts[i].x - min_x;
            int y1 = pts[i].y - min_y;
            int x2 = pts[j].x - min_x;
            int y2 = pts[j].y - min_y;

            if (x1==x2 || y1==y2) continue;

            int lx = x1<x2?x1:x2;
            int rx = x1>x2?x1:x2;
            int ty = y1<y2?y1:y2;
            int by = y1>y2?y1:y2;

            if (forbidden_count(lx,ty,rx+1,by+1,bad)) continue;

            long long area = (rx-lx+1)*(by-ty+1);
            if (area > best) {
                best = area;
                A = pts[i];
                B = pts[j];
            }
        }

    printf("Best corners: (%ld,%ld) and (%ld,%ld)\n",
           A.x,A.y,B.x,B.y);
    printf("Max rectangle area: %lld\n", best);

    return 0;
}

