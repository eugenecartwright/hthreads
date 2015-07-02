/* Eugene Cartwright */
#include <hthread.h>
#include <stdio.h>
#define HARDWARE_THREAD
#define NUM_TRIALS          (10)
#define DEBUG_DISPATCH

typedef struct
{
    int arg0;
    int arg1;
    int arg2;
    int arg3;
    int arg4;
} package;

void * delay() {
    
    volatile int e, x = 0,y = 0;
    for (e = 0; e < 1000000; e++) 
    {
        x+=y;
        x+=2;
    }
    return (void *) 1;
}

void * foo_thread(void * arg) 
{
    int * p = (int *) arg;
    int a,b,c,d,value=0;
    
    //delay();
    
    a = *(p+0); //1
    b = *(p+1); //400
    value+=(a*b);
    c = *(p+2); //2
    d = *(p+3); //380
    value+=(c*d)+*(p+4);
    
    return (void *) value;
}

#ifndef HETERO_COMPILATION
#include "ml605_test_prog.h"

int main(){

    printf("HOST: START\n");
    int i = 0;
    int ret[NUM_AVAILABLE_HETERO_CPUS];
    printf("HOST: Creating thread & attribute structures\n");
    hthread_t * child = (hthread_t *) malloc(sizeof(hthread_t) * NUM_AVAILABLE_HETERO_CPUS);
    hthread_attr_t * attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * NUM_AVAILABLE_HETERO_CPUS);

    printf("HOST: Setting up data package\n");
    
    package * thread_package = (package *) malloc(NUM_AVAILABLE_HETERO_CPUS*sizeof(package));
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
    {
        (thread_package+i)->arg0 = 1;
        (thread_package+i)->arg1 = 400;
        (thread_package+i)->arg2 = 2;
        (thread_package+i)->arg3 = 380;
        (thread_package+i)->arg4 = 0;
    }
    
    // Set up attributes for a hardware thread
    printf("HOST: Setting up Attributes\n");
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)
    { 
        hthread_attr_init(&attr[i]);
        hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
    }

   // Creating threads
   printf("Creating threads...\n");
   int j;
   for (j = 0; j < NUM_TRIALS; j++) 
   {
       for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
       {
       ((thread_package+i)->arg4)++;
#ifndef HARDWARE_THREAD
           if (hthread_create(&child[i],&attr[i],foo_thread, (void *)(thread_package+i))) 
           {
               printf("hthread_create error on HW THREAD %d\n", i);
               while(1);
           }
#else
           //microblaze_create(&child[i],&attr[i],foo_thread_FUNC_ID, (void *)(thread_package+i),i);
           thread_create(&child[i],&attr[i],foo_thread_FUNC_ID, (void *)(thread_package+i),STATIC_HW0+i,0);
#endif
       }
      
       // Joining threads
       for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
       {
           // Join on child thread
           if( hthread_join(child[i], (void *) &ret[i]))
           {
               printf("Error joining child thread\n");
               while(1);
           }
       }
       
       // Print out return value from each Hardware thread
       for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)
       {
           printf("Thread %02d Result = %02d\n",i,ret[i]);
       }
   }

   // Test Timer
   for (i = 0; i < 25; i++) {
      hthread_time_t start = hthread_time_get();
      hthread_time_t stop = hthread_time_get();
      hthread_time_t diff;
      hthread_time_diff(diff, stop, start); 
      printf("Time: = %f usec\n", hthread_time_usec(diff));
      printf("Time: = %f nsec\n", hthread_time_nsec(diff));
      printf("------------------------------\n");
   }
   printf("END\n");
   return 0;
}
#endif

