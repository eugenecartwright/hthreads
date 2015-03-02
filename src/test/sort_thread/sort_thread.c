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

#include <hthread.h>
#include "sort_thread.h"

int sort_partition( int *data, int low, int high )
{
    int temp;
    int pivot;
    int left;
    int right;

    pivot = data[low];
    left = low;
    right = high;

    while( left < right )
    {
        while( data[left] <= pivot ) left++;
        while( data[right] > pivot ) right--;
        
        if ( left < right )
        {
            temp = data[left];
            data[left] = data[right];
            data[right] = temp;
        }
    }

    data[low] = data[right];
    data[right] = pivot;
    
    return right;
}

void sort_quick( int *data, int low, int high )
{
    int pivot;

    if( high > low )
    {
        pivot = sort_partition( data, low, high );
        sort_quick( data, low, pivot - 1 );
        sort_quick( data, pivot + 1, high );
    }
}

void sort_data( int *data, int size )
{
    sort_quick( data, 0, size - 1 );
}

void sort_start( sort_struct *sort )
{
    hthread_mutex_lock( sort->mutex );
    while( *sort->ready == 0 ) hthread_cond_wait( sort->start, sort->mutex );
    *sort->ready = 0;
    hthread_mutex_unlock( sort->mutex );
}

void sort_finish( sort_struct *sort )
{
    *sort->done = 1;
    hthread_cond_signal( sort->finish );
}

void* sort_thread( void *arg )
{
    sort_struct  *sort;

    // The argument is a pointer to a sort structure
    sort = (sort_struct*)arg; 
    
    while( 1 )
    {
        // Wait for the start sorting condition to occur
        sort_start( sort );

        // Perform the sort
        sort_data( sort->data, sort->size );
    
        // Send the finished sorting condition out`
        sort_finish( sort );    
    }

    return NULL;
}
