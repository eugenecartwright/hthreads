//#include "time_lib.h"
#include "xcache_l.h"
#include "stdio.h"

#define ARR_LENGTH 1000

// Timer Control Status Register Masks
#define TIMER_ENABLE     0x00000080
#define TIMER_DISABLE    0x00000000

#define TIMER_INTERRUPT_ENABLE     0x00000040
#define TIMER_INTERRUPT_DISABLE       0x00000000

#define TIMER_LOAD     0x00000020
#define TIMER_NO_LOAD  0x00000000

#define TIMER_RELOAD     0x00000010
#define TIMER_HOLD       0x00000000

#define TIMER_CAPTURE_ENABLE     0x00000008
#define TIMER_CAPTURE_DISABLE    0x00000000

#define TIMER_GENERATE_ENABLE     0x00000004
#define TIMER_GENERATE_DISABLE    0x00000000

#define TIMER_COUNT_UP       0x00000000
#define TIMER_MODE_DOWN      0x00000002

#define TIMER_MODE_GENERATE     0x00000000
#define TIMER_MODE_CAPTURE      0x00000001

#define timerEnableMask 0x000004D2
#define timerClearMask  0x000005D2

// Timer Control Structure
typedef struct {
    volatile int *timer_control; //  = (int*)0x80200000;
    volatile int *timer_load;  //    = (int*)0x80200004;
    volatile int *timer_data;//      = (int*)0x80200008;
} xps_timer_t;

void xps_timer_create (xps_timer_t * timer, int * base_addr)
{
    // Initialize structure pointers
    timer->timer_control    = (int*)(base_addr);
    timer->timer_load       = (int*)(base_addr + 1);
    timer->timer_data       = (int*)(base_addr + 2);
}

void xps_timer_write_control (xps_timer_t * timer, int val)
{
    // Clear the timer
    *timer->timer_control = val;
}

int xps_timer_read_control (xps_timer_t * timer)
{
    return (*timer->timer_control);
}

void xps_timer_start (xps_timer_t * timer)
{
    int val = TIMER_MODE_GENERATE | TIMER_COUNT_UP | TIMER_GENERATE_DISABLE | TIMER_CAPTURE_DISABLE | TIMER_INTERRUPT_DISABLE | TIMER_ENABLE;

    // Set load to 0 and start timer
    *timer->timer_load = 0;
    xps_timer_write_control(timer, val);
}

int xps_timer_read_counter (xps_timer_t * timer)
{
    return (*timer->timer_data);
}


int my_array[ARR_LENGTH];

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
// checks whether data is sorted
int check_data( unsigned int *data, unsigned int size )
{
    int i;

    for ( i = 0; i < size - 1; i++ ) {
        if ( data[i] > data[i + 1] ) {
            return -1;
        }
    }
/*    for ( i = 0; i < size; i++ ) {
        xil_printf("Data[%d] = %d\r\n",i,data[i]);
    }
*/
    return 0;
}

int main()
{
	xps_timer_t timer;
    int time_start, time_stop;
    int x;

    xil_printf("\r\n Hthreads Test begin (array @ 0x%08x)...\r\n",(unsigned int)&my_array[0]);
    for (x = 0; x < ARR_LENGTH; x++)
    {
        my_array[x] = ARR_LENGTH - x;
    }

    // Setup cache...
    XCache_EnableICache(0xc0000001);
    //XCache_DisableICache();
    XCache_EnableDCache(0xc0000001); print("Data cache enabled~\r\n");
    //XCache_DisableDCache(); print("Data cache disabled~\r\n");

	// Create timer
	xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);

    // Grab first time point
    time_start = xps_timer_read_counter(&timer);

    // Perform test
    bubblesort((unsigned int*)my_array,ARR_LENGTH);

    // Grab last time point
    time_stop = xps_timer_read_counter(&timer);

    xil_printf("Start time = %d\r\n",time_start);
    xil_printf("Stop time  = %d\r\n",time_stop);
    xil_printf("Time diff  = %d\r\n",(time_stop - time_start));
    xil_printf("  Check data = %d\r\n",check_data((unsigned int*)my_array,ARR_LENGTH));
    return 0;
}
