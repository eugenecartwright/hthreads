#ifndef IMPORT_BUFFER
#define IMPORT_BUFFER

#include "common/types.h"
#include "interpreter/isa.h"

// This is the struct used by software threads to import their state.

typedef struct
{
    word register_file[NUMBER_REGISTERS];
} ImportBuffer;


#endif

