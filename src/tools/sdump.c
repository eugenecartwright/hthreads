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

/** 
 *  \file
 *  Bootstrap utility for Virtex II Pro
 *
 *  Copyright (c) 2003 Thomas Gleixner <tgxl@linutronix.de>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License version 2 as
 *  published by the Free Software Foundation.
 *
 *
 *  <p>
 *  Simple bootstrap utility<br>
 *  Following command line options are available
 *  </p>
 *  <table>
 *  <tr><td>-t, --tty DEVICE		</td><td>set tty device (default: /dev/ttyS0)</td></tr>
 *  <tr><td>-o, --offset OFFSET		</td><td>set SDRAM offset (default: 0x0)</td></tr>
 *  <tr><td>-s, --start OFFSET          </td><td>set SDRAM start address offset (default: 0x0).
 *  	start adrress offset > SDRAM size returns to download instead of starting the downloaded code</td></tr>
 *  <tr><td>-d, --debug			</td><td>enable debug output</td></tr>
 *  <tr><td>-v, --version		</td><td>show program version and exit</td></tr>
 *  <tr><td>-?, --help			</td><td>show this helptext and exit</td></tr>
 *  </table>	
 *  <p><b>Project:</b>		Virtex II Pro</p>	
 *  <p><b>File:</b>       	bootstrap.c</p>
 *
 *  <p>Change Log:</p>
 *  <ul>
 *  <li> 1.0 First implementation </li>
 *  </ul>
 *
 *  @author Thomas Gleixner <tglx@linutronix.de>
 *  @version 1.0 1
 *  $Id: sdump.c,v 1.3 2004/06/16 15:59:47 peckw Exp $
*/

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <getopt.h>
#include <signal.h>
#include <fcntl.h>
#include <termios.h>

/** Version string */
#define VERSION_STRING "Serial Port Dump V 1.0"

/** Timeout for receive */
#define RS_TIMEOUT	10

/* Global variables */

/** Global debug variable */
static int debug;

/** Stop the program */
static int stop = 0;

/** Do not output to the console */
static int quiet = 0;

/** Baudrate */
static int baud = 115200;

/** device */
static char dev[256];

/** output file */
static char out[256];

/** Option defines for commandline decoding */
static struct option long_options[] =
{
	{"tty", 1, NULL, 't'},
	{"buadrate", 1, NULL, 'b'},
	{"output", 1, NULL, 'o'},
	{"debug", 0, NULL, 'd'},
	{"quiet", 0, NULL, 'q'},
	{"version", 0, NULL, 'v'},
	{"help", 0, NULL, '?'},
	{NULL, 0, NULL, 0}
};

/** Helptext for commandline options */
static char *helptext =
"Usage: sdump [OPTIONS]\n"
"\n"
"Options:\n"
"  -t, --tty DEVICE         set tty device (default: /dev/ttyS0)\n"
"  -o, --output FILE        set the output file (default: output.log)\n"
"  -b, --baudrate BAUD      set Baudrate (default: 115200)\n"
"  -d, --debug              enable debug output on stderr\n"
"  -q, --quiet              do not output anything to the console\n"
"  -v, --version            show program version and exit\n"
"  -?, --help               show this helptext and exit\n"
"\n";

/** Decode commandline arguments
 *
 *	@param 	argc Number of commandline arguments
 *	@param 	argv Array of commandline arguments
*/
void decode_commandline (int argc, char** argv)
{
	int 	opt, c;
	strcpy( dev, "/dev/ttyS0" );
	strcpy( out, "output.log" );

	while((opt=getopt_long(argc,argv,"b:dqo:t:v?",long_options,&c)) >= 0)
    {
		switch (opt)
        {
		case 'b':   baud = atoi(optarg);                            break;
		case 'd':	debug = 1;  			                        break;
		case 'q':	quiet = 1;  			                        break;
		case 'o':	strcpy(out, optarg);                  			break;		
		case 't':	strcpy(dev, optarg);               			    break;		
		case 'v':	fprintf( stdout, "%s\n", VERSION_STRING );      exit (0);
		case 'h':
        case '?':
		default :	fprintf( stderr, helptext );                    exit (0);
		}
	}

    if( debug )
    {
        printf( "Baud:   %u\n", baud );
        printf( "Output: %s\n", out );
        printf( "Device: %s\n", dev );
    }
}

/** Signal handler for handling shut down events. 
 *  On SIGTER and SIGINT
 *  the stop variable is set to 1, This leads to termination of the 
 *  main loop.
 *
 *	@param sig received signal
 */
void term_handler (int sig)
{
	switch( sig )
    {
	case SIGTERM:   stop = 1;
	case SIGINT:    stop = 1;
	}	
}

/** get baudrate constants
 *
 *	@param	baud	given baudrate
 *  	@return		Baudrate constant
 */
int checkbaudrate (int baud)
{
	switch( baud )
    {
	case 1200:      baud = B1200;       break;
	case 2400:      baud = B2400;       break;
	case 4800:      baud = B4800;       break;
	case 9600:      baud = B9600;       break;
	case 19200:     baud = B19200;      break;
	case 38400:     baud = B38400;      break;
	case 115200:    baud = B115200;     break;
	default:        baud = B38400;      break;
	}
    
	return baud;		
}

int open_serial( struct termios *newtio, struct termios *oldtio )
{
    int fd;
    
	fd = open( dev, O_RDWR | O_NOCTTY );
	if( fd < 0 )
    {
		fprintf (stderr, "Could not open serial port %s\n", dev);
        exit( -EIO );
	}
    
	/* save current port settings */
	tcgetattr( fd, oldtio );	

    /* Setup the new port settings */
	bzero( newtio, sizeof (struct termios) );
	newtio->c_cflag = checkbaudrate( baud ) | CS8 | CLOCAL | CREAD;
	newtio->c_iflag = IGNPAR | IGNBRK;
	newtio->c_oflag = 0;
	
    /* set input mode (non canonical, no echo,...) */
	newtio->c_lflag = 0;
	newtio->c_cc[VTIME] = RS_TIMEOUT;
	
    /* return on first received char */	
	newtio->c_cc[VMIN] = 0;
	tcflush( fd, TCIFLUSH );
	tcsetattr( fd, TCSANOW, newtio );

    return fd;
}

int close_serial( int fd, struct termios *old )
{
	tcsetattr (fd, TCSANOW, old);
	return close( fd );
}

int receive_data( int fd )
{
    FILE*   output;
    char    buf[256];
    ssize_t num;
    
    output = fopen( out, "w" );

    num = read( fd, buf, 255 );
    while( (num >= 0) && (stop == 0) )
    {
        if( num > 0 )
        {
            fwrite( buf, 1, num, output );
            fflush( output );
            
            if( !quiet )
            {
                buf[ num ] = 0;
                printf( buf );
                fflush( stdout );
            }
        }
        
        num = read( fd, buf, 255 );
    }
    
    fclose( output );
    return 0;
}

/** Main fo bootstrap code. This function decodes the commandline
 *  and tries to download the file
 *
 *	@param 	argc Number of commandline arguments
 *	@param 	argv Array of commandline arguments
 *	@return 0 for normal exit, errorcode on abnormal program 
 *		termination
 */
int main (int argc, char** argv)
{
    int     serial;
    struct termios oldtio;
    struct termios newtio;

	/* Get command line arguments */
	decode_commandline( argc, argv );

	/* Install termination handlers */
	signal(SIGINT,  term_handler );
	signal(SIGTERM, term_handler );
	
    serial = open_serial( &newtio, &oldtio );
    receive_data( serial );
    close_serial( serial, &oldtio );
    
	return 0;
}
