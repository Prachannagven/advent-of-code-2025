#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>

typedef unsigned __int128 u128;

/* ---------- shared helpers ---------- */

static void print_u128(u128 v) {
    if (v == 0) { putchar('0'); return; }
    char buf[64];
    int pos = 0;
    while (v > 0) {
        buf[pos++] = '0' + (int)(v % 10);
        v /= 10;
    }
    for (int i = pos - 1; i >= 0; --i)
        putchar(buf[i]);
}

/* ---------- PART 1 ---------- */

static u128 solve_part1(const char *input) {
    const int MAX_POW = 20;
    unsigned long long pow10[MAX_POW + 1];
    pow10[0] = 1ULL;
    for (int i = 1; i <= MAX_POW; ++i)
        pow10[i] = pow10[i - 1] * 10ULL;

    unsigned long long global_max = 0;
    for (const char *p = input; *p; ) {
        while (*p && !isdigit((unsigned char)*p)) ++p;
        if (!*p) break;
        unsigned long long v = 0;
        while (*p && isdigit((unsigned char)*p)) {
            v = v * 10ULL + (*p - '0');
            ++p;
        }
        if (v > global_max) global_max = v;
    }

    int max_digits = 1;
    for (unsigned long long t = global_max; t >= 10; t /= 10)
        max_digits++;

    char *buf = strdup(input);
    char *saveptr = NULL;
    char *tok = strtok_r(buf, ",\n\r", &saveptr);

    u128 total = 0;

    while (tok) {
        char *dash = strchr(tok, '-');
        if (!dash) { free(buf); return 0; }
        *dash = 0;

        unsigned long long A = strtoull(tok, NULL, 10);
        unsigned long long B = strtoull(dash + 1, NULL, 10);
        if (A > B) { unsigned long long t = A; A = B; B = t; }

        for (int k = 1; k <= max_digits && k <= MAX_POW; ++k) {
            unsigned long long mul = pow10[k] + 1ULL;
            if ((u128)pow10[k - 1] * mul > (u128)B) break;

            unsigned long long xmin = (A + mul - 1) / mul;
            unsigned long long xmax = B / mul;

            unsigned long long lo = pow10[k - 1];
            unsigned long long hi = pow10[k] - 1;

            if (xmin < lo) xmin = lo;
            if (xmax > hi) xmax = hi;
            if (xmin > xmax) continue;

            u128 cnt = (u128)(xmax - xmin + 1);
            u128 sumx = cnt * (xmin + xmax) / 2;
            total += (u128)mul * sumx;
        }

        tok = strtok_r(NULL, ",\n\r", &saveptr);
    }

    free(buf);
    return total;
}

/* ---------- PART 2 ---------- */

static int mobius(int n) {
    if (n == 1) return 1;
    int cnt = 0;
    for (int p = 2; p * p <= n; ++p) {
        if (n % p == 0) {
            int c = 0;
            while (n % p == 0) { n /= p; c++; }
            if (c > 1) return 0;
            cnt++;
        }
    }
    if (n > 1) cnt++;
    return (cnt & 1) ? -1 : 1;
}

static u128 solve_part2(const char *input) {
    typedef struct { unsigned long long a, b; } range_t;
    range_t *ranges = NULL;
    size_t rc = 0;

    unsigned long long maxB = 0;
    char *buf = strdup(input);
    char *saveptr = NULL;
    char *tok = strtok_r(buf, ",", &saveptr);

    while (tok) {
        char *dash = strchr(tok, '-');
        if (!dash) { free(buf); free(ranges); return 0; }
        *dash = 0;

        unsigned long long A = strtoull(tok, NULL, 10);
        unsigned long long B = strtoull(dash + 1, NULL, 10);
        if (A > B) { unsigned long long t = A; A = B; B = t; }

        ranges = realloc(ranges, (rc + 1) * sizeof(*ranges));
        ranges[rc++] = (range_t){A, B};
        if (B > maxB) maxB = B;

        tok = strtok_r(NULL, ",", &saveptr);
    }

    int max_digits = 1;
    for (unsigned long long t = maxB; t >= 10; t /= 10)
        max_digits++;

    const int MAX_POW = 40;
    u128 pow10[MAX_POW + 1];
    pow10[0] = 1;
    for (int i = 1; i <= MAX_POW; ++i)
        pow10[i] = pow10[i - 1] * 10;

    u128 total = 0;

    for (int k = 1; k <= max_digits; ++k) {
        for (int r = 2; r * k <= max_digits; ++r) {
            u128 M = 0;
            for (int i = 0; i < r; ++i)
                M += pow10[k * i];

            for (size_t ri = 0; ri < rc; ++ri) {
                u128 A = ranges[ri].a;
                u128 B = ranges[ri].b;

                u128 xmin = (A + M - 1) / M;
                u128 xmax = B / M;

                u128 lo = pow10[k - 1];
                u128 hi = pow10[k] - 1;
                if (xmin < lo) xmin = lo;
                if (xmax > hi) xmax = hi;
                if (xmin > xmax) continue;

                u128 sum = 0;
                for (int d = 1; d <= k; ++d) {
                    if (k % d) continue;
                    int mu = mobius(k / d);
                    if (!mu) continue;

                    int t = k / d;
                    u128 T = 0;
                    for (int i = 0; i < t; ++i)
                        T += pow10[d * i];

                    u128 ymin = (xmin + T - 1) / T;
                    u128 ymax = xmax / T;

                    u128 dlo = pow10[d - 1];
                    u128 dhi = pow10[d] - 1;
                    if (ymin < dlo) ymin = dlo;
                    if (ymax > dhi) ymax = dhi;
                    if (ymin > ymax) continue;

                    u128 cnt = ymax - ymin + 1;
                    u128 s = cnt * (ymin + ymax) / 2;
                    if (mu == 1) sum += T * s;
                    else sum -= T * s;
                }

                total += M * sum;
            }
        }
    }

    free(buf);
    free(ranges);
    return total;
}

/* ---------- MAIN ---------- */

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <inputfile>\n", argv[0]);
        return 1;
    }

    FILE *f = fopen(argv[1], "r");
    if (!f) { perror("fopen"); return 1; }

    char *line = NULL;
    size_t cap = 0;
    if (getline(&line, &cap, f) == -1) {
        fprintf(stderr, "Empty input\n");
        fclose(f);
        return 1;
    }
    fclose(f);

    /* strip newline */
    size_t L = strlen(line);
    while (L && (line[L - 1] == '\n' || line[L - 1] == '\r'))
        line[--L] = 0;

    u128 p1 = solve_part1(line);
    u128 p2 = solve_part2(line);

    printf("Part 1 Solution: ");
    print_u128(p1);
    putchar('\n');

    printf("Part 2 Solution: ");
    print_u128(p2);
    putchar('\n');

    free(line);
    return 0;
}

