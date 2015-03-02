#include <stdio.h>
#include <stdlib.h>

int main( int argc, char *argv[] )
{
    int     w;
    int     h;
    int     d;
    size_t  read;
    char    buf[4096];

    w = atoi( argv[1] );
    h = atoi( argv[2] );
    d = atoi( argv[3] );

    fwrite( &w, sizeof(int), 1, stdout );
    fwrite( &h, sizeof(int), 1, stdout );
    fwrite( &d, sizeof(int), 1, stdout );

    read = fread( &buf, sizeof(char), 4096, stdin );
    while( read == 4096 )
    {
        fwrite( &buf, sizeof(char), read, stdout );
        read = fread( &buf, sizeof(char), 4096, stdin );
    }

    return 0;
}
