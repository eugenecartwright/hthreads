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

#include <stdlib.h>
#include "stdio.h"
#include <hthread.h>
#include "time_lib.h"
#include <xcache_l.h>

typedef struct
{
    int     size;
    int     head;
    int     tail;
    int     num;
    void    **mailbox;

    hthread_mutex_t mutex;
    hthread_cond_t  notempty;
    hthread_cond_t  notfull;
} mailbox_t;

typedef struct targ{
    mailbox_t mb_start;
    mailbox_t mb_done;
    int num_elements;
} sortarg_t;


void bubblesort(unsigned int *array, unsigned int len )
{

    int swapped = 1;
    unsigned int i, n, n_new, temp;
    n = len - 1;
    n_new = n;

    while ( swapped ) {
        swapped = 0;
        for ( i = 0; i < n; i++ ) {
            if ( array[i] > array[i + 1] ) {
                temp = array[i];
                array[i] = array[i + 1];
                array[i + 1] = temp;
                n_new = i;
                swapped = 1;
            }
        }
        n = n_new;
    }
}

int mailbox_write( mailbox_t *mailbox, void* value )
{
    // Lock the mailbox mutex
    hthread_mutex_lock( &mailbox->mutex );
    //printf( "Writing (%d) (%d)...\n", mailbox->notfull.num, mailbox->notempty.num );

    // Wait until there is space in the mailbox
    while( mailbox->num >= mailbox->size )
    {
        //printf( "Waiting for non-full\n" );
        hthread_cond_wait( &mailbox->notfull, &mailbox->mutex );
        //printf( "done waiting\n" );
    }

    // Store the value in the mailbox
    //printf( "Storing Value\n" );
    mailbox->mailbox[ mailbox->tail ] = value;
    mailbox->tail = (mailbox->tail + 1) % mailbox->size;
    mailbox->num++;
    //printf( "Write Size: %d\n", mailbox->num );

    // Unlock the mailbox mutex
    //printf( "Unlocking Mutex...\n" );
    hthread_mutex_unlock( &mailbox->mutex );
    //printf( "done\n" );

    // Signal that the mailbox in not empty any longer
    //printf( "Signalling not empty\n" );
    hthread_cond_signal( &mailbox->notempty );
    //printf( "done\n" );

    // Return successfully
    return 0;
}

void*  mailbox_read( mailbox_t *mailbox )
{
    void* value;

    // Lock the mailbox mutex
    hthread_mutex_lock( &mailbox->mutex );

    // Wait until there is space in the mailbox
    while( mailbox->num <= 0 )
    {
        //printf( "Waiting for data (%d)...\n", mailbox->notempty.num );
        hthread_cond_wait( &mailbox->notempty, &mailbox->mutex );
        //printf( "done waiting (%d)\n", mailbox->notempty.num );
    }

    // Get the value out of the mailbox
    value = mailbox->mailbox[ mailbox->head ];
    mailbox->head = (mailbox->head + 1) % mailbox->size;
    mailbox->num--;

    // Unlock the mailbox mutex
    hthread_mutex_unlock( &mailbox->mutex );

    // Signal that the mailbox is not full any longer
    hthread_cond_signal( &mailbox->notfull );

    // Return the read value
    return value;
}

int mailbox_trywrite( mailbox_t *mailbox, void* value )
{
    // Lock the mailbox mutex
    hthread_mutex_lock( &mailbox->mutex );

    // Return a failure if we don't have space
    while( mailbox->num >= mailbox->size )
    {
        hthread_mutex_unlock( &mailbox->mutex );
        return 1;
    }

    // Store the value in the mailbox
    mailbox->mailbox[ mailbox->tail ] = value;
    mailbox->tail = (mailbox->tail + 1) % mailbox->size;
    mailbox->num++;

    // Unlock the mailbox mutex
    hthread_mutex_unlock( &mailbox->mutex );

    // Signal that the mailbox in not empty any longer
    hthread_cond_signal( &mailbox->notempty );

    // Return successfully
    return 0;
}

void*  mailbox_tryread( mailbox_t *mailbox )
{
    void* value;

    // Lock the mailbox mutex
    hthread_mutex_lock( &mailbox->mutex );

    // Wait until there is space in the mailbox
    while( mailbox->num <= 0 )
    {
        hthread_mutex_unlock( &mailbox->mutex );
        return NULL;
    }

    // Get the value out of the mailbox
    value = mailbox->mailbox[ mailbox->head ];
    mailbox->head = (mailbox->head + 1) % mailbox->size;
    mailbox->num--;

    // Unlock the mailbox mutex
    hthread_mutex_unlock( &mailbox->mutex );

    // Signal that the mailbox is not full any longer
    hthread_cond_signal( &mailbox->notfull );

    // Return the read value
    return value;
}

int mailbox_init_no_globals(int mutexnum, int condnum, mailbox_t *mailbox, int size )
{
    hthread_mutexattr_t attr;
    hthread_condattr_t  cattr;

    // Allocate the mailbox memory
    mailbox->mailbox = (void**)malloc( sizeof(int)*size );
    if( mailbox->mailbox == NULL )    return ENOMEM;

    // Setup the mailbox structure
    mailbox->size = size;
    mailbox->head = 0;
    mailbox->tail = 0;
    mailbox->num  = 0;

    // Setup the mailbox mutex attributes
    hthread_mutexattr_init( &attr );
    hthread_mutexattr_setnum( &attr, mutexnum++ );
    hthread_mutexattr_settype( &attr, HTHREAD_MUTEX_RECURSIVE_NP );

    // Setup the mailbox mutex
    hthread_mutex_init( &mailbox->mutex, &attr );
    hthread_mutexattr_destroy( &attr );

    // Setup the mailbox condition variables
    hthread_condattr_init( &cattr );
    hthread_condattr_setnum( &cattr, condnum++ );
    hthread_cond_init( &mailbox->notempty, &cattr );
    hthread_condattr_setnum( &cattr, condnum++ );
    hthread_cond_init( &mailbox->notfull, &cattr );

    // Return successfully
    return 0;
}

