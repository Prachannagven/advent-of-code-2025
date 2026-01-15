#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define LINE_BUF 256
#define MAX_RANGES 10000

typedef struct {
    long low;
    long high;
} Range;

int parse_ranges(FILE *fp, Range *ranges) {
    char line[256];
    int count = 0;

    while (fgets(line, sizeof(line), fp)) {
        line[strcspn(line, "\n")] = '\0';
        if (strlen(line) == 0)
            break;

        long low, high;
        if (sscanf(line, "%ld-%ld", &low, &high) == 2) {
            ranges[count].low = low;
            ranges[count].high = high;
            count++;
        }
    }

    return count;
}

int is_fresh(Range *ranges, long id, int range_count) {
    for (int i = 0; i < range_count; i++) {
        if (ranges[i].low <= id && id <= ranges[i].high)
            return 1;
    }
    return 0;
}

int compare_ranges(const void *a, const void *b) {
    const Range *ra = a;
    const Range *rb = b;
    if (ra->low < rb->low) return -1;
    if (ra->low > rb->low) return 1;
    return 0;
}

int merge_ranges(Range *ranges, int count) {
    if (count == 0) return 0;

    qsort(ranges, count, sizeof(Range), compare_ranges);

    int out = 0;
    for (int i = 1; i < count; i++) {
        if (ranges[i].low <= ranges[out].high + 1) {
            if (ranges[i].high > ranges[out].high)
                ranges[out].high = ranges[i].high;
        } else {
            out++;
            ranges[out] = ranges[i];
        }
    }

    return out + 1;
}

long total_fresh_range(Range *ranges, int count) {
    long total = 0;
    for (int i = 0; i < count; i++)
        total += (ranges[i].high - ranges[i].low + 1);
    return total;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <inputfile>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (!fp) {
        perror("Error opening file");
        return 1;
    }

    Range ranges[MAX_RANGES];
    int range_count = parse_ranges(fp, ranges);

    int fresh_count = 0;
    char line_buf[LINE_BUF];

    while (fgets(line_buf, sizeof(line_buf), fp)) {
        long id;
        if (sscanf(line_buf, "%ld", &id) == 1) {
            if (is_fresh(ranges, id, range_count))
                fresh_count++;
        }
    }

    int merged_count = merge_ranges(ranges, range_count);
    long fresh_total = total_fresh_range(ranges, merged_count);

    printf("Fresh ingredient IDs found: %d\n", fresh_count);
    printf("Total number of IDs covered by fresh ranges: %ld\n", fresh_total);

    fclose(fp);
    return 0;
}

