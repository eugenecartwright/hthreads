///
/// \file sort8k.h
/// eCos thread entry function for sorting thread.
///
/// \author     Enno Luebbers   <luebbers@reconos.de>
/// \date       28.09.2007
//
// This file is part of the ReconOS project <http://www.reconos.de>.
// University of Paderborn, Computer Engineering Group.
//
// (C) Copyright University of Paderborn 2007.
//

#ifndef __SORT8K_NO_GLOBALS_H__
#define __SORT8K_NO_GLOBALS_H__

#ifndef cyg_addrword_t
#define cyg_addrword_t unsigned int
#endif

#include "mailbox_no_globals.h"

typedef struct targ{
    mailbox_t mb_start;
    mailbox_t mb_done;
} sortarg_t;


void bubblesort( unsigned int *array, unsigned int len );
void* sort8k_entry( void *data );
void* sort8k_entry2( void *data );
void* sort8k_entry3( void *data );

#endif
