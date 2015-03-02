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
#include "sort8k.h"
#include "mailbox.h"
#include "stdio.h"

extern mailbox_t mb_start, mb_done;
//extern cyg_handle_t mb_start_handle, mb_done_handle;


void* sort8k_entry( void *data )
{
#ifdef USE_ECOS
    void *ptr;
    unsigned int thread_number = ( unsigned int ) data;

    while ( 1 ) {
        // get pointer to next chunk of data
        ptr = cyg_mbox_get( mb_start_handle );
        // sort it
        bubblesort( ( unsigned int * ) ptr, N );
        // return
        cyg_mbox_put( mb_done_handle, ( void * ) 23 );                         // return any value
    }
#else
    void *ptr;
    //unsigned int tid = (unsigned int)hthread_self();
    //unsigned int thread_number = ( unsigned int ) data;

    while ( 1 ) {
        // get pointer to next chunk of data
        ptr = (void*)mailbox_read( &mb_start );
        // sort it
        bubblesort( ( unsigned int * ) ptr, N );
        // return
        mailbox_write( &mb_done, (void*)23 ); // return any value
    }
#endif
    return NULL;
}
