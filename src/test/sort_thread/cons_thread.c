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

#include <stdio.h>
#include <hthread.h>
#include "cons_thread.h"

void cons_data( int *data, int size )
{
    int odd;
    int mid;
    int med;

    odd = size % 2;
    mid = size / 2;

    if( odd )   med = (data[mid] + data[mid + 1]) / 2;
    else        med = data[mid];

    printf( "Median: %d\n", med );
}

void cons_start( cons_struct *cons )
{
    hthread_mutex_lock( cons->mutex );
    while( *cons->ready == 0 ) hthread_cond_wait( cons->start, cons->mutex );
    *cons->ready = 0;
    hthread_mutex_unlock( cons->mutex );
}

void cons_finish( cons_struct *cons )
{
    *cons->done = 1;
    hthread_cond_signal( cons->finish );
}

void* cons_thread( void *arg )
{
    cons_struct  *cons;

    // The argument is a pointer to a sort structure
    cons = (cons_struct*)arg; 
    
    while( 1 )
    {
        // Wait for the start sorting condition to occur
        cons_start( cons );

        // Perform the sort
        cons_data( cons->data, cons->size );
    
        // Send the finished sorting condition out`
        cons_finish( cons );    
    }

    return NULL;
}
