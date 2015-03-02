#include "daemon/daemon.h"
#include "program.h"
#include "long_program.h"
#include "count.h"
#include "count2.h"
#include "mcc.h"
#include <stdio.h>
#include <hthread.h>

int main()
{
	DaemonComm dc;
    sched_param_t my_priority;
    Hint my_policy;

    // Display main thread's priority level
    hthread_getschedparam(hthread_self(),&my_policy,&my_priority);
    //printf("My priority = %d\n", my_priority.sched_priority);

    printf("\n\nSYSTEM STARTUP\n\n");

    printf("MAIN: init'ing daemon...\n");
    daemon_init(&dc);

    printf("MAIN: Running COUNT TO 10,000,000...\n");
    daemon_create_thread(&dc, count_prog, count_prog_size);

    printf("MAIN: Running COUNT TO 13,460,480...\n");
    daemon_create_hw_thread(&dc, count_prog2, count_prog_size2);

    printf("MAIN: Running COUNT TO 10,000,000...\n");
    daemon_create_hw_thread(&dc, count_prog, count_prog_size);

    printf("MAIN: Running FACTORIAL(4)...\n");
    daemon_create_hw_thread(&dc, long_program_array, long_prog_size);

    printf("MAIN: Running FACTORIAL(5)...\n");
    daemon_create_thread(&dc, program_array, prog_size);

    printf("MAIN: Running MCC(5)...\n");
    daemon_create_thread(&dc, mcc_program, mcc_size);

    while(1)
    {
        //printf("Main running for a timeslice\n");
        hthread_yield();
    }
	return 0;
}
