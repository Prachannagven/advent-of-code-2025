// invalid_ids_sum.c
// Reads a single line of comma-separated ranges "L-R,L-R,..." and
// computes the sum of all numbers of the form "x concatenated with x"
// (no leading zeros in x) that lie inside any of the ranges.
//
// Example of such numbers: 11 (1 twice), 6464 (64 twice), 123123 (123 twice).
//
// Algorithm: For each range and for each k (half-length in digits), solve
//   x_min = max(10^(k-1), ceil(L / (10^k+1)))
//   x_max = min(10^k - 1, floor(R / (10^k+1)))
// If x_min <= x_max, add (10^k+1) * sum_{x=x_min..x_max} x
//
// Uses unsigned __int128 for intermediate arithmetic to avoid overflow.
//
// Author: ChatGPT

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdint.h>

#ifndef U128
typedef unsigned __int128 u128;
#else
typedef unsigned __int128 u128;
#endif

// Print unsigned __int128 as decimal
static void print_u128(u128 v) {
    if (v == 0) {
        putchar('0');
        return;
    }
    char buf[64];
    int pos = 0;
    while (v > 0) {
        int digit = (int)(v % 10);
        buf[pos++] = '0' + digit;
        v /= 10;
    }
    for (int i = pos - 1; i >= 0; --i) putchar(buf[i]);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <inputfile>\n", argv[0]);
        return 1;
    }

    // Read whole file (it should contain a single line of ranges)
    FILE *f = fopen(argv[1], "r");
    if (!f) {
        perror("Error opening file");
        return 1;
    }

    // load file into buffer (reasonable size assumption; expand if needed)
    char *buf = NULL;
    size_t bufsz = 0;
    ssize_t r = 0;
    // use getline for convenience
    if (getline(&buf, &bufsz, f) == -1) {
        // maybe empty file
        fprintf(stderr, "Empty or unreadable input file\n");
        if (buf) free(buf);
        fclose(f);
        return 1;
    }
    fclose(f);

    // Precompute powers of 10 up to 20 (safe for 128-bit)
    const int MAX_POW = 20;
    unsigned long long pow10[MAX_POW + 1];
    pow10[0] = 1ULL;
    for (int i = 1; i <= MAX_POW; ++i) pow10[i] = pow10[i-1] * 10ULL;

    // Find the maximal upper bound among ranges to limit k
    // But we can simply compute max_digits from the largest numeric substring.
    unsigned long long global_max = 0;
    // scan buffer for numbers to update global_max
    for (char *p = buf; *p; ) {
        while (*p && !isdigit((unsigned char)*p)) ++p;
        if (!*p) break;
        unsigned long long val = 0;
        while (*p && isdigit((unsigned char)*p)) {
            val = val * 10ULL + (unsigned)(*p - '0');
            ++p;
        }
        if (val > global_max) global_max = val;
    }

    // Compute maximum possible digits in global_max
    int max_digits = 1;
    unsigned long long tmp = global_max;
    while (tmp >= 10ULL) { tmp /= 10ULL; max_digits++; }
    // half-length k can be up to max_digits/2 (since N has 2k digits)
    int max_k = (max_digits + 1) / 2 + 1; // add small slack

    // We'll tokenise by commas
    char *saveptr = NULL;
    char *token = strtok_r(buf, ",\n\r", &saveptr);

    u128 total_sum = 0; // use 128-bit accumulator

    while (token) {
        // Trim whitespace
        char *s = token;
        while (*s && isspace((unsigned char)*s)) ++s;
        char *e = s + strlen(s) - 1;
        while (e >= s && isspace((unsigned char)*e)) { *e = '\0'; --e; }

        if (*s == '\0') { token = strtok_r(NULL, ",\n\r", &saveptr); continue; }

        // parse A-B
        char *dash = strchr(s, '-');
        if (!dash) {
            fprintf(stderr, "Invalid range token (missing '-'): '%s'\n", s);
            free(buf);
            return 1;
        }
        *dash = '\0';
        char *a_str = s;
        char *b_str = dash + 1;

        // parse unsigned long long
        char *endptr;
        unsigned long long A = strtoull(a_str, &endptr, 10);
        if (*endptr != '\0') {
            fprintf(stderr, "Invalid number: '%s'\n", a_str);
            free(buf);
            return 1;
        }
        unsigned long long B = strtoull(b_str, &endptr, 10);
        if (*endptr != '\0') {
            fprintf(stderr, "Invalid number: '%s'\n", b_str);
            free(buf);
            return 1;
        }
        if (A > B) { // swap or skip
            unsigned long long t = A; A = B; B = t;
        }

        // For each possible half-length k (digits in x)
        // We need (10^k + 1) multiplier
        // Choose k from 1 up to something where 10^(2k - 1) <= B (minimum 2k-digit number <= B)
        // We'll bound k by max_k computed earlier but also by 1..19 for safety.
        int k_upper = 19; // safe upper bound for uint64-based inputs
        for (int k = 1; k <= k_upper; ++k) {
            // multiplier = 10^k + 1
            // But 10^k might overflow unsigned long long for k>19; we limit k accordingly.
            if (k > MAX_POW) break;
            unsigned long long pow_10k = pow10[k];
            // multiplier fits in unsigned long long up to k reasonable
            unsigned long long mul = pow_10k + 1ULL;

            // minimal possible N for this k: x = 10^(k-1)
            // N_min_digits = 2k, N_min = 10^(k-1) * (10^k + 1)
            // Quick skip if minimal N > B
            // Use 128-bit to compute minimal N
            u128 nmin = (u128)pow10[k-1] * (u128)mul;
            if (nmin > (u128)B) {
                // since nmin increases with k, we could break early when k grows beyond limit.
                // but because mul grows, nmin grows rapidly; safe to continue to next k? We can break.
                // break here is safe: for larger k, nmin grows, so no numbers will be <= B.
                break;
            }

            // Compute x_min = ceil(A / mul), x_max = floor(B / mul)
            unsigned long long x_min = (unsigned long long)((A + mul - 1ULL) / mul); // ceil
            unsigned long long x_max = (unsigned long long)(B / mul);

            // enforce k-digit constraint: x in [10^(k-1), 10^k - 1]
            unsigned long long lower_x = pow10[k-1];
            unsigned long long upper_x = pow10[k] - 1ULL;
            if (x_min < lower_x) x_min = lower_x;
            if (x_max > upper_x) x_max = upper_x;

            if (x_min > x_max) continue;

            // Sum of x from x_min to x_max: count * (x_min + x_max) / 2
            unsigned long long count = x_max - x_min + 1ULL;

            // Use u128 for safe multiplication:
            u128 sum_x = (u128)count * (u128)(x_min + x_max) / 2u;

            // Contribution to total is mul * sum_x
            u128 contrib = (u128)mul * sum_x;

            total_sum += contrib;
        }

        token = strtok_r(NULL, ",\n\r", &saveptr);
    }

    free(buf);

    // Print final total_sum
    print_u128(total_sum);
    putchar('\n');

    return 0;
}

