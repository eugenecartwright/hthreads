#ifndef _HTHREADS_TEST_FS_FAT16_FAT_H_
#define _HTHREADS_TEST_FS_FAT16_FAT_H_

#include <fs/fat16/fat16.h>
#include <fs/fat16/dirs.h>

extern Hint fat16_showfat( fat16_t *fat );
extern Hint fat16_showroot( fat16_t *fat );
extern Hint fat16_allroot( fat16_t *fat );

#endif
