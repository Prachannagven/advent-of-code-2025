#ifndef SOL_H
#define SOL_H

#include <stdint.h>

#define MAX_BUTTONS 25
#define MAX_INT 99999
#define MAX_LINE 512

typedef struct{
	int num_lights;
	int num_buttons;
	uint64_t target;
	uint64_t button_mask[MAX_BUTTONS];
} Machine;


#endif
