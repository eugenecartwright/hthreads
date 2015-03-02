#ifndef _ACCELERATOR_H_
#define _ACCELERATOR_H_

// List all accelerators so
// user can just include them
#include <sort.h>
#include <crc.h>
#include <vector.h>

#define ACC_BIT_FILE_LENGTH         (45071)

#define NUM_OF_ACCELERATORS         (3)
#define NUM_OF_SIZES                (7)
#define PR_OVERHEAD                 (500)
#define BRAM_SIZE                   (4096)

// -------------------------------------------------------------- //
//                   Accelerator Enumeration                      //
// -------------------------------------------------------------- //
#define CRC     0
#define SORT    1
#define VECTOR  2

// -------------------------------------------------------------- //
//             Get's index size for given data size               //
// -------------------------------------------------------------- //
extern Huint get_index(Huint size);

#endif
