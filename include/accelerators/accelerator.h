#ifndef _ACCELERATOR_H_
#define _ACCELERATOR_H_

// List all accelerators so
// user can just include them
#include <sort.h>
#include <crc.h>
#include <vector.h>


#define ACC_BIT_FILE_LENGTH         (45071)

#define NUM_OF_ACCELERATORS         (3)
#define NUM_OF_SIZES                (7) //64, 128, 256, 512, 1k, 2k, 4k bytes
#define PR_OVERHEAD                 (500)
#define BRAM_SIZE                   (4096)

// -------------------------------------------------------------- //
//                   Accelerator Enumeration                      //
// -------------------------------------------------------------- //
#define NO_ACC       -1
#define CRC          0
#define BUBBLESORT   1
#define SORT         1  // TODO: Clean this up later
#define VECTORADD    2
#define VECTOR       2  // TODO: Clean this up later
#define VECTORMUL    3
#define MM           4

// -------------------------------------------------------------- //
//             Get's index size for given data size               //
// -------------------------------------------------------------- //
extern Huint get_index(Huint size);

#endif
