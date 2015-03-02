#include "time_lib.h"
#include <stdio.h>
#include <xcache_l.h>

#define ARR_LENGTH 1000

#define MULT 10000

int my_array[ARR_LENGTH];

int memory_access(unsigned int *array, unsigned int len, unsigned int multiplier)
{
    int counter, round;
    int offset = 4;
    int accum = len;
    for (round = 0; round < multiplier; round++)
    {
        for (counter = 0; counter < len; counter+=offset)
        {
            accum = accum + array[counter];
            accum = accum + array[counter + 1];
            accum = accum + array[counter + 2];
            accum = accum + array[counter + 3];
            array[counter] = array[counter] + accum;
        }
    }
    return accum;
}
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

int main()
{
	xps_timer_t timer;
    int time_start, time_stop;
    int x;

    print("\r\n Test begin...\r\n");
    for (x = 0; x < ARR_LENGTH; x++)
    {
        my_array[x] = ARR_LENGTH - x;
    }

    // Setup cache...
    //XCache_EnableICache(0xc0000001);
    //XCache_EnableDCache(0xc0000001);

	 // Create timer
	 xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);

    // Grab first time point
    time_start = xps_timer_read_counter(&timer);

    // Perform test
    //bubblesort((unsigned int*)my_array,ARR_LENGTH);
    int acc = memory_access((unsigned int*)my_array,ARR_LENGTH,MULT);

    // Grab last time point
    time_stop = xps_timer_read_counter(&timer);

    printf("Acc = %d\r\n",acc);
    printf("Start time = %d\r\n",time_start);
    printf("Stop time  = %d\r\n",time_stop);
    printf("Time diff  = %d\r\n",(time_stop - time_start));
    int words = (4+2)*ARR_LENGTH*MULT;
    printf("Words accessed = %d\r\n",words);
    printf("Average time per word = %d\r\n",(time_stop-time_start)/words);
    return 0;
}
