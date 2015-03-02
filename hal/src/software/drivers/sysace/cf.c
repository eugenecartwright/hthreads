#include <sysace/cf.h>
#include <sysace/cfg.h>

Hint sysace_cf_reset( sysace_t *ace )
{
    // If the device is not locked return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_MLOCK) )  return EDEADLK;

    // If the device is not ready return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_CREADY) ) return EBUSY;

    // Send the reset command to the controller
    sysace_setsector(ace, SYSACE_SECTOR_RESET );

    // Return successfully
    return SUCCESS;
}

Hint sysace_cf_abort( sysace_t *ace )
{
    // If the device is not locked return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_MLOCK) )  return EDEADLK;

    // If the device is not ready return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_CREADY) ) return EBUSY;

    // Send the abort command to the controller
    sysace_setsector(ace, SYSACE_SECTOR_ABORT );

    // Return successfully
    return SUCCESS;
}

Hint sysace_cf_ready( sysace_t *ace )
{
    // Wait for the device to be ready
    while( sysace_cf_isready(ace) != SUCCESS );

    // Return successfully
    return SUCCESS;
}

Hint sysace_cf_isready( sysace_t *ace )
{
    // If the device is not ready return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_CREADY) )   return EBUSY;
    else                                                    return SUCCESS;
}

Hint sysace_cf_identify( sysace_t *ace, sysace_cfinfo_t *info )
{
    Huint num;

    // If the device is not locked return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_MLOCK) )  return EDEADLK;

    // If the device is not ready return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_CREADY) ) return EBUSY;

    // Send the identify command to the controller
    sysace_setsector(ace, SYSACE_SECTOR_IDENTIFY );

    // Read the sector information from the device
    num = sysace_readbuffer( ace, (Hubyte*)info, SYSACE_DATA_SECTOR );

    // Check if there was an error during data transfer
    if( num < SYSACE_DATA_SECTOR )                        return EIO;

    // Convert all of the data to big endian from little endian
    info->sig                       = little_to_bigs( info->sig );
    info->default_cylinders         = little_to_bigs( info->default_cylinders );
    info->reserved1                 = little_to_bigs( info->reserved1 );
    info->default_heads             = little_to_bigs( info->default_heads );
    info->bytes_per_track           = little_to_bigs( info->bytes_per_track );
    info->bytes_per_sector          = little_to_bigs( info->bytes_per_sector );
    info->default_sectors_per_track = little_to_bigs( info->default_sectors_per_track );
    info->default_sectors_per_card  = little_to_bigs( info->default_sectors_per_card );
    info->vendor                    = little_to_bigs( info->vendor );
    info->buffer_type               = little_to_bigs( info->buffer_type );
    //info->buffer_size               = little_to_bigs( info->buffer_size );
    info->ecc_bytes                 = little_to_bigs( info->ecc_bytes );
    info->max_sectors               = little_to_bigs( info->max_sectors );
    info->dword                     = little_to_bigs( info->dword );
    info->capabilities              = little_to_bigs( info->capabilities );
    info->reserved2                 = little_to_bigs( info->reserved2 );
    info->pio_mode                  = little_to_bigs( info->pio_mode );
    info->dma_mode                  = little_to_bigs( info->dma_mode );
    info->translation               = little_to_bigs( info->translation );
    info->cylinders                 = little_to_bigs( info->cylinders );
    info->heads                     = little_to_bigs( info->heads );
    info->sectors_per_track         = little_to_bigs( info->sectors_per_track );
    info->sectors_per_card          = little_to_bigs( info->sectors_per_card );
    info->multiple_sectors          = little_to_bigs( info->multiple_sectors );
    info->lba_sectors               = little_to_bigs( info->lba_sectors );
    info->security                  = little_to_bigs( info->security );
    info->power                     = little_to_bigs( info->power );
    swapbytes( info->serial,       20 );
    swapbytes( info->version,       8 );
    swapbytes( info->model,        40 );
    swapbytes( info->reserved3,   132 );
    swapbytes( info->vendor_bytes, 62 );
    swapbytes( info->reserved4,   190 );

    sysace_cfg_reset( ace );

    // Return successfully
    return SUCCESS;
}

Huint sysace_cf_fatstatus( sysace_t *ace )
{
    // Return the status
    return sysace_getfat(ace);
}

Hint sysace_cf_readsector( sysace_t *ace, Huint sector, Huint num, Hubyte *data )
{
    // If the device is not locked return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_MLOCK) )  return EDEADLK;

    // If the device is not ready return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_CREADY) ) return EBUSY;

    // Send the sector number to the device
    sysace_setmlba(ace,sector);

    // Send the read command to the device
    sysace_setsector(ace, (num&SYSACE_SECTOR_COUNT) | SYSACE_SECTOR_READ );

    // Read all of the data from the device
    return sysace_readbuffer( ace, data, num * SYSACE_DATA_SECTOR );
}

Hint sysace_cf_writesector( sysace_t *ace, Huint sector, Huint num, Hubyte *data )
{
    // If the device is not locked return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_MLOCK) )  return EDEADLK;

    // If the device is not ready return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_CREADY) ) return EBUSY;

    // Send the sector number to the device
    sysace_setmlba(ace,sector);

    // Send the read command to the device
    sysace_setsector(ace, (num&SYSACE_SECTOR_COUNT) | SYSACE_SECTOR_WRITE );

    // Read all of the data from the device
    return sysace_writebuffer( ace, data, num * SYSACE_DATA_SECTOR );
}

