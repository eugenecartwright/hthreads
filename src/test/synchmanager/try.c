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
#include <hthread.h>        // Standard hthread's functionality
#include <mutex/mutex.h>    // Low level mutex commands

#define MUTEX_MAX   64

void setkind( Huint kind )
{
    Huint mid;

    // Set the kind for all of the mutexes
    for( mid = 0; mid < MUTEX_MAX; mid++ )
    {
        _mutex_setkind( mid, kind );
    }
}

int main( int argc, char *argv[] )
{
    Huint mid;
    Huint sta;

    // Set the mutexes to fast locking semantics
    setkind( HTHREAD_MUTEX_FAST_NP );

    // Print out a banner for the first attempt
    printf( "----------------------------------------------------------------------\n" );
    printf( "- Fast Lock: First Try Lock Attempt                                  -\n" );
    printf( "----------------------------------------------------------------------\n" );

    // Lock all of the mutexes
    for( mid = 0; mid < MUTEX_MAX; mid++ )
    {
        // Attempt to acquire the mutex for thread id 0
        sta = _mutex_tryacquire( 0, mid );

        // Print out the status information that was returned
        printf( "TRY LOCK: (MID=%d) (STA=0x%8.8x)\n", mid, sta );
    }

    // Print out a banner for the second attempt
    printf( "----------------------------------------------------------------------\n" );
    printf( "- Fast Lock: Second Try Lock Attempt                                 -\n" );
    printf( "----------------------------------------------------------------------\n" );

    // Try to lock all of the mutexes again
    for( mid = 0; mid < MUTEX_MAX; mid++ )
    {
        // Attempt to acquire the mutex for thread id 0
        sta = _mutex_tryacquire( 0, mid );

        // Print out the status information that was returned
        printf( "TRY LOCK: (MID=%d) (STA=0x%8.8x)\n", mid, sta );
    }
    
    // Finish the program
	printf( "-- QED --\n" );

	return 1;
}
