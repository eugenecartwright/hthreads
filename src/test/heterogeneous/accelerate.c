/* File: accelerate.c
 * Author: Eugene Cartwright 
 * Description: Modelled using Abazar's hw_acc.c file 
 * This is used to test the accelerator libraries for 
 * both host and slave processors. */
#include <hthread.h>
#include <stdio.h>
#include <accelerator.h>
#define HARDWARE_THREAD
//#define DYNAMIC
#define NUM_TRIALS          (1)
#define LIST_LENGTH         (10)
#define DEBUG_DISPATCH

#define TUNING

// Define only one at a time please
#define USER_SORT
//#define USER_CRC
//#define USER_VECTOR

//====================================================================================
// Author: Abazar
#define G_INPUT_WIDTH   32
#define G_DIVISOR_WIDTH 4
#define ARRAY_SIZE      4092

typedef struct {
    Huint * startAddr;
    Huint * endAddr;    
} Data;

#ifdef USER_VECTOR
typedef struct {
	Huint * startAddr1;
	Huint * endAddr1;
	Huint * startAddr2;
	Huint * endAddr2;
	Huint * startAddr3;
	Huint * endAddr3;	
} Data3;
#endif
//====================================================================================
#ifdef USER_SORT
void * sort_thread(void * arg) 
{
    // Get size of list
    unsigned int size = LIST_LENGTH;
    // Call sort
    if (sort(arg, (Huint) size))
        return (void *) FAILURE;
    else
        return (void *) SUCCESS;
}
#endif

#ifdef USER_CRC
void * crc_thread(void * arg) 
{
    Data * package = (Data *) arg;

    // Get size of list
    unsigned int size = ARRAY_SIZE;
    
    // Call sort
    if (crc((void *) package->startAddr, (Huint) size))
        return (void *) FAILURE;
    else
        return (void *) SUCCESS;
}
#endif

#ifdef USER_VECTOR
void * vector_add_thread(void * arg) 
{
    Data3 * package = (Data3 *) arg;

    // Get size of list
    unsigned int size = ARRAY_SIZE;
    
    // Call sort
    if (vector_add((void *) package->startAddr1,(void *) package->startAddr2, (void *) package->startAddr3, (Huint) size))
        return (void *) FAILURE;
    else
        return (void *) SUCCESS;
}
#endif



#ifndef HETERO_COMPILATION
#include "accelerate_prog.h"
#include <arch/htime.h>
#endif

#ifdef HETERO_COMPILATION
int main() { return 0; }
#else
int main(){

    printf("HOST: START\n");
    int i = 0; unsigned int j = 0;
    int ret[NUM_AVAILABLE_HETERO_CPUS];

    printf("HOST: Creating thread & attribute structures\n");
    hthread_t * child = (hthread_t *) malloc(sizeof(hthread_t) * NUM_AVAILABLE_HETERO_CPUS);
    hthread_attr_t * attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * NUM_AVAILABLE_HETERO_CPUS);

    printf("HOST: Setting up data package\n");
    
#ifdef USER_SORT
    int list[NUM_AVAILABLE_HETERO_CPUS][LIST_LENGTH];

    // initialized the list (would be nice for randomness)
    unsigned int index = 0, h = 0;
    for (h = 0; h < NUM_AVAILABLE_HETERO_CPUS; h++) {
        index = 0;
        for (i = LIST_LENGTH -1; i > -1; i--) {
            list[h][index++] = i;
        }
    }

    printf("&List[0] = 0x%08x\n", (unsigned int) &list[0]);
    printf("Printing original lists\n");
    for (h = 0; h < NUM_AVAILABLE_HETERO_CPUS; h++) {
        printf("List[%d]: ", h);
        for (i = 0; i < LIST_LENGTH; i++) {
            printf("..%d", list[h][i]);
        }
        printf("\n");
    }
#endif
#ifdef USER_CRC
    // =======================================================================
    // CRC setup
    // Author: Abazar
    Data input;
	input.startAddr = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint)); 
	input.endAddr = input.startAddr + ARRAY_SIZE - 1;

    Huint * ptr;
    for( ptr = input.startAddr; ptr <= input.endAddr; ptr++ ){*ptr = (rand() % 1000)*8;	}
    Huint * temp = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint)); 
    for ( j=0 ; j< ARRAY_SIZE;  j++){  
        *(temp+j) = gen_crc(*(input.startAddr+j));	
    }
#endif
#ifdef USER_VECTOR
    // =======================================================================
    // VECTOR setup
    // Author: Abazar
    Huint * ptr;
	Data3 input3[NUM_AVAILABLE_HETERO_CPUS];
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        input3[i].startAddr1 = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint)); 	
        input3[i].endAddr1 = input3[i].startAddr1 + ARRAY_SIZE - 1;
        input3[i].startAddr2 = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint)); 	
        input3[i].endAddr2 = input3[i].startAddr2 + ARRAY_SIZE - 1;
        input3[i].startAddr3 = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint)); 	
        input3[i].endAddr3 = input3[i].startAddr3 + ARRAY_SIZE - 1;
        
        for( ptr = input3[i].startAddr1; ptr <= input3[i].endAddr1; ptr++ ){*ptr = rand() % 1000;	/* printf( " %i \n",*ptr );*/} 
        for( ptr = input3[i].startAddr2; ptr <= input3[i].endAddr2; ptr++ ){*ptr = rand() % 1000;	/* printf( " %i \n",*ptr );*/}
    }    
