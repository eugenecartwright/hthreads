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

/** \file       keyboard.h
  * \brief      Header file for the ps2 keyboard driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads PS2 driver. This driver
  * is capable of communicating with any PS2 based device.
  */
#ifndef _HYBRID_THREADS_DRIVER_PS2_KEYBOARD_H_
#define _HYBRID_THREADS_DRIVER_PS2_KEYBOARD_H_

#include <httype.h>
#include <ps2/ps2.h>

#define KEY_A           0x1C
#define KEY_B           0x32
#define KEY_C           0x21
#define KEY_D           0x23
#define KEY_E           0x24
#define KEY_F           0x2B
#define KEY_G           0x34
#define KEY_H           0x33
#define KEY_I           0x43
#define KEY_J           0x3B
#define KEY_K           0x42
#define KEY_L           0x4B
#define KEY_M           0x3A
#define KEY_N           0x31
#define KEY_O           0x44
#define KEY_P           0x4D
#define KEY_Q           0x15
#define KEY_R           0x2D
#define KEY_S           0x1B
#define KEY_T           0x2C
#define KEY_U           0x3C
#define KEY_V           0x2A
#define KEY_W           0x1D
#define KEY_X           0x22
#define KEY_Y           0x35
#define KEY_Z           0x1A

#define KEY_1           0x16
#define KEY_2           0x1e
#define KEY_3           0x26
#define KEY_4           0x25
#define KEY_5           0x2E
#define KEY_6           0x36
#define KEY_7           0x3D
#define KEY_8           0x3E
#define KEY_9           0x46
#define KEY_0           0x45

#define KEY_ESC         0x76
#define KEY_F1          0x05
#define KEY_F2          0x06
#define KEY_F3          0x04
#define KEY_F4          0x0C
#define KEY_F5          0x03
#define KEY_F6          0x0B
#define KEY_F7          0x83
#define KEY_F8          0x0A
#define KEY_F9          0x01
#define KEY_F10         0x09
#define KEY_F11         0x78
#define KEY_F12         0x07

#define KEY_TILDE       0x0E
#define KEY_MINUS       0x4E
#define KEY_PLUS        0x55
#define KEY_BS          0x66
#define KEY_TAB         0x0D
#define KEY_CAPS        0x58
#define KEY_LSHIFT      0x12
#define KEY_RSHIFT      0x59
#define KEY_CTRL        0x14
#define KEY_ALT         0x11
#define KEY_NUMLOCK     0x77
#define KEY_LBRACE      0x54
#define KEY_RBRACE      0x5B
#define KEY_BSLASH      0x5D
#define KEY_FSLASH      0x4A
#define KEY_SEMI        0x4C
#define KEY_QUOTE       0x52
#define KEY_COMMA       0x41
#define KEY_PERIOD      0x49
#define KEY_SPACE       0x29
#define KEY_ENTER       0x5A
#define KEY_UP          0x75
#define KEY_DOWN        0x72
#define KEY_LEFT        0x6B
#define KEY_RIGHT       0x74
#define KEY_PAD5        0x73
#define KEY_SCROLL      0x7E
#define KEY_PADTIMES    0x7C
#define KEY_PADMINUS    0x7B
#define KEY_PADPLUS     0x79
#define KEY_PAUSE       0xE1

#define KEY_EXTEND      0xE0
#define KEY_INSERT      0x70
#define KEY_HOME        0x6C
#define KEY_PGUP        0x7D
#define KEY_DELETE      0x71
#define KEY_END         0x69
#define KEY_PGDOWN      0x7A
#define KEY_LWIN        0x1F
#define KEY_RWIN        0x27
#define KEY_MENU        0x2F
#define KEY_PRINT       0x7C
#define KEY_PADENTER    0x5A

#define KEY_RELEASE     0xF0

