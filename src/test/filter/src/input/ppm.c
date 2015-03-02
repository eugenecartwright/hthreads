#include <framebuffer.h>

static int32 framebuffer_ppmin1( framebuffer_t *image, framebuffer_file_t file, int32 max, int32 ascii )
{
    return 0;
}

static int32 framebuffer_ppmin8( framebuffer_t *image, framebuffer_file_t file, int32 max, int32 ascii )
{
    int32  x;
    int32  y;
    uint8  c8;
    uint32 c32;

    for( y = 0; y < image->height; y++ )
    {
        for( x = 0; x < image->width; x++ )
        {
            if( ascii )
            {
                framebuffer_fscanf( file, "%d", &c32 );
                framebuffer_set( image, x, y, color_make(c32,c32,c32,255) );
            }
            else
            {
                framebuffer_fread( &c8, sizeof(uint8), 1, file ); 
                framebuffer_set( image, x, y, color_make(c8,c8,c8,255) );
            }
        }
    }

    return 0;
}

static int32 framebuffer_ppmin24( framebuffer_t *image, framebuffer_file_t file, int32 max, int32 ascii )
{
    int32  x;
    int32  y;
    uint8  c8[3];
    uint32 c32[3];

    for( y = 0; y < image->height; y++ )
    {
        for( x = 0; x < image->width; x++ )
        {
            if( ascii )
            {
                framebuffer_fscanf( file, "%d", &c32[0] );
                framebuffer_fscanf( file, "%d", &c32[1] );
                framebuffer_fscanf( file, "%d", &c32[2] );
                framebuffer_set( image, x, y, color_make(c32[0],c32[1],c32[2],255) );
            }
            else
            {
                framebuffer_fread( c8, sizeof(uint8), 3, file ); 
                framebuffer_set( image, x, y, color_make(c8[1],c8[2],c8[0],255) );
            }
        }
    }

    return 0;
}

int32 framebuffer_ppmin( framebuffer_t *image, const char *path )
{
    char            type[2];
    int32           width;
    int32           height;
    int32           max;
    int32           res;
    framebuffer_file_t    file;

    // Open the input file
    file = framebuffer_fopen( path, "r" );

    // Get the image type
    framebuffer_fscanf( file, "%c%c", &type[0], &type[1] );
    if( type[0] != 'P' )                    return EINVAL;
    if( type[1] < '1' || type[1] > '6' )    return EINVAL;

    // Get the image width, height, and maximum value
    framebuffer_fscanf( file, "%d", &width );
    framebuffer_fscanf( file, "%d", &height );
    framebuffer_fscanf( file, "%d", &max );
    
    // Allocate the image
    res = framebuffer_create(image,width,height);
    if( res != 0 )  return res;

    // Read the image data
    switch( type[1] )
    {
    case '1':   return framebuffer_ppmin1( image, file, max, 1 );
    case '2':   return framebuffer_ppmin8( image, file, max, 1 );
    case '3':   return framebuffer_ppmin24( image, file, max, 1 );
    case '4':   return framebuffer_ppmin1( image, file, max, 0 );
    case '5':   return framebuffer_ppmin8( image, file, max, 0 );
    case '6':   return framebuffer_ppmin24( image, file, max, 0 );
    default:    return EINVAL;
    }

    // Return successfully
    return 0;
}
