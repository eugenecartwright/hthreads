#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>
#include <arch/htime.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/mman.h>

extern int fps;
extern int frame_limit_run;
void sdlinput_check_buffers( stream_node_t *node )
{
    // Make sure that the output buffer is valid
    if( node->output == NULL )
    {
        fprintf(stderr,"input node must be used with a valid output buffer\n");
        exit(1 );
    }
}

framebuffer_t* sdlinput_next_frame( stream_node_t *node )
{
    framebuffer_t *frame;

    if( node->input == NULL )
    {
        frame = (framebuffer_t*)malloc( sizeof(framebuffer_t) );
        if( frame != NULL )
        {
            framebuffer_create( frame, INPUT_WIDTH, INPUT_HEIGHT );
            //framebuffer_clone( frame, copy );
        }
    }
    else
    {
        frame = buffer_remove( node->input );
        //framebuffer_copy( frame, copy );
    }

    return frame;
}

/*
Hint sdlinput_preprocess( void )
{
    int i;
    int num;
    int res;
    framebuffer_t video;
    framebuffer_file_t file;

    // Open the input file
    file = framebuffer_fopen( "input.mga", "r" );
    if( file == NULL )
    {
        perror( "could not open video file" );
        exit( 1 );
    }

    // Read the number of files in the video file
    res = framebuffer_fread( &num, sizeof(int), 1, file );
    if( res != 1 || num <= 0 )
    {
        perror( "could determine number of frames" );
        exit( 1 );
    }

    // Read all of the input files
    for( i = 0; i < num; i++ )
    {
        fprintf( stderr, "    Loading %d of %d: %.2f%% done\r", i, num, (float)(100*i)/num );
        res = framebuffer_tgaread( &video, file );
        if( res != 0 )
        {
            perror( "could not read input frame" );
            exit( 1 );
        }

        // Write the raw image out to the disk
        res = framebuffer_rawout( &video, "movie.dat" );
        if( res != 0 )
        {
            perror( "could not write output frame" );
            exit( 1 );
        }
    }

    // Close the output file
    framebuffer_fclose( file );

    // Return the number of frames
    return num;
}

Hint sdlinput_load_files( framebuffer_t **frame )
{
    Hint num;
    int fd;
    size_t size;

    num = 886;

    // Calculate the size of one frame
    size = 3*sizeof(int32) + (INPUT_DEPTH/8)*INPUT_WIDTH*INPUT_HEIGHT*sizeof(int8);
    printf( "Image Size: %d\n", size );

    // Attempt to open the movie file
    fd = open( "movie.dat", O_RDWR, 0 );

    if( fd <= 0 )
    {
        // Process the input movie
        num = sdlinput_preprocess();

        // Attempt to open the movie file
        fd = open( "movie.dat", O_RDWR, 0 );
    }

    if( fd <= 0 )
    {
        perror( "could not open mapped movie file" );
        exit(1);
    }

    // Memory map the movie file
    *frame = (framebuffer_t*)mmap( NULL, num*size, PROT_READ|PROT_WRITE, MAP_FILE, fd, MAP_SHARED );
    if( *frame == (framebuffer_t*)-1 )
    {
        perror( "movie file could not be mapped" );
        exit(1);
    }

    // Show some information about the thread
    printf( "Image Width:  %d\n", (*frame)->width );
    printf( "Image Height: %d\n", (*frame)->height );
    printf( "Image Depth:  %d\n", (*frame)->depth );

    // Return the number of frames
    return num;
}

Hint sdlinput_load_files2( framebuffer_t **frame )
{
    int i;
    int num;
    int res;
    framebuffer_t *video;
    framebuffer_file_t file;

    // Open the input file
    file = framebuffer_fopen( "input.mga", "r" );
    if( file == NULL )
    {
        perror( "could not open video file" );
        exit( 1 );
    }

    // Read the number of files in the video file
    res = framebuffer_fread( &num, sizeof(int), 1, file );
    if( res != 1 || num <= 0 )
    {
        perror( "could determine number of frames" );
        exit( 1 );
    }

    // Allocate space for all of the frames
    video = (framebuffer_t*)malloc( num * sizeof(framebuffer_t) );
    if( video == NULL )
    {
        perror( "could not read input frames" );
        exit( 1 );
    }

    // Read all of the input files
    for( i = 0; i < num; i++ )
    {
        fprintf( stderr, "    Loading %d of %d: %.2f%% done\r", i, num, (float)(100*i)/num );
        res = framebuffer_tgaread( &video[i], file );
        if( res != 0 )
        {
            perror( "could not read input frame" );
            exit( 1 );
        }
    }

    // Store a pointer to the video files
    *frame = video;

    // Return the number of video frames loaded
    return num;
}
*/

void* sdlinput_thread( void *arg )
{
    Hint i;
    Hint num;
    Hint res;
    hthread_time_t start;
    hthread_time_t end;
    hthread_time_t diff;
    stream_node_t *node;
    framebuffer_t *frame;
    framebuffer_file_t file;

    // Get the argument to the thread
    node = (stream_node_t*)arg;

    // Check that the node was setup correctly
    sdlinput_check_buffers( node );

    // Read the input frames
    //num = sdlinput_load_files( &video );
    //printf( "Loaded %d video frames\n", num );

    // Open the input file
    file = framebuffer_fopen( "input.mga", "r" );
    if( file == NULL )
    {
        perror( "could not open video file" );
        exit( 1 );
    }

    // Read the number of files in the video file
    res = framebuffer_fread( &num, sizeof(int), 1, file );
    if( res != 1 || num <= 0 )
    {
        perror( "could determine number of frames" );
        exit( 1 );
    }

    // Set the initial frame number
    i = 0;

    // Get the current time
    hthread_time_get( &start );

    // Run the input thread
    while( 1 )
    {
        // Get the next video frame
        frame = sdlinput_next_frame( node );

        // Determine if we should halt the processing
        if( frame == NULL ) break;

        // Reset the file location if this is the first frame
        if( i == 0 ) framebuffer_fseek( file, sizeof(int32), SEEK_SET );

        // Attempt to read the next video frame
        framebuffer_rawread( frame, file, frame->width, frame->height, frame->depth );

        // Move to the next frame
        i = (i + 1) % num;

        // Wait for the next time frame
        if( frame_limit_run )
        {
            do
            {
                hthread_time_get( &end );
                hthread_time_diff( diff, end, start );
            } while( hthread_time_msec(diff) <= (1000.0/fps) );
        }
        
        // Store the old time
        start = end;

        // Insert the image to the output buffer
        buffer_insert( node->output, frame );
    }

    // Finish running the thread
    return NULL;
}
