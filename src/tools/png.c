/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Arkansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include "ethernet.h"
#include "image.h"

#define PNG_DEBUG 3
#include <png.h>

image* read_png_file( const char* file )
{
    image   *img;
	char    header[8];
    png_structp png_ptr;
    png_infop info_ptr;
    int number_of_passes;
    int y;
    png_bytep * row_pointers;

	/* open file and test for it being a png */
	FILE *fp = fopen( file, "rb" );
	if( fp == NULL )
    {
        printf( "Read PNG Failed: %s could not be read\n", file );
        exit( 1 );
    }
    
	fread( header, 1, 8, fp );
	if( png_sig_cmp(header, 0, 8) )
    {
        printf( "Read PNG Failed: %s not a PNG file\n", file );
        exit( 1 );
    }

	png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
	if( png_ptr == NULL )
    {
        printf( "Read PNG Failed: could not read PNG data\n" );
        exit( 1 );
    }

	info_ptr = png_create_info_struct(png_ptr);
	if( info_ptr == NULL )
    {
        printf( "Read PNG Failed: could not read image info\n" );
        exit( 1 );
    }

	if( setjmp(png_jmpbuf(png_ptr)) )
    {
        printf( "Read PNG Failed: could not initialize io\n" );
        exit( 1 );
    }

	png_init_io(png_ptr, fp);
	png_set_sig_bytes(png_ptr, 8);

	png_read_info(png_ptr, info_ptr);
    if( info_ptr->color_type != PNG_COLOR_TYPE_RGBA )
    {
        printf( "Read PNG Failed: only RGBA PNG images are supported\n" );
    }

    img = (image*)malloc( sizeof(image) );
	img->width  = info_ptr->width;
	img->height = info_ptr->height;
	img->depth  = info_ptr->rowbytes / img->width;
    img->type   = info_ptr->color_type;

    printf( "Image Width:  %u %u\n", img->width, info_ptr->width );
    printf( "Image Height: %u %u\n", img->height, info_ptr->height );
    printf( "Image Depth:  %u %u\n", img->depth, info_ptr->bit_depth );
    printf( "Image Type:   %u %u\n", img->type, info_ptr->color_type );

	number_of_passes = png_set_interlace_handling(png_ptr);
	png_read_update_info(png_ptr, info_ptr);

	if( setjmp(png_jmpbuf(png_ptr)) )
    {
        printf( "Read PNG Failed: image could not be read\n" );
        exit( 1 );
    }

    row_pointers = (png_bytep*)malloc( sizeof(png_bytep)*img->height);
    for( y = 0; y < img->height; y++ )
    {
        row_pointers[y] = (png_byte*)malloc(info_ptr->rowbytes);
    }

    printf( "reading...\n" );
	png_read_image( png_ptr, row_pointers );

    img->data = (Hubyte*)malloc( (img->width)*(img->height)*(img->depth) );
    for( y = 0; y < img->height; y++ )
    {
        memcpy( img->data + (y*img->width*img->depth),
                row_pointers[y],
                img->width*img->depth ); 
    }
    
    return img;
}


void write_png_file( const char* file, image *img )
{
    png_structp png_ptr;
    png_infop info_ptr;
    int y;
    png_bytep * row_pointers;
            
	FILE *fp = fopen( file, "wb" );
	if( fp == NULL )
    {
        printf( "Write PNG Failed: %s could not be opened=n", file );
        exit( 1 );
    }

	png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
	if( png_ptr == NULL )
    {
        printf( "Write PNG Failed: could not read file\n" );
        exit( 1 );
    }

	info_ptr = png_create_info_struct(png_ptr);
	if( info_ptr == NULL )
    {
        printf( "Write PNG Failed: could not read image info\n" );
        exit( 1 );
    }
    
	if( setjmp(png_jmpbuf(png_ptr)) )
    {
        printf( "Write PNG Failed: could not initialize io\n" );
        exit( 1 );
    }

	png_init_io(png_ptr, fp);
	if( setjmp(png_jmpbuf(png_ptr)) )
    {
        printf( "Write PNG Failed: error reading header\n" );
        exit( 1 );
    }

	png_set_IHDR(png_ptr, info_ptr, img->width, img->height,
		     8, img->type, PNG_INTERLACE_NONE,
		     PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);

	png_write_info(png_ptr, info_ptr);
	if( setjmp(png_jmpbuf(png_ptr)) )
    {
        printf( "Write PNG Failed: could not write data\n" );
        exit( 1 );
    }

    row_pointers = (png_bytep*)malloc( sizeof(png_bytep)*img->height);
    for( y = 0; y < img->height; y++ )
    {
        row_pointers[y] = (png_byte*)malloc(img->width*img->height);
    }
    
    for( y = 0; y < img->height; y++ )
    {
        memcpy( row_pointers[y],
                img->data + (y*img->width*img->depth),
                img->width*img->depth ); 
    }
    
	png_write_image( png_ptr, row_pointers );
	if( setjmp(png_jmpbuf(png_ptr)) )
    {
        printf( "Write PNG Failed: could not write image\n" );
        exit( 1 );
    }

	png_write_end(png_ptr, NULL);
}
