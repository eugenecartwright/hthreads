/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
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
*     * Neither the name of the University of Kansas nor the name of the
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

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "ethernet.h"
#include "image.h"

image* read_raw_file( const char *file )
{
    Huint   s;
    Huint   size;
    image   *img;
    FILE    *in;

    in = fopen( file, "r" );
    if( in == NULL )
    {
        printf( "Could not open image: %s\n", file );
        exit( 1 );
    }

    img = (image*)malloc( sizeof(image) );
    
    img->width  = 1024;
    img->height = 819;
    img->depth  = 3;
    
    size = img->width * img->height * img->depth;
    img->data = (Hubyte*)malloc( sizeof(Hubyte)*size );
    
    s = fread( img->data, sizeof(Hubyte), size, in );
    if( s != size )
    {
        printf( "Image Unreadable: %s (%u %u)\n", file, s, size );
        exit( 1 );
    }
    
    fclose( in );
    return img;
}

void write_raw_file( const char *file, image *img )
{
    Huint   s;
    Huint   size;
    FILE    *out;

    out = fopen( file, "w" );
    if( out == NULL )
    {
        printf( "Could not open image: %s\n", file );
        exit( 1 );
    }

    size = img->width * img->height * img->depth;
    s = fwrite( img->data, sizeof(Hubyte), size, out );
    if( s != size )
    {
        printf( "Image Unwritable: %s\n", file );
        exit( 1 );
    }
    
    fclose( out );
}

