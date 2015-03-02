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

#include <stdio.h>
#include <stdlib.h>
#include <debug.h>
#include <hthread.h>
#include "prod_thread.h"

void prod_data( int *data, int size, int min, int max )
{
    int i;
    int delta;

    delta = (max - min);

    DEBUG_PRINTF( "PRODUCER: " );
    for( i = 0; i < size; i++ )
    {
        data[i] = (rand() % delta) + min;
        DEBUG_PRINTF( "%5d", data[i] );
    }
    DEBUG_PRINTF( "\n" );
}

void prod_start( prod_struct *prod )
{
    DEBUG_PRINTF( "PRODUCER: Waiting to Start.\n" );

    hthread_mutex_lock( prod->mutex );
    while( *prod->ready == 0 ) hthread_cond_wait( prod->start, prod->mutex );
    *prod->ready = 0;
    hthread_mutex_unlock( prod->mutex );
}

void prod_finish( prod_struct *prod )
{
    DEBUG_PRINTF( "PRODUCER: Sending Finish.\n" );

    *prod->done = 1;
    hthread_cond_signal( prod->finish );
}

void* prod_thread( void *arg )
{
    
    prod_struct  *prod;

    // The argument is a pointer to a sort structure
    prod = (prod_struct*)arg; 
    
    DEBUG_PRINTF( "PRODUCER: Thread Started.\n" );
    while( 1 )
    {
        // Wait for the start sorting condition to occur
        prod_start( prod );

        // Perform the sort
        prod_data( prod->data, prod->size, prod->min, prod->max );
    
        // Send the finished sorting condition out`
        prod_finish( prod );    
    }

    DEBUG_PRINTF( "PRODUCER: Thread Ended.\n" );
    return NULL;
}
