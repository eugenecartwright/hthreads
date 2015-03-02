/*

   Library for accessing the Xilinx Timer

   The Xilinx Timer is a 32-bit timer capable of generating interrupts if needed

   */

#include "xil_timing.h"

#define TIMER_BASE      (0x73000000)
#define TIMER_CONTROL   (TIMER_BASE + 0)
#define TIMER_LOAD      (TIMER_BASE + 4)
#define TIMER_DATA      (TIMER_BASE + 8)
  
typedef struct targ
{
    unsigned int start;
    unsigned int stop;
}threadarg_t;

// Function used to enable the Xilinx Timer
void enableTimer(void)
{
    volatile unsigned int *timerControl   = (unsigned int *) TIMER_CONTROL;
    volatile unsigned int *timerLoad	  = (unsigned int *) TIMER_LOAD;

    *timerLoad    = 0x00000000; // Set period to max-period (when counting up, re-load value should be all 0's)
    *timerControl = 0x590;      // Set timer to be enabled, no interrupts, up counter, auto-reload
}

// Function used to read the current counter value within the Xilinx Timer
unsigned int readTimer(void)
{
   volatile unsigned int *timerData      = (unsigned int *) TIMER_DATA;

   return (*timerData); 
}

// Thread used to read 2 consecutive timer entries
void * junkThread (void * arg)
{
   threadarg_t * targ = (threadarg_t *)arg;

   enableTimer();

   targ->start = readTimer();
   targ->stop = readTimer();

   return 0;
}
