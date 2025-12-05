#include <stdio.h>
#include <string.h>

#define LINE_BUF 256
#define MAX_RANGES 10000

typedef struct {
	long low;
	long high;
} Range;

int parse_ranges (FILE *fp, Range *ranges){
	char line[256];
	int count = 0;

	while(fgets(line, sizeof(line), fp)){
		//Replace the newline character with \0
		line[strcspn(line, "\n")] = '\0';

		if(strlen(line) == 0){
			break;
		}

		long low, high;
		if(sscanf(line, "%ld-%ld", &low, &high) == 2){
			ranges[count].low = low;
			ranges[count].high = high;
			count ++;
			//printf("Parsed range: %d - %d\n", low, high);
		}
		else{
			fprintf(stderr, "Invalid range on line %d \n %s", count, line);
		}
	}

	return count;
}

int is_fresh(Range *ranges, long id, int range_count){
	for(int i = 0; i < range_count; i++){
		if(ranges[i].low <= id && ranges[i].high >= id){
			return 1;
		}
	}
	return 0;
}

int main (int argc, char **argv) {
	if (argc < 2){
		fprintf(stderr, "Usage: %s program <inputfile>", argv[0]);
		return 1;
	}

	FILE *fp = fopen(argv[1], "r");
	if(!fp){
		perror("Error opening file");
		return 1;
	}

	Range ranges[MAX_RANGES];
	int range_count = parse_ranges(fp, ranges);
	int fresh_count = 0;

	char line_buf[LINE_BUF];
	while(fgets(line_buf, sizeof(line_buf), fp)){
		long id;
		if(sscanf(line_buf, "%ld", &id) == 1){
			if(is_fresh(ranges, id, range_count)){
				fresh_count ++;
			}
		}
	}

	printf("The total number of fresh items is %d\n", fresh_count);
	return 0;
}
