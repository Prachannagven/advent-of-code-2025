// part2_repeat_sum.c
// Sum numbers inside ranges that are formed by repeating a k-digit block r>=2 times.
// Uses unsigned __int128 for safety.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>
#include <math.h>

typedef unsigned __int128 u128;

// print unsigned __int128
static void print_u128(u128 v) {
    if (v == 0) { putchar('0'); return; }
    char buf[64]; int pos = 0;
    while (v > 0) {
        int digit = (int)(v % 10);
        buf[pos++] = '0' + digit;
        v /= 10;
    }
    for (int i = pos - 1; i >= 0; --i) putchar(buf[i]);
}

// compute mobius mu(n) for small n (n <= 64 typically)
static int mobius(int n) {
    if (n == 1) return 1;
    int cnt = 0;
    int tmp = n;
    for (int p = 2; p * p <= tmp; ++p) {
        if (tmp % p == 0) {
            int c = 0;
            while (tmp % p == 0) { tmp /= p; c++; }
            if (c > 1) return 0; // squared prime factor
            cnt++;
        }
    }
    if (tmp > 1) cnt++;
    return (cnt % 2 == 0) ? 1 : -1;
}

// ceil division of unsigned long long using u128 safe math: ceil(a/b)
static unsigned long long ceil_div_ull(unsigned long long a, unsigned long long b) {
    if (b == 0) return 0;
    return (a + b - 1ULL) / b;
}

