#ifndef _HTHREADS_TEST_FS_FAT16_PART_H_
#define _HTHREADS_TEST_FS_FAT16_PART_H_

#include <block/block.h>
#include <fs/fat16/fat16.h>

extern Hint fat16_showpart( block_t*, fat16_prt_t*, int );

#endif
