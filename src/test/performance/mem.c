#include <hthread.h>
#include <arch/htime.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE    (64 * 1024 * 1024)
void memcpy2( void *dst, void *src, Huint bytes )
{
    Hubyte *bstart;
    Hubyte *bend;
    Huint  *wstart;
    Huint  *wend;
    Hubyte *bsrc;
    Hubyte *bdst;
    Huint  *wsrc;
    Huint  *wdst;

    // Get byte boundary start and end locations
    bstart = (Hubyte*)src;
    bend   = (Hubyte*)src + bytes;

    // Calculate word boundary start and end locations
    wstart = (Huint*)(bstart + ((4 - ((Huint)bstart % 4)) % 4));
    wend   = (Huint*)(bend - ((Huint)bend % 4));

    // Fill bytes at the beginning upto the word boundary
    bdst = (Hubyte*)dst;
    for( bsrc = bstart; bsrc < (Hubyte*)wstart; bsrc++ )    *bdst++ = *bsrc;

    // Fill words in the middle upto the word boundaries
    wdst = (Huint*)bdst;
    for( wsrc = wstart; wsrc < wend; wsrc++ )               *wdst++ = *wsrc;

    // Fill bytes at the end upto the word boundary
    bdst = (Hubyte*)wdst;
    for( bsrc = (Hubyte*)wend; bsrc < bend; bsrc++ )        *bdst++ = *bsrc;
}

void copy_bytes( Hubyte *dst, Hubyte *src, Huint bytes )
{
    Huint           i;
    double          sc;
    hthread_time_t  start;
    hthread_time_t  finish;

    hthread_time_get( &start );
    for( i = 0; i < bytes; i++ )     dst[i] = src[i];
    hthread_time_get( &finish );

    hthread_time_diff( finish, finish, start );
    sc = hthread_time_sec(finish);

    printf( "Byte Copy:   %f secs\n", sc );
}

void copy_short( Hushort *dst, Hushort *src, Huint shorts )
{
    Huint           i;
    double          sc;
    hthread_time_t  start;
    hthread_time_t  finish;

    hthread_time_get( &start );
    for( i = 0; i < shorts; i++ )     dst[i] = src[i];
    hthread_time_get( &finish );

    hthread_time_diff( finish, finish, start );
    sc = hthread_time_sec(finish);

    printf( "Short Copy:  %f secs\n", sc );
}

void copy_int( Huint *dst, Huint *src, Huint ints )
{
    Huint           i;
    double          sc;
    hthread_time_t  start;
    hthread_time_t  finish;

    hthread_time_get( &start );
    for( i = 0; i < ints; i++ )     dst[i] = src[i];
    hthread_time_get( &finish );

    hthread_time_diff( finish, finish, start );
    sc = hthread_time_sec(finish);

    printf( "Word Copy:   %f secs\n", sc );
}

void copy_mem( void *dst, void *src, Huint bytes )
{
    double          sc;
    hthread_time_t  start;
    hthread_time_t  finish;

    hthread_time_get( &start );
    memcpy( dst, src, bytes );
    hthread_time_get( &finish );

    hthread_time_diff( finish, finish, start );
    sc = hthread_time_sec(finish);

    printf( "Memory Copy: %f secs\n", sc );
}

void copy_smart( void *dst, void *src, Huint bytes )
{
    double          sc;
    hthread_time_t  start;
    hthread_time_t  finish;

    hthread_time_get( &start );
    memcpy2( dst, src, bytes );
    hthread_time_get( &finish );

    hthread_time_diff( finish, finish, start );
    sc = hthread_time_sec(finish);

    printf( "Smart Copy:  %f secs\n", sc );
}

int main( int argc, char *argv[] )
{
    Huint   *src;
    Huint   *dst;

    src = (Huint*)malloc( SIZE );
    dst = (Huint*)malloc( SIZE );

    copy_bytes( (Hubyte*)dst, (Hubyte*)src, SIZE );
    copy_short( (Hushort*)dst, (Hushort*)src, SIZE/2 );
    copy_int( dst, src, SIZE/4 );
    copy_mem( dst, src, SIZE );
    copy_smart( dst, src, SIZE );

    free( src );
    free( dst );

    return 0;
}
