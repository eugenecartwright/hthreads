#include <framebuffer.h>

static int32 framebuffer_ppmout8( framebuffer_t *image, framebuffer_file_t file )
{
    // Output the file type
    framebuffer_fprintf( file, "P5 " );

    // Output the image dimensions
    framebuffer_fprintf( file, "%d ", image->width );
    framebuffer_fprintf( file, "%d ", image->height );
    framebuffer_fprintf( file, "255\n" );

    // Output the image data
    framebuffer_fwrite(image->data,sizeof(uint8),image->width*image->height,file);

    // Return successfully
    return 0;
}

static int32 framebuffer_ppmout24( framebuffer_t *image, framebuffer_file_t file )
{
    int32   x;
    int32   y;
    int8    d[3];
    color_t c;

    // Output the file type
    framebuffer_fprintf( file, "P6 " );

    // Output the image dimensions
    framebuffer_fprintf( file, "%d ", image->width );
    framebuffer_fprintf( file, "%d ", image->height );
    framebuffer_fprintf( file, "255\n" );

    // Output the image data
    for( y = 0; y < image->height; y++ )
    {
        for( x = 0; x < image->width; x++ )
        {
            c = framebuffer_get( image, x, y );
            d[0] = color_red( c );
            d[1] = color_green( c );
            d[2] = color_blue( c );

            framebuffer_fwrite( d, sizeof(uint8), 3, file );
        }
    }

    // Return successfully
    return 0;
}

int32 framebuffer_ppmout( framebuffer_t *image, const char *path )
{
    int32 res;
    framebuffer_file_t    file;

    // Open the output file
    file = framebuffer_fopen( path, "w" );

    switch( image->depth )
    {
    case 8:     res = framebuffer_ppmout8( image, file );
    case 24:    res = framebuffer_ppmout24( image, file );
    case 32:    res = framebuffer_ppmout24( image, file );
    default:    res = EINVAL;
    }

    // Close the output file
    framebuffer_fclose( file );

    // Return the results
    return res;
}
