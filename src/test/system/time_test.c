/*
 This simulates a scenarion where threads are running and another with the highest priority comes in.
 */

#include <stdio.h>
#include <hthread.h>
#include <string.h>
#include <arch/htime.h>

#define THREAD_NUM    3
#define MAX_PRI       0
#define LOWEST_PRI    127

/*********************
 FUNCTION DEFINITIONS
 ********************/

hthread_t create_new_thread(void *arg, void *thread);
void set_priority(hthread_t th, Hint pri);
void *interrupt_thread(void *arg);
void printTitle(char *title);
void wait(int seconds);


/*****
 MAIN
 ****/

typedef struct{
    int my_priority;
    int my_interrupt;
    int my_iter;
    char my_char;
} targ_t;

struct thread_compute{
    int a;
    int b;
    int c;
    int result;
};

struct thread_compute TC_INIT = {1,2,0,0};

//Global mutex
hthread_mutex_t mutex;

int main() {
    printf("Time Test...\n");
    arch_clock_t time1;
    arch_clock_t time2;
    int x = 0;

    while(1)
    {
        time1 = _arch_get_time();
        x++;
        time2 = _arch_get_time();

        printf("Time = %lu\n",(long unsigned int)(time2 - time1));
    }
    return 0; 
}



void wait(int seconds) {
    arch_clock_t stop_time;
   
    stop_time = _arch_get_time() + CLOCKS_PER_SEC * seconds;

    while(_arch_get_time() < stop_time) {
        int i;
        int a = 0;
        for(i = 0; i < 10000; i++) {
            a = a + 1;
        }
    }
}

