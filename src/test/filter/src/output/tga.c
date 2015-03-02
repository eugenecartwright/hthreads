#include <framebuffer.h>

static void framebuffer_outcolor( framebuffer_t *image, color_t color, framebuffer_file_t file )
{
    uint8    r;
    uint8    g;
    uint8    b;
    uint8    a;

    r = color_red(color);
    g = color_green(color);
    b = color_blue(color);
    a = color_alpha(color);
    switch( image->depth )
    {
    case 8:
        framebuffer_fputc( g, file );
        break;

    case 24:
        framebuffer_fputc( b, file );
        framebuffer_fputc( g, file );
        framebuffer_fputc( r, file );
        break;
                
    case 32:
        framebuffer_fputc( b, file );
        framebuffer_fputc( g, file );
        framebuffer_fputc( r, file );
        framebuffer_fputc( a, file );
        break;
    }
}

static int32 framebuffer_tgarle( framebuffer_t *image, framebuffer_file_t file )
{
    int32   i;
    int32   loc;
    int32   rle;
    int32   max;
    int32   fix;
    color_t next;
    color_t temp;

    for( loc = 0; loc < image->width*image->height; loc += rle )
    {
        // Determine the maximum number of pixles to encode
        max = image->width*image->height - loc;
        if( max > 128 ) max = 128;

        // Get the color of the current element
       next = framebuffer_pixel( image, loc );

        // Find the number of elements to encode
        for( rle = 1; rle < max; rle++ )
        {
            temp = framebuffer_pixel( image, loc+rle );
            if( !color_equal(next,temp) )  break;
        }

        // Determine if we should use encoding or raw data
        if( rle > 1 )
        {
            // Write the encoded data
            framebuffer_fputc( 0x80|(rle-1), file );
            framebuffer_outcolor( image, next, file );
        }
        else
        {
            // By default no fixup is needed
            fix = 0;

            // Determine the number of raw pixels to write
            for( rle = 1; rle < max; rle++ )
            {
                temp = framebuffer_pixel( image, loc+rle );
                if( color_equal(next,temp) )  {  fix = 1; break; }
                next = temp;
            }

            // Fixup the location to end at
            if( rle > 1 && fix ) rle--;

            // Write the packet header
            framebuffer_fputc( (rle-1), file );

            // Write the raw data
            for( i = 0; i < rle; i++ )
            {
                next = framebuffer_pixel( image, loc+i );
                framebuffer_outcolor( image, next, file );
            }
        }
    }

    // Return successfully
    return 0;
}

static int32 framebuffer_tgaraw( framebuffer_t *image, framebuffer_file_t file )
{
    int32           x;
    int32           y;
    color_t         c;

    // Output the image data
    for( y = 0; y < image->height; y++ )
    {
        for( x = 0; x < image->width; x++ )
        {
            c = framebuffer_get( image, x, y );
            framebuffer_outcolor( image, c, file );
        }
    }

    // Return successfully
    return 0;
}

int32 framebuffer_tgaout( framebuffer_t *image, const char *path, uint32 flags )
{
    uint16          width;
    uint16          height;
    uint16          type;
    uint16          zero;
    int32           res;
    framebuffer_file_t    file;

    // Setup the zero value
    zero = 0;

    // Determine the file type to use
    if( image->depth == 8 ) type = 3;
    else                    type = 2;
    if( (flags & TGA_RLE) ) type += 8;

    // Open the output file
    file = framebuffer_fopen( path, "w" );
    if( file == NULL )  return EINVAL;

    // Get the width and height of the image
    width  = (uint16)image->width;
    height = (uint16)image->height;

    // Write the header information
    framebuffer_fwrite( &zero, sizeof(uint16), 1, file );
    framebuffer_fwrite( &type, sizeof(uint16), 1, file );
    framebuffer_fwrite( &zero, sizeof(uint16), 1, file );
    framebuffer_fwrite( &zero, sizeof(uint16), 1, file );
    framebuffer_fwrite( &zero, sizeof(uint16), 1, file );
    framebuffer_fwrite( &zero, sizeof(uint16), 1, file );
    framebuffer_fwrite( &width,  sizeof(uint16), 1, file );
    framebuffer_fwrite( &height, sizeof(uint16), 1, file );
    framebuffer_fputc( image->depth, file );
    if( image->depth == 32 )    framebuffer_fputc( 0x28, file );
    else                        framebuffer_fputc( 0x20, file );

    // Write the file to disk
    if( (flags & TGA_RLE) ) res = framebuffer_tgarle( image, file );
    else                    res = framebuffer_tgaraw( image, file );

    // Close the file
    framebuffer_fclose( file );

    // Return the results
    return res;
}
