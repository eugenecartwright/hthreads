#include <framebuffer.h>

static color_t framebuffer_colorin( framebuffer_t *image, framebuffer_file_t file, int32 depth )
{
    uint8   r;
    uint8   g;
    uint8   b;
    uint8   a;

    switch( depth )
    {
    case 8:
        framebuffer_fread( &g, sizeof(uint8), 1, file );
        return color_make( g, g, g, 255 );

    case 24:
        framebuffer_fread( &r, sizeof(uint8), 1, file );
        framebuffer_fread( &g, sizeof(uint8), 1, file );
        framebuffer_fread( &b, sizeof(uint8), 1, file );
        return color_make( r, g, b, 255 );

    case 32:
        framebuffer_fread( &r, sizeof(uint8), 1, file );
        framebuffer_fread( &g, sizeof(uint8), 1, file );
        framebuffer_fread( &b, sizeof(uint8), 1, file );
        framebuffer_fread( &a, sizeof(uint8), 1, file );
        return color_make( r, g, b, a );

    default:
        return color_make( 0, 0, 0, 0 );
    }
}

int32 framebuffer_rawread( framebuffer_t *image, framebuffer_file_t file, int32 w, int32 h, int32 d)
{
    int32   x;
    int32   y;
    color_t c;
    int32   res;

    // Allocate the image
    if( image->data == NULL )
    {
        res = framebuffer_create(image,w,h);
        if( res != 0 )  return res;
    }

    // Make sure the image is the right size
    if(image->data==NULL||image->height!=h||image->width!=w) return EINVAL;

    // Determine if we can read all of the data at once
    if( image->depth == d )
    {
        res = framebuffer_fread( image->data, sizeof(color_t), image->width*image->height, file );
        if( res != image->width*image->height ) return EINVAL;
    }
    else
    {
        // Input the image data pixel by pixel
        for( y = 0; y < image->height; y++ )
        {
            for( x = 0; x < image->width; x++ )
            {
                c = framebuffer_colorin( image, file, d );
                framebuffer_set( image, x, y, c );
            }
        }
    }

    // Return successfully
    return 0;
}

int32 framebuffer_rawin( framebuffer_t *image, const char *path )
{
    int32 w;
    int32 h;
    int32 d;
    int32 res;
    framebuffer_file_t file;

    // Open the input file
    file = framebuffer_fopen( path, "r" );

    // Input the image dimensions
    framebuffer_fread( &w, sizeof(int32), 1, file );
    framebuffer_fread( &h, sizeof(int32), 1, file );
    framebuffer_fread( &d, sizeof(int32), 1, file );
    fprintf( stderr, "Image: %dx%d (%d bpp)\n", w, h, d );

    // Read in the input image
    res = framebuffer_rawread( image, file, w, h, d );

    // Close the input file
    framebuffer_fclose( file );

    // Return the results
    return res;
}