// floor division for u128 by u128 returning unsigned long long when possible
static unsigned long long floor_div_u128_u128(u128 a, u128 b) {
    // returns floor(a/b) as unsigned long long (caller must ensure it fits)
    return (unsigned long long)(a / b);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <inputfile>\n", argv[0]);
        return 1;
    }

    // Read input single line
    FILE *f = fopen(argv[1], "r");
    if (!f) { perror("Error opening file"); return 1; }
    char *line = NULL;
    size_t linecap = 0;
    if (getline(&line, &linecap, f) == -1) { fprintf(stderr, "Empty input\n"); free(line); fclose(f); return 1; }
    fclose(f);

    // Trim newline
    size_t L = strlen(line);
    while (L > 0 && (line[L-1] == '\n' || line[L-1] == '\r')) { line[--L] = 0; }

    // parse ranges, also find global max B to bound digit lengths
    unsigned long long global_maxB = 0;
    // We'll parse tokens separated by commas
    char *saveptr = NULL;
    char *tok = strtok_r(line, ",", &saveptr);

    // store ranges in dynamic arrays
    typedef struct { unsigned long long a,b; } range_t;
    range_t *ranges = NULL;
    size_t rcount = 0;

    while (tok) {
        // trim whitespace
        while (*tok && isspace((unsigned char)*tok)) ++tok;
        char *end = tok + strlen(tok) - 1;
        while (end >= tok && isspace((unsigned char)*end)) { *end = '\0'; --end; }

        if (*tok == '\0') { tok = strtok_r(NULL, ",", &saveptr); continue; }
        char *dash = strchr(tok, '-');
        if (!dash) { fprintf(stderr, "Bad token: '%s'\n", tok); free(ranges); free(line); return 1; }
        *dash = '\0';
        char *as = tok, *bs = dash+1;
        char *ep;
        unsigned long long A = strtoull(as, &ep, 10);
        if (*ep) { fprintf(stderr, "Bad number: %s\n", as); free(ranges); free(line); return 1; }
        unsigned long long B = strtoull(bs, &ep, 10);
        if (*ep) { fprintf(stderr, "Bad number: %s\n", bs); free(ranges); free(line); return 1; }
        if (A > B) { unsigned long long t = A; A = B; B = t; } // swap if needed

        ranges = (range_t*)realloc(ranges, (rcount+1)*sizeof(range_t));
        ranges[rcount].a = A;
        ranges[rcount].b = B;
        if (B > global_maxB) global_maxB = B;
        rcount++;
        tok = strtok_r(NULL, ",", &saveptr);
    }

    if (!ranges) { fprintf(stderr, "No ranges\n"); free(line); return 1; }

    // Precompute powers of 10 up to 40 digits (safe)
    const int MAX_POW = 40;
    u128 pow10[MAX_POW+1];
    pow10[0] = 1;
    for (int i = 1; i <= MAX_POW; ++i) pow10[i] = pow10[i-1] * (u128)10;

    // compute max digits in global_maxB
    int max_digits = 1;
    {
        unsigned long long t = global_maxB;
        while (t >= 10ULL) { t /= 10ULL; max_digits++; }
    }

    u128 total_sum = 0;

    // We will iterate over primitive block length k = 1..max_k
    // and repeats r >= 2 such that k*r <= max_digits
    int max_k = max_digits; // safe upper bound

    for (int k = 1; k <= max_k; ++k) {
        // precompute T_factors for divisors when forming x from smaller y
        // but we'll compute on the fly.

        // for repeats r
        for (int rrep = 2; rrep * k <= max_digits; ++rrep) {
            // multiplier M = sum_{i=0..rrep-1} 10^{k*i} = (10^{k*rrep}-1)/(10^k - 1)
            // compute as u128
            u128 M = 0;
            for (int i = 0; i < rrep; ++i) M += pow10[k*i];

            // For each input range:
            for (size_t ri = 0; ri < rcount; ++ri) {
                unsigned long long A = ranges[ri].a;
                unsigned long long B = ranges[ri].b;

                // compute x_min = ceil(A / M), x_max = floor(B / M)
                // but A,B are ull while M is u128
                u128 Au = (u128)A;
                u128 Bu = (u128)B;

                u128 x_min_u = (Au + M - 1) / M;
                u128 x_max_u = Bu / M;

                if (x_min_u > x_max_u) continue;

                // enforce k-digit x: lower_x = 10^{k-1}, upper_x = 10^k - 1
                u128 lower_x = pow10[k-1];
                u128 upper_x = pow10[k] - 1;

                if (x_max_u < lower_x) continue;
                if (x_min_u > upper_x) continue;

                if (x_min_u < lower_x) x_min_u = lower_x;
                if (x_max_u > upper_x) x_max_u = upper_x;

                // Now we need sum over x in [x_min_u .. x_max_u] whose minimal period is exactly k.
                // Use Möbius inversion: sum_{primitive x of length k} f(x) = sum_{d|k} mu(d) * sum_{y (d-digit)} f(rep(y, k/d))
                // Here f(x) = x (we will multiply by M later), but rep(y) = y * T where T = sum_{i=0..(k/d)-1}10^{d*i}
                // So compute S_primitive = sum_{d|k} mu(d) * sum_{y range} rep(y)

                // find divisors of k
                // we iterate d over divisors
                u128 sum_primitive_x = 0;

                for (int d = 1; d <= k; ++d) {
                    if (k % d != 0) continue;
                    int mu = mobius(k / d); // careful: we want mu(k/d) when summing over divisors d such that d*k/d = k
                    // Equivalent to iterate t | k where t = k/d; but using this formula works.
                    // Here we use standard Möbius inversion mapping: P(k) = sum_{t|k} mu(t) * A(k/t)
                    // We're iterating over d being divisor of k, and using mu(k/d).
                    if (mu == 0) continue;

                    int t = k / d; // number of repeats of the d-block inside k
                    // Trep = sum_{i=0..t-1} 10^{d*i}  (to build x from y)
                    u128 Trep = 0;
                    for (int i = 0; i < t; ++i) Trep += pow10[d * i];

                    // Now x (k-digit) equals rep(y) = y * Trep, where y has d digits [10^{d-1} .. 10^d -1]
                    // We need y range such that x_min_u <= y*Trep <= x_max_u.
                    u128 y_min_u = (x_min_u + Trep - 1) / Trep;
                    u128 y_max_u = x_max_u / Trep;

                    u128 y_lower = pow10[d-1];
                    u128 y_upper = pow10[d] - 1;

                    if (y_max_u < y_lower) continue;
                    if (y_min_u > y_upper) continue;

                    if (y_min_u < y_lower) y_min_u = y_lower;
                    if (y_max_u > y_upper) y_max_u = y_upper;

                    // sum of y from y_min..y_max
                    // count * (y_min + y_max) / 2
                    u128 count = (y_max_u - y_min_u + 1);
                    u128 sum_y = count * (y_min_u + y_max_u) / 2;

                    // sum of rep(y) = Trep * sum_y
                    u128 sum_rep = Trep * sum_y;

                    if (mu == 1) sum_primitive_x += sum_rep;
                    else if (mu == -1) sum_primitive_x -= sum_rep;
                }

                if (sum_primitive_x == 0) continue;

                // Contribution to total: M * sum_primitive_x
                u128 contrib = M * sum_primitive_x;
                total_sum += contrib;
            } // end ranges loop
        } // end rrep
    } // end k

    // print result
    print_u128(total_sum);
    putchar('\n');

    free(ranges);
    free(line);
    return 0;
}

