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

/** \file       reg.h
  * \brief      Header file for the sysace driver register access macros.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#ifndef _HYBRID_THREADS_DRIVER_SYSACE_REG_H_
#define _HYBRID_THREADS_DRIVER_SYSACE_REG_H_

#include <sysace/sysace.h>
#include <hendian.h>


#define sysace_setreg32(reg,v)              \
({                                          \
    Hushort ___cd;                          \
                                            \
    ___cd = big_to_littles(v);              \
    *(reg[0]) = ___cd;                      \
                                            \
    ___cd = big_to_littles(v>>16);          \
    *(reg[1]) = ___cd;                      \
})

#define sysace_getreg32(reg)                \
({                                          \
    Huint   ___cr;                          \
    Hushort ___cd;                          \
                                            \
    ___cd = *(reg[0]);                      \
    ___cr = little_to_bigs(___cd);          \
                                            \
    ___cd = *(reg[1]);                      \
    ___cr |= little_to_bigs(___cd) << 16;   \
                                            \
    ___cr;                                  \
})

#define sysace_orreg32(reg,mask)            \
({                                          \
    Huint   ___cr;                          \
                                            \
    ___cr  = sysace_getreg32(reg);          \
    ___cr |= (mask);                        \
    sysace_setreg32(reg,___cr);             \
})

#define sysace_andreg32(reg,mask)           \
({                                          \
    Huint   ___cr;                          \
                                            \
    ___cr  = sysace_getreg32(reg);          \
    ___cr &= (mask);                        \
    sysace_setreg32(reg,___cr);             \
})

#define sysace_setreg16(reg,v)              \
({                                          \
    Hushort _v;                             \
                                            \
    _v = big_to_littles(v);                 \
    *(reg[0]) = _v;                         \
})

#define sysace_getreg16(reg)                \
({                                          \
    Hushort _v;                             \
                                            \
    _v = *(reg[0]);                         \
    little_to_bigs(_v);                     \
})

#define sysace_orreg16(reg,mask)            \
({                                          \
    Hushort ___cr;                          \
                                            \
    ___cr = sysace_getreg16(reg);           \
    ___cr |= mask;                          \
    sysace_setreg16(reg,___cr);             \
})

#define sysace_andreg16(reg,mask)           \
({                                          \
    Hushort ___cr;                          \
                                            \
    ___cr = sysace_getreg16(reg);           \
    ___cr &= mask;                          \
    sysace_setreg16(reg,___cr);             \
})

// Delay function to wait a small period of time after we set the control register
#define DELAY_CTRL(ace)         \
({                              \
    sysace_getversion(ace);     \
    sysace_getversion(ace);     \
    sysace_getversion(ace);     \
    sysace_getversion(ace);     \
})

// Register access to the mode register
#define sysace_setmode(ace,v)           sysace_setreg16((ace)->mode,v)
#define sysace_getmode(ace)             sysace_getreg16((ace)->mode)
#define sysace_ormode(ace,mask)         sysace_orreg16((ace)->mode,mask)
#define sysace_andmode(ace,mask)        sysace_andreg16((ace)->mode,mask)

// Register access to the control register
#define sysace_setcontrol(ace,v)        ({sysace_setreg32((ace)->control,v); DELAY_CTRL(ace); })
#define sysace_getcontrol(ace)          sysace_getreg32((ace)->control)
#define sysace_orcontrol(ace,mask)      ({sysace_orreg32((ace)->control,mask); DELAY_CTRL(ace); })
#define sysace_andcontrol(ace,mask)     ({sysace_andreg32((ace)->control,mask); DELAY_CTRL(ace); })

// Register access to the error register
#define sysace_seterror(ace,v)          sysace_setreg32((ace)->error,v)
#define sysace_geterror(ace)            sysace_getreg32((ace)->error)
#define sysace_orerror(ace,mask)        sysace_orreg32((ace)->error,mask)
#define sysace_anderror(ace,mask)       sysace_andreg32((ace)->error,mask)

// Register access to the status register
#define sysace_setstatus(ace,v)         sysace_setreg32((ace)->status,v)
#define sysace_getstatus(ace)           sysace_getreg32((ace)->status)
#define sysace_orstatus(ace,mask)       sysace_orreg32((ace)->status,mask)
#define sysace_andstatus(ace,mask)      sysace_andreg32((ace)->status,mask)

// Register access to the version register
#define sysace_setversion(ace,v)        sysace_setreg16((ace)->version,v)
#define sysace_getversion(ace)          sysace_getreg16((ace)->version)
#define sysace_orversion(ace,mask)      sysace_orreg16((ace)->version,mask)
#define sysace_andversion(ace,mask)     sysace_andreg16((ace)->version,mask)

// Register access to the count register
#define sysace_setsector(ace,v)         sysace_setreg16((ace)->count,v)
#define sysace_getsector(ace)           sysace_getreg16((ace)->count)
#define sysace_orsector(ace,mask)       sysace_orreg16((ace)->count,mask)
#define sysace_andsector(ace,mask)      sysace_andreg16((ace)->count,mask)

// Register access to the fat register
#define sysace_setfat(ace,v)            sysace_setreg16((ace)->fat,v)
#define sysace_getfat(ace)              sysace_getreg16((ace)->fat)
#define sysace_orfat(ace,mask)          sysace_orreg16((ace)->fat,mask)
#define sysace_andfat(ace,mask)         sysace_andreg16((ace)->fat,mask)

// Register access to the data register
#define sysace_setdata(ace,v)           sysace_setreg16((ace)->data,v)
#define sysace_getdata(ace)             sysace_getreg16((ace)->data)
#define sysace_ordata(ace,mask)         sysace_orreg16((ace)->data,mask)
#define sysace_anddata(ace,mask)        sysace_andreg16((ace)->data,mask)

// Register access to the configuration lba register
#define sysace_setclba(ace,v)           sysace_setreg32((ace)->clba,v)
#define sysace_getclba(ace)             sysace_getreg32((ace)->clba)
#define sysace_orclba(ace,mask)         sysace_orreg32((ace)->clba,mask)
#define sysace_andclba(ace,mask)        sysace_andreg32((ace)->clba,mask)

// Register access to the mpu lba register
#define sysace_setmlba(ace,v)           sysace_setreg32((ace)->mlba,v)
#define sysace_getmlba(ace)             sysace_getreg32((ace)->mlba)
#define sysace_ormlba(ace,mask)         sysace_orreg32((ace)->mlba,mask)
#define sysace_andmlba(ace,mask)        sysace_andreg32((ace)->mlba,mask)

#endif
