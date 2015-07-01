#ifndef _ICAP_H_
#define _ICAP_H_

#include <hthread.h>
#include "config.h"
#ifdef ICAP
//#include "xbasic_types.h"
#include "xil_types.h"
#include "xil_assert.h"
#include "xhwicap_i.h"
#include "xhwicap.h"

// Define header length for a bit file
#define ICAP_HEADER_LENGTH  (103)

#define ICAP_DMA_BASEADDR           (0x84050000)
#define ICAP_BASEADDR               (XPAR_XPS_HWICAP_0_BASEADDR)

extern Hint XHwIcap_DRAM2Icap(XHwIcap * HwIcap, Huint * src_bit, Huint size);

extern Hint XHwIcap_DeviceWriteDMA(XHwIcap *InstancePtr, u32 *FrameBuffer, u32 NumWords);

extern Hint perform_PR(hthread_mutex_t * icap_mutex, XHwIcap * HwIcap, Huint * bit_file_addr, Hint bit_file_len);
#endif
#endif
