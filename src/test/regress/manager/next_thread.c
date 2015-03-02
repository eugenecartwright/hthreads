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
#include <manager/manager.h>

int main( int argc, char *argv[] )
{
	Huint		    i;
    Huint           tid;
    Huint           status;
    Huint           failed;
	
    _reset_hardware();

    failed = 0;

    for( i = 0; i < 256; i++ )
    {
        status = _create_detached();
        if( has_error(status) )
        {
            printf( "Created Detached Failed:    (LOOP VAL=%u)\n", i );
            failed = 1;
        }
        else
        {
            tid = extract_id( status );
            printf( "Created Detached Succeeded: (TID=%u)\n", tid );
        }
    }
    
    for( i = 0; i < 256; i++ )
    {
        status = _create_detached();
        if( has_error(status) )
        {
            printf( "Created Detached Failed:    (LOOP VAL=%u)\n", i );
        }
        else
        {
            tid = extract_id( status );
            printf( "Created Detached Succeeded: (TID=%u)\n", tid );
            failed = 1;
        }
    }
    
    if( failed )    printf( "--FAILURE--\n" );
    else            printf( "--QED--\n" );
	return 1;
}
