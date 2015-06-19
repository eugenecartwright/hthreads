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

void xps_timer_clear_interrupt (xps_timer_t * timer)
{
#define CLEAR_INT   0x100
    int temp = *timer->timer_control;
    *timer->timer_control = temp | CLEAR_INT;
}


void xps_timer_start (xps_timer_t * timer)
{
    int val = TIMER_MODE_GENERATE | TIMER_COUNT_UP | TIMER_GENERATE_DISABLE | TIMER_CAPTURE_DISABLE | TIMER_INTERRUPT_ENABLE | TIMER_ENABLE | TIMER_RELOAD;

    // Set load to 0 and start timer
    *timer->timer_load = 0xdbcdabcd;
    xps_timer_write_control(timer, val);
}

int xps_timer_read_counter (xps_timer_t * timer)
{
    return (*timer->timer_data);
}

