#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>
#include <SDL.h>

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
    { 3, 1, 1, 1, 1, 1, imginput_node },
    { 1, 3, 1, 1, 0, 0, sdloutput_node },
    { 0, 0, 0, 0, 0, 0, null_node }
};
#else
// Declare filtering streams
stream_t streams[] =  {
    { 190,  10, 10, 10, 1, 1, sdlinput_node },
    {  10,  20, 10, 10, 0, 1, gray_node },
    {  20,  30, 10, 10, 0, 1, pixelate_node },
    {  30,  40, 10, 10, 0, 1, emboss_node },
    {  40,  50, 10, 10, 0, 1, sharpen_node },
    {  50,  60, 10, 10, 0, 1, blur_node },
    {  60,  70, 10, 10, 0, 1, median_node },
    {  70,  80, 10, 10, 0, 1, sobel_node },
    {  80,  90, 10, 10, 0, 1, laplace3_node },
    {  90, 100, 10, 10, 0, 1, laplace5_node },
    { 100, 110, 10, 10, 0, 1, contrast_node },
    { 110, 120, 10, 10, 0, 1, thresh_node },
    { 120, 130, 10, 10, 0, 1, histogram_node },
    { 130, 140, 10, 10, 0, 1, intensity_waveform_node },
    { 140, 150, 10, 10, 0, 1, uv_mapping_node },
    { 150, 160, 10, 10, 0, 1, dct_node },
    { 160, 170, 10, 10, 0, 1, hough_node },
    { 170, 180, 10, 10, 0, 1, idct_node },
    { 180, 190, 10, 10, 0, 0, sdloutput_node },
    { 0, 0, 0, 0, 0, 0, null_node }
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
    int ind;
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

    // Run the output thread
    ind = (sizeof(streams) / sizeof(stream_t)) - 2;
    streams[ind].node.func( &streams[ind].node );

    // Wait for the stream filter to finish and then clean it up
    stream_destroy( streams );

    // Exit the program
    return 0;
}

