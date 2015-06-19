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

/** \file       intr.c
  * \brief      The implementation of interrupts for the Hybrid Threads API.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Keith Preston
  *             Ed Komp <komp@ittc.ku.edu>
  */
#include <hthread.h>
#include <sys/syscall.h>
#include <pic/pic.h>

/** \brief  Associate a thread with an interrupt.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will associate a thread with and interrupt so that the thread
  * will not run again until the interrupt has occurred. This function call
  * will block the calling thread until the interrupt that was associated with
  * has fired.
  *
  * \param iid      This parameter is the interrupt number of the interrupt
  *                 to associate the calling thread with.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The thread has successfully been associated with
  *                     the given interrupt number.
  *                 - HTHREAD_FAILURE\n
  *                     The thread could not be associated with the given
  *                     interrupt number.
  */
Hint hthread_intrassoc( Huint iid )
{
    return (Hint)do_syscall( HTHREAD_SYSCALL_INTRASSOC,
                             (void*)iid,
                             NULL,
                             NULL,
                             NULL,
                             NULL );
}

Huint hthread_cbis_init()
{
    // Not a syscall, make a direct function call
    Huint res;
    volatile Huint *cmd;

    // 1) Form command address
    cmd = (Huint *)cbis_encode_cmd(CBIS_MANUAL_RESET, 0, 0);

    // 2) Invoke command (read from address) and grab result
    res = *cmd;

    return res;
}

