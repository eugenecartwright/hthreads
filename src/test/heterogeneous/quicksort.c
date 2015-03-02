/************************************************************************************
* Copyright (c) 2012, University of Arkansas, Fayetteville - CSDL lab ,http://hthreads.csce.uark.edu
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Arkansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

/*###############################################################################
// File:     src/test/heterogenous/quicksort.c
// Author:   Unknown ( original file was hwti_sort.c)
// Date:     14 Nov 2012
//
// Revised by: Abazar Sadeqian
//
// Desc:   First, creates  N= NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS threads. Num_sw_threads is an arbitrary value, but Num_hetero_cpus is based on HW platform.
	   Then, it  file creates N vectors with size= arraysize and fills them with random values( N= total number of threads) ;	
           Each array is assigned to one of the sw/hw threads to sort. Finally, the main joins on all threads and checks to see if the sorting is done .
	   Attention: Each thread works by its own to sort the designated vector.	 
//
// How to use:  define NUM_SW_THREADS to number of sw threads, define ARRAYSIZE to  size of the vector.    
		Currently, it is part of the "Comprehensive testing of hthreads"
		   
//
// revisions: 1- Change the original C application to Heterogenous Application 
//	      2- create N vectors filled with random values to sort, in order to feed all SW/HW threads.
	      3- This code can be executed on both Numa and SMP systems, Virtex6 and Virtex5 Boards with changeable number of Slaves.		
				
//###############################################################################*/


#include <stdio.h>
#include <hthread.h>
#include <stdlib.h>
#include <string.h>


#define NUM_SW_THREADS                      NUM_AVAILABLE_HETERO_CPUS  
      
#define TEST_PASSED                         0

#define THREAD_SOFTWARE_CREATE_FAILED       2
#define THREAD_SOFTWARE_JOIN_FAILED         3

#define THREAD_HARDWARE_CREATE_FAILED       4
#define THREAD_HARDWARE_JOIN_FAILED         5 

#define THREAD_HARDWARE_INCORRECT_RETURN    6
#define THREAD_SOFTWARE_INCORRECT_RETURN    7

#define FINAL_JOIN_ERROR                    8

#define TEST_FAILED                         9

#define MALLC_ERROR                         10

#define RETURN(x)                          { printf("%d\n",x); \
                                            printf("END\n"); \
                                            return x;}


#define ARRAY_SIZE 500
struct sortData {
    Huint * startAddr;
    Huint * endAddr;
    Huint cacheOption;
};


void quickSort(Huint * startPtr, Huint * endPtr) {
	Huint pivot;
	Huint * leftPtr, * rightPtr;
	Huint temp, * tempPtr;

	//fflush( stdout );
	if ( startPtr == endPtr ) { return; }

	leftPtr = startPtr;
	rightPtr = endPtr;

	pivot = (*leftPtr + *rightPtr)/2;

	while (leftPtr < rightPtr) {
		while ((leftPtr < rightPtr) && (*leftPtr <= pivot) ) {
			leftPtr++;
		}

		while((leftPtr <= rightPtr) && (*rightPtr > pivot) ) {
			rightPtr--;
		}

		if ( leftPtr < rightPtr ) {
			temp = *leftPtr;
			*leftPtr = *rightPtr;
			*rightPtr = temp;
		}
	}
	
	if ( leftPtr == rightPtr ) {
		if ( *rightPtr >= pivot ) {
			leftPtr = rightPtr - 1;
		} else {
			rightPtr++;
		}
	} else {
		if ( *rightPtr > pivot ) {
			leftPtr = rightPtr - 1;
		} else {
			tempPtr = leftPtr;
			leftPtr = rightPtr;
			rightPtr = tempPtr;
		}
	}
	
	quickSort( rightPtr, endPtr );
	quickSort( startPtr, leftPtr );
}

//===================================================================
// Slave thread
//===================================================================
void * worker_thread(void* input)
{         
	struct sortData * data;
	Huint * startAddr, * endAddr;

	//printf( "Inside quickSortThread\n" );
	data = (struct sortData *) input;
	startAddr = data->startAddr;
	endAddr = data->endAddr;

	//fflush( stdout );
        quickSort( startAddr, endAddr );
   
	return NULL;

}


// Conditional includes
#ifndef HETERO_COMPILATION
#include "quicksort_prog.h"
#endif


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else


