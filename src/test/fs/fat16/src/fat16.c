#include <hthread.h>
#include <sysace/block.h>
#include <utils.h>

extern Hint fat16_showidentity( block_t* );
extern Hint fat16_showmbr( block_t* );

Hint fat16_runpart( block_t *block )
{
    Hint i;
    Hint res;
    fat16_bts_t boot;
    
    res = fat16_boots_read( block, &boot, 0 );
    if( res != SUCCESS ) {printf( "Error Reading Boot Sector: %d\n",res);return res;}

    for( i = 0; i < 4; i++ )
    {
    // Attempt to read the boot sector
    res = fat16_boots_read( block, &boot, 62 );
    if( res != SUCCESS ) {printf( "Error Reading Boot Sector: %d\n",res);return res;}

    // Show the partition information
    printf( "Partition Boot Sector\n" );
    printf( "---------------------------------------------------------------------\n" );
    printf( "Name:          %s\n", fat16_boots_name(&boot) );
    printf( "Label:         %s\n", fat16_boots_label(&boot) );
    printf( "Type:          %s\n", fat16_boots_type(&boot) );
    printf( "Bytes/Sec:     %d\n", boot.bytes_per_sector );
    printf( "Sec/Cluster:   %d\n", boot.sectors_per_cluster );
    printf( "Reserved:      %d\n", boot.reserved_sectors );
    printf( "FATs:          %d\n", boot.fats );
    printf( "Max Root:      %d\n", boot.max_root );
    printf( "SSectors:      %d\n", boot.ssectors );
    printf( "Media:         %d\n", boot.media );
    printf( "Sec/FAT:       %d\n", boot.sectors_per_fat );
    printf( "Sec/Track:     %d\n", boot.sectors_per_track );
    printf( "Heads:         %d\n", boot.heads );
    printf( "Hidden:        %d\n", boot.hidden );
    printf( "Sectors:       %d\n", boot.sectors );
    printf( "Drive:         %d\n", boot.drive );
    printf( "Signature:     0x%2.2X\n", boot.signature );
    printf( "Serial:        0x%8.8X\n", boot.serial );
    printf( "Marker:        0x%4.4X\n", boot.marker );
    printf( "\n\n" );
    }

    // Return successfully
    return SUCCESS;
}
void fat16_test( block_t *block )
{
    //fat16_runpart( block );
    fat16_showidentity( block );
    fat16_showmbr( block );
}

int main( int argc, const char *argv[] )
{
    sysace_config_t    config;
    block_t            block;

    config.base         = 0x41800000;
    sysace_block_create( &block, &config, 32, 64 );

    fat16_test( &block );
    sysace_block_destroy( &block );

    return 0;
}
