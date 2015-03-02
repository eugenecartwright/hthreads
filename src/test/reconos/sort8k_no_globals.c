///
/// \file sort8k.c
/// eCos thread entry function for sorting
///
/// \author     Enno Luebbers   <luebbers@reconos.de>
/// \date       28.09.2007
//
// This file is part of the ReconOS project <http://www.reconos.de>.
// University of Paderborn, Computer Engineering Group.
//
// (C) Copyright University of Paderborn 2007.
//

#ifdef USE_ECOS
#include <cyg/infra/diag.h>
#include <cyg/kernel/kapi.h>
#endif
#include <stdlib.h>
#include "setup.h"
#include "bubblesort.h"
#include "sort8k_no_globals.h"
#include "mailbox_no_globals.h"
#include "stdio.h"

void* sort8k_entry( void *data )
{
    sortarg_t * my_arg;
    void *ptr;

    my_arg = (sortarg_t *)data;
    //unsigned int tid = (unsigned int)hthread_self();
    //unsigned int thread_number = ( unsigned int ) data;

    while ( 1 ) {
        // get pointer to next chunk of data
        ptr = (void*)mailbox_read( &my_arg->mb_start );
        // sort it
        bubblesort( ( unsigned int * ) ptr, N );
        // return
        mailbox_write( &my_arg->mb_done, (void*)23 ); // return any value
    }
    return NULL;
}

void* sort8k_entry2( void *data )
{
    sortarg_t * my_arg;
    void *ptr;

    my_arg = (sortarg_t *)data;
    //unsigned int tid = (unsigned int)hthread_self();
    //unsigned int thread_number = ( unsigned int ) data;

    while ( 1 ) {
        // get pointer to next chunk of data
        ptr = (void*)mailbox_read( &my_arg->mb_start );
        // sort it
        bubblesort2( ( unsigned int * ) ptr, N );
        // return
        mailbox_write( &my_arg->mb_done, (void*)23 ); // return any value
    }
    return NULL;
}

void* sort8k_entry3( void *data )
{
    sortarg_t * my_arg;
    void *ptr;

    my_arg = (sortarg_t *)data;
    //unsigned int tid = (unsigned int)hthread_self();
    //unsigned int thread_number = ( unsigned int ) data;

    while ( 1 ) {
        // get pointer to next chunk of data
        ptr = (void*)mailbox_read( &my_arg->mb_start );
        // sort it
        bubblesort3( ( unsigned int * ) ptr, N );
        // return
        mailbox_write( &my_arg->mb_done, (void*)23 ); // return any value
    }
    return NULL;
}