int main(int argc, char *argv[]) 
{	
 	struct sortData input[NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS];
	Huint               i, j,retVal;  

	printf("Number of Slave CPU= %i , Number of Sw threads=%i , Size of the array=%i \n",NUM_AVAILABLE_HETERO_CPUS, NUM_SW_THREADS,ARRAY_SIZE);
//=================================================================
// Allocate NUM_THREADS threads, AND Set up attributes for a hardware thread
//=================================================================
	hthread_t * tid = (hthread_t *) malloc(sizeof(hthread_t) * NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS);
	hthread_attr_t * attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * NUM_AVAILABLE_HETERO_CPUS);
	
	if ( tid == 0 	|| attr == 0 ) 
	   RETURN(MALLC_ERROR) 
	
	for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)	{ 
		hthread_attr_init(&attr[i]);
		hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
	}

        printf("Allocating NUM_THREADS threads...... Finished\n");
//=================================================================
//Initializing vectors data 
//=================================================================

	for (i=0; i<NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS; i++)
	{	
		input[i].startAddr = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint));   
		input[i].endAddr = input[i].startAddr + ARRAY_SIZE - 1;
		if ( input[i].startAddr == 0 ) 
	   		RETURN(MALLC_ERROR)	
	}

	Huint * ptr;
	for( i=0; i<NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS; i++ )
	{
		for( ptr = input[i].startAddr; ptr <= input[i].endAddr; ptr++ ) 
			*ptr = rand() % 1000;
	
		input[i].cacheOption = 0;
	}

	/*for (j=0; j<NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS; j++)
	{printf("*********************\n");
		for( i=0; i<(ARRAY_SIZE-1); i++ ) 
		printf("%i\n",* (input[j].startAddr+i));}*/

      printf("Initializing vectors data .......Finished\n");

//=================================================================
// Creating HW  and sw threads
//=================================================================
	

	for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
                #ifdef SPLIT_BRAM		
		if (microblaze_create_DMA( &tid[i], &attr[i], worker_thread_FUNC_ID, (void*)&input[i], 0,0,i) ) 
                #else
 		if (microblaze_create( &tid[i], &attr[i], worker_thread_FUNC_ID, (void*)&input[i], i) ) 
                #endif 
			RETURN(THREAD_HARDWARE_CREATE_FAILED)
      
	// software threads
	for (i = NUM_AVAILABLE_HETERO_CPUS; i < NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS; i++)	
		if (hthread_create( &tid[i], NULL, worker_thread, (void*)&input[i]) )			
			RETURN(THREAD_SOFTWARE_CREATE_FAILED);	
      
        
	printf("Creating HW  and sw threads....... Finished \n");
	
//=================================================================
//  Join on the threads.
//=================================================================       

    for (i = 0; i < NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS; i++)       
	    if (hthread_join(tid[i], (void *) &retVal ))
                if  (i<  NUM_AVAILABLE_HETERO_CPUS)       
            		RETURN(THREAD_HARDWARE_JOIN_FAILED)
		else
      			RETURN(THREAD_SOFTWARE_JOIN_FAILED)
            else
                  ;//printf("thread %i returned %i \n", i, retVal);
	
	printf("Joining on the threads........ Finished \n");
//=================================================================
// Test to see if the test failed or no ( The job is done?)
//=================================================================  
	for (j=0; j<NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS; j++)
	{
		for( i=0; i<(ARRAY_SIZE-1); i++ ) 		
                	 if  ((* (input[j].startAddr+i)) > (* (input[j].startAddr+i+1)))  
			 	RETURN(TEST_FAILED)
	}

	/*for (j=0; j<NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS; j++)
	{printf("*********************\n");
		for( i=0; i<(ARRAY_SIZE-1); i++ ) 
		printf("%i\n",* (input[j].startAddr+i));}*/



	printf("Testing to see if the job is done........... Finished \n");	
//=================================================================
// Free the used resources and declare Sucess
//=================================================================  
	for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)	
		hthread_attr_destroy( &attr[i] );  

	for (j=0; j<NUM_SW_THREADS+NUM_AVAILABLE_HETERO_CPUS; j++)
		free( input[j].startAddr) ; 
  
         RETURN(TEST_PASSED)
}


#endif
