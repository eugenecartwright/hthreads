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

#include <prof.h>

#define LOOPS               10
#define PROFILE_TESTAVG     1
#define PROFILE_TESTHIST    1
#define PROFILE_TESTBUFF    1
#define PROFILE_TESTSUM     1
#define PROFILE_TIMEAVG     1
#define PROFILE_TIMEHIST    1
#define PROFILE_TIMEBUFF    1
#define PROFILE_TIMESUM     1

#define TEST_TYPE           short
#define TEST_OUTPUT         serial
#define TEST_NAME           "test"

#define TIME_TYPE           time
#define TIME_OUTPUT         serial
#define TIME_NAME           "time"

void avg( void )
{
    Huint i;

    hprofile_avg_declare( TESTAVG, TEST_TYPE );
    hprofile_avg_create( TESTAVG, TEST_TYPE );

    for( i = 0; i < LOOPS; i++ )
    {
        hprofile_avg_capture( TESTAVG, TEST_TYPE, i );
    }

    hprofile_avg_flush( TESTAVG, TEST_TYPE, TEST_OUTPUT, TEST_NAME );
    hprofile_avg_close( TESTAVG, TEST_TYPE );
}

void hist( void )
{
    Huint i;

    hprofile_hist_declare( TESTHIST, TEST_TYPE );
    hprofile_hist_create( TESTHIST, TEST_TYPE, 0, 10, 10 );

    for( i = 0; i < LOOPS; i++ )
    {
        hprofile_hist_capture( TESTHIST, TEST_TYPE, i );
    }

    hprofile_hist_flush( TESTHIST, TEST_TYPE, TEST_OUTPUT, TEST_NAME );
    hprofile_hist_close( TESTHIST, TEST_TYPE );
}

void buff( void )
{
    Huint i;

    hprofile_buff_declare( TESTBUFF, TEST_TYPE );
    hprofile_buff_create( TESTBUFF, TEST_TYPE, 10 );

    for( i = 0; i < LOOPS; i++ )
    {
        hprofile_buff_capture( TESTBUFF, TEST_TYPE, LOOPS-i-1, i );
    }

    hprofile_buff_flush( TESTBUFF, TEST_TYPE, TEST_OUTPUT, TEST_NAME );
    hprofile_buff_close( TESTBUFF, TEST_TYPE );
}

void sum( void )
{
    Huint i;

    hprofile_sum_declare( TESTSUM, TEST_TYPE );
    hprofile_sum_create( TESTSUM, TEST_TYPE, 0 );

    for( i = 0; i < LOOPS; i++ )
    {
        hprofile_sum_capture( TESTSUM, TEST_TYPE, i );
    }

    hprofile_sum_flush( TESTSUM, TEST_TYPE, TEST_OUTPUT, TEST_NAME );
    hprofile_sum_close( TESTSUM, TEST_TYPE );
}

void tim( void )
{
    Huint i;

    hprofile_buff_declare( TIMEBUFF, TIME_TYPE );
    hprofile_buff_create( TIMEBUFF, TIME_TYPE, 10 );

    hprofile_hist_declare( TIMEHIST, TIME_TYPE );
    hprofile_hist_create( TIMEHIST, TIME_TYPE, 0, 100, 20 );

    hprofile_avg_declare( TIMEAVG, TIME_TYPE );
    hprofile_avg_create( TIMEAVG, TIME_TYPE );

    hprofile_sum_declare( TIMESUM, TIME_TYPE );
    hprofile_sum_create( TIMESUM, TIME_TYPE, 0 );

    for( i = 0; i < LOOPS; i++ )
    {
        hprofile_avg_start( TIMEAVG, TIME_TYPE );
        hprofile_avg_finish( TIMEAVG, TIME_TYPE );

        hprofile_buff_start( TIMEBUFF, TIME_TYPE );
        hprofile_buff_finish( TIMEBUFF, TIME_TYPE, i );

        hprofile_hist_start( TIMEHIST, TIME_TYPE );
        hprofile_hist_finish( TIMEHIST, TIME_TYPE );

        hprofile_sum_start( TIMESUM, TIME_TYPE );
        hprofile_sum_finish( TIMESUM, TIME_TYPE );
    }

    hprofile_avg_flush( TIMEAVG, TIME_TYPE, TIME_OUTPUT, TIME_NAME );
    hprofile_hist_flush( TIMEHIST, TIME_TYPE, TIME_OUTPUT, TIME_NAME );
    hprofile_buff_flush( TIMEBUFF, TIME_TYPE, TIME_OUTPUT, TIME_NAME );
    hprofile_sum_flush( TIMESUM, TIME_TYPE, TIME_OUTPUT, TIME_NAME );

    hprofile_avg_close( TIMEAVG, TIME_TYPE );
    hprofile_hist_close( TIMEHIST, TIME_TYPE );
    hprofile_buff_close( TIMEBUFF, TIME_TYPE );
    hprofile_sum_close( TIMESUM, TIME_TYPE );
}

int main( int argc, char *argv[] )
{
    avg();
    hist();
    buff();
    sum();
    tim();

	return 0;
}
