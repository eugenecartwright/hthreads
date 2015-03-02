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

// A simple test that creates several detached children but does not run them.
// This means that it simply verifies that creating a detached child works.

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <manager/manager.h>
#include <sys/exception.h>

const char *title =
"Create Detached Test";

const char *descr =
"This program will test the creation of detached \
threads using the thread manager. The program is \
divided into three parts. The first part tests that \
all 256 threads are created successfully as detached \
threads. The second part tests that the thread \
manager will give an error if more that 256 threads \
are created. The third part tests that no unexpected \
interrupts were thrown during the test.";

void show_error1( const char *hdr, Huint tid, Huint sta )
{
    Huint   ent;
    ent = _read_thread_status( tid );
    
    printf( "%s: (TID=%u) (STA=0x%8.8x) (ENT=0x%8.8x)\n", hdr, tid, sta, ent );
}

void show_error2( const char *hdr, Huint num, Huint sta )
{
    printf( "%s: (LOOP=%u) (STA=0x%8.8x)\n", hdr, num, sta );
}

void show_error3( const char *hdr, Huint sta )
{
    printf( "%s: (VAL=0x%8.8x)\n", hdr, sta );
}

void show_break( const char *hdr )
{
    printf( "\n\n" );
    printf( "****************************************" );
    printf( "****************************************\n" );
    printf( "* %-76s *", hdr );
    printf( "****************************************" );
    printf( "****************************************\n" );
}

void format_descr( const char *desc )
{
    int i;
    int j;

    i = 0;
    j = 0;
    
    while( desc[i] != 0 )
    {
        if( j == 0 )
        {
            printf( "*" );
            j = (j + 1) % 80;
        }
        else if( j == 1 )
        {
            printf( " " );
            j = (j + 1) % 80;
        }
        else if( j == 78 )
        {
            printf( " " );
            j = (j + 1) % 80;
        }
        else if( j == 79 )
        {
            printf( "*\n" );
            j = (j + 1) % 80;
        }
        else
        {
            if( j != 2 || desc[i] != ' ' )
            {
                printf( "%c", desc[i] );
                j = (j + 1) % 80;
            }

            i++;
        }
    }
    
    while( j >= 1 && j <= 79 )
    {
        if( j == 0 )            printf( "*" );
        else if( j == 1 )       printf( " " );
        else if( j == 78 )      printf( " " );
        else if( j == 79 )      printf( "*\n" );
        else                    printf( " " );

        j = (j + 1) % 80;
    }
}

void show_header( void )
{
    printf( "****************************************" );
    printf( "****************************************\n" );
    printf( "* %-76s *", title );
    printf( "****************************************" );
    printf( "****************************************\n" );
    format_descr( descr );
    printf( "****************************************" );
    printf( "****************************************\n" );
}

Huint test_interrupts( Huint crit_mask, Huint nonc_mask )
{
    Huint   crit;
    Huint   nonc;

    crit = 0;
    nonc = 0;
    //crit = intr_status(CRIT_PIC_BASEADDR);
    //nonc = intr_status(NONCRIT_PIC_BASEADDR);

    show_break( "Interrupt Controller Information" );
    printf( "Critical Interrupt Status: 0x%8.8x\n", crit );
    printf( "Noncritical Interrupt Status: 0x%8.8x\n", nonc );

    crit = crit & crit_mask;
    if( crit > 0 )
    {
        show_error3( "Unexpected Active Critical Interrupts", crit );
        return 1;
    }
    
    nonc = nonc & nonc_mask;
    if( nonc > 0 )
    {
        show_error3( "Unexpected Active Noncritical Interrupts", nonc );
        return 1;
    }

    return 0;
}

int test_create( int join )
{
	Huint		    i;
    Huint           tid;
    Huint           status;

    show_break( "Tests below here should be successful." );
    for( i = 0; i < 256; i++ )
    {
        if( join )  status = _create_joinable();
        else        status = _create_detached();
        
        if( has_error(status) )
        {
            if( join )  show_error1( "Create Joinable Failed", i, status );
            else        show_error1( "Create Detached Failed", i, status );

            return 1;
        }
        else
        {
            tid = extract_id( status );
            if( join )  printf( "Create Joinable: (TID=%u)\n", tid );
            else        printf( "Create Detached: (TID=%u)\n", tid );
        }
    }

    show_break( "Tests below here should fail." );
    for( i = 0; i < 256; i++ )
    {
        if( join )  status = _create_joinable();
        else        status = _create_detached();
        
        if( has_error(status) )
        {
            if( join )  show_error1( "Create Joinable Failed", i, status );
            else        show_error1( "Create Detached Failed", i, status );
        }
        else
        {
            tid = extract_id( status );
            if( join )  printf( "Create Joinable: (TID=%u)\n", tid );
            else        printf( "Create Detached: (TID=%u)\n", tid );

            return 1;
        }
    }

    return 0;
}

int main( int argc, char *argv[] )
{
    Huint failed_create;
    Huint failed_intr;
	
    show_header();
    _reset_hardware();
    
    failed_create   = test_create( 0 );
    failed_intr     = test_interrupts( 0xFFFFFFFF, 0xFFFFFFFF );

    show_break( "Test Status." );
    if( failed_create )     printf( "--FAILURE--\n" );
    else if( failed_intr )  printf( "--FAILURE--\n" );
    else                    printf( "--QED--\n" );

	return 0;
}
