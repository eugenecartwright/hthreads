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

/** \file       cfg.h
  * \brief      Header file for the sysace jtag driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads sysace jtag driver. This driver
  * is capable of communicating with any SysAce based jtag device.
  */
#ifndef _HYBRID_THREADS_DRIVER_SYSACE_JTAG_H_
#define _HYBRID_THREADS_DRIVER_SYSACE_JTAG_H_

#include <sysace/sysace.h>

extern Hint sysace_cfg_reset( sysace_t* );
extern Hint sysace_cfg_addr( sysace_t*, Huint );
extern Hint sysace_cfg_mode( sysace_t*, Hbool, Hbool );
extern Hint sysace_cfg_select( sysace_t*, Hbool );
extern Hint sysace_cfg_prog( sysace_t*, Hubyte*, Huint );
extern Huint sysace_cfg_sector( sysace_t* );

#endif
