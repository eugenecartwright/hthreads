#ifndef _HTHREADS_TEST_FS_FAT16_UTILS_H_
#define _HTHREADS_TEST_FS_FAT16_UTILS_H_

#include <fs/fat16/fat16.h>
#include <fs/fat16/boots.h>
#include <fs/fat16/part.h>
#include <fs/fat16/mbr.h>

// FAT16 MBR utility functions
extern const char* fat16_state( fat16_prt_t* );
extern const char* fat16_type( fat16_prt_t* );
extern const char* fat16_sectors( fat16_prt_t* );
extern const char* fat16_size( fat16_prt_t* );
extern const char* fat16_offset( fat16_prt_t* );

// FAT16 Boot Sector utility functions
extern const char *fat16_boots_name( fat16_bts_t* );
extern const char *fat16_boots_label( fat16_bts_t* );
extern const char *fat16_boots_type( fat16_bts_t* );

#endif
