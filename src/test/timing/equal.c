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

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <log/log.h>

#define LOOPS       5000
#undef PRINT

#define OUTER       400
#define INNER       500
#define DELTA       (10 * 100000 - 1)

log_t logbuf;

void setup_timer( void )
{
    Huint data;
    Huint delta;
    Huint timer1;
    Huint timer2;
    Huint timer3;

    printf( "Setting up Timer\n" );
    
    timer_set_delta( 0,  5 * DELTA );
    delta = timer_get_delta( 0 );
    
    timer_set_data( 0, 0xCAFEBABE );
    data = timer_get_data( 0 );
    
    timer_set_command( 0,   HT_TIMER_CMD_PERIODIC   |
                            HT_TIMER_CMD_ENABLE     |
                            HT_TIMER_CMD_LOAD       |
                            HT_TIMER_CMD_RUN        );

    timer1 = timer_get_value( 0 );
    timer2 = timer_get_value( 0 );
    timer3 = timer_get_value( 0 );
    
    printf( "Timer Delta:    %u\n", delta );
    printf( "Timer Data:     %#08x\n", data );
    printf( "Timer Value 1:  %#08x\n", timer1 );
    printf( "Timer Value 2:  %#08x\n", timer2 );
    printf( "Timer Value 3:  %#08x\n", timer3 );
    
    timer_set_delta( 0, DELTA );
    timer_set_command( 0,   HT_TIMER_CMD_PERIODIC   |
                            HT_TIMER_CMD_ENABLE     |
                            HT_TIMER_CMD_LOAD       |
                            HT_TIMER_CMD_RUN        );
}

int main( int argc, char *argv[] )
{
    Huint       j;
    Huint       self;
    register Huint start_time;
    register Huint end_time;

    setup_timer();

    self = hthread_self();
    log_create( &logbuf, LOOPS * 2 );
    for( j = 0; j < LOOPS; j++ )
    {
        start_time = timer_get_globallo();
        hthread_equal( self, 0 );
        end_time = timer_get_globallo();
        
        logbuf.buffer[ logbuf.pos++ ] = start_time;
        logbuf.buffer[ logbuf.pos++ ] = end_time;
        
#ifdef PRINT
            //XExc_mDisableExceptions(XEXC_NON_CRITICAL);
            printf( "Self: %u\n", self );
            //XExc_mEnableExceptions(XEXC_NON_CRITICAL);
#endif
    }

    //XExc_mDisableExceptions(XEXC_NON_CRITICAL);
    printf( "Flushing %u timing values...\n", logbuf.pos );
    log_flush( &logbuf );
    //log_close( &logbuf );
	printf( "--DONE--\n" );
    //XExc_mEnableExceptions(XEXC_NON_CRITICAL);

	return 1;
}
