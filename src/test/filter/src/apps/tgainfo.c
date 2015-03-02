#include <stdio.h>
#include <stdlib.h>

struct __tga_header
{
   unsigned char  idlength;
   unsigned char  colourmaptype;
   unsigned char  datatypecode;
   unsigned short int colourmaporigin;
   unsigned short int colourmaplength;
   unsigned char  colourmapdepth;
   unsigned short int x_origin;
   unsigned short int y_origin;
   unsigned short width;
   unsigned short height;
   unsigned char  bitsperpixel;
   unsigned char  imagedescriptor;
} __attribute__((__packed__));;

typedef struct __tga_header tga_header_t ;

int main( int argc, char *argv[] )
{
    FILE            *file;
    tga_header_t    tga;

    file = fopen( argv[1], "r" );
    if( file == NULL )
    {
        perror( "could not open file" );
        exit(1);
    }

    fread( &tga, sizeof(tga_header_t), 1, file );
    printf( "ID Length:    %d\n", tga.idlength );
    printf( "Color Type:   %d\n", tga.colourmaptype );
    printf( "Data Type:    %d\n", tga.datatypecode );
    printf( "Color Origin: %d\n", tga.colourmaporigin );
    printf( "Color Length: %d\n", tga.colourmaplength );
    printf( "Color Depth:  %d\n", tga.colourmapdepth );
    printf( "X Origin:     %d\n", tga.x_origin );
    printf( "Y Origin:     %d\n", tga.y_origin );
    printf( "Width:        %d\n", tga.width );
    printf( "Height:       %d\n", tga.height );
    printf( "Depth:        %d\n", tga.bitsperpixel );
    printf( "Descriptor:   0x%2.2x\n", tga.imagedescriptor );

    fclose( file );
    return 0;
}
