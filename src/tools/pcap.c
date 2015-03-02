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

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netinet/if_ether.h>
#include <ncurses.h>
#include <math.h>
#include <string.h>
#include "ethernet.h"

#define FILTER  "ether dst 00:E0:18:E4:B2:74 and ether src 00:E0:18:E4:B2:75"
#define SKIP_PACKETS 1

static WINDOW *main_win;
static WINDOW *size_win;
static WINDOW *pack_win;
static WINDOW *oper_win;
static WINDOW *mini_win;
static WINDOW *maxi_win;
static WINDOW *mean_win;
static WINDOW *stdd_win;
static WINDOW *data_win;

static Huint     num_packets;
static Huint     num_bytes;

static Huint     res_total;
static Huint     res_number;
static Huint     res_max;
static Huint     res_min;
static float     res_mean;
static float     res_std;

FILE* open_file( const char *path )
{
    FILE *file;
    
    file = fopen( path, "w" );
    if( file == NULL )
    {
        perror( "Could not Open Log File" );
        exit( 1 );
    }

    return file;
}

void show_address( const char *header, u_char *addr )
{
    int i = ETHER_ADDR_LEN;
    printf( header );
    
    do
    {
        printf("%s%2.2X", (i == ETHER_ADDR_LEN) ? " " : ":", *addr++ );
    } while( --i > 0 );
    
    printf("\n");
}

void show_size( WINDOW *win, int bytes, int packets )
{
    wmove( win, 1, 1 );

    wattron( win, A_BOLD );
    wprintw( win, "Amount of Data Captured\n" );
    wattroff( win, A_BOLD );

    wmove( win, 2, 1 );
    whline( win, 0, 5000 );

    if( bytes != 0 )
    {
        wmove( win, 3, 1 );
        wprintw( win, "Bytes:   %u\n", bytes, packets );
    }

    if( packets != 0 )
    {
        wmove( win, 4, 1 );
        wprintw( win, "Packets: %u\n", packets );
    }
}

void show_mini( WINDOW *win, Huint min )
{
    wmove( win, 1, 1 );

    wattron( win, A_BOLD );
    wprintw( win, "Minimum\n" );
    wattroff( win, A_BOLD );

    wmove( win, 2, 1 );
    whline( win, 0, 5000 );

    wmove( win, 3, 1 );
    if( res_number > 0 )    wprintw( win, "%u\n", min );
    else                    wprintw( win, "No Values\n" );
}

void show_maxi( WINDOW *win, Huint max )
{
    wmove( win, 1, 1 );

    wattron( win, A_BOLD );
    wprintw( win, "Maximum\n" );
    wattroff( win, A_BOLD );

    wmove( win, 2, 1 );
    whline( win, 0, 5000 );

    wmove( win, 3, 1 );
    if( res_number > 0 )    wprintw( win, "%u\n", max );
    else                    wprintw( win, "No Values\n" );
}

void show_mean( WINDOW *win, float mean )
{
    wmove( win, 1, 1 );


    wattron( win, A_BOLD );
    wprintw( win, "Mean:\n" );
    wattroff( win, A_BOLD );

    wmove( win, 2, 1 );
    whline( win, 0, 5000 );

    wmove( win, 3, 1 );
    if( res_number > 0 )        wprintw( win,"%.2f\n", mean );
    else                        wprintw( win, "No Values\n" );
}

void show_stdd( WINDOW *win, float std )
{
    wmove( win, 1, 1 );

    wattron( win, A_BOLD );
    wprintw( win, "Std Dev\n" );
    wattroff( win, A_BOLD );

    wmove( win, 2, 1 );
    whline( win, 0, 5000 );

    wmove( win, 3, 1 );
    if( res_number > 0 )        wprintw( win, "%.2f\n", std );
    else                        wprintw( win, "No Values\n" );
}

int find_width( int max, int chunks )
{
    int width = 0;

    while( max > chunks )
    {
        width++;
        max -= chunks;
    }

    if( width == 0 )  return 1;
    else              return width;
}

