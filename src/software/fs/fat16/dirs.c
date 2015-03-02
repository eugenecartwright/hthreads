/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
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
*     * Neither the name of the University of Kansas nor the name of the
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
#include <fs/fat16/dirs.h>
#include <hendian.h>
#include <debug.h>

// Declaration of internal functions
extern Hint fat16_dir_findentry( fat16_direntry_t*, Huint, Huint );
extern Hint fat16_dir_nextentry( fat16_t*, Huint, Huint, fat16_dir_entry_t* );
extern Hint fat16_dir_readname( fat16_t*, fat16_dir_entry_t*, Huint, char* );
    
Hint fat16_dir_root( fat16_t *fat, fat16_dir_t *dir )
{
    // Print out a message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, dir == NULL, "NULL fat16 directory pointer\n" );

    // Set the directory entry to the fat16 entry for the root directory
    dir->block = fat->root_sector;
    dir->size  = fat->root_size;

    // Print out a message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint fat16_dir_first( fat16_t *fat, fat16_dir_t *dir, fat16_dir_entry_t *entry )
{
    Hint          res;

    // Print out a message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, dir == NULL, "NULL fat16 directory pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 directory entry pointer\n" );

    // Store the parent of the entry
    entry->parent = dir;

    // Get the first entry
    res = fat16_dir_nextentry( fat, dir->block, 0, entry );
    if( res < 0 )
    {
        TRACE_PRINTF( TRACE_ERR, FAT16_DEBUG, "no entry in directory\n" );
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with error\n" );
        return res;
    }

    // Print out a message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint fat16_dir_next( fat16_t *fat, fat16_dir_entry_t *cur, fat16_dir_entry_t *next )
{
    Hint          res;

    // Print out a message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, cur == NULL, "NULL fat16 current entry pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, next == NULL, "NULL fat16 next entry pointer\n" );

    // Store the parent of the entry
    next->parent = cur->parent;

    // Get the next entry
    res = fat16_dir_nextentry( fat, cur->parent->block, cur->entryno+1, next );
    if( res < 0 )
    {
        TRACE_PRINTF( TRACE_ERR, FAT16_DEBUG, "no more entries in directory\n" );
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with error\n" );
        return res;
    }

    // Print out a message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint fat16_dir_nextentry( fat16_t *fat, Huint sblk, Huint sent, fat16_dir_entry_t *entry )
{
    Hint                res;
    Huint               blk;
    Huint               off;
    Huint               ent;
    fat16_direntry_t    entries[16];

    // Print out a message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, fat == NULL, "NULL fat16 pointer\n" );
    
    // Initialize the entry to start with
    blk = sblk + (sent / 16);
    off = sent % 16;
    ent = sent;

    // Loop until we have found the next entry
    while( 1 )
    {
        // Read in the next block
        res = fat->block->read( fat->block, blk, 1, (Hubyte*)entries );
        if( res < 0 )
        {
            TRACE_PRINTF( TRACE_ERR, FAT16_DEBUG, "error reading from block device\n" );
            TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with error\n" );
            return res;
        }

        // Look for the next block starting at the offset
        printf( "Blk: %d Ent: %d Off: %d\n", blk, ent, off );
        res = fat16_dir_findentry( entries, off, 16 );
        printf( "Found Res: %d\n", res );
        if( res >= 0 )
        {
            entry->entryno  = ent + res - off;
            entry->attrs    = entries[res].attrs;
            entry->size     = little_to_bigl(entries[res].size);
            entry->cluster  = ( little_to_bigs(entries[res].cluster_hi) << 16 |
                               little_to_bigs(entries[res].cluster_lo) );
            fat16_direntry_name( &entries[res], entry->name, FAT16_NAME_MAX );
            fat16_dir_readname( fat, entry, sblk, entry->name );
            return SUCCESS;
        }
        else if( res == -2 )
        {
            break;
        }

        // Determine the next set of entries to read
        ent += 16 - off;
        blk += 1;
        off  = 0;
    }

    // Print out a message if configured
    TRACE_PRINTF( TRACE_INFO, FAT16_DEBUG, "could not find another entry\n" );
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with error\n" );

    // Return with an error
    return EINVAL;
}

Hint fat16_dir_findentry( fat16_direntry_t *entries, Huint start, Huint num )
{
    Hint i;

    for( i = start; i < num; i++ )
    {
        printf( "Start: %d Attrs: 0x%4.4x\n", start, entries[i].attrs );

        switch( fat16_direntry_free(&entries[i]) )
        {
        case 0:                     // This is a valid entry
            if( fat16_direntry_longname(&entries[i]) )  break;
            else                                        return i;
        case 1:     break;          // This is not a valid entry
        case 2:     return -2;      // There are no more valid entries
        }
    }

    // Return that a entry could not be found
    return -1;
}

Hint fat16_dir_readname( fat16_t *fat, fat16_dir_entry_t *ent, Huint sblk, char *name )
{
    Hint                n;
    Hint                res;
    Hint                nent;
    Huint               blk;
    Huint               off;
    fat16_longname_t    entries[16];

    // Move to the previous entry
    nent = ent->entryno - 1;

    // Keep moving to previous entries while we still can
    while( nent > 0 )
    {
        // Initialize the entry to start with
        blk = sblk + (nent / 16);
        off = nent % 16;

        // Read in the next block
        res = fat->block->read( fat->block, blk, 1, (Hubyte*)entries );
        if( res < 0 )
        {
            TRACE_PRINTF( TRACE_ERR, FAT16_DEBUG, "error reading from block device\n" );
            TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with error\n" );
            return res;
        }

        // Determine if the block is a long file name
        if((entries[off].attr&FAT16_DIRENTRY_LONGNAME)!=FAT16_DIRENTRY_LONGNAME)  break;

        // Copy over the long name data
        for( n = 0; n < 5; n++ )    *name++ = (char)little_to_bigs(entries[off].name1[n]);
        for( n = 0; n < 6; n++ )    *name++ = (char)little_to_bigs(entries[off].name2[n]);
        for( n = 0; n < 2; n++ )    *name++ = (char)little_to_bigs(entries[off].name3[n]);

        // Determine if this is the last of the long name entries
        if( (entries[nent].order & 0x40) == 0x40 )  break;

        // Move to the previous entry
        nent -= 1;
    }
    
    // Return successfully
    return SUCCESS;
}
