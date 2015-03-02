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

/** \file       thread_attr.c
  * \brief      The implementations of the thread attribute function for the
  *             Hybrid Threads API.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains implementation of the thread attribute functions
  * for the Hybrid Threads API. Hybrid Threads is a threading library for
  * embedded systems which is similar in functionality to PThreads. However,
  * the management of most functionality in Hybrid Threads is done in hardware
  * on an FPGA. This frees the processor so that it only performs meaningful
  * computations. The overhead from the use of threading is reduced
  * to a simple context switch.
  */
#include <hthread.h>
#include <sys/internal.h>
#include <sys/syscall.h>
#include <hwti/hwti.h>

/** \internal
  * \brief  
  */
Hint hthread_attr_init( hthread_attr_t *attr )
{
    attr->detached      = Hfalse;
    attr->hardware      = Hfalse;
    attr->hardware_addr = 0x00000000;
    attr->stack_size    = HT_DEFAULT_STACK_SIZE;
    attr->stack_addr    = NULL;
    attr->sched_param   = 64;

    return SUCCESS;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_destroy( hthread_attr_t *attr )
{
    attr->detached      = Hfalse;
    attr->hardware      = Hfalse;
    attr->hardware_addr = 0x00000000;
    attr->stack_size    = HT_DEFAULT_STACK_SIZE;
    attr->stack_addr    = NULL;
    attr->sched_param   = 64;

    return SUCCESS;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_setstacksize( hthread_attr_t *attr, size_t stacksize )
{
    // Make sure that the stack size is at least the minimum
    if( stacksize < HTHREAD_STACK_MIN ) return EINVAL;

    // Store the stack size attribute
    attr->stack_size    = stacksize;

    // Return successfully
    return SUCCESS;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_getstacksize( const hthread_attr_t *attr, size_t *stacksize )
{
    // Store the stack size in the given location
    *stacksize = attr->stack_size;

    // Return successfully
    return SUCCESS;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_setstackaddr( hthread_attr_t *attr, void *stackaddr )
{
    // Store the stack address to use
    attr->stack_addr = stackaddr;

    // Return successfully
    return SUCCESS;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_getstackaddr( const hthread_attr_t *attr, void **stackaddr )
{
    // Store the stack address in the given location
    *stackaddr = attr->stack_addr;

    // Return successfully
    return SUCCESS;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_setstack( hthread_attr_t *attr, void *addr, size_t stacksize )
{
    hthread_attr_setstackaddr( attr, addr );
    return hthread_attr_setstacksize( attr, stacksize );
}

/** \internal
  * \brief  
  */
Hint hthread_attr_getstack( const hthread_attr_t *attr, void **addr, size_t *stacksize )
{
    hthread_attr_getstackaddr( attr, addr );
    return hthread_attr_getstacksize( attr, stacksize );
}

/** \internal
  * \brief  
  */
Hint hthread_attr_setdetachstate( hthread_attr_t *attr, Hint detachstate )
{
    if( detachstate == HTHREAD_CREATE_JOINABLE )        attr->detached = Hfalse;
    else if( detachstate == HTHREAD_CREATE_DETACHED)    attr->detached = Htrue;
    else                                                return EINVAL;

    return SUCCESS;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_getdetachstate(const hthread_attr_t *attr, Hint *detachstate )
{
    if( attr->detached )    *detachstate = HTHREAD_CREATE_DETACHED;
    else                    *detachstate = HTHREAD_CREATE_JOINABLE;

    return SUCCESS;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_setinheritsched( hthread_attr_t *attr, Hint *detachstate )
{
    return ENOTSUP;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_getinheritsched( const hthread_attr_t *attr, Hint *detachstate )
{
    return ENOTSUP;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_setschedparam( hthread_attr_t *attr, const struct sched_param *sched )
{
    // Check that the scheduling parameters are within the boundary
    if( sched->sched_priority < 0 || sched->sched_priority > HTHREAD_SCHEDPARAM_MAX )
        return EINVAL;

    // Store the scheduling parameter
    attr->sched_param = sched->sched_priority;

    // Return successfully
    return SUCCESS;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_getschedparam( const hthread_attr_t *attr, struct sched_param *sched )
{
    // Store the scheduling parameter in the given location
    sched->sched_priority = attr->sched_param;

    // Return successfully
    return SUCCESS;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_setschedpolicy( hthread_attr_t *attr, Hint schedpolicy )
{
    return ENOTSUP;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_getschedpolicy( const hthread_attr_t *attr, Hint *schedpolicy )
{
    return ENOTSUP;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_setscope( const hthread_attr_t *attr, Hint setscope )
{
    return ENOTSUP;
}

/** \internal
  * \brief  
  */
Hint hthread_attr_getscope( const hthread_attr_t *attr, Hint *setscope )
{
    return ENOTSUP;
}

/** \internal
  * \brief
  */
Hint hthread_attr_sethardware( hthread_attr_t *attr, void *baseaddr )
{
    attr->hardware      = Htrue;
    attr->hardware_addr = (Huint)baseaddr + HT_HWTI_COMMAND_OFFSET;
    attr->stack_size    = 0;
    attr->stack_addr    = NULL;

    return SUCCESS;
}

