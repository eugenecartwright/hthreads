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

#include <stdlib.h>
#include <stdio.h>
#include <htcmds.h>

#define BASE					0xFFFC0000
/*
#define HT_CMD_CLEAR_THREAD     0x00
#define HT_CMD_JOIN_THREAD      0x01
#define HT_CMD_DETACH_THREAD    0x02
#define HT_CMD_READ_THREAD      0x03
#define HT_CMD_ADD_THREAD       0x04
#define HT_CMD_CREATE_THREAD_J  0x05
#define HT_CMD_CREATE_THREAD_D  0x06
#define HT_CMD_EXIT_THREAD      0x07
#define HT_CMD_NEXT_THREAD      0x08
#define HT_CMD_YIELD_THREAD     0x09

#define HT_CMD_CURRENT_THREAD   0x10
#define HT_CMD_IDLE_THREAD      0x11
#define HT_CMD_QUE_LENGTH       0x12
#define HT_CMD_EXCEPTION_ADDR   0x13
#define HT_CMD_EXCEPTION_REG    0x14

#define HT_CMD_SOFT_START       0x15
#define HT_CMD_SOFT_STOP        0x16
#define HT_CMD_SOFT_RESET       0x17

#define HT_CMD_SCHED_ENTRY      0x60

#define ERR_SHIFT           0
#define ERR_MASK            0x00000001
#define ERR_BIT             (ERR_MASK << ERR_SHIFT)
    
#define STATUS_SHIFT        1
#define STATUS_MASK         0x00000007
    
#define THREAD_ID_SHIFT     2
#define THREAD_ID_MASK      0x000000FF

#define THREAD_CMD_SHIFT    10  
#define THREAD_CMD_MASK     0x0000001F

#define THREAD_SHIFT        1
#define THREAD_MASK         0x000000FF

#define has_error(status)       ((status)&ERR_BIT)
#define extract_error(status)   (((status)>>ERR_SHIFT)&ERR_MASK)
#define encode_error(status)    (((status)<<ERR_SHIFT)|ERR_MASK)

#define encode_cmd(base, th,cmd)  base |			                          \
                            ((((th)&THREAD_ID_MASK) << THREAD_ID_SHIFT) |	  \
							(((cmd)&THREAD_CMD_MASK) << THREAD_CMD_SHIFT))
#define encode_reg(reg)     encode_cmd( 0, reg )

#define extract_id(status)  (((status) >> THREAD_SHIFT) & THREAD_MASK)
#define read_reg(cmd)       (*(Huint*)(cmd))
#define write_reg(reg,val)  (*(Huint*)(reg) = val)
*/	

