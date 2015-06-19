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

#include <stdlib.h>
#include <debug.h>
#include <hthread.h>
#include "prod_thread.h"
#include "sort_thread.h"
#include "cons_thread.h"

#define SIZE    6
#define MIN     0
#define MAX     500

extern void* prod_thread( void* );
extern void* sort_thread( void* );
extern void* cons_thread( void* );

void setup_structs( prod_struct *prod, sort_struct *sort, cons_struct *cons )
{
    int *data;
    int *ready_prod;
    int *ready_sort;
    int *ready_cons;
    hthread_mutex_t *mutex;
    hthread_cond_t  *start_prod;
    hthread_cond_t  *start_sort;
    hthread_cond_t  *start_cons;

    data        = (int*)malloc( SIZE * sizeof(int) );
    mutex       = (hthread_mutex_t*)malloc( sizeof(hthread_mutex_t) );
    ready_prod  = (int*)malloc( sizeof(int) );
    ready_sort  = (int*)malloc( sizeof(int) );
    ready_cons  = (int*)malloc( sizeof(int) );
    start_prod  = (hthread_cond_t*)malloc( sizeof(hthread_cond_t) );
    start_sort  = (hthread_cond_t*)malloc( sizeof(hthread_cond_t) );
    start_cons  = (hthread_cond_t*)malloc( sizeof(hthread_cond_t) );

    hthread_mutex_init( mutex, NULL );
    hthread_cond_init( start_prod, NULL );
    hthread_cond_init( start_sort, NULL );
    hthread_cond_init( start_cons, NULL );

    prod->mutex     = mutex;
    prod->start     = start_prod;
    prod->finish    = start_sort;
    prod->data      = data;
    prod->size      = SIZE;
    prod->min       = MIN;
    prod->max       = MAX;
    prod->ready     = ready_prod;
    prod->done      = ready_sort;

    sort->mutex     = mutex;
    sort->start     = start_sort;
    sort->finish    = start_cons;
    sort->data      = data;
    sort->size      = SIZE;
    sort->ready     = ready_sort;
    sort->done      = ready_cons;

    cons->mutex     = mutex;
    cons->start     = start_cons;
    cons->finish    = start_prod;
    cons->data      = data;
    cons->size      = SIZE;
    cons->ready     = ready_cons;
    cons->done      = ready_prod;
}

void destroy_structs( prod_struct *prod, sort_struct *sort, cons_struct *cons )
{
    free( prod->data );
    free( prod->start );
    free( sort->start );
    free( cons->start );

    free( prod->ready );
    free( sort->ready );
    free( cons->ready );
}

void start_producer( prod_struct *prod, sort_struct *sort, cons_struct *cons )
{
    *prod->ready = 1;
    hthread_cond_signal( prod->start );
}

int main( int argc, char *argv[] )
{
    hthread_t   prod_tid;
    hthread_t   sort_tid;
    hthread_t   cons_tid;
    prod_struct prod;
    sort_struct sort;
    cons_struct cons;

    // Setup the structures for the threads
    DEBUG_PRINTF( "Setting up Structures\n" );
    setup_structs( &prod, &sort, &cons );

    // Create the producing thread
    DEBUG_PRINTF( "Creating Producer\n" );
    hthread_create( &prod_tid, NULL, prod_thread, (void*)&prod );
    
    // Create the sorting thread
    DEBUG_PRINTF( "Creating Sorter\n" );
    hthread_create( &sort_tid, NULL, sort_thread, (void*)&sort );

    // Create the consuming thread
    DEBUG_PRINTF( "Creating Consumer\n" );
    hthread_create( &cons_tid, NULL, cons_thread, (void*)&cons );
    
    // Send the start signal to the producer
    DEBUG_PRINTF( "Starting Producer\n" );
    start_producer( &prod, &sort, &cons );

    // Wait for the sorting thread to finish
    hthread_join( prod_tid, NULL );
    
    // Wait for the sorting thread to finish
    hthread_join( sort_tid, NULL );
    
    // Wait for the sorting thread to finish
    hthread_join( cons_tid, NULL );

    // Clean up the structures
    DEBUG_PRINTF( "Cleaning Structures\n" );
    destroy_structs( &prod, &sort, &cons );

    // Exit the program
    return 0;
}
