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
	int count = 0;
	while(fgets(line_buf, sizeof(line_buf), fp)){
		int max_1 = 0;
		int max_loc_1 = 0;
		int max_2 = 0;
		int max_loc_2 = 0;
		int max_3 = 0;
		int max_loc_3 = 0;
		int max_4 = 0;
		int max_loc_4 = 0;
		int max_5 = 0;
		int max_loc_5 = 0;
		int max_6 = 0;
		int max_loc_6 = 0;
		int max_7 = 0;
		int max_loc_7 = 0;
		int max_8 = 0;
		int max_loc_8 = 0;
		int max_9 = 0;
		int max_loc_9 = 0;
		int max_10 = 0;
		int max_loc_10 = 0;
		int max_11 = 0;
		int max_loc_11 = 0;
		int max_12 = 0;
		int max_loc_12 = 0;

		int len = (int)strlen(line_buf);

		//Looking for the first appearance of the largest value
		for(int i = 0; i < len-12; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_1){
				max_1 = test_val;
				max_loc_1 = i;
			}
		}

		//Looking for the largest value after the first largest (positionally)
		for(int i = max_loc_1 + 1; i< len - 11; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_2){
				max_2 = test_val;
				max_loc_2 = i;
			}
		}
		
		for(int i = max_loc_2 + 1; i< strlen(line_buf) - 10; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_3){
				max_3 = test_val;
				max_loc_3 = i;
			}
		}

		for(int i = max_loc_3 + 1; i< strlen(line_buf) - 9; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_4){
				max_4 = test_val;
				max_loc_4 = i;
			}
		}

		for(int i = max_loc_4 + 1; i< strlen(line_buf) - 8; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_5){
				max_5 = test_val;
				max_loc_5 = i;
			}
		}
		
		for(int i = max_loc_5 + 1; i< strlen(line_buf) - 7; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_6){
				max_6 = test_val;
				max_loc_6 = i;
			}
		}

		for(int i = max_loc_6 + 1; i< strlen(line_buf) - 6; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_7){
				max_7 = test_val;
				max_loc_7 = i;
			}
		}
		for(int i = max_loc_7 + 1; i< strlen(line_buf) - 5; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_8){
				max_8 = test_val;
				max_loc_8 = i;
			}
		}
		for(int i = max_loc_8 + 1; i< strlen(line_buf) - 4; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_9){
				max_9 = test_val;
				max_loc_9 = i;
			}
		}
		for(int i = max_loc_9 + 1; i< strlen(line_buf) - 3; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_10){
				max_10 = test_val;
				max_loc_10 = i;
			}
		}
		for(int i = max_loc_10 + 1; i< strlen(line_buf) - 2; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_11){
				max_11 = test_val;
				max_loc_11 = i;
			}
		}
		for(int i = max_loc_11 + 1; i< strlen(line_buf) - 1; i++){
			if(!isdigit((unsigned char)line_buf[i])) continue;
			int test_val = line_buf[i] - '0';
			if(test_val > max_12){
				max_12 = test_val;
				max_loc_12 = i;
			}
		}

		long power = 	max_1*100000000000L +
						max_2*10000000000L + 
						max_3*1000000000L +
						max_4*100000000L +
						max_5*10000000L +
						max_6*1000000L +
						max_7*100000L +
						max_8*10000L +
						max_9*1000L +
						max_10*100L +
						max_11*10L + 
						max_12*1L;
		printf("Line %d power = %ld\n", count, power);
		count++;
		total_power += power;
	}

	fclose(fp);
	printf("The total power is: %ld\n", total_power);
}
