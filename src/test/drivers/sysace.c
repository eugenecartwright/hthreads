#include <hthread.h>
#include <config.h>
#include <sysace/sysace.h>
#include <sysace/block.h>
#include <sysace/cf.h>
#include <sysace/cfg.h>
#include <fs/fat16/fat16.h>
#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include <time.h>

#define READ_BLOCKS     16384
#define READ_RANDOM     786432;

char* sysace_serialstr( Hubyte *data )
{
    static char buffer[21];
    snprintf( buffer, 21, "%-20s", data );
    return buffer;
}

char* sysace_versionstr( Hubyte *data )
{
    static char buffer[9];
    snprintf( buffer, 9, "%-8s", data );
    return buffer;
}

char* sysace_modelstr( Hubyte *data )
{
    static char buffer[41];
    snprintf( buffer, 41, "%-40s", data );
    return buffer;
}

char* sysace_vendorstr( Hubyte *data )
{
    static char buffer[63];
    snprintf( buffer, 63, "%-62s", data );
    return buffer;
}

Hint sysace_showidentity( block_t *block )
{
    Hint            res;
    sysace_cfinfo_t info;
    sysace_block_t  *ace;

    // Clear the information structure out
    ace = (sysace_block_t*)block->data;
    memset( &info, 0, sizeof(sysace_cfinfo_t) );

    // Attempt to lock the sysace controller
    res = sysace_lock( &ace->ace );
    if( res != SUCCESS ) { printf( "Error Locking Controller: %d\n", res ); return res; }

    // Wait for the device to be ready
    res = sysace_cf_ready( &ace->ace );
    if( res != SUCCESS ) { printf( "Error Waiting for Device: %d\n", res ); return res; }

    // Attempt to identify the sysace device
    res = sysace_cf_identify( &ace->ace, &info );
    if( res != SUCCESS ) { printf( "Error Identifing Device: %d\n", res ); return res; }

    // Attempt to unlock the sysace controller
    res = sysace_unlock( &ace->ace );
    if( res != SUCCESS ) { printf( "Error Unlocking Controller: %d\n", res ); }

    // Print out the device identification
    printf( "SysACE Compact Flash Device Information\n" );
    printf( "---------------------------------------------------------------------\n" );
    printf( "Signature:         0x%4.4x\n", info.sig );
    printf( "Default Cylinders: %d\n", info.default_cylinders );
    printf( "Reserved:          0x%4.4x\n", info.reserved1 );
    printf( "Default Heads:     %d\n", info.default_heads );
    printf( "Bytes per Track:   %d\n", info.bytes_per_track );
    printf( "Bytes per Sector:  %d\n", info.bytes_per_sector );
    printf( "Default Sec/Track: %d\n", info.default_sectors_per_track );
    printf( "Default Sec/Card:  %d\n", info.default_sectors_per_card );
    printf( "Vendor:            0x%4.4x\n", info.vendor );
    printf( "Serial:            %s\n", sysace_serialstr(info.serial+4) );
    printf( "Buffer Type:       %d\n", info.buffer_type );
    //printf( "Buffer Size:       %d\n", info.buffer_size );
    printf( "ECC Bytes:         %d\n", info.ecc_bytes );
    printf( "Version:           %s\n", sysace_versionstr(info.version) );
    printf( "Model:             %s\n", sysace_modelstr(info.model) );
    printf( "Max Sectors:       %d\n", info.max_sectors );
    printf( "DWord:             0x%4.4x\n", info.dword );
    printf( "Capabilities:      0x%4.4x\n", info.capabilities );
    printf( "Reserved:          0x%4.4x\n", info.reserved2 );
    printf( "PIO Mode:          %d\n", info.pio_mode );
    printf( "DMA Mode:          %d\n", info.dma_mode );
    printf( "Translation:       %d\n", info.translation );
    printf( "Cylinders:         %d\n", info.cylinders );
    printf( "Heads:             %d\n", info.heads );
    printf( "Sectors per Track: %d\n", info.sectors_per_track );
    printf( "Sectors per Card:  %d\n", info.sectors_per_card );
    printf( "Multiple Sectors:  %d\n", info.multiple_sectors );
    printf( "LBA Sectors:       %d\n", info.lba_sectors );
    printf( "Security:          0x%4.4x\n", info.security );
    printf( "Vendor Name:       %s\n", sysace_vendorstr(info.vendor_bytes) );
    printf( "Power:             0x%4.4x\n", info.power );
    printf( "\n\n" );

    // Return successfully
    return SUCCESS;
}

Hint sysace_testseq( block_t *block )
{
    Hint    i;
    Hint    res;
    Huint   hit;
    Huint   total;
    Huint   lines;
    Huint   depth;
    Huint   blocks;
    clock_t start;
    clock_t end;
    clock_t diff;
    double  secs;
    double  rate;
    Hubyte  data[ 512 ];

    blocks = 0;

    // Flush the cache before the test
    sysace_block_cacheflush( (sysace_block_t*)block->data );

    // Start the test
    start = clock();
    for( i = 0; i < READ_BLOCKS; i++,blocks++ )
    {
        // Read the next block from the device
        res = block->read( block, i, 1, data );
        if( res < 0 )   { printf( "Block Read Error: %d\n", res ); return res; }
    }
    end = clock();
    
    // Calculate time information
    diff = end - start;
    secs = (double)diff / CLOCKS_PER_SEC;
    
    // Calculate the hit rate
    hit   = ((sysace_block_t*)block->data)->hit;
    total = hit + ((sysace_block_t*)block->data)->miss;
    rate = (100.0 * hit) / total;

    // Determine the cache geometry
    lines   = ((sysace_block_t*)block->data)->lines;
    depth   = ((sysace_block_t*)block->data)->depth;

    // Show information
    printf( "SysACE Compact Flash Read Test (Sequential)\n" );
    printf( "---------------------------------------------------------------------\n" );
    printf( "Data Read:         %2.2f KB\n", blocks*512/1024.0 );
    printf( "Elapsed Time:      %2.2f S\n", secs );
    printf( "Transfer Rate:     %2.2f KB/S\n", (blocks*512)/secs/1024.0 );
    printf( "Cache Geometry:    %u x %u\n", lines, depth );
    printf( "Cache Hit Rate:    %2.2f%% (%d of %d)\n", rate, hit, total );
    printf( "\n\n" );
    
    // Return successfully
    return SUCCESS;
}

