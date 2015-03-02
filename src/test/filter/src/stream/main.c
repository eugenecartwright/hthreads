#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>

// Declare filtering streams
// Format: Input Buffer Number  - The number of the input buffer. Identical
//                                buffer numbers correspond to identical buffers
//         Output Buffer Number - The number of the output buffer. Identical
//                                buffer numbers correspond to identical buffers
//         Input Buffer Size    - The requested input buffer size. The actual
//                                buffer size will be the maximum of all of
//                                the requested sizes for the given buffer.
//         Output Buffer Size   - The requested output buffer size. The
//                                actual buffer size will be the maximum of
//                                all of the requested sizes for the given
//                                buffer
//         Fill Node            - A true value if the given node should have
//                                its input buffer filled, otherwise
//                                a false value.
//         Create Node          - A true value if the given node should be
//                                created, a false value otherwise. This can
//                                be used so that all of the information
//                                for a node is setup but the node is not
//                                actually created.
//         Node                 - The node to run
#if 0
stream_t streams[] =  {
    { 3, 1, 1, 1, 1, 1, vdecinput_node },
    { 1, 3, 1, 1, 0, 1, vgaoutput_node },
    { 0, 0, 0, 0, 0, 0, null_node }
};
#else
stream_t streams[] =  {
    { 15, 1, 1, 1, 1, 1, vdecinput_node },
    { 1, 2, 1, 1, 0, 1, pixelate_node },
    { 2, 3, 1, 1, 0, 1, emboss_node },
    { 3, 4, 1, 1, 0, 1, sharpen_node },
    { 4, 5, 1, 1, 0, 1, sobel_node },
    { 5, 6, 1, 1, 0, 1, blur_node },
    { 6, 7, 1, 1, 0, 1, laplace3_node },
    { 7, 8, 1, 1, 0, 1, laplace5_node },
    { 8, 9, 1, 1, 0, 1, histogram_eq_node },
    { 9, 10, 1, 1, 0, 1, intensity_waveform_node },
    { 10, 11, 1, 1, 0, 1, uv_mapping_node },
    { 11, 12, 1, 1, 0, 1, rotate_node },
    { 12, 13, 1, 1, 0, 1, invert_node },
    { 13, 14, 1, 1, 0, 1, histogram_node },
    { 14, 15, 1, 1, 0, 1, vgaoutput_node },
};
#endif

void fill_buffer( buffer_t *buffer )
{
    int32 i;
    framebuffer_t *frame;

    printf( "Filling start thread's input buffer...\n" );
    for( i = 0; i < buffer->size; i++ )
    {
        // Allocate a new frame 
        frame = (framebuffer_t*)malloc( sizeof(framebuffer_t) );
        if( frame != NULL )
        {
            framebuffer_create( frame, INPUT_WIDTH, INPUT_HEIGHT );
        }

        // Insert the frame into the buffer
        buffer_insert( buffer, frame );
    }
}

int main( int argc, char *argv[] )
{
    stream_t *cur;

    // Show the stream filter on stdout
    stream_show( streams );

    // Create the stream filter
    stream_create( streams );

    // Fill the input buffer of the required nodes
    for( cur = &streams[0]; cur->node.name != NULL; cur++ )
    {
        if( cur->start )    fill_buffer( cur->node.input );
    }

    // Wait for the stream filter to finish and then clean it up
    stream_destroy( streams );

    // Exit the program
    return 0;
}

