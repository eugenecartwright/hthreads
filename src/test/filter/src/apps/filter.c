#include <framebuffer.h>
#include <stdio.h>
#include <getopt.h>
#include "helper.h"

const char fshort[] = "hSs:b:p:l:g";
static struct option flong[] = {
    {"help",        no_argument,       NULL, 'h'},
    {"sobel",       no_argument,       NULL, 'S'},
    {"scale",       required_argument, NULL, 's'},
    {"emboss",      no_argument,       NULL,   1},
    {"sharpen",     no_argument,       NULL,   0},
    {"box-blur",    required_argument, NULL, 'b'},
    {"pixelate",    required_argument, NULL, 'p'},
    {"laplace",     required_argument, NULL, 'l'},
    {"gray",        no_argument,       NULL, 'g'},
    {0, 0, 0, 0}
};

int32 width = 0;
int32 height = 0;

void showhelp( int argc, char *argv[] )
{
    FILE *f = stderr;
    fprintf(f,"Usage: %s [option]...\n", argv[0] );
    fprintf(f,"where option is\n" );
    fprintf(f,"\t-h, --help         show this help information\n");
    fprintf(f,"\t-i, --input=IMG    use IMG for the input image (required)\n");
    fprintf(f,"\t-o, --output=IMG   use IMG for the output image (required)\n");
    fprintf(f,"\t-e, --encode       use RLE compression on the output image\n");
    fprintf(f,"\t-s, --scale=WxH    scale to W x H dimensions\n");
    fprintf(f,"\t-b, --box-blur=NUM box blur with strength NUM\n");
    fprintf(f,"\t-p, --pixelate=WxH pixelate with strides of W x H\n");
    fprintf(f,"\t-l, --laplace=NUM  detect edges using laplace (NUM=3 or 5)\n");
    fprintf(f,"\t-g, --gray         convert to gray scale\n");
    fprintf(f,"\t-S, --sobel        detect edges using sobel\n");
    fprintf(f,"\t    --sharpen      perform a sharpening filter\n");
    fprintf(f,"\t    --emboss       perform a embossing filter\n");
    exit( 1 );
}

void parse_size( char *size )
{
    int32 i;
    int32 j;
    int32 l;
    char  bw[128];
    char  bh[128];

    i = 0;
    l = strlen(size);
    for( j = 0; j < l; j++ )  if( size[j] == 'x' )  { i = j; break; }   

    strncpy( bw, size, i ); bw[i] = 0;
    strncpy( bh, size+i+1, l-i );

    width = atoi(bw);
    height = atoi(bh);
}

void run_filters( int argc, char *argv[], framebuffer_t *img )
{
    int         c;
    int         ind;
    framebuffer_t     dst;
    kernel_t    sharpen;
    kernel_t    emboss;

    kernel_sharpen( &sharpen );
    kernel_emboss( &emboss );

    optreset = 1;
    optind   = 1;
    opterr   = 0;
    while( (c = getopt_long(argc, argv, fshort, flong, &ind)) != -1 )
    {
        switch( c )
        {
        case 0:
            framebuffer_create( &dst, img->width, img->height );
            framebuffer_kernel( &dst, img, &sharpen );
            framebuffer_destroy( img );
            framebuffer_clone( img, &dst );
            break;

        case 1:
            framebuffer_create( &dst, img->width, img->height );
            framebuffer_kernel( &dst, img, &emboss );
            framebuffer_destroy( img );
            framebuffer_clone( img, &dst );
            break;

        case 'S':
            framebuffer_create( &dst, img->width, img->height );
            framebuffer_sobel( &dst, img );
            framebuffer_destroy( img );
            framebuffer_clone( img, &dst );
            break;

        case 's':
            parse_size( optarg );
            framebuffer_create( &dst, width, height );
            framebuffer_linear( &dst, img );
            framebuffer_destroy( img );
            framebuffer_clone( img, &dst );
            break;

        case 'b':
            framebuffer_create( &dst, img->width, img->height );
            framebuffer_blur( &dst, img, atoi(optarg) );
            framebuffer_destroy( img );
            framebuffer_clone( img, &dst );
            break;

        case 'p':
            parse_size( optarg );
            framebuffer_pixelate( img, width, height );
            break;

        case 'l':
            framebuffer_create( &dst, img->width, img->height );
            if( atoi(optarg) == 5 ) framebuffer_laplace5( &dst, img );
            else                    framebuffer_laplace3( &dst, img );
            framebuffer_destroy( img );
            framebuffer_clone( img, &dst );
            break;

        case 'g':
            framebuffer_gray( img );
            break;

        case '?':
            optind++;
            break;
        }
    }

    kernel_destroy( &sharpen );
    kernel_destroy( &emboss );
}

int main( int argc, char *argv[] )
{
    framebuffer_t img;

    parse_options( argc, argv );
    load_image( &img );

    run_filters( argc, argv, &img );

    output_image( &img );
    destroy_image( &img );

    return 0;
}
