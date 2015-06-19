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

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
/*
#include <manager/commands.h>
#include <time/time.h>
#include <sys/exception.h>
*/

#define CPU_FREQ    100000000
void setupTimer( void )
{
}

int main( int argc, char *argv[] )
{
    /*
    setupTimer();

    timer_set_delta( 0, 1 * 1000 * 100000 - 1 );
    timer_set_delta( 1, 5 * 1000 * 100000 - 1 );

    timer_set_data( 0, 0xCAFEBABE );
    timer_set_data( 1, 0xDEADBEEF );

    timer_set_command( 0,   HT_TIMER_CMD_PERIODIC   | 
                            HT_TIMER_CMD_ENABLE     |
                            HT_TIMER_CMD_LOAD       |
                            HT_TIMER_CMD_RUN        );
    timer_set_command( 1,   HT_TIMER_CMD_ENABLE     |
                            HT_TIMER_CMD_LOAD       |
                            HT_TIMER_CMD_RUN        );

	printf( "--DONE--\n" );
    while( 1 )
    {
       timer_set_delta( 1, 5 * 1000 * 100000 - 1 );
    }
    */
    
	return 1;
}
