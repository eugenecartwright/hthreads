#ifndef _HTHREADS_TEST_FS_FAT16_IDENT_H_
#define _HTHREADS_TEST_FS_FAT16_IDENT_H_

#include <sysace/cf.h>
#include <sysace/block.h>

extern Hint fat16_readidentity( sysace_t*, sysace_cfinfo_t* );
extern Hint fat16_showidentity( block_t* );

#endif
