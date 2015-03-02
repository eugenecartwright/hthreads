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

/** \file       keycodes.h
  * \brief      Header file for the ps2 keyboard driver keycodes.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads PS2 driver. This driver
  * is capable of communicating with any PS2 based device.
  */
#ifndef _HYBRID_THREADS_DRIVER_PS2_KEYCODES_H_
#define _HYBRID_THREADS_DRIVER_PS2_KEYCODES_H_

#define KEYCODE_PRESS       0xF0000000
#define KEYCODE_RELEASE     0xF0000000

#define KEYCODE_NULL        0x00
#define KEYCODE_ESC         0x76
#define KEYCODE_F1          0x05
#define KEYCODE_F2          0x06
#define KEYCODE_F3          0x04
#define KEYCODE_F4          0x0C
#define KEYCODE_F5          0x03
#define KEYCODE_F6          0x0B
#define KEYCODE_F7          0x83
#define KEYCODE_F8          0x0A
#define KEYCODE_F9          0x01
#define KEYCODE_F10         0x09
#define KEYCODE_F11         0x78
#define KEYCODE_F12         0x07

#define KEYCODE_TILDE       0x0E
#define KEYCODE_1           0x16
#define KEYCODE_2           0x1e
#define KEYCODE_3           0x26
#define KEYCODE_4           0x25
#define KEYCODE_5           0x2E
#define KEYCODE_6           0x36
#define KEYCODE_7           0x3D
#define KEYCODE_8           0x3E
#define KEYCODE_9           0x46
#define KEYCODE_0           0x45
#define KEYCODE_MINUS       0x4E
#define KEYCODE_PLUS        0x55
#define KEYCODE_BS          0x66

#define KEYCODE_TAB         0x0D
#define KEYCODE_Q           0x15
#define KEYCODE_W           0x1D
#define KEYCODE_E           0x24
#define KEYCODE_R           0x2D
#define KEYCODE_T           0x2C
#define KEYCODE_Y           0x35
#define KEYCODE_U           0x3C
#define KEYCODE_I           0x43
#define KEYCODE_O           0x44
#define KEYCODE_P           0x4D
#define KEYCODE_LBRACE      0x54
#define KEYCODE_RBRACE      0x5B
#define KEYCODE_BSLASH      0x5D

#define KEYCODE_CAPS        0x58
#define KEYCODE_A           0x1C
#define KEYCODE_S           0x1B
#define KEYCODE_D           0x23
#define KEYCODE_F           0x2B
#define KEYCODE_G           0x34
#define KEYCODE_H           0x33
#define KEYCODE_J           0x3B
#define KEYCODE_K           0x42
#define KEYCODE_L           0x4B
#define KEYCODE_SEMI        0x4C
#define KEYCODE_QUOTE       0x52
#define KEYCODE_ENTER       0x5A

#define KEYCODE_SHIFT       0x12
#define KEYCODE_Z           0x1A
#define KEYCODE_X           0x22
#define KEYCODE_C           0x21
#define KEYCODE_V           0x2A
#define KEYCODE_B           0x32
#define KEYCODE_N           0x31
#define KEYCODE_M           0x3A
#define KEYCODE_COMMA       0x41
#define KEYCODE_PERIOD      0x49
#define KEYCODE_FSLASH      0x4A

#define KEYCODE_CTRL        0x14
#define KEYCODE_WIN         0x1F
#define KEYCODE_ALT         0x11
#define KEYCODE_SPACE       0x29
#define KEYCODE_MENU        0x2F

#define KEYCODE_PRINT       0x7C
#define KEYCODE_SCROLL      0x7E
#define KEYCODE_PAUSE       0xE1

#define KEYCODE_INSERT      0x70
#define KEYCODE_HOME        0x6C
#define KEYCODE_PGUP        0x7D

#define KEYCODE_DELETE      0x71
#define KEYCODE_END         0x69
#define KEYCODE_PGDOWN      0x7A

#define KEYCODE_UP          0x75
#define KEYCODE_LEFT        0x6B
#define KEYCODE_DOWN        0x72
#define KEYCODE_RIGHT       0x74

#define KEYCODE_NUMLOCK     0x77
#define KEYCODE_PADTIMES    0x7C
#define KEYCODE_PADMINUS    0x7B
#define KEYCODE_PADPLS      0x79
#define KEYCODE_PAD5        0x73
#define KEYCODE_PADENTER    0x5A

#endif
