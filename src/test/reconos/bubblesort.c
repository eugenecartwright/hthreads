///
/// \file bubblesort.c
/// Simple sequential bubble sort implementation.
///
/// \author     Enno Luebbers   <luebbers@reconos.de>
/// \date       28.09.2007
//
// This file is part of the ReconOS project <http://www.reconos.de>.
// University of Paderborn, Computer Engineering Group.
//
// (C) Copyright University of Paderborn 2007.
//

#include <stdio.h>
#include <arch/cache.h>
#include "bubblesort.h"
#include "hthread.h"

//#define DBG

#ifdef DBG
#define dbg_printf(x,...) printf(x,##__VA_ARGS__)
#else
#define dbg_printf(x,...)
#endif

void bubblesort( unsigned int *array, unsigned int len )
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

/*
void bubblesort2( unsigned int *array, unsigned int len )
{
    int i;

    volatile long long int *core_base	    = (long long int*)(0x20000000);
    volatile long long int *core_done       = (long long int*)(core_base + 0x0);
    volatile long long int *core_read_data  = (long long int*)(core_base + 0x1);
    volatile long long int *core_addr       = (long long int*)(core_base + 0x2);
    volatile long long int *core_write_data = (long long int*)(core_base + 0x3);
    volatile long long int *core_control    = (long long int*)(core_base + 0x4);
    volatile long long int *core_param      = (long long int*)(core_base + 0x5);

    // Reset core
    *core_control = 0x00; 
    *core_control = 0x01; 
    *core_control = 0x00;

    // Setup core's sort length
    *core_param = 0x7FF;

    // Copy data
    for( i = 0; i < len; i++)
    {
        *core_addr = i;
        *core_write_data = array[i];
    }   

    // Send a go-signal
    *core_control = 0x00; 
    *core_control = 0x02; 
    *core_control = 0x00; 
    
    // Wait for a done-signal
    printf("Waiting for core to finish...\n");
    while(*core_done == 0);

    // Copy data back
    for( i = 0; i < len; i++)
    {
        *core_addr = i;
        array[i] = *core_read_data;
        //printf("Data = %i\n",array[i]);
    }  
}
*/
void bubblesort3( unsigned int *array, unsigned int len )
{
    int i;

    int *data;
    //volatile long long int *data;
    volatile int *core_base	    = (int*)(0x90000000);
    volatile int *core_len	    = (int*)(0x90000004);
    volatile int *core_mem	    = (int*)(0x90008000);

    // Set the core length in the core
    dbg_printf("length before = %d,",(int)*core_len);
    *core_len = len - 1;
    dbg_printf("length after = %d\n,",(int)*core_len);
    dcache_flushaddr( (void*)core_len );

    // Copy data
    dbg_printf("Copying data to BRAM...\n");
    for( data = (int*)core_mem,i = 0; i < len; i++ )
    {
        data[i] = array[i];
        dbg_printf("    @@ Data before %d\n",data[i]);
    }
    //ppc405_dcache_inv();

    // Send a go-signal
    dbg_printf( "Sending Go Signal to Hardware...\n" );
    *core_base = 0x00000000;
    dcache_flushaddr( (void*) core_base );
    dbg_printf("Status before starting = 0x%08x\n",*core_base);
    *core_base = 0xffffffff;
    dcache_flushaddr( (void*) core_base );
    dbg_printf("Status after starting = 0x%08x\n",*core_base);
    *core_base = 0x00000000;
    dcache_flushaddr( (void*) core_base );
    
    // Wait for a done-signal
    dbg_printf("Waiting for core to finish...\n");
    dcache_inv();
    while(*core_base == 0)
    {
        dcache_flushaddr( (void*)core_base );
    }
    dcache_flushaddr( (void*)core_base );
    dbg_printf("Status after finished = 0x%08x\n",*core_base);

    // Copy data back
    dbg_printf("Copying data from BRAM...\n");
    dcache_inv();
    for(data = (int*)core_mem,i = 0; i < len; i++ )
    {
        //ppc405_dcache_flushaddr( &data[i] );
        array[i] = data[i];
        dbg_printf("   ---> Data(%d)[0x%08x] = %d\n",i,(int)&data[i],data[i]);
    }
}

int *myBase = (int*)0x20000000;

