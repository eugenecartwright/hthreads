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

#include <buffer.h>
#include <consumer.h>

void* consumer( void *arg )
{
    Hint        num;
    Hint        tot;
    Hint        val;
    hthread_t   id; 

    // Cast the argument to a buffer structure
    buffer_t *data;
    data = (buffer_t*)arg;

    // Get the thread id of this thread
    id = hthread_self();

    // Print out that we are starting
    TRACE3_PRINTF( "CONSUMER %d: (OP=START)\n", (int)id );

    num = 0;
    while( 1 )
    {
        // Read a value out of the buffer
        tot = buffer_get( data, &val );

        // Check if there was an error reading the value
        if( tot < -1 )   DEBUG_PRINTF( "ERROR: (OP=BUFFER GET) (STA=0x%8.8x)\n", tot );

        // Check to see if we should exit
        if( tot == -1 ) break;

        // Print out a message
        TRACE4_PRINTF( "CONSUMER %d: (READ=%d) (TOT=%d) (NUM=%d)\n", (int)id, val, tot, num );

        // Increment the number of values that we have read
        num += 1;
    }

    // Print out that we are exiting
    TRACE3_PRINTF( "CONSUMER %d: (OP=EXIT)\n", (int)id );

    // Print out how many value that we consumed
    TRACE1_PRINTF( "CONSUMER %d: (OP=NUM) (VAL=%d)\n", (int)id, num );

    // Return the number of items we produced
    return (void*)num;
}
