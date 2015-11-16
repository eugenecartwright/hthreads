#ifndef _ACCELERATOR_H_
#define _ACCELERATOR_H_

#include <hthread.h>
#include <config.h>
#include <httype.h>
#include "xaxicdma.h"

#define NUM_ACCELERATORS            (5)
#define NUM_OF_SIZES                (7)
#define PR_OVERHEAD                 (1300)
#define BRAM_SIZE                   (4096)
#define PR_FLAG                     (0x1)



// -------------------------------------------------------------- //
//                   Accelerator Enumeration                      //
// -------------------------------------------------------------- //
#define NO_ACC             -1
#define CRC                0
#define BUBBLESORT         1
#define VECTORADD          2
#define VECTORMUL          3
#define MATRIXMUL          4

// -------------------------------------------------------------- //
//             Get's index size for given data size               //
// -------------------------------------------------------------- //
extern Huint get_index(Huint size);

// -------------------------------------------------------------- //
//                   Accelerator Header Files                     //
// -------------------------------------------------------------- //
#include <sort.h>
#include <crc.h>
#include <vector.h>
#include <matrix.h>

#endif