void show_data( WINDOW *win, const Hubyte *data, int len )
{
    int i;
    int line;
    int space;
    int width;
    int waste;

    werase( win );
    wmove( win, 1, 1 );

    wattron( win, A_BOLD );
    wprintw( win, "Packet Data\n" );
    wattroff( win, A_BOLD );

    wmove( win, 2, 1 );
    whline( win, 0, 5000 );

    width = find_width( COLS - 2, 9 );
    waste = (COLS - 2) - width*9;
    waste /= 2;
    waste += 1;
    
    width *= 4;
    if( data != NULL && len > 0 )
    {
        line = 3;
        space = 0;
        for( i = 0; i < len; i++ )
        {
            if( i % width == 0 )
            {
                wmove( win, line++, waste );
                space = 0;
            }
            
            if( space == 4 )
            {
                wprintw( win, " " );
                space = 0;
            }

            space++;
            wprintw( win, "%2.2x", data[i] );
        }
        wprintw( win, "\n" );
    }
}

void show_packet( WINDOW *win, Hubyte *data, Huint size )
{
    wmove( win, 1, 1 );

    wattron( win, A_BOLD );
    wprintw( win, "Last Packet\n" );
    wattroff( win, A_BOLD );

    wmove( win, 2, 1 );
    whline( win, 0, 5000 );

    if( data != NULL && size > 0 )
    {
        wmove( win, 3, 1 );
        wprintw( win, "Number of Results: %u\n", size/4  );

        wmove( win, 4, 1 );
        wprintw( win, "Packet Length:     %u\n", size  );
    }
}

void show_operation( WINDOW *win, const char *oper )
{
    wmove( win, 1, 1 );

    wattron( win, A_BOLD );
    wprintw( win, "Program Status\n" );
    wattroff( win, A_BOLD );

    wmove( win, 2, 1 );
    whline( win, 0, 5000 );

    if( oper != NULL )
    {
        wmove( win, 3, 1 );
        wprintw( win, "%s\n", oper );
    }
}

void dump_packet( Huint size, Huint *data, FILE *fl)
{
    Huint   i;
    Huint   val;
    float   temp;
    float   sum;
    
    fwrite( data, sizeof(Huint), size, fl );
    fflush( fl );

    num_bytes   += size * sizeof(Huint);
    num_packets += 1;

    for( i = 0; i < size; i++ )
    {
        val = ntohl( data[i] );

        res_total   += val;
        res_number  += 1;

        if( val > res_max || res_number == 1 )  res_max = val;
        if( val < res_min || res_number == 1 )  res_min = val;
    }

    if( res_number > 0 )    res_mean = (float)res_total / (float)res_number;
    else                    res_mean = 0.0f;
    
    sum = 0;
    for( i = 0; i < size; i++ )
    {
        val     = ntohl( data[i] );
        temp    = val - res_mean;
        sum     += (temp * temp); 
    }

    sum /= (size - 1);
    res_std = sqrt( sum );

    show_size( size_win, num_bytes, num_packets );
    show_packet( pack_win, (Hubyte*)data, size*sizeof(Huint) );
    show_mini( mini_win, res_min );
    show_maxi( maxi_win, res_max );
    show_mean( mean_win, res_mean );
    show_stdd( stdd_win, res_std );
    show_data( data_win, (Hubyte*)data, size*sizeof(Huint) );
    show_operation( oper_win, "Showing Data..." );

    box( size_win, 0, 0 );
    box( pack_win, 0, 0 );
    box( mini_win, 0, 0 );
    box( maxi_win, 0, 0 );
    box( mean_win, 0, 0 );
    box( stdd_win, 0, 0 );
    box( data_win, 0, 0 );
    box( oper_win, 0, 0 );
    
    wrefresh( size_win );
    wrefresh( pack_win );
    wrefresh( mini_win );
    wrefresh( maxi_win );
    wrefresh( mean_win );
    wrefresh( stdd_win );
    wrefresh( data_win );
    wrefresh( oper_win );
}

