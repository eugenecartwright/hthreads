#include <htime.h>
#include <buffer.h>
#include <stdio.h>
#include <stdlib.h>
#include <consumer.h>
#include <producer.h>

// The number of 32-bit elements that the buffer can hold
#define BUFFER_SIZE     (16)

// The number of consumers that are spawned
#define CONSUMERS       (1)

// The number of producers that are spawned
#define PRODUCERS       (1)

// The number of elements each consumer/producer creates/consumes
#define ELEMENTS        (1024*1024)

// An array to store all of the consumer ids
hthread_t consumers[ CONSUMERS ];

// An array to store all of the producer ids
hthread_t producers[ PRODUCERS ];

// The consumer argument
consumer_t con;

// The producer argument
producer_t pro;

void create_buffer( buffer_t *buffer )
{
    int res;

    // Initialize the buffer
    res = buffer_init( buffer, BUFFER_SIZE );
    
    // Ensure that the buffer is valid
    if( res != 0 )
    {
        perror( "could not create buffer" );
        exit( 1 );
    }
}

void create_consumers( buffer_t *buffer )
{
    int i;

    // Create the consumer argument
    con.num    = ELEMENTS;
    con.buffer = buffer;

    // Create all of the consumer threads
    for( i = 0; i < CONSUMERS; i++ )
    {
        hthread_create( &consumers[i], NULL, consumer, &con );
    }
}

void create_producers( buffer_t *buffer )
{
    int i;

    // Create the consumer argument
    pro.num    = ELEMENTS;
    pro.buffer = buffer;

    // Create all of the consumer threads
    for( i = 0; i < PRODUCERS; i++ )
    {
        hthread_create( &producers[i], NULL, producer, &pro );
    }
}

void wait_consumers( void )
{
    int i;

    // Wait for all of the consumer threads
    for( i = 0; i < CONSUMERS; i++ )    hthread_join( consumers[i], NULL );
}

void wait_producers( void )
{
    int i;

    // Create all of the consumer threads
    for( i = 0; i < PRODUCERS; i++ )    hthread_join( producers[i], NULL );
}

int main( int argc, char *argv[] )
{
    buffer_t buffer;
    hthread_time_t start;
    hthread_time_t end;
    hthread_time_t diff;
    float          sec;

    // Get the current time
    hthread_time_get( &start );

    // Create the buffer
    create_buffer( &buffer );

    // Create all of the consumers
    create_consumers( &buffer );

    // Create all of the producers
    create_producers( &buffer );

    // Wait for all of the consumers to finish
    wait_consumers();

    // Wait for all of the producers to finish
    wait_producers();

    // Get the finish time
    hthread_time_get( &end );

    // Get the elapsed time
    hthread_time_diff( diff, end, start );
    sec = hthread_time_sec( diff );

    // Show statistics
    printf("Elements Produced: %d\n",ELEMENTS*PRODUCERS);
    printf("Elements Consumed: %d\n",ELEMENTS*CONSUMERS);
    printf("Bytes Produced:    %lu B\n",ELEMENTS*PRODUCERS*sizeof(int));
    printf("Bytes Consumed:    %lu B\n",ELEMENTS*CONSUMERS*sizeof(int));
    printf("Elapsed Time:      %.2f s\n",sec);
    printf("Produce Rate:      %.2f B/s\n",ELEMENTS*PRODUCERS*sizeof(int)/sec);
    printf("Consume Rate:      %.2f B/s\n",ELEMENTS*CONSUMERS*sizeof(int)/sec);

    // Exit the program
    return 0;
}
