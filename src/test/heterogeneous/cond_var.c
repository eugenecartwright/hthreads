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
// File:     src/test/heterogenous/cond_var.c
// Author:    Abazar Sadeqian
// Date:     14 Nov 2012
//
// 
// Desc:   This code was first written to test HW threads, interacting with OPB_hwti in order to get the timing of cond_wait and cond_signal system calls.
           I tweaked it to be a hetergeneous application, testing hthread_cores.
	   Let us say we have 10 slave CPUs. This C application loops over all slaves and perform the follwoing tasks:
		1- Create a HW thread on Salve#i , and creates a SW thread to interact with.
		2- The HW thread and SW thread keeps signaling and waiting on each other for ITERATIN times.
		3- After joining on both hw and sw thread, we create another hw thread on next microblaze with a new Sw thread to interact with.
//
// How to use:  leave the Num_sw_threads to be always one. Just change the ITERAATION  any number you want. This can be used for a good stress test.  
		Currently, it is part of the "Comprehensive testing of hthreads"
		   
//
// revisions: 1- Create as many HW thread as number of slave microblazes, and run two  different complemntary worker thread on Slave and host.
	      2- This code can be executed on both Numa and SMP systems, Virtex6 and Virtex5 Boards with changeable number of Slaves.	


//Futuer work : 1- Generate more computaions of HW/SW threads interactions, for example HW/HW thread , SW/SW thread.
		2- Change to code to test Cond_Broadcast as well.
				
//###############################################################################*/


#include <stdio.h>
#include <hthread.h>
#include <stdlib.h>
#include <string.h>


#define NUM_SW_THREADS                     1 // It should be always one, for this test  
      
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


#define ITERATION 100
struct data {
	Huint size;
	hthread_mutex_t * myMutex1;
        hthread_cond_t  *myCond1;  
        hthread_mutex_t * myMutex2;
        hthread_cond_t  *myCond2;  
        Huint var1;
        Huint var2;

};


//===================================================================
// Slave thread
//===================================================================
void * worker_thread_1(void* arg)
{  
    struct data *  workerdata;
    workerdata = (struct data *) arg;
    //printf( "Software thread starting...\n" );
    int i;
    for (  i=0 ; i< ITERATION+1 ;i++)
    {

           /*cond wait*/                                           //printf( "starting Wait condition...\n" ); 
            hthread_mutex_lock( workerdata->myMutex2 );           // printf( "locked the mutex for waiting...\n" ); 
            workerdata->var2 = 1;
	    hthread_cond_wait(workerdata->myCond2,workerdata->myMutex2 );  
            workerdata->var2 = 2;
	    hthread_mutex_unlock( workerdata->myMutex2 );           //printf( "Unlocked the mutex after waiting...\n" );
          

            //cond signal           
            while (workerdata->var1 != 1) ;   
	    hthread_mutex_lock( workerdata->myMutex1 );	            // printf( "locked the mutex for signaling...\n" ); 
	    hthread_cond_signal(workerdata->myCond1); 
            workerdata->var1 =3;
	    hthread_mutex_unlock( workerdata->myMutex1 );          //  printf( "Unlocked the mutex after signaling...\n" );
           
     }

   return NULL; 
}

void * worker_thread_2(void* arg)
{  
    struct data *  workerdata;
    workerdata = (struct data *) arg;
    //printf( "Software thread starting...\n" );
    int i;
    for (  i=0 ; i< ITERATION+1 ;i++)
    {
	   //cond signal           
            while (workerdata->var2 != 1) ;   
	    hthread_mutex_lock( workerdata->myMutex2 );	            // printf( "locked the mutex for signaling...\n" ); 
	    hthread_cond_signal(workerdata->myCond2); 
            workerdata->var2 =3;
	    hthread_mutex_unlock( workerdata->myMutex2 );          //  printf( "Unlocked the mutex after signaling...\n" );

           /*cond wait*/                                           //printf( "starting Wait condition...\n" ); 
            hthread_mutex_lock( workerdata->myMutex1 );           // printf( "locked the mutex for waiting...\n" ); 
            workerdata->var1 = 1;
	    hthread_cond_wait(workerdata->myCond1,workerdata->myMutex1 );  
            workerdata->var1 = 2;
	    hthread_mutex_unlock( workerdata->myMutex1 );           //printf( "Unlocked the mutex after waiting...\n" ); 
           
     }

   return NULL; 
}

