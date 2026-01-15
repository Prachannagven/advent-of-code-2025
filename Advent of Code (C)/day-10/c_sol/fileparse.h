#ifndef FILEPARSE_H
#define FILEPARSE_H

#include <stdint.h>
#include "sol.h"

uint64_t parseLights(const char *s, int *num_lights);
uint64_t parseButton(const char *s);
int parseMachineLine(const char *line, Machine *m);

#endif