#define KEYBOARD_CMD_RESET      0xFF
#define KEYBOARD_CMD_DISABLE    0xF5
#define KEYBOARD_CMD_ENABLE     0xF4
#define KEYBOARD_CMD_SETRATE    0xF3
#define KEYBOARD_CMD_GETID      0xF2
#define KEYBOARD_CMD_SETLED     0xED

#define KEYBOARD_LED_SCROLL     0x01
#define KEYBOARD_LED_NUM        0x02
#define KEYBOARD_LED_CAPS       0x04

#define KEYBOARD_DELAY_0_25     0x00
#define KEYBOARD_DELAY_0_50     0x20
#define KEYBOARD_DELAY_0_75     0x40
#define KEYBOARD_DELAY_1_00     0x60

#define KEYBOARD_RATE_30_0      0x00
#define KEYBOARD_RATE_26_7      0x01
#define KEYBOARD_RATE_24_0      0x02
#define KEYBOARD_RATE_21_8      0x03
#define KEYBOARD_RATE_20_7      0x04
#define KEYBOARD_RATE_18_5      0x05
#define KEYBOARD_RATE_17_1      0x06
#define KEYBOARD_RATE_16_0      0x07
#define KEYBOARD_RATE_15_0      0x08
#define KEYBOARD_RATE_13_3      0x09
#define KEYBOARD_RATE_12_0      0x0A
#define KEYBOARD_RATE_10_9      0x0B
#define KEYBOARD_RATE_10_0      0x0C
#define KEYBOARD_RATE_09_2      0x0D
#define KEYBOARD_RATE_08_6      0x0E
#define KEYBOARD_RATE_08_0      0x0F
#define KEYBOARD_RATE_07_5      0x10
#define KEYBOARD_RATE_06_7      0x11
#define KEYBOARD_RATE_06_0      0x12
#define KEYBOARD_RATE_05_5      0x13
#define KEYBOARD_RATE_05_0      0x14
#define KEYBOARD_RATE_04_6      0x15
#define KEYBOARD_RATE_04_3      0x16
#define KEYBOARD_RATE_04_0      0x17
#define KEYBOARD_RATE_03_7      0x18
#define KEYBOARD_RATE_03_3      0x19
#define KEYBOARD_RATE_03_0      0x1A
#define KEYBOARD_RATE_02_7      0x1B
#define KEYBOARD_RATE_02_5      0x1C
#define KEYBOARD_RATE_02_3      0x1D
#define KEYBOARD_RATE_02_1      0x1E
#define KEYBOARD_RATE_02_0      0x1F

typedef struct
{
    Hbool   shift;
    Hbool   ctrl;
    Hbool   alt;
    Hbool   caps;
    Hbool   scroll;
    Hbool   num;

    Hubyte  leds;
    Hubyte  rate;
    Hubyte  delay;

    Hubyte  size;
    Hubyte  data[3];

    ps2_t   *ps2;
} keyboard_t;

extern Hint keyboard_create( keyboard_t*, ps2_t* );
extern Hint keyboard_destroy( keyboard_t* );
extern Hint keyboard_reset( keyboard_t* );
extern Huint keyboard_getkey( keyboard_t* );
extern Huint keyboard_getcode( keyboard_t* );
extern Hubyte keyboard_getascii( keyboard_t* );
extern void keyboard_enablecaps( keyboard_t* );
extern void keyboard_disablecaps( keyboard_t* );
extern void keyboard_togglecaps( keyboard_t* );
extern void keyboard_enablenum( keyboard_t* );
extern void keyboard_disablenum( keyboard_t* );
extern void keyboard_togglenum( keyboard_t* );
extern void keyboard_enablescroll( keyboard_t* );
extern void keyboard_disablescroll( keyboard_t* );
extern void keyboard_togglescroll( keyboard_t* );
extern void keyboard_enable( keyboard_t* );
extern void keyboard_disable( keyboard_t* );
extern void keyboard_setrate( keyboard_t*, Hubyte );
extern void keyboard_setdelay( keyboard_t*, Hubyte );

#endif
