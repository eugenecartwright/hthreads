#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <arch/arch.h>

#define PRINT
//#define YIELD
//#define SELF
#define ITERATIONS 10

struct simple_test 
{
    Huint val;
    hthread_mutex_t *mutex;
};

void* simple_thread(void * arg) 
{
    struct simple_test * simple;
	
    // Extract thread argument
    simple = (struct simple_test *) arg;

#ifdef PRINT	
    int * pic_0_addr = (void*)0x41200000;
    int * pic_1_addr = (void*)0x41210000;
    printf( "\n..................................\n");
    printf( "simple_thread: CPUID = %d\n", _get_procid());
    printf( "simple_thread: PIC 0 = 0x%8.8x\n",*pic_0_addr);
    printf( "simple_thread: PIC 1 = 0x%8.8x\n",*pic_1_addr);
    printf( "simple_thread: Val =  %d\n", simple->val );
#endif
    
    // Increment value
    simple->val = simple->val + 10; 

#ifdef YIELD    
    hthread_yield();
#endif

#ifdef SELF
    hthread_t self_test = hthread_self();
#ifdef PRINT
    printf("simple_thread: TID VERIFIED %d\n", self_test);
#endif
#endif		

    return (void*)simple->val;
}

int main (int argc, char *argv[]) 
{
    unsigned int start      = 0;
    unsigned int stop       = 0;
    hthread_t thread;
    struct simple_test simple;
    Huint i, j, ret;
	
for(j = 0; j < ITERATIONS; j++)
{

#ifdef PRINT	
    printf("\nStarting Simple Test...\n");
#endif	
    simple.val = 110;

    // Xilinx OPB Timer locations as specified in the .mhs file
    volatile int *timer_control = (int*)0x73000000;
    volatile int *timer_value   = (int*)0x73000008;

    // Enable timer and clear interrupt
    *timer_control = 0x00000510;

    // Start the timer
    start = *timer_value;

    for(i = 0; i < j+1; i++)
    {
	hthread_create(&thread, NULL, simple_thread, (void*)&simple); 
        hthread_join(thread, (void*)&ret);

#ifdef PRINT		
        printf( "main: CPUID = %d\n",_get_procid());
        printf( "main: Val =  %d\n", simple.val );
	printf( "..................................\n");
#endif	
    }

    // Stop timer
    stop = *timer_value;
    
    printf("Exec. Time = %d Iteration = %d\n",(stop-start),j);

#ifdef PRINT
    printf("Start Time = %u\n",start);
    printf("Stop Time  = %u\n",stop);
    printf("Exec. Time = %d\n",(stop-start));
    printf( "main: Val =  %d\n", simple.val );
    printf( "- done -\n\n" );
#endif
}
    return 0;
}
