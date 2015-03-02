#include <framebuffer.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <getopt.h>

#define FILE_RAW    0
#define FILE_PPM    1
#define FILE_TGA    2

extern void showhelp( int argc, char *argv[] );
char *input_name  = NULL;
char *output_name = NULL;
int32 userle      = 0;

static struct option hoptions[] = {
    {"help",        no_argument,        NULL, 'h'},
    {"input",       required_argument,  NULL, 'i'},
    {"output",      required_argument,  NULL, 'o'},
    {"encode",      no_argument,        NULL, 'e'},
    {0, 0, 0, 0}
};

int32 filetype( const char *path )
{
    int j;
    int i;
    int len;

    i = -1;
    len = strlen(path);
    for( j = len-1; j >= 0; j-- )   if(path[j] == '.')    {i = j; break;}

    if( i < 0 )        return -1;
    if( len - i != 4 ) return -1;

    if(path[i+1]=='r' && path[i+2]=='a' && path[i+3]=='w' )   return FILE_RAW;
    if(path[i+1]=='p' && path[i+2]=='p' && path[i+3]=='m' )   return FILE_PPM;
    if(path[i+1]=='t' && path[i+2]=='g' && path[i+3]=='a' )   return FILE_TGA;
    return -1;
}

void parse_options( int argc, char *argv[] )
{
    int c;
    int ind;
     
    optreset = 1;
    optind   = 1;
    opterr   = 0;
    while( (c = getopt_long(argc, argv, "i:o:e", hoptions, &ind)) != -1 )
    {
        switch (c)
        {
        case 'h':
            showhelp(argc,argv);
            break;

        case 'e':
            userle = 1;
            break;

        case 'i':
            if( input_name != NULL )
            {
                fprintf( stderr, "Only one input file can be specified\n" );
                showhelp(argc,argv);
            }
            input_name = optarg;
            break;

        case 'o':
            if( output_name != NULL )
            {
                fprintf( stderr, "Only one output file can be specified\n" );
                showhelp(argc,argv);
            }
            output_name = optarg;
            break;

        case '?':
            optind++;
            break;

        default:
            showhelp(argc,argv);
        }
     }

    if( input_name == NULL )
    {
        fprintf( stderr, "you must specify an input image\n" );
        showhelp(argc,argv);
    }

    if( output_name == NULL )
    {
        fprintf( stderr, "you must specify an output image\n" );
        showhelp(argc,argv);
    }
}


void load_image( framebuffer_t *img )
{
    int res;
    int type;

    type = filetype( input_name );
    if( type < 0 || type > 2 )
    {
        fprintf( stderr, "unknown input file type...assuming raw\n" );
        type = 0;
    }

    switch( type )
    {
    case 0:     res = framebuffer_rawin( img, input_name ); break;
    case 1:     res = framebuffer_ppmin( img, input_name ); break;
    case 2:     res = framebuffer_tgain( img, input_name ); break;
    default:    res = EINVAL;
    }

    if( res != 0 )
    {
        fprintf( stderr, "could not create image: %d\n", res );
        exit( 1 );
    }
}

void destroy_image( framebuffer_t *img )
{
    int res;

    res = framebuffer_destroy( img );
    if( res != 0 )
    {
        fprintf( stderr, "could not destroy image\n" );
        exit( 1 );
    }
}

void output_image( framebuffer_t *img )
{
    int res;
    int type;
    int flags;

    type = filetype( output_name );
    if( type < 0 || type > 2 )
    {
        fprintf( stderr, "unknown output file type...assuming raw\n" );
        type = 0;
    }

    flags = TGA_RAW;
    if( userle ) flags = TGA_RLE;

    switch( type )
    {
    case 0:     res = framebuffer_rawout( img, output_name ); break;
    case 1:     res = framebuffer_ppmout( img, output_name ); break;
    case 2:     res = framebuffer_tgaout( img, output_name, flags ); break;
    default:    res = EINVAL;
    }

    if( res != 0 )
    {
        fprintf( stderr, "could not save image\n" );
    }
}
