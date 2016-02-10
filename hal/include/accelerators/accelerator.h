#ifndef _ACCELERATOR_H_
#define _ACCELERATOR_H_

#include <hthread.h>
#include <config.h>
#include <httype.h>
#include "xaxicdma.h"
#ifdef PR
#include <pr.h>
#endif

#define NUM_ACCELERATORS            (5)
#define PR_OVERHEAD                 (1000.0f)
#define HW_SW_THRESHOLD             (75.0f)
#define BRAM_SIZE                   (4096)
#define BRAM_GRANULARITY_SIZE       (64)
#define PR_FLAG                     (0x1)

#define MAGIC_NUMBER                (0xDEADBEEF)
// -------------------------------------------------------------- //
//                   Accelerator Enumeration                      //
// -------------------------------------------------------------- //
#define NO_ACC             -1
#define CRC                0
#define BUBBLESORT         1
#define VECTORADD          2
#define VECTORSUB          2
#define VECTORMUL          3
#define VECTORDIV          3
#define MATRIXMUL          4

// -------------------------------------------------------------- //
//                   Accelerator Header Files                     //
// -------------------------------------------------------------- //
#include <sort.h>
#include <crc.h>
#include <vector.h>
#include <matrix.h>

typedef struct {
   float hw_time;
   float sw_time;
} volatile tuning_table_t;

// -------------------------------------------------------------- //
//                     DMA Transfer Wrapper                       //
// -------------------------------------------------------------- //
extern int transfer_dma(void * src, void * des, Hint size);

// -------------------------------------------------------------- //
//             Determine if we use HW, PR if necessary            //
// -------------------------------------------------------------- //
extern Hbool useHW(Huint accelerator_type, Huint size);

// -------------------------------------------------------------- //
//                 Polymorphic init function                      //
// -------------------------------------------------------------- //
extern Hbool poly_init(Hint acc, Huint size);
#endif
