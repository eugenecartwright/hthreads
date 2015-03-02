#include <framebuffer.h>

typedef struct
{
    uint8           idlen;
    uint8           colty;
    uint8           datty;
    uint16          colorg;
    uint16          collen;
    uint8           coldep;
    uint16          xorg;
    uint16          yorg;
    uint16          width;
    uint16          height;
    uint8           depth;
    uint8           options;
} __attribute__((packed)) tgahdr_t;

static color_t framebuffer_incolor( framebuffer_t *image, framebuffer_file_t file, int32 depth )
{
    uint8    r;
    uint8    g;
    uint8    b;
    uint8    a;

    switch( depth )
    {
    case 8:
        framebuffer_fread( &g, sizeof(uint8), 1, file );
        return color_make(g,g,g,255);

    case 24:
        framebuffer_fread( &b, sizeof(uint8), 1, file );
        framebuffer_fread( &g, sizeof(uint8), 1, file );
        framebuffer_fread( &r, sizeof(uint8), 1, file );
        return color_make(r,g,b,255);
                
    case 32:
        framebuffer_fread( &b, sizeof(uint8), 1, file );
        framebuffer_fread( &g, sizeof(uint8), 1, file );
        framebuffer_fread( &r, sizeof(uint8), 1, file );
        framebuffer_fread( &a, sizeof(uint8), 1, file );
        return color_make(r,g,b,a);

    default:
        return color_make(0,0,0,0);
    }
}

static int32 framebuffer_tgarle( framebuffer_t *image, framebuffer_file_t file, int32 f, int32 d)
{
    uint8   h;
    int32   i;
    int32   loc;
    int32   r;
    int32   x;
    int32   y;
    color_t c;
    color_t t;

    for( loc = 0; loc < image->width*image->height; loc += r )
    {
        framebuffer_fread( &h, sizeof(uint8), 1, file );
        if( h & 0x80 )
        {
            r = (h & 0x7F) + 1;
            c = framebuffer_incolor( image, file, d );
            for( i = 0; i < r; i++ )    framebuffer_place( image, loc+i, c );
        }
        else
        {
            r = (h & 0x7F) + 1;
            for( i = 0; i < r; i++ )
            {
                c = framebuffer_incolor( image, file, d );
                framebuffer_place( image, loc+i, c );
            }
        }
    }

    if( !(f & 0x20) )
    {
        for( y = 0; y < image->height/2; y++ )
        {
            for( x = 0; x < image->width; x++ )
            {
                c = framebuffer_get( image, x, y );
                t = framebuffer_get( image, x, image->height-y-1 );

                framebuffer_set( image, x, y, t );
                framebuffer_set( image, x, image->height-y-1, c );
            }
        }
    }

    // Return successfully
    return 0;
}

static int32 framebuffer_tgaraw( framebuffer_t *image, framebuffer_file_t file, int32 f, int32 d )
{
    int32           x;
    int32           y;
    int32           s;
    int32           e;
    int32           i;
    color_t         c;

    if( f & 0x20 )    { i = 1;  s = 0; e = image->height; }
    else              { i = -1; s = image->height-1; e = 0; }

    for( y = s; (i > 0 && y < e) || (i < 0 && y >= e); y += i )
    {
        for( x = 0; x < image->width; x++ )
        {
            c = framebuffer_incolor( image, file, d );
            framebuffer_set( image, x, y, c );
        }
    }

    return 0;
}

int32 framebuffer_tgaread( framebuffer_t *image, framebuffer_file_t file )
{
    int32    res;
    tgahdr_t hdr;

    // Read in the header values
    res = framebuffer_fread( &hdr, sizeof(tgahdr_t), 1, file );
    if( res != 1 ) return EINVAL;

    // Make sure we can load this image
    if( hdr.datty!=2 && hdr.datty!=3 && hdr.datty!=10 && hdr.datty!=11 )
    { return EINVAL; }

    // Allocate an image for this file
    if( image->data == NULL ) framebuffer_create(image, hdr.width, hdr.height);

    // Read past the extra header information
    framebuffer_fseek( file, hdr.idlen, SEEK_CUR );

    // Determine if we are using run length encoding or not
    if(hdr.datty>8) res=framebuffer_tgarle(image,file,hdr.options,hdr.depth);
    else            res=framebuffer_tgaraw(image,file,hdr.options,hdr.depth);

    // Return the results
    return res;
}

int32 framebuffer_tgain( framebuffer_t *image, const char *path )
{
    int res;
    framebuffer_file_t    file;

    // Open the output file
    file = framebuffer_fopen( path, "r" );
    if( file == NULL )  return EINVAL;

    // Read in the file
    res = framebuffer_tgaread( image, file );

    // Close the input file
    framebuffer_fclose( file );

    // Return the results
    return res;
}
