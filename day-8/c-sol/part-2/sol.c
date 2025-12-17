#include <stdio.h>
#include <stdlib.h>

/* ===================== Data Structures ===================== */

typedef struct {
    int x, y, z;
} Point;

typedef struct {
    int u, v;
    long long dist2;
} Edge;

/* ===================== Union-Find ===================== */

int *parent;
int *sz;

void uf_init(int n) {
    parent = malloc(n * sizeof(int));
    sz     = malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) {
        parent[i] = i;
        sz[i] = 1;
    }
}

void uf_free(void) {
    free(parent);
    free(sz);
}

int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);
    return parent[x];
}

int unite(int a, int b) {
    int ra = find(a);
    int rb = find(b);
    if (ra == rb) return 0;

    if (sz[ra] < sz[rb]) {
        parent[ra] = rb;
        sz[rb] += sz[ra];
    } else {
        parent[rb] = ra;
        sz[ra] += sz[rb];
    }
    return 1;
}

/* ===================== Utilities ===================== */

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

/* ===================== Main ===================== */

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    /* ---------- Read input ---------- */

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        perror("fopen");
        return 1;
    }

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

    if (n < 2) {
        fprintf(stderr, "Not enough junction boxes\n");
        return 1;
    }

    /* ---------- Build all edges ---------- */

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

    qsort(edges, edge_count, sizeof(Edge), cmp_edge);

    /* =========================================================
       PART 1: First 1000 closest PAIRS
       ========================================================= */

    uf_init(n);

    int K = 1000;
    if (K > edge_count) K = edge_count;

    for (int i = 0; i < K; i++) {
        unite(edges[i].u, edges[i].v);
    }

    int a = 0, b = 0, c = 0;
    for (int i = 0; i < n; i++) {
        if (parent[i] == i) {
            int s = sz[i];
            if (s > a) { c = b; b = a; a = s; }
            else if (s > b) { c = b; b = s; }
            else if (s > c) { c = s; }
        }
    }

    long long part1 = (long long)a * b * c;
    uf_free();

    /* =========================================================
       PART 2: Connect until fully connected
       ========================================================= */

    uf_init(n);
    int components = n;
    int last_u = -1, last_v = -1;

    for (int i = 0; i < edge_count; i++) {
        if (unite(edges[i].u, edges[i].v)) {
            components--;
            last_u = edges[i].u;
            last_v = edges[i].v;

            if (components == 1)
                break;
        }
    }

    long long part2 =
        (long long)points[last_u].x *
        (long long)points[last_v].x;

    uf_free();

    /* ---------- Output ---------- */

    printf("Part 1: %lld\n", part1);
    printf("Part 2: %lld\n", part2);

    /* ---------- Cleanup ---------- */

    free(points);
    free(edges);

    return 0;
}

