#include <hthread.h>
#include <part.h>
#include <fat.h>
#include <utils.h>
#include <stdio.h>

extern Hint fat16_showfat( fat16_t* );
extern Hint fat16_showroot( fat16_t* );

Hint fat16_showpart( block_t *block, fat16_prt_t *part, int num )
{
    Hint res;
    fat16_bts_t boot;
    fat16_t     fat;

    // Show the partition information
    printf( "Partition %d: Boot Sector\n", num );
    printf( "---------------------------------------------------------------------\n" );
    printf( "Type:          %s\n", fat16_type(part) );
    printf( "Sectors:       %s\n", fat16_sectors(part) );
    printf( "Offset:        %d\n", part->offset ); 
    printf( "Size:          %d\n", part->size );

    if( part->type == 0x06 || part->type == 0x0C )
    {
        // Create a FAT16 file system using the block device
        fat16_create( &fat, part, block );

        // Attempt to read the boot sector
        res = fat16_boots_read( block, &boot, fat.boot_sector );
        if( res != SUCCESS ) {printf( "Error Reading Boot Sector: %d\n",res);return res;}

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

        // Show the FAT16 file system
        fat16_showfat( &fat );
        fat16_showroot( &fat );
        fat16_allroot( &fat );

        // Destroy the FAT16 file system
        fat16_destroy( &fat );
    }

    // Print the terminating new lines
    printf( "\n\n" );

    // Return successfully
    return SUCCESS;
}