#endif

    // Set up attributes for a hardware thread
    printf("HOST: Setting up Attributes\n");
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)
    { 
        hthread_attr_init(&attr[i]);
        hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
    }
    

    // -----------------------------SORT--------------------------//
#ifdef USER_SORT
    // Creating threads
   printf("Creating threads...\n");
   for (j = 0; j < NUM_TRIALS; j++) 
   {
       for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
       {
#ifndef HARDWARE_THREAD
           if (thread_create (&child[i],
                       &attr[i],
                       sort_thread_FUNC_ID, 
                       (void *)(&list[i][0]),
                       SOFTWARE_THREAD,
                       0)) 
          {
               printf("hthread_create error on HW THREAD %d\n", i);
               while(1);
           }
#else
    #ifdef  DYNAMIC
           thread_create(
                   &child[i],
                   &attr[i],
                   sort_thread_FUNC_ID, 
                   (void *)(&list[i][0]),
                   DYNAMIC_HW,
                   (Huint) 0);
    #else
           thread_create(
                   &child[i],
                   &attr[i],
                   sort_thread_FUNC_ID, 
                   (void *)(&list[i][0]),
                   STATIC_HW0 + i,
                   0);
    #endif
#endif
       }
#endif
   
    // -----------------------------CRC--------------------------//
#ifdef USER_CRC
    // Creating threads
    printf("Creating threads...\n");
    for (j = 0; j < NUM_TRIALS; j++) 
    {
        for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
        {
#ifndef HARDWARE_THREAD
            if (thread_create (&child[i],
                        &attr[i],
                        crc_thread_FUNC_ID, 
                        (void *)(&input),
                        SOFTWARE_THREAD,
                        0)) 
            {
                printf("hthread_create error on HW THREAD %d\n", i);
                while(1);
            }
#else
    #ifdef  DYNAMIC
            thread_create(
                   &child[i],
                   &attr[i],
                   crc_thread_FUNC_ID, 
                   (void *)(&input),
                   DYNAMIC_HW,
                   0);
    #else
            thread_create(
                   &child[i],
                   &attr[i],
                   crc_thread_FUNC_ID, 
                   (void *)(&input),
                   STATIC_HW0 + i,
                   0);
    #endif
#endif
        
       }
#endif
        // -----------------------------VECTOR--------------------------//
#ifdef USER_VECTOR
    // Creating threads
    printf("Creating threads...\n");
    for (j = 0; j < NUM_TRIALS; j++) 
    {
        for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
        {
#ifndef HARDWARE_THREAD
            if (thread_create (&child[i],
                        &attr[i],
                        vector_add_thread_FUNC_ID, 
                        (void *)(&input3[i]),
                        SOFTWARE_THREAD,
                        0)) 
            {
                printf("hthread_create error on HW THREAD %d\n", i);
                while(1);
            }
#else
    #ifdef  DYNAMIC
            thread_create(
                   &child[i],
                   &attr[i],
                   vector_add_thread_FUNC_ID, 
                   (void *)(&input3[i]),
                   DYNAMIC_HW,
                   0);
    #else
            thread_create(
                   &child[i],
                   &attr[i],
                   vector_add_thread_FUNC_ID, 
                   (void *)(&input3[i]),
                   STATIC_HW0 + i,
                   0);
    #endif
#endif
        
       }
#endif
        
       // Joining threads
       for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
       {
           // Join on child thread
           if( hthread_join(child[i], (void *) &ret[i]))
           {
               printf("Error joining child thread\n");
               while(1);
           }
           //printf("Thread %02d Result = %d\n",i,ret[i]);
           printf("Thread %02d Result = 0x%08x\n",i,(unsigned int) ret[i]);
       }
       
	
#ifdef USER_CRC
      // For CRC Results
              
       Huint passed=0;
       for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)
       {
           for ( j=0 ; j< ARRAY_SIZE;  j++) { 
               if ( *(input.startAddr+j)   !=   *(temp+j) )  {
                   passed=1;
                }
           } //the crc'ed of crce'd data sould be 0;
           if (!passed)
               printf( "CRC    on microblaze %i , passed\n", i);
           else
               printf( "CRC    on microblaze %i , failed\n", i);
       }
       free(input.startAddr);
#endif

#ifdef USER_VECTOR
       Huint passed=0;
       //Huint error_count = 0;
       for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)
       {
           for ( j=0 ; j< ARRAY_SIZE;  j++) {
               if ( (input3[i].startAddr3[j])   !=   (input3[i].startAddr1[j] + input3[i].startAddr2[j])  )  {
                   passed=1;
                   //error_count++;
                }
           } //the crc'ed of crce'd data sould be 0;
           if (!passed)
               printf( "VECTOR ADD   on microblaze %i , passed\n", i);
           else
               printf( "VECTOR ADD   on microblaze %i , failed\n", i);
           free(input3[i].startAddr1);
           free(input3[i].startAddr2);
           free(input3[i].startAddr3);
       }
       //printf("Amount of errors = %u\n", error_count);
       
#endif

#ifdef USER_SORT 
       index = 0; h = 0;
    
       printf("Now checking the lists\n");
       for (h = 0; h < NUM_AVAILABLE_HETERO_CPUS; h++) {
           printf("List[%d]: ", h);
           for (i = 0; i < LIST_LENGTH; i++) {
               printf("..%d", list[h][i]);
           }
           printf("\n");
       }
#endif

   }
   
   printf("END\n");
   return 0;
}
#endif

