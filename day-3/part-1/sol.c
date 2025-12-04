#include <ctype.h>
#include <stdio.h>
#include <string.h>

#define LINE_BUF 256

int main(int argc, char **argv){
	if(argc < 2){
		fprintf(stderr, "Usage: %s program <inputfile>", argv[0]);
		return 1;
	}

	FILE *fp = fopen(argv[1], "r");
	if(!fp){
		perror("Error opening file");
		return 1;
	}

	long total_power = 0;
	char line_buf[LINE_BUF];

	while(fgets(line_buf, sizeof(line_buf), fp)){
		int count = 0;
		int max_1 = 0;
		int max_loc_1 = 0;
		int max_2 = 0;
		int max_loc_2 = 0;

		//Looking for the first appearance of the largest value
		for(int i = 0; i < strlen(line_buf)-2; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			char test_char = line_buf[i];
			int test_val = test_char - '0';
			if(test_val > max_1){
				max_1 = test_val;
				max_loc_1 = i;
			}
		}

		//Looking for the largest value after the first largest (positionally)
		for(int i = max_loc_1 + 1; i< strlen(line_buf); i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			char test_char = line_buf[i];
			int test_val = test_char - '0';
			if(test_val > max_2){
				max_2 = test_val;
				max_loc_2 = i;
			}
		}

		int power = 10*max_1 + max_2;
		printf("Line %d power = %d\n", count, power);
		count++;
		total_power += power;
	}

	fclose(fp);
	printf("The total power is: %ld\n", total_power);
}
