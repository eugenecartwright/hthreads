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

#include <prof.h>
#include <config.h>
#include <arch/htime.h>
#include <sys/time.h>

#define TIME_LOOPS          10000
#define PROFILE_TIMEAVG     1

#include <perf.h>

void raw( void )
{
    Huint           i;
    hthread_time_t  start;
    hthread_time_t  finish;
    hthread_time_t  diff;
    double          avg;

    avg = 0;
    for( i = 0; i < TIME_LOOPS; i++ )
    {
        // Perform two timing measurements as fast as possible
        hthread_time_get( &start );
        hthread_time_get( &finish );

        // Caclulate the difference
        hthread_time_diff( diff, finish, start );

        // Update the average
        avg += hthread_time_nsec( diff );
    }

    // Calculate the average
    avg /= TIME_LOOPS;

    // Show the average in nanoseconds
    printf( "Raw Average Time: %.1f ns\n", avg );
}

void std( void )
{
    Huint           i;
    struct timeval  start;
    struct timeval  finish;
    struct timeval  diff;
    double avg;

    avg = 0;
    for( i = 0; i < TIME_LOOPS; i++ )
    {
        // Perform two timing measurements as fast as possible
        gettimeofday( &start, NULL );
        gettimeofday( &finish, NULL );

        // Caculate the difference
        if( start.tv_usec > finish.tv_usec )
        { finish.tv_sec--; finish.tv_usec += 1000000; }

        diff.tv_sec = finish.tv_sec - start.tv_sec;
        diff.tv_usec = finish.tv_usec - start.tv_usec;

        // Caclulate the average
        avg += diff.tv_sec * 1000000 + diff.tv_usec;
    }

    avg /= TIME_LOOPS;
    printf( "Get Time of Day Average Time: %.1f ns\n", avg*1000 );
}

void avg( void )
{
    Huint           i;

    hprofile_avg_declare( TIMEAVG, time );
    hprofile_avg_create( TIMEAVG, time );

    for( i = 0; i < TIME_LOOPS; i++ )
    {
        // Perform two timing measurements as fast as possible
        hprofile_avg_start( TIMEAVG, time );
        hprofile_avg_finish( TIMEAVG, time );
    }

    // Show the average time
    hprofile_avg_flush( TIMEAVG, time, default, "time" );
    hprofile_avg_close( TIMEAVG, time );
}

int main( int argc, char *argv[] )
{
    printf( "Running timing tests...\n" );
    raw();
    std();
    avg();

    // Exit the main thread
	return 0;
}
