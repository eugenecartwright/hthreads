#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>

void stream_buffers( stream_t *stream, int *min, int *max )
{
    stream_t *cur;

    *min = stream[0].input;
    *max = stream[0].input;
    for(cur = &stream[0]; cur->node.name != NULL; cur++)
    {
        if( cur->input < *min )  *min = cur->input;
        if( cur->output < *min ) *min = cur->output;

        if( cur->input > *max )  *max = cur->input;
        if( cur->output > *max ) *max = cur->output;
    }
}

int stream_buffer_exists( stream_t *stream, int num )
{
    stream_t *cur;

    // Buffer zero is special, it never exists
    if( num == 0 )  return 0;

    // Determine if the buffer is references some where in the stream
    for(cur = &stream[0]; cur->node.name != NULL; cur++)
    {
        if( cur->input == num )     return 1;
        if( cur->output == num )    return 1;
    }

    // The buffer was not referenced
    return 0;
}

void stream_buffer_show( stream_t *stream, int num )
{
    int      in;
    int      out;
    int      len;
    int      iloc;
    int      oloc;
    int      mid;
    int      done;
    int      ibefore;
    int      obefore;
    stream_t *cur;

    // Setup the default values
    in   = 0;
    out  = 0;
    len  = 0;
    iloc = 0;
    oloc = 0;

    // Determine how many stream nodes reference this buffer
    for( cur = &stream[0]; cur->node.name != NULL; cur++ )
    {
        if( strlen(cur->node.name) > len )  len = strlen(cur->node.name);
        if( cur->input == num )             in++;
        if( cur->output == num )            out++;
    }

    // Determine the middle number
    if( in > out )  { mid = in/2; ibefore = 0; obefore = in - mid; }
    else            { mid = out/2; ibefore = out - mid; obefore = 0; }

    // Show all of the streams that use this buffer
    while( in > 0 || out > 0 )
    {
        // Find the next input node
        while( in > 0 && stream[iloc].input != num ) iloc++;

        // Find the next output node
        while( out > 0 && stream[oloc].output != num ) oloc++;

        // Print the output node if we have one
        if( out > 0 )
        {
            // Determine the number of spaces already taken
            done = strlen( stream[oloc].node.name );

            // Fill in the input name with the required number of spaces
            while( done < len ) { printf( " " ); done++; }

            // Print out the name
            printf( "%s %d", stream[oloc].node.name, oloc );

            // Decrement the number of remaining output nodes
            out--;
        }
        else
        {
            // Setup the white space filling
            done = 0;

            // Fill in the input name with the required number of spaces
            while( done < len ) { printf( " " ); done++; }
        }


        // Print the buffer name
        if(ibefore == 1 || obefore == 1) printf( " -> buffer %2d -> ", num );
        else                             printf( "                   " );

        // Print the input name if we have one
        if( in > 0 ) {printf( "%s %d", stream[iloc].node.name, iloc ); in--;}

        // End this line
        printf( "\n" );

        // Move to the next input and output locations
        iloc++;
        oloc++;

        // Decrement the before numbers if needed
        if( ibefore > 0 )   ibefore--;
        if( obefore > 0 )   obefore--;
    }
}

int stream_buffer_max( stream_t *stream, int num )
{
    int max;
    stream_t *cur;

    // By default the minimum size is 1
    max = 1;

    // Find the maximum size requested for the buffer
    for( cur = &stream[0]; cur->node.name != NULL; cur++ )
    {
        if( cur->input==num && cur->input_size>max )   max = cur->input_size;
        if( cur->output==num && cur->output_size>max ) max = cur->output_size;
    }

    // Return the maximum requested size
    return max;
}

void stream_buffer_create( stream_t *stream, int num )
{
    int size;
    buffer_t *buffer;
    stream_t *cur;

    // Create a new buffer
    buffer = (buffer_t*)malloc( sizeof(buffer_t) );
    if( buffer == NULL ) { perror( "could not create buffer" ); exit(1); }

    // Get the maximum size requested for this buffer
    size = stream_buffer_max( stream, num );

    // Initialize the buffer
    buffer_init( buffer, size );

    // Set the input and output buffers for all nodes
    for( cur = &stream[0]; cur->node.name != NULL; cur++ )
    {
        if( cur->input == num )  cur->node.input = buffer;
        if( cur->output == num ) cur->node.output = buffer;
    }
}

void stream_buffer_clean( stream_t *stream, int num )
{
    stream_t *cur;

    // Set the input and output buffers for all nodes
    for( cur = &stream[0]; cur->node.name != NULL; cur++ )
    {
        if( cur->input == num )
        {
            buffer_destroy( cur->node.input );
            free( cur->node.input );
            return;
        }
        else if( cur->output == num )
        {
            buffer_destroy( cur->node.output );
            free( cur->node.output );
            return;
        }
    }
}

void stream_show( stream_t *stream )
{
    int i;
    int max;
    int min;

    // Get the minimum and maximum buffer numbers
    stream_buffers( stream, &min, &max);

    // Loop over all of the buffer numbers
    for( i = min; i <= max; i++ )
    {
        // Don't process this buffer number if it doesn't exist
        if( !stream_buffer_exists(stream,i) ) continue;

        // Print the current buffer number
        printf( "\n" );
        stream_buffer_show( stream, i );
        printf( "\n" );
    }
}

void stream_create( stream_t *stream )
{
    int i;
    int max;
    int min;
    int res;
    stream_t *cur;

    // Get the minimum and maximum buffer numbers
    stream_buffers( stream, &min, &max);

    // Create all of the input and output buffers
    for( i = min; i <= max; i++ )
    {
        // Don't process this buffer number if it doesn't exist
        if( !stream_buffer_exists(stream,i) ) continue;

        // Create a new buffer
        stream_buffer_create(stream,i);
    }

    // Create threads to run each node
    for( cur = &stream[0]; cur->node.name != NULL; cur++ )
    {
        if( cur->create )
        {
            // Create a new thread
            res=hthread_create(&cur->node.tid,NULL,cur->node.func,&cur->node);

            // Make sure that the create thread worked
            if( res != 0 ) { perror( "could not create filter" ); exit(1); }
        }
    }
}

void stream_destroy( stream_t *stream )
{
    int i;
    int max;
    int min;
    int res;
    stream_t *cur;

    // Get the minimum and maximum buffer numbers
    stream_buffers( stream, &min, &max);

    // Wait for all of the threads to exit
    for( cur = &stream[0]; cur->node.name != NULL; cur++ )
    {
        if( cur->create )
        {
            // Create a new thread
            res=hthread_join( cur->node.tid, NULL );

            // Make sure that the create thread worked
            if( res != 0 ) { printf( "failed to wait for filter\n" ); }
        }
    }

    // Clean up all of the output buffers
    for( i = min; i <= max; i++ )
    {
        // Don't process this buffer number if it doesn't exist
        if( !stream_buffer_exists(stream,i) ) continue;

        // Clean up the old buffer
        stream_buffer_clean(stream,i);
    }

}

