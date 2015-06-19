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

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

FILE* file_open( const char *name )
{
    FILE *file;

    file = fopen( name, "r" );
    if( file == NULL )
    {
        perror( "could not open file" );
        exit( 1 );
    }

    return file;
}

void file_close( FILE *file )
{
    int res;

    res = fclose( file );
    if( res != 0 )
    {
        perror( "could not close file" );
    }
}

void file_header( FILE *file )
{
    fscanf( file, "%*s" );
}

float file_next( FILE *file )
{
    int   num;
    int   tag;
    float time;

    num = fscanf( file, "%d,%f", &tag, &time );
    if( num != 2 )    return -1.0f;

    return time;
}

void file_read( FILE *file )
{
    float time1;
    float time2;
    float diff;
    float mean;
    float var;
    float delta;
    int   num;

    num  = 0;
    var  = 0.0f;
    mean = 0.0f;
    file_header(file);
    while( 1 )
    {
        time1 = file_next(file); if( time1 < 0 )    break;
        time2 = file_next(file); if( time2 < 0 )    break;
        diff  = time2 - time1;

        num++;
        delta = diff - mean;
        mean += delta / num;
        var  += delta * (diff - mean);

        printf( "%f\n", diff );
    }

    printf( "\n\n" );
    printf( "Mean:     %f\n", mean );
    printf( "Std. Dev: %f\n", sqrt(var/(num-1)) );
}

int main( int argc, char* argv[] )
{
    FILE *file;

    if( argc < 2 )
    {
        printf( "Usage: %s file\n", argv[0] );
        exit( 1 );
    }

    file = file_open( argv[1] );
    file_read(file);
    file_close(file);
    
    return 0;
}