int main( int argc, char *argv[] )
{
	unsigned int base;
	unsigned int cmd;
	unsigned int id;
	unsigned int mx;
    
	if( argc < 3 )
	{
		printf( "Usage: %s <thread id> <mutex id> [base addr]\n", argv[0] );
		return 1;
	}

	base	= BASE;
	id 	    = atoi( argv[1] );
    mx      = atoi( argv[2] );

	if( argc >= 4 )
	{
		base = strtol( argv[3], NULL, 16 );
	}
	
	printf( "\n\n" );
	printf(	"HWTI Base Address:      0x%04x\n", base	);
	printf( "Thread ID:              %u\n", id );
	printf( "Mutex ID:               %u\n", mx );
	printf( "-----------------------------------------------\n" );

	cmd = encode_cmd(id, HT_CMD_CLEAR_THREAD );
	printf(	"Clear Thread:           mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(id, HT_CMD_JOIN_THREAD );
	printf(	"Join Thread:            mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(id, HT_CMD_DETACH_THREAD );
	printf(	"Detach Thread:          mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(id, HT_CMD_READ_THREAD );
	printf(	"Read Thread:            mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(id, HT_CMD_ADD_THREAD );
	printf(	"Add Thread:             mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(id, HT_CMD_EXIT_THREAD );
	printf(	"Exit Thread:            mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(0, HT_CMD_CREATE_THREAD_J );
	printf(	"Create Joinable Thread: mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(0, HT_CMD_CREATE_THREAD_D );
	printf(	"Create Detached Thread: mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(0, HT_CMD_NEXT_THREAD );
	printf(	"Next Thread:            mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(0, HT_CMD_CURRENT_THREAD );
	printf(	"Current Thread:         mrd 0x%04x\n", cmd	);

    cmd = encode_cmd(0, HT_CMD_EXCEPTION_REG);
	printf(	"Exception Cause:        mrd 0x%04x\n", cmd	);

	cmd = sched_cmd(0, id, HT_CMD_SCHED_SET_IDLE_THREAD );
	printf(	"Idle Thread:            mrd 0x%04x\n", cmd	);

    cmd = sched_cmd(0, id, HT_CMD_SCHED_HIGHPRI );
	printf(	"High/DBG Thread:        mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(0, HT_CMD_QUE_LENGTH );
	printf(	"Queue Length:           mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(0, HT_CMD_SOFT_STOP );
	printf(	"Soft Stop:              mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(0, HT_CMD_SOFT_START );
	printf(	"Soft Start:             mrd 0x%04x\n", cmd	);

	cmd = encode_cmd(0, HT_CMD_SOFT_RESET );
	printf(	"Soft Reset:             mrd 0x%04x\n", cmd	);

    cmd = mutex_cmd( HT_MUTEX_LOCK, id, mx );
    //cmd = blk_sema_cmd( HT_CMD_REQUEST, id, mx );
	printf(	"Mutex Lock:             mrd 0x%04x\n", cmd	);
    
    cmd = mutex_cmd( HT_MUTEX_UNLOCK, id, mx );
    //cmd = blk_sema_cmd( HT_CMD_RELEASE, id, mx );
	printf(	"Mutex Unlock:           mrd 0x%04x\n", cmd	);
    
    cmd = mutex_cmd( HT_MUTEX_TRY, id, mx );
    //cmd = blk_sema_cmd( HT_CMD_TRYLOCK, id, mx );
	printf(	"Mutex Try Lock:         mrd 0x%04x\n", cmd	);
    
    cmd = mutex_cmd( HT_MUTEX_OWNER, 0, mx );
	printf(	"Mutex Owner:            mrd 0x%04x\n", cmd	);
    
    cmd = mutex_cmd( HT_MUTEX_KIND, 0, mx );
	printf(	"Mutex Kind:             mrd 0x%04x\n", cmd	);
    
    cmd = mutex_cmd( HT_MUTEX_COUNT, 0, mx );
	printf(	"Mutex Count:            mrd 0x%04x\n", cmd	);
    
    cmd = cvr_sema_cmd(HT_CMD_SIGNAL, id, mx);
	printf(	"Cond Signal:            mrd 0x%04x\n", cmd	);

    cmd = cvr_sema_cmd(HT_CMD_CWAIT, id, mx);
	printf(	"Cond Wait:              mrd 0x%04x\n", cmd	);

    cmd = cvr_sema_cmd(HT_CMD_BROADCAST, id, mx);
	printf(	"Cond Broad:             mrd 0x%04x\n", cmd	);

    cmd = sched_cmd(0, id, HT_CMD_SCHED_ENTRY);
	printf(	"Sched Entry:            mrd 0x%04x\n", cmd	);

    cmd = sched_cmd( 0, id, HT_CMD_SCHED_SETSCHEDPARAM );
	printf(	"Set Sched Param:        mrd 0x%04x\n", cmd	);

    cmd = sched_cmd( 0, id, HT_CMD_SCHED_GETSCHEDPARAM );
	printf(	"Get Sched Param:        mrd 0x%04x\n", cmd	);

    cmd = sched_cmd( 0, id, HT_CMD_SCHED_SYSCALL_LOCK );
    cmd |= 0x00040000;
	printf(	"Syscall lock:           mrd 0x%04x\n", cmd	);

    cmd = sched_cmd( 0, id, HT_CMD_SCHED_SYSCALL_LOCK );
	printf(	"Syscall unlock:         mrd 0x%04x\n", cmd	);

    cmd = sched_cmd( 0, id, HT_CMD_SCHED_MALLOC_LOCK );
    cmd |= 0x00040000;
	printf(	"Malloc lock:            mrd 0x%04x\n", cmd	);

    cmd = sched_cmd( 0, id, HT_CMD_SCHED_MALLOC_LOCK );
	printf(	"Malloc unlock:          mrd 0x%04x\n", cmd	);

    cmd = hwti_cmd( base, HT_CMD_HWTI_COMMAND );
	printf(	"HWTI Reset:             mrd 0x%04x\n", cmd	);

    cmd = hwti_cmd( base, HT_CMD_HWTI_SETID );
	printf(	"HWTI Set ID:            mrd 0x%04x\n", cmd	);

    cmd = hwti_cmd( base, HT_CMD_HWTI_SETARG );
	printf(	"HWTI Set Arg:           mrd 0x%04x\n", cmd	);

    cmd = hwti_cmd( base, HT_CMD_HWTI_RESULTS );
	printf(	"HWTI Results:           mrd 0x%04x\n", cmd	);

    cmd = cbis_encode_cmd( CBIS_WRITE, id, mx );
	printf(	"CBIS Associate (TID = %d, IID = %d)  mrd 0x%04x\n", id, mx, cmd	);

	printf( "\n\n" );
	return 0;
}

