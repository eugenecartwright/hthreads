#include <vga.h>
#include <string.h>
//#include <arch/cache.h>

Hint vga_init( vga_t *vga, vga_config_t *config )
{
    Huint mem;

    // Calculate the location of the VGA registers
    vga->addr   = (Huint*)(config->base);
    vga->enable = (Huint*)(config->base + 4);

    // Store the width and height of the VGA framebuffer
    vga->width  = config->width;
    vga->height = config->height;

    // The default frame buffer is 2MB of memory
    mem = 2*1024*1024;

    // A double buffered frame buffer requires twice as much memory
    if( config->dbuf == Htrue ) mem *= 2;

    // We need an extra two megabytes to ensure a properly aligned buffer
    mem += 2*1024*1024;

    // Allocate memory for the video framebuffer
    vga->memory = (Hubyte*)malloc(mem);
    if( vga->memory == NULL )  return -ENOMEM;

    // Calculate a properly aligned framebuffer
    vga->base = (Huint*)((Huint)vga->memory & 0xFFF00000);
    if( (Huint)vga->base < (Huint)vga->memory ) vga->base += 0x40000;

    // Calcualte the address of the double buffer if needed
    if( config->dbuf == Htrue ) vga->dbase = vga->base + 0x80000;
    else                        vga->dbase = NULL;

    printf( "Memory:        %8p\n", vga->memory );
    printf( "Memory Align:  %8p\n", (Huint*)((Huint)vga->memory & 0xFFF00000) );
    printf( "Frame Buffer:  %8p\n", vga->base );
    printf( "Double Buffer: %8p\n", vga->dbase );

    // Clear the VGA memory
    memset( vga->memory, 0, mem );

    // Enable the VGA device
    vga_enable( vga );

    // Return succcessfully
    return 0;
}

Hint vga_destroy( vga_t *vga )
{
    // Disable the VGA device
    vga_disable( vga );

    // Free the VGA framebuffer memory
    free( vga->memory );

    // Destroy the VGA driver
    vga->addr   = NULL;
    vga->enable = NULL;
    vga->width  = 0;
    vga->height = 0;
    vga->memory = NULL;
    vga->base   = NULL;
    vga->dbase  = NULL;

    // Return successfully
    return 0;
}

void vga_enable( vga_t *vga )
{
    Huint res;

    *vga->addr   = (Huint)vga->base;
    *vga->enable = 1;

    res = *vga->addr;
    printf( "Sent: 0x%8.8x\n", (Huint)vga->base );
    printf( "Got:  0x%8.8x\n", res );
}

void vga_disable( vga_t *vga )
{
    *vga->enable = 0;
    *vga->addr   = 0;
}

void vga_flip( vga_t *vga )
{
    Huint *tmp;

    // Flush the data cache out to main memory
    //dcache_flush();

    // Swap the buffers if needed
    if( vga->dbase != NULL )
    {
        tmp         = vga->dbase;
        vga->dbase  = vga->base;
        vga->base   = tmp;
        *vga->addr  = (Huint)tmp;
    }
}

void vga_clear( vga_t *vga )
{
    vga_clearto( vga, vga_make(0,0,0) );
}

void vga_clearto( vga_t *vga, vga_color col )
{
    Huint *base;
    Huint x;
    Huint y;
    Huint w;
    Huint h;

    // Determine which buffer to use
    if( vga->dbase != NULL )    base = (Huint*)vga->dbase;
    else                        base = (Huint*)vga->base;

    // Store the width and height
    w = vga->width;
    h = vga->height;

    // Clear the buffer to the given color
    for( y = 0; y < h; y++ )
    {
        for( x = 0; x < w; x++ )
        {
            base[1024*y + x] = col.value;
        }
    }
}

void vga_fill( vga_t *vga, Huint x, Huint y, Huint w, Huint h, vga_color col )
{
    Huint *base;
    Huint xoff;
    Huint yoff;

    // Determine which buffer to use
    if( vga->dbase != NULL )    base = (Huint*)vga->dbase;
    else                        base = (Huint*)vga->base;

    for( yoff = y; yoff < y+h; yoff++ )
    {
        for( xoff = x; xoff < x+w; xoff++ )
        {
            base[1024*yoff + xoff] = col.value;
        }
    }
}

void vga_copy( vga_t *vga, void *mem )
{
    Huint y;
    Huint *copy;
    Huint *base;

    // Type cast the memory pointer
    copy = (Huint*)mem;

    // Determine which buffer to use
    if( vga->dbase != NULL )    base = (Huint*)vga->dbase;
    else                        base = (Huint*)vga->base;

    // Copy the data to the screen
    for( y = 0; y < vga->height; y++ )
    {
        memcpy( &base[1024*y], &copy[vga->width*y], vga->width*4 );
    }
}

void vga_framecopy( vga_t *vga, void *data, Huint w, Huint h, Huint d )
{
    Huint  x;
    Huint  y;
    Huint  fx;
    Huint  fy;
    Huint  *base;
    Hubyte *copy;
    vga_color col;

    // Type cast the memory pointer
    copy = (Hubyte*)data;

    // Determine which buffer to use
    if( vga->dbase != NULL )    base = (Huint*)vga->dbase;
    else                        base = (Huint*)vga->base;

    // Fill the frame buffer
    for( y = 0; y < vga->height; y++ )
    {
        for( x = 0; x < vga->width; x++ )
        {
            fx = x / 2;
            fy = y / 2;

            // Form the next color value
            col = vga_make( copy[fy*w+fx], copy[fy*w+fx], copy[fy*w+fx] );

            // Place the color into the frame buffer
            base[y*1024 + x] = col.value;
        }
    }
}
