#ifndef _ACCELERATOR_H_
#define _ACCELERATOR_H_

#include <hthread.h>
#include <accelerator_brams.h>
#include <config.h>
#include <dma/dma.h>
#include <httype.h>

#define ACC_BIT_FILE_LENGTH         (45071)
#define NUM_OF_ACCELERATORS         (3)
#define NUM_SIZES                   (7)
#define ACCELERATOR_DMA_BASEADDR    (0x85050000)
#define PR_OVERHEAD                 (500)
#define BRAM_SIZE                   (4096)
#define MAGIC_NUMBER                (0xDEADBEEF)
// -------------------------------------------------------------- //
//                   Accelerator Enumeration                      //
// -------------------------------------------------------------- //
#define CRC     0
#define SORT    1
#define VECTOR  2

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

typedef struct {
  unsigned char * crc;  
  unsigned char * sort;  
  unsigned char * vector;
} accelerator_list_t; 

typedef struct {
    unsigned char chunks;
    unsigned int hw_time;
    unsigned int sw_time;
    unsigned char optimal_thread_num;
} tuning_table_t;

// -------------------------------------------------------------- //
//                     DMA Transfer Wrapper                       //
// -------------------------------------------------------------- //
extern int transfer_dma(dma_t * dma, void * src, void * des, int size);

// -------------------------------------------------------------- //
//                    Reset and Clear FIFOS                       //
// -------------------------------------------------------------- //
extern void reset_accelerator(unsigned char fifo_depth);

// -------------------------------------------------------------- //
//             Get's index size for given data size               //
// -------------------------------------------------------------- //
extern Huint get_index(Huint size);

// -------------------------------------------------------------- //
//             Determine if we use HW, PR if necessary            //
// -------------------------------------------------------------- //
extern Hbool useHW(Huint accelerator_type, Huint size);
#endif
