#include <hthread.h>
#include <fat.h>
#include <utils.h>
#include <stdio.h>

Hint fat16_showfat( fat16_t *fat )
{
    Hint    i;
    Hint    j;
    Hint    res;
    Hint    show;
    Hint    lastshow;
    Hushort *data;
    Hushort last[8];

    // Allocate a buffer which can hold the entire fat
    data = (Hushort*)malloc( fat->fat_size * 512 );

    // Clear out the last data
    lastshow = 0;

    // Read the entire FAT table
    printf( "Reading FAT: %d - %d\n", fat->fat_sector, 4 /*fat->fat_size*/ );
    res = fat->block->read( fat->block, fat->fat_sector, 4 /*fat->fat_size*/, (Hubyte*)data );
    if( res < 0 ) {printf( "Could not read FAT table: %d\n",res); return res;}

    // Show the entire fat table
    printf( "FAT16 Table\n" );
    printf( "---------------------------------------------------------------------" );
    for( i = 0; i < /*fat->fat_size*/4 * 256; i += 8 )
    {
        // Determine if the row is different
        show = 0; for(j=0;j<8;j++) {if(last[j]!=data[i+j])show=1;last[j]=data[i+j];}

        if( i == 0 || i == (fat->fat_size*256-8) || show )
        {
            show = 1;
            printf( "\n0x%8.8X        ", i );
            for( j = 0; j < 8; j++ )
            { if( j == 4 ) printf( "    " ); printf( "%4.4X ", data[i+j] ); }
        }
        else if( !show && lastshow )
        {
            printf( "\n...               ..." );
        }

        // Store the last action that we took
        lastshow = show;
    }
    printf( "\n\n" );

    // Free the allocated buffer
    free( data );

    // Return successfully
    return SUCCESS;
}

Hint fat16_showroot( fat16_t *fat )
{
    Hint                res;
    fat16_dir_t         root;
    fat16_dir_entry_t   entry;

    // Attempt to get the root directory entry
    res = fat16_dir_root( fat, &root );
    if( res < 0 ) { printf( "Could not read root directory\n" ); return res; }

    // Read all of the directory entries
    res = fat16_dir_first( fat, &root, &entry );
    while( res == SUCCESS )
    {
        printf("FAT16 Root Directory\n");
        printf("---------------------------------------------------------------------\n");
        printf( "Entry Number:      %u\n", entry.entryno );
        printf( "Entry Name:        %s\n", entry.name );
        printf( "Entry Attributes:  0x%8.8x\n", entry.attrs );
        printf( "Entry Size:        %u bytes\n", entry.size );
        printf( "Entry Cluster:     %u\n", entry.cluster );
        printf( "\n" );
        printf( "\n" );

        res = fat16_dir_next( fat, &entry, &entry );
    }

    // Check the exit condition
    if( res < 0 ) { printf( "Could not get directory entry\n" ); }

    // Return successfully
    return SUCCESS;
}

Hint fat16_allroot( fat16_t *fat )
{
    Hint i;
    Hint res;
    Hint last;
    Hint show;
    char name[16];
    fat16_direntry_t *entries;

    // Allocate a buffer to hold all of the root entries
    entries = (fat16_direntry_t*)malloc( fat->root_size * 512 );

    // Initialize the last data
    last = 0;

    // Read the entire FAT root directory
    res = fat->block->read(fat->block,fat->root_sector,fat->root_size, (Hubyte*)entries);
    if( res < 0 ) { printf( "Could not read root directory: %d\n", res ); return res; }

    // Show the entire root table
    printf( "FAT16 Root Directory\n" );
    printf( "---------------------------------------------------------------------\n" );
    for( i = 0; i < fat->root_size * 512 / 32; i++ )
    {
        // Determine if this entry is free
        show  = !fat16_direntry_free( &entries[i] );
        show &= !fat16_direntry_longname( &entries[i] );
        
        // If the entry is not free then show it
        if( i == 0 || i == ((fat->root_size*512/32)-1) || show )
        {
            show = 1;
            printf( "%-8.1d        ", i );
            printf( "%-12s    ", fat16_direntry_name(&entries[i],name,16) );
            printf( "%c", fat16_direntry_readonly(&entries[i]) ? 'r' : ' ');
            printf( "%c", fat16_direntry_hidden(&entries[i]) ? 'h' : ' ' );
            printf( "%c", fat16_direntry_system(&entries[i]) ? 's' : ' ' );
            printf( "%c", fat16_direntry_volumeid(&entries[i]) ? 'v' : ' ' );
            printf( "%c", fat16_direntry_directory(&entries[i]) ? 'd' : ' ' );
            printf( "%c    ", fat16_direntry_archive(&entries[i]) ? 'a' : ' ' );
            printf( "0x%8.8X    ", fat16_direntry_cluster(&entries[i]) );
            printf( "0x%8.8X    ", fat16_direntry_size(&entries[i]) );
            printf( "\n" );
        }
        else if( last )
        {
            printf( "...\n" );
        }

        // Store the last action
        last = show;
    }
    printf( "\n\n" );

    // Free the allocated buffer
    free( entries );

    // Return successfully
    return SUCCESS;
}
