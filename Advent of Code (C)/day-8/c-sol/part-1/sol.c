#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int x, y, z;
} Point;

typedef struct {
    int u, v;
    long long dist2;   // squared distance
} Edge;

/* ---------- Union Find ---------- */

int *parent;
int *sz;

int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);
    return parent[x];
}

void unite(int a, int b) {
    int ra = find(a);
    int rb = find(b);
    if (ra == rb) return;

    if (sz[ra] < sz[rb]) {
        parent[ra] = rb;
        sz[rb] += sz[ra];
    } else {
        parent[rb] = ra;
        sz[ra] += sz[rb];
    }
}

/* ---------- Utilities ---------- */

long long dist2(Point a, Point b) {
    long long dx = (long long)a.x - b.x;
    long long dy = (long long)a.y - b.y;
    long long dz = (long long)a.z - b.z;
    return dx*dx + dy*dy + dz*dz;
}

int cmp_edge(const void *a, const void *b) {
    const Edge *ea = a;
    const Edge *eb = b;
    if (ea->dist2 < eb->dist2) return -1;
    if (ea->dist2 > eb->dist2) return 1;
    return 0;
}

/* ---------- Main ---------- */

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        perror("fopen");
        return 1;
    }

    /* Read points */
    Point *points = NULL;
    int n = 0, cap = 0;

    while (1) {
        int x, y, z;
        if (fscanf(fp, "%d,%d,%d", &x, &y, &z) != 3)
            break;

        if (n == cap) {
            cap = cap ? cap * 2 : 64;
            points = realloc(points, cap * sizeof(Point));
        }
        points[n++] = (Point){x, y, z};
    }
    fclose(fp);

    if (n < 3) {
        fprintf(stderr, "Not enough points\n");
        return 1;
    }

    /* Init Union-Find */
    parent = malloc(n * sizeof(int));
    sz     = malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) {
        parent[i] = i;
        sz[i] = 1;
    }

    /* Build all edges */
    int edge_count = n * (n - 1) / 2;
    Edge *edges = malloc(edge_count * sizeof(Edge));

    int k = 0;
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            edges[k++] = (Edge){
                .u = i,
                .v = j,
                .dist2 = dist2(points[i], points[j])
            };
        }
    }

    /* Sort edges */
    qsort(edges, edge_count, sizeof(Edge), cmp_edge);

    /* Process FIRST 1000 EDGES (not unions) */
    int limit = edge_count < 1000 ? edge_count : 1000;
    for (int i = 0; i < limit; i++) {
        unite(edges[i].u, edges[i].v);
    }

    /* Collect component sizes */
    int *comps = malloc(n * sizeof(int));
    int comp_count = 0;

    for (int i = 0; i < n; i++) {
        if (parent[i] == i) {
            comps[comp_count++] = sz[i];
        }
    }

    /* Find largest three */
    int a = 0, b = 0, c = 0;
    for (int i = 0; i < comp_count; i++) {
        int s = comps[i];
        if (s > a) { c = b; b = a; a = s; }
        else if (s > b) { c = b; b = s; }
        else if (s > c) { c = s; }
    }

    long long result = (long long)a * b * c;
    printf("%lld\n", result);

    /* Cleanup */
    free(points);
    free(edges);
    free(parent);
    free(sz);
    free(comps);

    return 0;
}

