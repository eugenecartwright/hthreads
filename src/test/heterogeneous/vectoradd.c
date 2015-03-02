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
// File:     src/test/heterogenous/vectoradd.c
// Author:   Unknown ( original file was matrixadd.c)
// Date:     14 Nov 2012
//
// Revised by: Abazar Sadeqian
//
// Desc:     This file creates two vectors with size= VECTORSIZE ;
	     Then creates NUM_SW_THREADS+NUM_HW_THREADS threads '
             All Sw and HW threads contribute to add these two vectors and put the result in third vector( using a mutex variable to synchronize). 
//
// How to use: define NUM_SW_THREADS to number of sw threads, define VECTORSIZE to  size of the vector.    
		Currently, it is part of the "Comprehensive testing of hthreads"
		   
//
// revisions: 1- Change the original C application to Heterogenous Application 
//	      2- Making arbitary  number of threads to perfom the vector add
	      3- This code can be executed on both Numa and SMP systems, Virtex6 and Virtex5 Boards with changeable number of Slaves		
				
//###############################################################################*/

#include <stdio.h>
#include <hthread.h>
#include <stdlib.h>
#include <string.h>


//#define NUM_SW_THREADS                     NUM_AVAILABLE_HETERO_CPUS
#define NUM_SW_THREADS                     3  
#define NUM_HW_THREADS                     3
//#define NUM_HW_THREADS                     NUM_AVAILABLE_HETERO_CPUS
      
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


//#define VECTORSIZE 100000
#define VECTORSIZE 100
struct matrix {
	Huint size;
	Huint index;
	Huint * X;
	Huint * Y;
	Huint * Z;
	hthread_mutex_t * matrixMutex;
};


//===================================================================
// Slave thread
//===================================================================
void * worker_thread(void* arg)
{  
        struct matrix * inputMatrix;
	Huint size, count, myindex, x, y;

	inputMatrix = (struct matrix *) arg;
	size = inputMatrix->size;
	count = 0;
        //xil_printf("SW thread is starting......\n");
	while ( 1 ) {
		
		hthread_mutex_lock( inputMatrix->matrixMutex );              
		myindex = inputMatrix->index;
		inputMatrix->index = myindex+1;
		hthread_mutex_unlock( inputMatrix->matrixMutex );
		hthread_yield();

		if ( myindex < size ) {
			x = inputMatrix->X[myindex];
			y = inputMatrix->Y[myindex];
			inputMatrix->Z[myindex] = x + y;
			count++;                                               
		} 
                else 	break;		
	}      

	return count;    
}

// Conditional includes
#ifndef HETERO_COMPILATION
#include "vectoradd_prog.h"
#endif


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else


int main(int argc, char *argv[]) 
{	
	hthread_mutex_t     mutex;
	struct matrix       matrixData;
	Huint               i, j,retVal;  

	printf("Number of HW threads= %i , Number of Sw threads=%i , Size of the Vector=%i \n",NUM_HW_THREADS, NUM_SW_THREADS,VECTORSIZE);
//=================================================================
// Allocate NUM_THREADS threads, AND Set up attributes for a hardware thread
//=================================================================
	hthread_t * tid = (hthread_t *) malloc(sizeof(hthread_t) * NUM_SW_THREADS+NUM_HW_THREADS);
	hthread_attr_t * attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * NUM_HW_THREADS);
	
	if ( tid == 0 	|| attr == 0 ) 
	   RETURN(MALLC_ERROR) 
	
	for (i = 0; i < NUM_HW_THREADS; i++)	{ 
		hthread_attr_init(&attr[i]);
		hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
	}

        printf("Allocating %i  threads...... Finished\n",NUM_SW_THREADS+NUM_HW_THREADS);
//=================================================================
// // 
//=================================================================
	hthread_mutex_init( &mutex, NULL );       
	matrixData.matrixMutex = &mutex;
	
	matrixData.size = VECTORSIZE;
	matrixData.index = 0;
	matrixData.X = (Huint *) malloc( sizeof( Huint ) * VECTORSIZE );
	matrixData.Y = (Huint *) malloc( sizeof( Huint ) * VECTORSIZE );
	matrixData.Z = (Huint *) malloc( sizeof( Huint ) * VECTORSIZE );
	
	if ( matrixData.X == 0 	|| matrixData.Y == 0|| matrixData.Z == 0 ) 
	   RETURN(MALLC_ERROR)	
	

	for( i = 0; i < VECTORSIZE; i++ ) {
		matrixData.X[i] = i;
		matrixData.Y[i] = i*2;
		matrixData.Z[i] = 0;	}

      printf("Initializing matrixData .......Finished\n");

//=================================================================
// Creating HW  and sw threads
//=================================================================
	hthread_mutex_lock(&mutex); //to make it fair for all

	for (i = 0; i < NUM_HW_THREADS; i++) 
                #ifdef SPLIT_BRAM		
		if (microblaze_create_DMA( &tid[i], &attr[i], worker_thread_FUNC_ID, (void*)(&matrixData), 0,0,i) ) 
                #else
 		if (microblaze_create( &tid[i], &attr[i], worker_thread_FUNC_ID, (void*)(&matrixData),i) ) 
                #endif 
			RETURN(THREAD_HARDWARE_CREATE_FAILED)
      
	// software threads
	for (i = NUM_HW_THREADS; i < NUM_SW_THREADS+NUM_HW_THREADS; i++)	
		if (hthread_create( &tid[i], NULL, worker_thread, (void*)(&matrixData)) )			
			RETURN(THREAD_SOFTWARE_CREATE_FAILED);	

      
        
	printf("Creating HW  and sw threads....... Finished \n");
	hthread_mutex_unlock(&mutex);
//=================================================================
//  Join on the threads.
//=================================================================       

    for (i = 0; i < NUM_SW_THREADS+NUM_HW_THREADS; i++)       
	    if (hthread_join(tid[i], (void *) &retVal ))
                if  (i<  NUM_HW_THREADS)       
            		RETURN(THREAD_HARDWARE_JOIN_FAILED)
		else
      			RETURN(THREAD_SOFTWARE_JOIN_FAILED)
            else
                  printf("thread %i returned %i \n", i, retVal);
	
	printf("Joining on the threads........ Finished \n");
//=================================================================
// Test to see if the test failed or no ( The job is done?)
//=================================================================  
	for( i = 0; i < VECTORSIZE; i++ ) 	
		if ( matrixData.Z[i] != 3 * i )
			 RETURN(TEST_FAILED)

	printf("Testing to see if the job is done........... Finished \n");	
//=================================================================
// Free the used resources and declare Sucess
//=================================================================  
	for (i = 0; i < NUM_HW_THREADS; i++)	
		hthread_attr_destroy( &attr[i] );  

	free( matrixData.X );
	free( matrixData.Y );
	free( matrixData.Z );
  
         RETURN(TEST_PASSED)
}

#endif