Hint sysace_testran( block_t *block )
{
    Hint    i;
    Hint    res;
    Huint   hit;
    Huint   total;
    Huint   blk;
    Huint   blocks;
    Huint   lines;
    Huint   depth;
    clock_t start;
    clock_t end;
    clock_t diff;
    double  secs;
    double  rate;
    Hubyte  data[ 512 ];

    blocks = 0;

    // Flush the cache before the test
    sysace_block_cacheflush( (sysace_block_t*)block->data );

    // Start the test
    start = clock();
    for( i = 0; i < READ_BLOCKS; i++,blocks++ )
    {
        // Determine the block to read
        blk = rand() % READ_RANDOM;

        // Read the next block from the device
        res = block->read( block, blk, 1, data );
        if( res < 0 )   { printf( "Block Read Error: %d\n", res ); return res; }
    }
    end = clock();
    
    // Calculate time information
    diff = end - start;
    secs = (double)diff / CLOCKS_PER_SEC;
    
    // Calculate the hit rate
    hit   = ((sysace_block_t*)block->data)->hit;
    total = hit + ((sysace_block_t*)block->data)->miss;
    rate = (100.0 * hit) / total;

    // Determine the cache geometry
    lines   = ((sysace_block_t*)block->data)->lines;
    depth   = ((sysace_block_t*)block->data)->depth;

    // Show information
    printf( "SysACE Compact Flash Read Test (Random Access)\n" );
    printf( "---------------------------------------------------------------------\n" );
    printf( "Data Read:         %2.2f KB\n", blocks*512/1024.0 );
    printf( "Elapsed Time:      %2.2f S\n", secs );
    printf( "Transfer Rate:     %2.2f KB/S\n", (blocks*512)/secs/1024.0 );
    printf( "Cache Geometry:    %u x %u\n", lines, depth );
    printf( "Cache Hit Rate:    %2.2f%% (%d of %d)\n", rate, hit, total );
    printf( "\n\n" );
    
    // Return successfully
    return SUCCESS;
}

void sysace_test( block_t *block )
{
    Hint i;
    Hint j;

    sysace_showidentity( block );
    //for( i = 1; i <= 256; i *= 2 )
    for( i = 16; i <= 64; i *= 2 )
    {
        //for( j = 1; j <= 1024; j *= 2 )
        for( j = 16; j <= 256; j *= 2 )
        {
            sysace_block_cachesize( (sysace_block_t*)block->data, i, j );
            sysace_testseq( block );
            sysace_testran( block );
        }
    }
}

int main( int argc, const char *argv[] )
{
    sysace_config_t    config;
    block_t            block;
    sysace_block_t     *ace;

    config.base         = SYSACE_BASEADDR;
    sysace_block_create( &block, &config, 1, 1 );

    ace = (sysace_block_t*)block.data;
    printf( "SysACE Controller Information\n" );
    printf( "---------------------------------------------------------------------\n" );
    printf( "Mode Register 1:               0x%8.8x\n", (Huint)ace->ace.mode[0] );
    printf( "Mode Register 2:               0x%8.8x\n", (Huint)ace->ace.mode[1] );
    printf( "Control Register 1:            0x%8.8x\n", (Huint)ace->ace.control[0] );
    printf( "Control Register 2:            0x%8.8x\n", (Huint)ace->ace.control[1] );
    printf( "Error Register 1:              0x%8.8x\n", (Huint)ace->ace.error[0] );
    printf( "Error Register 2:              0x%8.8x\n", (Huint)ace->ace.error[1] );
    printf( "Status Register 1:             0x%8.8x\n", (Huint)ace->ace.status[0] );
    printf( "Status Register 2:             0x%8.8x\n", (Huint)ace->ace.status[1] );
    printf( "Version Register:              0x%8.8x\n", (Huint)ace->ace.version[0] );
    printf( "Sector Register:               0x%8.8x\n", (Huint)ace->ace.count[0] );
    printf( "Fat Register:                  0x%8.8x\n", (Huint)ace->ace.fat[0] );
    printf( "Data Register:                 0x%8.8x\n", (Huint)ace->ace.data[0] );
    printf( "Controller LBA Register 1:     0x%8.8x\n", (Huint)ace->ace.clba[0] );
    printf( "Controller LBA Register 2:     0x%8.8x\n", (Huint)ace->ace.clba[1] );
    printf( "Processor LBA Register 1:      0x%8.8x\n", (Huint)ace->ace.mlba[0] );
    printf( "Processor LBA Register 2:      0x%8.8x\n", (Huint)ace->ace.mlba[1] );
    printf( "\n\n" );
    
    sysace_test( &block );
    sysace_block_destroy( &block );

    printf( "-- QED --\n" );
    return 0;
}
