/*

   Library for accessing the Xilinx Timer

   The Xilinx Timer is a 32-bit timer capable of generating interrupts if needed

   */

#ifndef __XIL_TIMING_H__
#define __XIL_TIMING_H__

void enableTimer(void);
unsigned int readTimer(void);

#endif  // __XIL_TIMING_H__
