#include <stdint.h>
#include "sol.h"
#include "fileparse.h"

uint64_t parseLights(const char *s, int *num_lights){
	uint64_t target = 0;
	int idx = 0;

	for(int i = 1; s[i] != ']'; i++){
		if(s[i] == '#'){
			target |= (1ULL << (i-1));
		}
		idx ++;
	}
	*num_lights = idx;

	return target;
}

uint64_t parseButton(const char *s){
	uint64_t mask = 0;
	int i = 1;

	while(s[i] != ')'){
		int val = 0;
		while(s[i] >='0' && s[i] <= '9'){
			val = val*10 + (s[i]-'0');
			i++;
		}

		mask |= (1ULL << val);

		if(s[i] == ','){
			i++;
		}
	}

	return mask;
}

int parseMachineLine(const char *line, Machine *m){
	const char *p = line;

	m->target = parseLights(p, &m->num_lights);

	while(*p && *p != ']') p++;
	p++;

	m->num_buttons = 0;
	while(*p && *p!= '{'){
		if(*p == '('){
			m->button_mask[m->num_buttons++] |= parseButton(p);
		}
		p++;
	}

	return 1;

}
