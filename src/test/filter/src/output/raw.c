#include <framebuffer.h>

int32 framebuffer_rawout( framebuffer_t *image, const char *path )
{
    framebuffer_file_t    file;

    // Open the output file
    file = framebuffer_fopen( path, "a" );
    if( file == NULL ) return 1;

    // Output the image dimensions
    framebuffer_fwrite( &image->width,  sizeof(int32), 1, file );
    framebuffer_fwrite( &image->height, sizeof(int32), 1, file );
    framebuffer_fwrite( &image->depth,  sizeof(int32), 1, file );

    // Output the image data
    framebuffer_fwrite(   image->data,
                    sizeof(uint8),
                    image->width*image->height*(image->depth/8),
                    file);

    // Close the output file
    framebuffer_fclose( file );

    // Return successfully
    return 0;
}
