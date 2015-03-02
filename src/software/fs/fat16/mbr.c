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
#include <hendian.h>
#include <debug.h>

Hint fat16_mbr_read( block_t *block, fat16_mbr_t *mbr, Huint sector )
{
    Hint res;

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, block == NULL, "NULL block device\n" );
    TRACE_PRINTF( TRACE_FATAL, mbr == NULL, "NULL master boot record\n" );
    
    // Read the master boot record from the block device
    res = block->read( block, sector, 1, (Hubyte*)mbr );
    if( res < 0 )
    {
        TRACE_PRINTF( TRACE_ERR, FAT16_DEBUG, "error reading block device\n" );
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with error\n" );
        return res;
    }
    
    // Endian Convert the Data
    fat16_mbr_readconvert( mbr );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint fat16_mbr_readconvert( fat16_mbr_t *mbr )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );

    fat16_part_readconvert( &mbr->partitions[0] );
    fat16_part_readconvert( &mbr->partitions[1] );
    fat16_part_readconvert( &mbr->partitions[2] );
    fat16_part_readconvert( &mbr->partitions[4] );
    mbr->executable = little_to_bigs( mbr->executable );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}
