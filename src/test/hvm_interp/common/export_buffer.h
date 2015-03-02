#ifndef EXPORT_BUFFER
#define EXPORT_BUFFER

#include "common/types.h"
#include "interpreter/isa.h"

// This is the struct used by software threads to export their state.

typedef struct
{
    word register_file[NUMBER_REGISTERS];
} ExportBuffer;


#endif

