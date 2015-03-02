/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
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
*     * Neither the name of the University of Kansas nor the name of the
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

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>

#define FACTMAX 7

/*
   Factorial Test - uses create, join, exit, and thread return values
   ------------------------------------------------------------------

   */


// Factorial data structure (thread argument)
// ***************************************************
struct factorial {
	Huint factNum;
	Huint factVal;
};


// findFactorial thread implementation
// ***************************************************
void* findFactorial(void * arg) {
	hthread_t threadOne;
    Huint ret;
	struct factorial * fact;
	struct factorial factNext;
    
    // Extract thread argument
    fact = (struct factorial *) arg;
    printf( "Factorial: %d\n", fact->factNum );
    
    // Check for base case of factorial
    if (fact->factNum == 0 || fact->factNum == 1) {
        // Base case
		fact->factVal = 1;
	} else {
        // Recursive case
		factNext.factNum = fact->factNum - 1;                               // Setup child thread's factorial parameter
		printf( "  Creating thread for factorial %d\n", factNext.factNum );
		hthread_create(&threadOne, NULL, findFactorial, (void*)&factNext);  // Create child thread and pass its parameter
		printf( "  Joining thread for factorial %d\n", factNext.factNum );
		hthread_join(threadOne, (void*)&ret);                               // Join child thread and gather its return value
		fact->factVal = ret * fact->factNum;                                // Calculate the factorial value
	}

	printf( "  Returning ..." );
	return (void*)fact->factVal;                                            // Return the factorial value
}

// Main Program
// ***************************************************
int main (int argc, char *argv[]) {
	hthread_t thread;
	struct factorial fact;
    Huint factArray[FACTMAX];
	Huint i;
    Huint ret;

    // Setup cache
    //XCache_EnableICache(0xC0000001);
    //XCache_DisableDCache();

    // Caluclate factorials
    printf("\n\nCalculating Factorials...\n");
    printf("\tThread Identifer Address = 0x%08x = ...\n",(unsigned int)&thread);
    for( i=0; i<FACTMAX; i++ ) { 
		fact.factNum = i;   // Initialize the factorial structure
		fact.factVal = 0;
        
		hthread_create(&thread, NULL, findFactorial, (void*)&fact);     // Create child thread and pass its factorial parameter
        printf("**** TID = %d\n",thread);
        hthread_join(thread, (void*)&ret);                              // Join child thread and gather its return value
		factArray[i] = ret;                                             // Store the return value
	}

    // Display results
    printf("Now Displaying Results...\n");
    for( i=0; i<FACTMAX; i++ ) {
		printf( "Factorial(%d) =  %d\n", i, factArray[i] );
	}
	printf( " - done -\n\n" );
	return 1 ;
}