void bubblesort2( unsigned int *array, unsigned int len )
{
    int i;
/*
    volatile long long int *core_base	    = (long long int*)(0x20000000);
    volatile long long int *core_done       = (long long int*)(core_base + 0x0);
    volatile long long int *core_read_data  = (long long int*)(core_base + 0x1);
    volatile long long int *core_addr       = (long long int*)(core_base + 0x2);
    volatile long long int *core_write_data = (long long int*)(core_base + 0x3);
    volatile long long int *core_control    = (long long int*)(core_base + 0x4);
    volatile long long int *core_param      = (long long int*)(core_base + 0x5);
*/
    volatile  int *core_base	    = ( int*)(0x20000000);
    volatile  int *core_done       = ( int*)(core_base + 0x0);
    volatile  int *core_read_data  = ( int*)(core_base + 0x1);
    volatile  int *core_addr       = ( int*)(core_base + 0x2);
    volatile  int *core_write_data = ( int*)(core_base + 0x3);
    volatile  int *core_control    = ( int*)(core_base + 0x4);
    volatile  int *core_param      = ( int*)(core_base + 0x5);


    //printf("Staring sort @ mybase = 0x%08x\n",(unsigned int)myBase);
    if (myBase == (int*)0x20000000)
    {
	    core_base	    = ( int*)(myBase);
	    core_done       = ( int*)(myBase + 0x0);
	    core_read_data  = ( int*)(myBase + 0x1);
	    core_addr       = ( int*)(myBase + 0x2);
	    core_write_data = ( int*)(myBase + 0x3);
	    core_control    = ( int*)(myBase + 0x4);
	    core_param      = ( int*)(myBase + 0x5);
        myBase          = (int*)0x20100000;
    }
    else if (myBase == (int*)0x20100000)
    {
	    core_base	    = ( int*)(myBase);
	    core_done       = ( int*)(myBase + 0x0);
	    core_read_data  = ( int*)(myBase + 0x1);
	    core_addr       = ( int*)(myBase + 0x2);
	    core_write_data = ( int*)(myBase + 0x3);
	    core_control    = ( int*)(myBase + 0x4);
	    core_param      = ( int*)(myBase + 0x5);
        myBase          = (int*)0x20200000;
    }
    else if (myBase == (int*)0x20200000)
    {
	    core_base	    = ( int*)(myBase);
	    core_done       = ( int*)(myBase + 0x0);
	    core_read_data  = ( int*)(myBase + 0x1);
	    core_addr       = ( int*)(myBase + 0x2);
	    core_write_data = ( int*)(myBase + 0x3);
	    core_control    = ( int*)(myBase + 0x4);
	    core_param      = ( int*)(myBase + 0x5);
        myBase          = (int*)0x20300000;
    }
    else
    {
	    core_base	    = ( int*)(myBase);
	    core_done       = ( int*)(myBase + 0x0);
	    core_read_data  = ( int*)(myBase + 0x1);
	    core_addr       = ( int*)(myBase + 0x2);
	    core_write_data = ( int*)(myBase + 0x3);
	    core_control    = ( int*)(myBase + 0x4);
	    core_param      = ( int*)(myBase + 0x5);
        myBase          = (int*)0x20000000;
    }

    // Reset core
    *core_control = 0x00; 
    *core_control = 0x01; 
    *core_control = 0x00;

    // Setup core's sort length
    //printf("length = 0x%08x\n",len);
    //*core_param = 0x7FF;
    *core_param = len-1;
/*
    printf(" base = %08x, %llu\n",core_base, *core_base);
    printf(" done = %08x, %llu\n",core_done, *core_done);
    printf(" read_data = %08x, %llu \n",core_read_data, *core_read_data);
    printf(" addr = %08x, %llu \n",core_addr, *core_addr);
    printf(" write_data = %08x, %llu\n",core_write_data, *core_write_data);
    printf(" core_control = %08x, %llu\n",core_control, *core_control);
    printf(" core_param = %08x, %llu\n",core_param, *core_param);
*/

    // Copy data
    for( i = 0; i < len; i++)
    {
        *core_addr = i;
        *core_write_data = array[i];
        //printf("Data in [(0x%08x), %d] (actual = 0x%08x) (writeData = 0x%08x) (readData = 0x%08x)\n",core_addr,*core_addr,array[i],*core_write_data,*core_read_data);
    }   

    // Send a go-signal
    *core_control = 0x00; 
    *core_control = 0x02; 
    *core_control = 0x00; 
    
    // Wait for a done-signal
    //printf("Waiting for core to finish...\n");
    while(*core_done == 0) {
        //printf("yielding (0x%08x)\n",core_base);
        hthread_yield();
    };

    // Copy data back
    for( i = 0; i < len; i++)
    {
        *core_addr = i;
        array[i] = *core_read_data;
        //printf("Data = %i\n",array[i]);
    }  
}

