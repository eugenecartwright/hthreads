#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stream/const.h>
#include <stdio.h>
#include <arch/htime.h>
#include <SDL.h>

extern int sdlquit;
extern void process_keys();
void sdloutput_check_buffers( stream_node_t *node )
{
    // Make sure that the input buffer is valid
    if( node->input == NULL )
    {
        fprintf(stderr,"output node must be used with a valid input buffer\n");
        exit(1 );
    }
}

void sdloutput_capture_time( hthread_time_t *s, hthread_time_t *e, Huint *f )
{
    hthread_time_t diff;
    double sec;

    // Increment the number of frames that have been processed
    (*f)++;

    // Get the current time
    hthread_time_get(e);

    // Get the elapsed time since the last time we printed
    hthread_time_diff( diff, *e, *s );
    sec = hthread_time_sec( diff );

    // Show the FPS that we are handling
    if( sec > 1 )
    {
        printf( "STATS: (FRAMES=%d) (RATE=%.2f)\n", *f, *f/sec );
        *f = 0;
        hthread_time_get(s);
    }
}

void sdloutput_cleanup_frame( stream_node_t *node, framebuffer_t *frame )
{
    // Either destroy the frame or insert it in the output buffer
    if( node->output == NULL )
    {
        framebuffer_destroy( frame );
        free( frame );
    }
    else
    {
        buffer_insert( node->output, frame );
    }
}

void sdloutput_open_window( SDL_Surface **scr, SDL_Palette *pal )
{
    int res;

    // Attempt to initialize the video subsystem
    res = SDL_Init( SDL_INIT_VIDEO );
    if( res < 0 ) { printf( "could not initialize video\n" ); exit(1); }

    // Attempt to set the video mode
    *scr = SDL_SetVideoMode(INPUT_WIDTH,INPUT_HEIGHT,INPUT_DEPTH,SDL_SWSURFACE);
    if( !(*scr) ) { printf( "could not open window\n" ); exit(1); }

    // Setup the palette for the screen
    if( INPUT_DEPTH == 8 )  SDL_SetPalette( *scr, SDL_LOGPAL|SDL_PHYSPAL, pal->colors, 0, 256 );

    // Enable UNICODE Translation
    SDL_EnableUNICODE( 1 );
}

void sdloutput_put_pixel(SDL_Surface *surface, int x, int y, Uint32 pixel)
{
    Hint    bpp = surface->format->BytesPerPixel;
    Hubyte *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;

    switch(bpp)
    {
    case 1:
        *p = pixel;
        break;

    case 2:
        *(Uint16 *)p = pixel;
        break;

    case 3:
        if(SDL_BYTEORDER == SDL_BIG_ENDIAN) {
            p[0] = (pixel >> 16) & 0xff;
            p[1] = (pixel >> 8) & 0xff;
            p[2] = pixel & 0xff;
        } else {
            p[0] = pixel & 0xff;
            p[1] = (pixel >> 8) & 0xff;
            p[2] = (pixel >> 16) & 0xff;
        }
        break;

    case 4:
        *(Uint32 *)p = pixel;
        break;
    }
}

void sdloutput_show_frame8( SDL_Surface *s, framebuffer_t *f, SDL_Palette *p )
{
    int32 x;
    int32 y;
    uint8 r;
    uint8 g;
    uint8 b;
    color_t col;

    for( y = 0; y < f->height; y++ )
    {
        for( x = 0; x < f->width; x++ )
        {
            col = framebuffer_get( f, x, y );
            r = color_red( col );
            g = color_green( col );
            b = color_blue( col );

            sdloutput_put_pixel( s, x, y, SDL_MapRGB( s->format, r, g, b) );
        }
    }
}

void sdloutput_show_frame24( SDL_Surface *s, framebuffer_t *f, SDL_Palette *p )
{
    int32 x;
    int32 y;
    uint8 r;
    uint8 g;
    uint8 b;
    color_t col;
    uint8   *d;

    Hint    bpp = s->format->BytesPerPixel;
    for( y = 0; y < f->height; y++ )
    {
        for( x = 0; x < f->width; x++ )
        {
            col = framebuffer_get( f, x, y );
            r = color_red( col );
            g = color_green( col );
            b = color_blue( col );

            d = (uint8*)s->pixels + y*s->pitch + x * bpp;
            if(SDL_BYTEORDER==SDL_BIG_ENDIAN) { d[0] = r; d[1] = g; d[2] = b; }
            else                              { d[0] = b; d[1] = g; d[2] = r; }
        }
    }
}

