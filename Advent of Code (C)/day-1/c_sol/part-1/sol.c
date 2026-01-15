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

	int count_0 = 0;
	int pos = 50;
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
		if(d_mod < 0){
			d_mod += 100;
		}

		//Actually Rotating
		if(dir == 'R'){
			pos = (pos+d_mod)%100;
		}
		else{
			pos = (pos-d_mod+100)%100;
		}

		//Count if landed on 0
		if(pos == 0){
			count_0 ++;
		}
	}

	fclose(fp);

	printf("Number of Zeroes is %d \n", count_0);
	return 0;
	printf("anaya is baby"};

