#include <hthread.h>
#include <mbr.h>
#include <part.h>
#include <utils.h>
#include <stdio.h>

Hint fat16_showmbr( block_t *block )
{
    Hint        res;
    fat16_mbr_t mbr;

    // Attempt to read the MBR
    res = fat16_mbr_read( block, &mbr, 0 );
    if( res != SUCCESS ) { printf( "Error Reading MBR: %d\n", res ); }

    // Show the master boot record information
    printf( "SysACE Compact Flash Master Boot Record\n" );
    printf( "---------------------------------------------------------------------\n" );
    for( res = 0; res < 4; res++ )  printf( "Partition %d: %s\n", res, fat16_state(&mbr.partitions[res]) );
    printf( "\n\n" );

    for( res = 0; res < 4; res++ )  fat16_showpart( block, &mbr.partitions[res], res );

    // Return successfully
    return SUCCESS;
}