void log_data( FILE *file )
{
    Huint   size;
    Huint   data[ ETH_MTU_WORD ];
    
    while( 1 )
    {
        memset( data, 0, sizeof(Huint)*size );

        show_operation( oper_win, "Waiting for Header..." );
        box( oper_win, 0, 0 );
        wrefresh( oper_win );
        eth_recv( (Hubyte*)&size, sizeof(Huint) );
        size = ntohl( size );

        show_operation( oper_win, "Waiting for Data..." );
        box( oper_win, 0, 0 );
        wrefresh( oper_win );
        eth_recv( (Hubyte*)data, size*sizeof(Huint) );

        dump_packet( size, data, file );
    }
}

WINDOW* create_window( WINDOW *main, int wid, int hgt, int x, int y )
{
    WINDOW *win;

    win = subwin( main, wid, hgt, x, y );
    return win;
}

void setup_ncurses( void )
{
    main_win = initscr();
    keypad(main_win, TRUE);     // enable keyboard mapping
    nonl();                     // tell curses not to do NL->CR/NL on output
    cbreak();                   // input chars one at a time, no wait for \n
    noecho();                   // don't echo input
    nodelay(main_win, TRUE);    // do non-blocking input
    curs_set( 0 );              // don't show the cursor

    size_win = create_window( main_win, 6, COLS/2, 0, 0 );
    pack_win = create_window( main_win, 6, COLS/2, 0, COLS/2 );
    mini_win = create_window( main_win, 5, COLS/4, 6, 0*(COLS/4) );
    maxi_win = create_window( main_win, 5, COLS/4, 6, 1*(COLS/4) );
    mean_win = create_window( main_win, 5, COLS/4, 6, 2*(COLS/4) );
    stdd_win = create_window( main_win, 5, COLS/4, 6, 3*(COLS/4) );
    data_win = create_window( main_win, LINES - 16, COLS, 11, 0 );
    oper_win = create_window( main_win, 5, COLS, LINES-5, 0 );

    // Use colors if the terminal has them
    if( has_colors() )
    {
        start_color();
        /*
        * Simple color assignment, often all we need.
        */
        init_pair(COLOR_BLACK, COLOR_BLACK, COLOR_BLACK);
        init_pair(COLOR_GREEN, COLOR_GREEN, COLOR_BLACK);
        init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK);
        init_pair(COLOR_CYAN, COLOR_CYAN, COLOR_BLACK);
        init_pair(COLOR_WHITE, COLOR_WHITE, COLOR_BLACK);
        init_pair(COLOR_MAGENTA, COLOR_MAGENTA, COLOR_BLACK);
        init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_BLACK);
        init_pair(COLOR_YELLOW, COLOR_YELLOW, COLOR_BLACK);
    }

    show_size( size_win, 0, 0 );
    show_packet( pack_win, NULL, 0 );
    show_mini( mini_win, 0 );
    show_maxi( maxi_win, 0 );
    show_mean( mean_win, 0 );
    show_stdd( stdd_win, 0 );
    show_data( data_win, NULL, 0 );
    show_operation( oper_win, "Waiting for Data..." );

    box( size_win, 0, 0 );
    box( pack_win, 0, 0 );
    box( mini_win, 0, 0 );
    box( maxi_win, 0, 0 );
    box( mean_win, 0, 0 );
    box( stdd_win, 0, 0 );
    box( data_win, 0, 0 );
    box( oper_win, 0, 0 );
    
    wrefresh( size_win );
    wrefresh( pack_win );
    wrefresh( mini_win );
    wrefresh( maxi_win );
    wrefresh( mean_win );
    wrefresh( stdd_win );
    wrefresh( data_win );
    wrefresh( oper_win );
}

void close_ncurses( void )
{
    endwin();
}

int main(int argc, char **argv)
{
    FILE    *file;
    Hubyte   mac[6];

    mac[0] = 0x00;    mac[1] = 0xE0;
    mac[2] = 0x18;    mac[3] = 0xE4;
    mac[4] = 0xB2;    mac[5] = 0x74;

    eth_init( mac );
    setup_ncurses();

    num_packets = 0;
    num_bytes   = 0;
    res_total   = 0;
    res_number  = 0;
    res_max     = 0;
    res_min     = 0;
    
    file = open_file( argv[1] );
    log_data( file );

    close_ncurses();
    eth_destroy();
    return 0;
}
