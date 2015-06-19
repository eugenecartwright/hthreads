/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
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

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>

#define FIBMAX 6

void* findFibonacci(void * arg)
{
    Huint       num;
    void        *res1;
    void        *res2;
	hthread_t threadOne;
	hthread_t threadTwo;
    
    num = (Huint)arg;
	if( num <= 1)
    {
        return (void*)1;
	}
    else
    {
		hthread_create(&threadOne, NULL, findFibonacci, (void*)(num-1));
		hthread_create(&threadTwo, NULL, findFibonacci, (void*)(num-2));
        
		hthread_join(threadOne, (void**)&res1);
		hthread_join(threadTwo, (void**)&res2);

        return (void*)((Huint)res1 + (Huint)res2);
	}

	return NULL;
}

int main (int argc, char *argv[])
{
    Huint       i;
    void        *res;
	hthread_t   thread;

    // Calculate the fibonacci numbers
	for(i = 0; i < FIBMAX; i++)
    {
		hthread_create(&thread, NULL, findFibonacci, (void*)i );
		hthread_join(thread, &res);

        printf( "Fibonnaci of %u is %u\n", i, (Huint)res );
	}

	printf( "-- QED --\n\n" );
	return 0;
}
