#include <framebuffer.h>
#include <stdio.h>
#include "helper.h"

void showhelp( int argc, char *argv[] )
{
    fprintf( stderr, "Usage: %s [option]...\n", argv[0] );
    fprintf( stderr, "where option is\n" );
    fprintf( stderr, "  -i <input>      set the input file name\n" );
    fprintf( stderr, "  -o <output>     set the output file name\n" );
    fprintf( stderr, "  -e              use compression on output file\n" );
    exit( 1 );
}

void check_args( int argc, char *argv[] )
{
    if( argc < 3 )
    {
        fprintf( stderr, "Usage: %s <input> <output>\n", argv[0] );
        exit(1);
    }
}

int main( int argc, char *argv[] )
{
    framebuffer_t img;

    parse_options( argc, argv );
    load_image( &img );

    framebuffer_rect( &img, rect_make(10,10,10,10), color_make(255,255,0,255) );

    output_image( &img );
    destroy_image( &img );

    return 0;
}
