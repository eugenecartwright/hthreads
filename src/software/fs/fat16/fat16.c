/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Arkansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/
#include <fs/fat16/fat16.h>
#include <debug.h>

Hint fat16_create( fat16_t *fat, fat16_prt_t *part, block_t *block )
{
    Hint        res;
    fat16_bts_t boot;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, part == NULL, "NULL partition pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, block == NULL, "NULL block device\n" );

    // Store the device used for physical access
    fat->block = block;

    // Store important information from the partition
    fat->first_sector = part->offset;
    fat->last_sector  = part->offset + part->size;
    fat->boot_sector  = fat->first_sector;

    // Read the boot sector from the disk
    res = fat16_boots_read( fat->block, &boot, fat->boot_sector );
    if( res < 0 )
    {
        TRACE_PRINTF( TRACE_ERR, FAT16_DEBUG, "error reading boot sector\n" );
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with error\n" );
        return res;
    }

    // Store important information from the boot sector
    fat->sectors        = boot.ssectors != 0 ? boot.ssectors : boot.sectors;
    fat->bt_sector      = boot.bytes_per_sector;
    fat->fat_sector     = fat->first_sector + boot.reserved_sectors;
    fat->fat_size       = boot.sectors_per_fat;
    fat->root_sector    = fat->fat_sector + (boot.fats * boot.sectors_per_fat);
    fat->root_size      = ((boot.max_root * 32) + (fat->bt_sector-1)) / fat->bt_sector;
    fat->data_sector    = fat->root_sector + fat->root_size; 
    fat->data_size      = fat->sectors-fat->fat_sector-fat->root_size-fat->first_sector;
    fat->cl_sectors     = boot.sectors_per_cluster;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint fat16_destroy( fat16_t *fat )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Huint fat16_bootsector( fat16_t *fat )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return fat->boot_sector;
}

Huint fat16_fatsector( fat16_t *fat, Hint table )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return fat->fat_sector + table*fat->fat_size;
}

Huint fat16_rootsector( fat16_t *fat )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );
    return fat->root_sector;
}

Huint fat16_sector( fat16_t *fat, Huint cluster )
{
    Huint sector;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );

    sector  = cluster - 2;
    sector *= fat->cl_sectors;
    sector += fat->data_sector;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return sector;
}

Huint fat16_entry_sector( fat16_t *fat, Huint cluster )
{
    Huint sector;
    Huint offset;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );

    offset = cluster * 2;
    sector = fat->fat_sector + offset/fat->bt_sector;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return sector;
}

Huint fat16_entry_offset( fat16_t *fat, Huint cluster )
{
    Huint off;
    Huint offset;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );

    offset = cluster * 2;
    off    = offset % fat->bt_sector;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return off;
}

Hint fat16_getentry( fat16_t *fat, Huint cluster, Hushort *entry )
{
    Hint    res;
    Huint   sector;
    Huint   offset;
    Hubyte  buffer[512];

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL entry pointer\n" );

    // Get the sector number and offset for the cluster
    sector = fat16_entry_sector( fat, cluster );
    offset = fat16_entry_offset( fat, cluster );

    // Read the sector containing the entry
    res = fat->block->read( fat->block, sector, 1, buffer );
    if( res < 0 )
    {
        TRACE_PRINTF( TRACE_ERR, FAT16_DEBUG, "error reading block device\n" );
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with error\n" );
        return res;
    }

    // Store the entry
    *entry = ((Hushort*)buffer)[ offset ];

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint fat16_setentry( fat16_t *fat, Huint cluster, Hushort entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}