// Conditional includes
#ifndef HETERO_COMPILATION
#include "cond_var_prog.h"
#endif


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else


int main(int argc, char *argv[]) 
{	
	hthread_mutex_t mutex1,mutex2;
    	hthread_cond_t  cond1,cond2;
    	struct data	myData;
	Huint               i, j,retVal;  

	printf("Number of Slave CPU= %i , Number of Sw threads=%i , Number of iterations=%i \n",NUM_AVAILABLE_HETERO_CPUS, 1,ITERATION);
//=================================================================
// Allocate NUM_THREADS threads, AND Set up attributes for a hardware thread
//=================================================================
	hthread_t * tid = (hthread_t *) malloc(sizeof(hthread_t) * 2);
	hthread_attr_t * attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * 1);
	
	if ( tid == 0 	|| attr == 0 ) 
	   RETURN(MALLC_ERROR) 
	
	for (i = 0; i < 1; i++)	{ 
		hthread_attr_init(&attr[i]);
		hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
	}

        printf("Allocating  thread ids...... Finished\n");
//=================================================================
// Initializing data
//=================================================================
	hthread_mutex_init( &mutex1, NULL );
        hthread_cond_init( &cond1, NULL );
        hthread_mutex_init( &mutex2, NULL );
        hthread_cond_init( &cond2, NULL );
       
	myData.myMutex1 = &mutex1;
        myData.myCond1 = &cond1;
        myData.myMutex2 = &mutex2;
        myData.myCond2 = &cond2;
        myData.size = ITERATION;
        myData.var1 = 0;
	myData.var2 = 0;

        /*printf( "Struct address is %x\n", (Huint)&myData );
	printf( "Mutex1 address is %x\n", (Huint)myData.myMutex1 );
        printf( "Cond1 address is %x\n", (Huint)myData.myCond1 );
        printf( "Mutex2 address is %x\n", (Huint)myData.myMutex2 );
        printf( "Cond2 address is %x\n", (Huint)myData.myCond2 );*/	

      printf("Initializing data .......Finished\n");

//=================================================================
// Creating  one HW  and  one sw thread; then join on them
//=================================================================
	for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) 
	{

                #ifdef SPLIT_BRAM 
		if (microblaze_create_DMA( &tid[0], &attr[0], worker_thread_1_FUNC_ID, (void*)(&myData), 0,0,i) ) 
                #else
 		if (microblaze_create( &tid[0], &attr[0], worker_thread_1_FUNC_ID, (void*)(&myData), i) ) 
                #endif 
			RETURN(THREAD_HARDWARE_CREATE_FAILED)
	
		if (hthread_create( &tid[1], NULL, worker_thread_2, (void*)(&myData)) )			
			RETURN(THREAD_SOFTWARE_CREATE_FAILED);	

		if (hthread_join(tid[0], (void *) &retVal ))          
			RETURN(THREAD_HARDWARE_JOIN_FAILED)
		if (hthread_join(tid[1], (void *) &retVal ))	
	      		RETURN(THREAD_SOFTWARE_JOIN_FAILED)
 	}     
        
	printf("Creating HW  and sw threads and joining on them....... Finished \n");
	
//=================================================================
// Test to see if the test failed or no ( The job is done?)
//=================================================================  
	//Since we joined, that means the job is done;
	printf("Testing to see if the job is done........... Finished \n");	
//=================================================================
// Free the used resources and declare Sucess
//=================================================================  
	for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)	
		hthread_attr_destroy( &attr[i] );  
	
         RETURN(TEST_PASSED)
}

#endif
