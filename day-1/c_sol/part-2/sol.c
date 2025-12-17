#include <stdio.h>
#include <stdlib.h>

#define LINE_BUF 256

//Function to parse the rotation command and return the direction and distance of each line
static int parse_rot(const char *line, char *out_dir, long *out_dist){
	
	//Make sure line starts with R or L, return error -1 otherwise
	if(*line != 'R' && *line != 'L'){
		return 0;
	}

	//First char of the line is the direction, so we can return that directly
	*out_dir = *line;
	line++;

	char *endptr;
	long val = strtol(line, &endptr, 10);

	if(line == endptr){
		//No digits were found
		return 0;
	}
t 
	*out_dist = val;
	return 1;
}

int main(int argc, char **argv){
	
	//Error handling for input arguments
	if(argc < 2){
		fprintf(stderr, "Usage: %s program <inputfile>", argv[0]);
		return 1;
	}

	//Opening the file
	FILE *fp = fopen(argv[1], "r");
	if(!fp){
		perror("Error opening file");
		return 1;
	}

	long zero_count = 0;
	int zero_cross = 0;
	int pos_init= 50;
	int pos_next = 0;
	char line_buf[LINE_BUF];

	while(fgets(line_buf, sizeof(line_buf), fp)){
		char dir;
		long dist;

		//Get the direction and distance while simultaneously checking for erros
		if(!parse_rot(line_buf, &dir, &dist)){
			fprintf(stderr, "Invalid input line %s\n", line_buf);
			fclose(fp);
			return 1;
		}

		//In case JS was a retard and put distances greater than 100
		long d_mod = dist % 100;
		zero_cross += (dist / 100);

		if(d_mod < 0){
			d_mod += 100;
		}

		//Actually Rotating
		if(dir == 'R'){
			pos_next = pos_init + d_mod;
			if(pos_next > 100 && pos_init != 0){
				zero_cross ++;
			}
			pos_init = pos_next % 100;
		}
		else{
			pos_next = pos_init - d_mod;
			if(pos_next < 0 && pos_init != 0){
				zero_cross ++;
			}
			pos_init = (pos_next + 100) % 100;
		}

		//Count if landed on 0
		if(pos_init == 0){
			zero_count ++;
		}
	}

	fclose(fp);

	printf("Number of Zero Crosses is %d \n", zero_cross);
	printf("Final position is : %d \n", pos_init);
	printf("Number of Zeroes is %ld \n", zero_count);
	printf("Solution of Zero Cross in part 2 is %ld \n", zero_count+zero_cross);
	return 0;
}
