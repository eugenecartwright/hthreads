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
#include <buffer.h>
#include <producer.h>
#include <consumer.h>
#include <utilities.h>
#include <constants.h>

void children_init( hthread_t **consm, hthread_t **prodc, Huint *c, Huint *p )
{
    Huint i;

    // Initialize the number of children to zero
    *c = 0;
    *p = 0;

    // Loop over all streams and add in their consumer children
    for( i = 0; i < STREAMS; i++ )  *c += STREAM_CONSM[i];

    // Loop over all streams and add in their producer children
    for( i = 0; i < STREAMS; i++ )  *p += STREAM_PRODC[i];

    // Allocate the array of children
    *consm = malloc( sizeof(hthread_t) * (*c) );
    *prodc = malloc( sizeof(hthread_t) * (*p) );

    // Make sure the allocation was successful
    if( *consm == NULL )  DEBUG_PRINTF( "ERROR: (OP=CHILDREN) (STA=MALLOC FAILED)\n" );
    if( *prodc == NULL )  DEBUG_PRINTF( "ERROR: (OP=CHILDREN) (STA=MALLOC FAILED)\n" );
}

void children_destroy( hthread_t **consm, hthread_t **prodc )
{
    // Free the array of children
    free( *consm );
    free( *prodc );

    // Set the array of children to the default value
    *consm = NULL;
    *prodc = NULL;
}

Hint create_consumer( buffer_t *buffer, hthread_t *tid )
{
    Hint sta;

    // Attempt to create the thread
    sta = hthread_create( tid, NULL, consumer, (void*)buffer );

    // Check that the creation was successful
    if( sta != 0 )  DEBUG_PRINTF( "ERROR: (OP=CREATE) (STA=0x%8.8x)\n", sta );

    // Return the status back to the user
    return sta;
}

Hint create_producer( buffer_t *buffer, hthread_t *tid )
{
    Hint sta;

    // Attempt to create the thread
    sta = hthread_create( tid, NULL, producer, (void*)buffer );

    // Check that the creation was successful
    if( sta != 0 )  DEBUG_PRINTF( "ERROR: (OP=CREATE) (STA=0x%8.8x)\n", sta );

    // Return the status back to the user
    return sta;
}

int main( int argc, char *argv[] )
{
	Huint		i;
	Huint		j;
    Huint       t;
    //clock_t     s;
    //clock_t     e;
    Huint       sta;
    Huint       prodcs;
    Huint       consms;
    void        *retval;
    hthread_t   *consm;
    hthread_t   *prodc;
    buffer_t    buffers[ STREAMS ];

    // Capture the start time
    //s = clock();

    // Initialize the children information
    children_init( &consm, &prodc, &consms, &prodcs );

    // Create the bounded buffers
    TRACE2_PRINTF( "Initializing Streams...\n" );
    for( i = 0; i < STREAMS; i++ )
    {
        // Attempt the initialize the buffer
        sta = buffer_init( &buffers[i], STREAM_SIZES[i], STREAM_ENDS[i] );

        // Check if there was an error during initialization
        if( sta < 0 )   DEBUG_PRINTF( "ERROR: (OP=BUFFER INIT) (STA=0x%8.8x)\n", sta );
    }

    // Initialize the tid counter
    t = 0;

    // Create the consumers for each buffer
    TRACE2_PRINTF( "Initializing Consumers...\n" );

    for( i = 0; i < STREAMS; i++ )
    {
        for( j = 0; j < STREAM_CONSM[i]; j++ )
        {
            // Attempt to create the consumer
            sta = create_consumer( &buffers[i], &consm[t++] );
            TRACE5_PRINTF( "CONSUMER ID: %d\n", (int)consm[t-1] );

           // Check if there was an error during initialization
            if( sta < 0 )   DEBUG_PRINTF( "ERROR: (OP=CONSUMER) (STA=0x%8.8x)\n", sta );
        }
    }

    // Initialize the tid counter
    t = 0;

    // Create the producers for each buffer
    TRACE2_PRINTF( "Initializing Producers...\n" );
    for( i = 0; i < STREAMS; i++ )
    {
        for( j = 0; j < STREAM_PRODC[i]; j++ )
        {
            // Attempt to create the consumer
            sta = create_producer( &buffers[i], &prodc[t++] );
            TRACE5_PRINTF( "PRODUCER ID: %d\n", (int)prodc[t-1] );

            // Check if there was an error during initialization
            if( sta < 0 )   DEBUG_PRINTF( "ERROR: (OP=PRODUCER) (STA=0x%8.8x)\n", sta );
        }
    }

    // Join all of the producers
    TRACE2_PRINTF( "Waiting for Producers...\n" );
    for( i = 0; i < prodcs; i++ )
    {
        // Join the producer
        sta = hthread_join( prodc[i], &retval );

        // Check if there was an error during initialization
        if( sta != 0 )   DEBUG_PRINTF( "ERROR: (OP=JOIN) (STA=0x%8.8x)\n", sta );

        // Print out its return value
        printf( "PRODUCER %d: %d values produced\n", i, (Huint)retval );
    }
    
    // Join all of the consumers
    TRACE2_PRINTF( "Waiting for Consumers...\n" );
    for( i = 0; i < consms; i++ )
    {
        // Join the producer
        sta = hthread_join( consm[i], &retval );

        // Check if there was an error during initialization
        if( sta != 0 )   DEBUG_PRINTF( "ERROR: (OP=JOIN) (STA=0x%8.8x)\n", sta );

        // Print out its return value
        printf( "CONSUMER %d: %d values consumed\n", i, (Huint)retval );
    }

    // Capture the end time
    //e = clock();

    //printf( "Start Time: %ld\n", (long)s );
    //printf( "End Time: %ld\n", (long)e );

    // Print out a message that we are done
	printf( "-- QED --\n" );

    // Exit the program
	return 0;
}
