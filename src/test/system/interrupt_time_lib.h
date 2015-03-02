/* 
--------------------------------
   XPS Timer Library
--------------------------------
   Written by Jason Agron
--------------------------------
 */

// ********************************************
// Timer Control Status Register Masks
// ********************************************
#define TIMER_ENABLE                0x00000080
#define TIMER_DISABLE               0x00000000

#define TIMER_INTERRUPT_ENABLE      0x00000040
#define TIMER_INTERRUPT_DISABLE     0x00000000

#define TIMER_LOAD                  0x00000020
#define TIMER_NO_LOAD               0x00000000

#define TIMER_RELOAD                0x00000010
#define TIMER_HOLD                  0x00000000

#define TIMER_CAPTURE_ENABLE        0x00000008
#define TIMER_CAPTURE_DISABLE       0x00000000

#define TIMER_GENERATE_ENABLE       0x00000004
#define TIMER_GENERATE_DISABLE      0x00000000

#define TIMER_COUNT_UP              0x00000000
#define TIMER_MODE_DOWN             0x00000002

#define TIMER_MODE_GENERATE         0x00000000
#define TIMER_MODE_CAPTURE          0x00000001

#define TIMER_CLEAR_INTERRUPT       0x00000100

// ********************************************
// Timer Control Structure
// ********************************************
typedef struct {
    volatile unsigned int *timer_control; //  = (unsigned int*)0x80200000;
    volatile unsigned int *timer_load;  //    = (unsigned int*)0x80200004;
    volatile unsigned int *timer_data;//      = (unsigned int*)0x80200008;
} xps_timer_t;

// ********************************************
// Timer Functions
// ********************************************

void xps_timer_clear_interrupt (xps_timer_t * timer)
{
    // Read-modify-write of the timer control register to clear the interrupt bit
    unsigned int temp = *timer->timer_control;
    *timer->timer_control = temp | TIMER_CLEAR_INTERRUPT;
}

void xps_timer_write_control (xps_timer_t * timer, unsigned int val)
{
    // Clear the timer
    *timer->timer_control = val;
}

void xps_timer_create (xps_timer_t * timer, unsigned int * base_addr)
{
    // Initialize structure pounsigned inters
    timer->timer_control    = (unsigned int*)(base_addr);
    timer->timer_load       = (unsigned int*)(base_addr + 1);
    timer->timer_data       = (unsigned int*)(base_addr + 2);

    // Initialize control
    xps_timer_write_control(timer, (TIMER_DISABLE | TIMER_INTERRUPT_DISABLE));

    // Clear interrupts, if any
    xps_timer_clear_interrupt(timer);
}

unsigned int xps_timer_read_control (xps_timer_t * timer)
{
    // Return the timer control value
    return (*timer->timer_control);
}

void xps_timer_start (xps_timer_t * timer, unsigned int reload_value, unsigned int control_settings)
{

    // Clear interrupts, if any
    //xps_timer_clear_interrupt(timer);

    // Load reload value and set LOAD timer
    *timer->timer_load = reload_value;
    xps_timer_write_control(timer, TIMER_LOAD);

    // Then de-assert LOAD (as specified on page 2 under "Characteristics" of XPS Timer Document)
    xps_timer_write_control(timer, TIMER_NO_LOAD);

    // Enable timer with desired control settings
    // An example control_setting could be --> (TIMER_MODE_GENERATE | TIMER_COUNT_UP | TIMER_GENERATE_DISABLE | TIMER_CAPTURE_DISABLE | TIMER_INTERRUPT_ENABLE | TIMER_ENABLE | TIMER_RELOAD)
    xps_timer_write_control(timer, (TIMER_ENABLE | control_settings));
}

unsigned int xps_timer_read_counter (xps_timer_t * timer)
{
    // Return timer counter value
    return (*timer->timer_data);
}

void xps_timer_show_info( xps_timer_t * timer)
{
    printf("Timer Info:\n");
    printf("\t CONTROL = 0x%08x\n",(unsigned int)timer->timer_control);
    printf("\t LOAD    = 0x%08x\n",(unsigned int)timer->timer_load);
    printf("\t DATA    = 0x%08x\n",(unsigned int)timer->timer_data);
}
