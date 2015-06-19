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
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES
{
}

* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/
#include <fs/fat16/fat16.h>
#include <fs/fat16/dirs.h>
#include <hendian.h>
#include <debug.h>
#include <ctype.h>

Hint fat16_direntry_free( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    if( entry->name[0] == 0xE5 )
    {
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with free\n" );
        return 1;
    }
    else if( entry->name[0] == 0x00 )
    {
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with all free\n" );
        return 2;
    }
    else
    {
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with not free\n" );
        return 0;
    }
}

char* fat16_direntry_name( fat16_direntry_t *entry, char *buffer, Huint num )
{
    Hint    i;
    Hint    n;
    Hint    lower;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );
    TRACE_PRINTF( TRACE_FATAL, buffer == NULL, "NULL name buffer\n" );

    // Return if there is no room
    if( num == 0 )
    {
        TRACE_PRINTF( TRACE_ERR, FAT16_DEBUG, "empty name buffer given\n" );
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );
        return buffer;
    }

    // Reserve room for the terminating null
    num--;

    // Intialize the number of bytes copied
    n = 0;

    // Determine if we should name the name lower case or not
    lower = ((entry->reserved & 0x08) == 0x08);

    // Copy over the name, adding a period if neccessary
    for( i = 0; i < 11; i++ )
    {
        if( entry->name[i] == ' ' || entry->name[i] == 0 )
        {
            if( i < 8 )
            {
                if( entry->name[8] == ' ' || entry->name[8] == 0 )  break;
                else                                                i = 8;
                lower = ((entry->reserved & 0x10) == 0x10);
            }
            else
            {
                break;
            }
        }

        if( n < num && i == 8 )    buffer[n++] = '.';
        if( n < num )   buffer[n++] = lower ? tolower(entry->name[i]) : entry->name[i];
    }

    // Add terminating null to the name
    buffer[n++] = 0;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return buffer;
}

Huint fat16_direntry_size( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return little_to_bigl(entry->size);
}

Hint fat16_direntry_readonly( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    if( (entry->attrs & FAT16_DIRENTRY_LONGNAME) == FAT16_DIRENTRY_LONGNAME )   return 0;
    return (entry->attrs & FAT16_DIRENTRY_READONLY) != 0;
}

Hint fat16_direntry_hidden( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    if( (entry->attrs & FAT16_DIRENTRY_LONGNAME) == FAT16_DIRENTRY_LONGNAME )   return 0;
    return (entry->attrs & FAT16_DIRENTRY_HIDDEN) != 0;
}

Hint fat16_direntry_system( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    if( (entry->attrs & FAT16_DIRENTRY_LONGNAME) == FAT16_DIRENTRY_LONGNAME )   return 0;
    return (entry->attrs & FAT16_DIRENTRY_SYSTEM) != 0;
}

Hint fat16_direntry_volumeid( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    if( (entry->attrs & FAT16_DIRENTRY_LONGNAME) == FAT16_DIRENTRY_LONGNAME )   return 0;
    return (entry->attrs & FAT16_DIRENTRY_VOLUMEID) != 0;
}

Hint fat16_direntry_directory( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return (entry->attrs & FAT16_DIRENTRY_DIRECTORY) != 0;
}

Hint fat16_direntry_archive( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return (entry->attrs & FAT16_DIRENTRY_ARCHIVE) != 0;
}

Hint fat16_direntry_longname( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return (entry->attrs & FAT16_DIRENTRY_LONGNAME) == FAT16_DIRENTRY_LONGNAME;
}

Huint fat16_direntry_createmtime( fat16_direntry_t *entry )
{
    Huint time;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    time = entry->create_mtime * 10;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return (time % 1000);
}

Huint fat16_direntry_createtime( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return 0;
}

Huint fat16_direntry_createdate( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return 0;
}

Huint fat16_direntry_writetime( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    return 0;
}

Huint fat16_direntry_writedate( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return 0;
}

Huint fat16_direntry_accessdate( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return 0;
}

Huint fat16_direntry_cluster( fat16_direntry_t *entry )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, entry == NULL, "NULL fat16 entry\n" );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    return ((little_to_bigs(entry->cluster_hi) << 16)|little_to_bigs(entry->cluster_lo));
}

