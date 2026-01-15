#include <stdint.h>
#include <stdio.h>
#include "sol.h"
#include "fileparse.h"


int solveBruteforce(const Machine *m){
	int best = MAX_INT;
	int M = m->num_buttons;

	for(uint64_t mask = 0; mask < (1ULL << M); mask++){
		uint64_t lights = 0;

		for(int j = 0; j < M; j++){
			if(mask & (1ULL << j)){
				lights ^= m->button_mask[j];
			}
		}

		if(lights == m->target){
			int presses = __builtin_popcountll(mask);
			if(presses < best)
				best = presses;
		}

	}

	return best;
}

int main(int argc, char **argv){
	if(argc < 2){
		fprintf(stderr, "Incorrect usage. Correct usage is ./%s <TEST_FILE>\n", argv[0]);
		return 1;
	}

	FILE *fp = fopen(argv[1], "r");

	if(!fp){
		perror("Failed to open file");
		return 1;
	}

	char line[MAX_LINE];
	int total = 0;

	while(fgets(line, sizeof(line), fp)){
		Machine m = {0};
		parseMachineLine(line, &m);

		int presses = solveBruteforce(&m);
		if(presses != MAX_INT){
			total += presses;
		}
	}

	fclose(fp);
	printf("Total: %d\n", total);
	return 0;
}
