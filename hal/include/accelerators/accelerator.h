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

#define MAGIC_NUMBER                (0xDEADBEEF)
// -------------------------------------------------------------- //
//                   Accelerator Enumeration                      //
// -------------------------------------------------------------- //
#define NO_ACC             -1
#define CRC                0
#define BUBBLESORT         1
#define VECTOR_ADD_SUB     2
#define VECTOR_MUL_DIVIDE  3
#define MATRIXMUL          4

// -------------------------------------------------------------- //
//                       Accelerator Flags                        //
// -------------------------------------------------------------- //
#define ACCELERATOR_FLAG    (0x80000000)
#define PR_FLAG             (0x40000000)

// -------------------------------------------------------------- //
//                   Accelerator Header Files                     //
// -------------------------------------------------------------- //
#include <sort.h>
#include <crc.h>
#include <vector.h>
#include <matrix.h>

typedef struct {
    unsigned char chunks;
    unsigned int hw_time;
    unsigned int sw_time;
    unsigned char optimal_thread_num;
} tuning_table_t;

// -------------------------------------------------------------- //
//                     DMA Transfer Wrapper                       //
// -------------------------------------------------------------- //
extern int transfer_dma(void * src, void * des, int size);

// -------------------------------------------------------------- //
//             Get's index size for given data size               //
// -------------------------------------------------------------- //
extern Huint get_index(Huint size);

// -------------------------------------------------------------- //
//             Determine if we use HW, PR if necessary            //
// -------------------------------------------------------------- //
extern Hbool useHW(Huint accelerator_type, Huint size);

// -------------------------------------------------------------- //
//                 Polymorphic init function                      //
// -------------------------------------------------------------- //
extern Hbool poly_init(Hint acc);
#endif
