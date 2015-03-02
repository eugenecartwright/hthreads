#include <hthread.h>
#include <ident.h>
#include <utils.h>
#include <stdio.h>

Hint fat16_readidentity( sysace_t *ace, sysace_cfinfo_t *data )
{
    Hint            res;

    // Attempt to lock the sysace controller
    res = sysace_lock( ace );
    if( res != SUCCESS ) { printf( "Error Locking Controller: %d\n", res ); return res; }

    // Wait for the device to be ready
    res = sysace_cf_ready( ace );
    if( res != SUCCESS ) { printf( "Error Waiting for Device: %d\n", res ); return res; }

    // Attempt to identify the sysace device
    res = sysace_cf_identify( ace, data );
    if( res != SUCCESS ) { printf( "Error Identifing Device: %d\n", res ); return res; }

    // Attempt to unlock the sysace controller
    res = sysace_unlock( ace );
    if( res != SUCCESS ) { printf( "Error Unlocking Controller: %d\n", res ); }

    // Return successfully
    return SUCCESS;
}

Hint fat16_showidentity( block_t *block )
{
    Hint            res;
    sysace_cfinfo_t info;

    // Attempt to read the compact flash identity
    res = fat16_readidentity( &((sysace_block_t*)block->data)->ace, &info );
    if( res < 0 )   return res;

    // Print out the device identification
    printf( "SysACE Compact Flash Device Information\n" );
    printf( "---------------------------------------------------------------------\n" );
    printf( "Signature:         0x%4.4x\n", info.sig );
    printf( "Default Cylinders: %d\n", info.default_cylinders );
    printf( "Default Heads:     %d\n", info.default_heads );
    printf( "Bytes per Track:   %d\n", info.bytes_per_track );
    printf( "Bytes per Sector:  %d\n", info.bytes_per_sector );
    printf( "Default Sec/Track: %d\n", info.default_sectors_per_track );
    printf( "Default Sec/Card:  %d\n", info.default_sectors_per_card );
    printf( "Vendor:            0x%4.4x\n", info.vendor );
    printf( "Buffer Type:       0x%4.4x\n", info.buffer_type );
    //printf( "Buffer Size:       %d\n", info.buffer_size );
    printf( "ECC Bytes:         %d\n", info.ecc_bytes );
    printf( "Max Sectors:       %d\n", info.max_sectors );
    printf( "DWord:             0x%4.4x\n", info.dword );
    printf( "Capabilities:      0x%4.4x\n", info.capabilities );
    printf( "PIO Mode:          0x%4.4x\n", info.pio_mode );
    printf( "DMA Mode:          0x%4.4x\n", info.dma_mode );
    printf( "Translation:       0x%4.4x\n", info.translation );
    printf( "Cylinders:         %d\n", info.cylinders );
    printf( "Heads:             %d\n", info.heads );
    printf( "Sectors per Track: %d\n", info.sectors_per_track );
    printf( "Sectors per Card:: %d\n", info.sectors_per_card );
    printf( "Multiple Sectors:  0x%4.4x\n", info.multiple_sectors );
    printf( "LBA Sectors:       %d\n", info.lba_sectors );
    printf( "Security:          0x%4.4x\n", info.security );
    printf( "Power:             0x%4.4x\n", info.power );
    printf( "Serial:            %s\n", info.serial );
    printf( "Version:           %s\n", info.version );
    printf( "Model:             %s\n", info.model );
    printf( "Vendor Name:       %s\n", info.vendor_bytes );
    printf( "\n\n" );

    // Return successfully
    return SUCCESS;
}
