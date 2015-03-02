#include <hthread.h>
#include <sort.h>
#include <stdio.h>

// The size of the array to sort
#define SIZE        2*2*2*2*2*1000

// The minimum value to place in the array
#define MIN         0

// The maximum value to place in the array
#define MAX         1000

void run_sort( void )
{
    Hint        res;
    sort_t      sort;
    hthread_t   sorter;

    // Show the beginning message
    printf( "Running sort algorithm...\n" );

    // Initialize the sort algorithm
    sort_init();

    // Initialize and fill the array to sort
    sort_setup( &sort, SIZE );
    sort_fill( &sort, MIN, MAX );
    
    // Create a thread to sort the array
    hthread_create( &sorter, NULL, sort_thread, &sort );

    // Wait for the thread to finish sorting the array
    hthread_join( sorter, NULL );

    // Attempt to verify the sort
    res = sort_verify( &sort );

    // Print a message indicating success or failure
    if( res < 0 )   printf( "\tFAILED\n" );
    else            printf( "\tSUCCEEDED\n" );

    // Finish using the sort algorithm
    sort_finish();
}

int main( int argc, char **argv )
{
    // Run the sorting algorithm
    run_sort();
    
    // Show a message that we are done
    printf( "-- QED --\n" );

    // Return successfully
    return 0;
}