void sdloutput_show_frame32( SDL_Surface *s, framebuffer_t *f, SDL_Palette *p )
{
    int32 x;
    int32 y;
    uint8 r;
    uint8 g;
    uint8 b;
    color_t col;
    uint8   *d;

    Hint    bpp = s->format->BytesPerPixel;
    for( y = 0; y < f->height; y++ )
    {
        for( x = 0; x < f->width; x++ )
        {
            col = framebuffer_get( f, x, y );
            r = color_red( col );
            g = color_green( col );
            b = color_blue( col );

            d = (uint8*)s->pixels + y*s->pitch + x * bpp;
            if(SDL_BYTEORDER==SDL_BIG_ENDIAN) { d[0] = r; d[1] = g; d[2] = b; }
            else                              { d[0] = b; d[1] = g; d[2] = r; }
        }
    }
}

void sdloutput_show_frameall(SDL_Surface *s,framebuffer_t *f, SDL_Palette *p )
{
    int32 x;
    int32 y;
    uint8 r;
    uint8 g;
    uint8 b;
    color_t col;

    for( y = 0; y < f->height; y++ )
    {
        for( x = 0; x < f->width; x++ )
        {
            col = framebuffer_get( f, x, y );
            r = color_red( col );
            g = color_green( col );
            b = color_blue( col );

            sdloutput_put_pixel( s, x, y, SDL_MapRGB( s->format, r, g, b) );
        }
    }
}

void sdloutput_show_frame( SDL_Surface *s, framebuffer_t *f, SDL_Palette *p )
{
    Hint    bpp = s->format->BytesPerPixel;

    SDL_LockSurface( s );
    switch( f->depth )
    {
    case 8:
        if( bpp == 1 )  sdloutput_show_frame8( s, f, p );
        else            sdloutput_show_frameall( s, f, p );
        break;

    case 24:
        if( bpp == 3 )  sdloutput_show_frame24( s, f, p );
        else            sdloutput_show_frameall( s, f, p );
        break;

    case 32:
        if( bpp == 4 )  sdloutput_show_frame32( s, f, p );
        else            sdloutput_show_frameall( s, f, p );
        break;

    default:
        sdloutput_show_frameall( s, f, p );
        break;
    }
    SDL_UnlockSurface( s );
    SDL_Flip( s );
}

void sdloutput_create_palette( SDL_Palette *pal )
{
    int i;

    // Allocate space for the palette
    pal->colors = (SDL_Color*)malloc( 256*sizeof(SDL_Color) );
    if( pal->colors == NULL )
    {
        perror( "could not allocate space for palette" );
        exit(1);
    }

    // Fill the color palette
    for( i = 0; i < 256; i++ )
    {
        pal->colors[i].r = i;
        pal->colors[i].g = i;
        pal->colors[i].b = i;
        pal->colors[i].unused = 255;
    }

    // Store the number of colors
    pal->ncolors = 256;
}

void* sdloutput_thread( void *arg )
{
    SDL_Surface   *screen;
    SDL_Palette   palette;
    framebuffer_t *frame;
    stream_node_t *node;
    hthread_time_t start;
    hthread_time_t end;
    Huint          frames;

    // Get the argument to the thread
    node = (stream_node_t*)arg;

    // Make sure the node is setup correctly
    sdloutput_check_buffers( node );

    // Attempt to setup the video window
    sdloutput_create_palette( &palette );
    sdloutput_open_window( &screen, &palette );

    // Initialize the FPS counter
    frames = 0;

    // Capture the current time
    hthread_time_get( &start );

    // Run the input thread
    while( 1 )
    {
        // Process any pressed keys
        process_keys();

        // Get an image to output from the input buffer
        frame = buffer_remove( node->input );

        // Determine if we should stop processing
        if( frame == NULL ) break;

        // Quit the application if requested
        if( sdlquit ) { SDL_Quit(); exit(0); }

        // Output the frame to the window
        sdloutput_show_frame( screen, frame, &palette );

        // Show the FPS that we are handling
        sdloutput_capture_time( &start, &end, &frames );

        // Clean up the processed frame
        sdloutput_cleanup_frame( node, frame );
    }

    // Clean up the color palette
    free( palette.colors );

    // Finish running the thread
    return NULL;
}