void* mbox_thread( void *data )
{
    sortarg_t * my_arg;
    void *ptr;

    // Grab argument
    my_arg = (sortarg_t *)data;

    // Grab TID
    hthread_t tid = hthread_self();


    while ( 1 ) {

        // Read from mbox
        ptr = (void*)mailbox_read( &my_arg->mb_start );

        int res = (0x08 << 16) + ((int)ptr << 4) + tid;

        // Write result to mbox
        mailbox_write( &my_arg->mb_done, (void*)res);
    }
    return NULL;
}

#define CHUNK_SIZE  (10)
#define NUM_CHUNKS  (5)
#define TOTAL_SIZE  (NUM_CHUNKS*CHUNK_SIZE)
#define MAX_ITEMS   (10000)

#define NUM_THREADS (3)

#define USE_HW_THREAD

// The base addresses of the hardware thread we are creating
#define HWTI_BASEADDR0               (0xB0000000)
#define HWTI_BASEADDR1               (0xB0000100)
#define HWTI_BASEADDR2               (0xB0000200)
#define HWTI_BASEADDR3               (0xB0000300)
#define HWTI_BASEADDR4               (0xB0000400)
#define HWTI_BASEADDR5               (0xB0000500)
#define HWTI_BASEADDR6               (0xB0000600)
#define HWTI_BASEADDR7               (0xB0000700)
#define HWTI_BASEADDR8               (0xB0000800)
#define HWTI_BASEADDR9               (0xB0000900)


#define NUM_CPUS        (10)
unsigned int base_array[NUM_CPUS] = {HWTI_BASEADDR0, HWTI_BASEADDR1, HWTI_BASEADDR2, HWTI_BASEADDR3, HWTI_BASEADDR4, HWTI_BASEADDR5, HWTI_BASEADDR6, HWTI_BASEADDR7, HWTI_BASEADDR8, HWTI_BASEADDR9};

void run_tests()
{
    sortarg_t arg;
    int mutexnum = 0;
    int condnum = 0;
    hthread_t       tid[NUM_THREADS];
    hthread_attr_t attr[NUM_THREADS];
    xps_timer_t timer;
    int time_create, time_start, time_stop;

    // *********************************************    
    extern unsigned char intermediate[];

    extern unsigned int mbox_handle_offset;
    unsigned int mbox_handle = (mbox_handle_offset) + (unsigned int)(&intermediate);
    // **********************************************    

    // Setup Cache
    XCache_DisableDCache();
    XCache_EnableICache(0xc0000801);

    // Create timer
    xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);

    // Initialize thread argument and mailboxes
    arg.num_elements = CHUNK_SIZE;
    mailbox_init_no_globals(mutexnum++,condnum++, &arg.mb_start, NUM_CHUNKS);
    mailbox_init_no_globals(mutexnum++,condnum++, &arg.mb_done, NUM_CHUNKS );

#ifdef USE_HW_THREAD
    printf("Using %d heterogeneous MB threads...\r\n", NUM_THREADS);
#else
    printf("Using %d Native PPC threads...\r\n", NUM_THREADS);
#endif

    time_create = xps_timer_read_counter(&timer);

    int i = 0;
    // Create threads
    for (i = 0; i < NUM_THREADS; i++)
    {
        // Initialize attributes
        hthread_attr_init( &attr[i] );
        hthread_attr_sethardware( &attr[i], (void*)base_array[i] );

        // Spawn thread
#ifdef USE_HW_THREAD
            hthread_create( &tid[i], &attr[i], (void*)mbox_handle, (void*)&arg );
#else
            hthread_create( &tid[i], NULL, mbox_thread, (void*)&arg );
#endif
    }

    // Initialize count array
    int counts[10];
    for (i = 0; i < 10; i++)
    {
        counts[i] = 0;
    }


    // Loop until all items have been sent through the mbox chain
    int items_to_send = MAX_ITEMS;
    int items_received = 0;
    int ret;
    int index;

    time_start = xps_timer_read_counter(&timer);

    i = 0;
    while (items_received <  MAX_ITEMS)
    {
        // Try to send items
        while (items_to_send > 0)
        {
            if( mailbox_trywrite( &arg.mb_start, (void*)i ) == 0 ) {
                // Write succeeds
                i++;
                items_to_send--;
            }
            else
            {
                // Write fails
                break;  // Exit loop
            }
        }

        // Receive items
        ret = (int)mailbox_read( &arg.mb_done );
        //printf("Ret value(%d) = 0x%08x\n",items_received,ret);
        index = ret & 0xf;
        counts[index]++;
        items_received++;
    }

    // Grab stop time
    time_stop = xps_timer_read_counter(&timer);

    // Display processing counts
    for (i = 0; i < 10; i++)
    {
        if (counts[i] != 0)
            printf("Count for TID %d = %d\n",i,counts[i]);
    }

        printf("*********************************\n");
        printf("Create time  = %u\n",time_create);
        printf("Start time   = %u\n",time_start);
        printf("Stop time    = %u\n",time_stop);
        printf("*********************************\n");
        printf("Creation time (|Start - Create|) = %u\n",time_start - time_create);
        printf("Elapsed time  (|Stop - Start|)   = %u\n",time_stop - time_start);
        printf("Cycles/Word                      = %f\n",(time_stop-time_start)/(1.0*MAX_ITEMS));
}

int main()
{
    int x;
    for (x = 0; x < 1; x++)
    {
        run_tests();
    }
    return 0;
}
