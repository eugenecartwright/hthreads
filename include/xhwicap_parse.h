/* $Header: /group/xrlabs/cvsroot/pc_srp/i/xhwicap_parse.h,v 1.1 2004/09/24 22:04:12 brandonb Exp $ */  
/*****************************************************************************
*
*       XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
*       AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
*       SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
*       OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
*       APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
*       THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
*       AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
*       FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
*       WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
*       IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
*       REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
*       INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*       FOR A PARTICULAR PURPOSE.
*
*       (c) Copyright 2004 Xilinx Inc.
*       All rights reserved.
*
*****************************************************************************/

/****************************************************************************/
/**
*
* @file xhwicap_parse.h
*
* This file has prototypes which define functions used for parsing
* bitstreams.  It also contains some useful macros and data types for
* bitstream parsing.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -------------------------------------------------------
* 1.00a bjb  9/1/04 First release
*
* </pre>
*
*****************************************************************************/

#ifndef XHWICAP_PARSE_H_ /* prevent circular inclusions */
#define XHWICAP_PARSE_H_ /* by using protection macros */

/***************************** Include Files ********************************/

#include "xhwicap_l.h"
#include "xhwicap_i.h"
#include <xstatus.h>
#include "xbasic_types.h"

/* TODO - move this to another header file */
/* #include <xhwicap_sim.h> */

/************************** Constant Definitions ****************************/

/* Used for parsing bitstream header */
#define XHI_EVEN_MAGIC_BYTE     0x0f
#define XHI_ODD_MAGIC_BYTE      0xf0

/* Extra mode for IDLE */
#define XHI_OP_IDLE  -1

#define XHI_BIT_HEADER_FAILURE -1

/* The imaginary module length register */
#define XHI_MLR                  15

/************************** Type Definitions ********************************/

/**
* This typedef contains bitstream header information.
*/
typedef struct
{
    Xint32  HeaderLength;     /* Length of header in 32 bit words */
    Xuint32 BitstreamLength;  /* Length of bitstream to read in bytes*/
    Xuint8 *DesignName;       /* Design name read from bitstream header */
    Xuint8 *PartName;         /* Part name read from bitstream header */
    Xuint8 *Date;             /* Date read from bitstream header */
    Xuint8 *Time;             /* Bitstream creation time read from header */
    Xuint32 MagicLength;      /* Length of the magic numbers in header */

} XHwIcap_Bit_Header;


/***************** Macro (Inline Functions) Definitions *********************/

/****************************************************************************/
/**
* 
* Returns the Header Type from the specified Header.
* register.
*
* @param    Header is the packet header
*
* @return   Type of header.  Type 1 or Type 2
*
* @note     None.
*
*****************************************************************************/
#define XHwIcap_mGetType(Header) ((Header >> XHI_TYPE_SHIFT) & XHI_TYPE_MASK)

/****************************************************************************/
/**
* 
* Returns the Operation Type (read or write) from the specified Header.
* register.
*
* @param    Header is the packet header
*
* @return   Operation Type.
*
* @note     None.
*
*****************************************************************************/
#define XHwIcap_mGetOp(Header) ((Header >> XHI_OP_SHIFT) & XHI_OP_MASK)

/****************************************************************************/
/**
* 
* Returns the Register that the Header operates on.
*
* @param    Header is the packet header
*
* @return   Register
*
* @note     None.
*
*****************************************************************************/
#define XHwIcap_mGetRegister(Header) ((Header >> XHI_REGISTER_SHIFT) & XHI_REGISTER_MASK)

/****************************************************************************/
/**
* 
* Returns the Word count for the type 1 packet
*
* @param    Header is the packet header
*
* @return   Packet word count
*
* @note     None.
*
*****************************************************************************/
#define XHwIcap_mGetWordCountType1(Header) (Header & XHI_WORD_COUNT_MASK_TYPE_1)

/****************************************************************************/
/**
* 
* Returns the Word count for the type 2 packet
*
* @param    Header is the packet header
*
* @return   Packet word count
*
* @note     None.
*
*****************************************************************************/
#define XHwIcap_mGetWordCountType2(Header) (Header & XHI_WORD_COUNT_MASK_TYPE_2)

/************************** Function Prototypes *****************************/


/*  xhwicap_parse prototypes */

XHwIcap_Bit_Header XHwIcap_ReadHeader(Xuint8 *Data, Xuint32 Size);


/************************** Variable Declarations ***************************/


#endif
