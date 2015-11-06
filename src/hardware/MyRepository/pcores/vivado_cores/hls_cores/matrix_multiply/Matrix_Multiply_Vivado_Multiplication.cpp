/*******************************************************************************
Vendor: Xilinx
Associated Filename: matrixmul.cpp
Purpose: Matrix multiplication example for AutoESL
Revision History: February 13, 2012 - initial release

*******************************************************************************
Copyright (C) 2013 XILINX, Inc.

This file contains confidential and proprietary information of Xilinx, Inc. and
is protected under U.S. and international copyright and other intellectual
property laws.

DISCLAIMER
This disclaimer is not a license and does not grant any rights to the materials
distributed herewith. Except as otherwise provided in a valid license issued to
you by Xilinx, and to the maximum extent permitted by applicable law:
(1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX
HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR
FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether
in contract or tort, including negligence, or under any other theory of
liability) for any loss or damage of any kind or nature related to, arising under
or in connection with these materials, including for any direct, or any indirect,
special, incidental, or consequential loss or damage (including loss of data,
profits, goodwill, or any type of loss or damage suffered as a result of any
action brought by a third party) even if such damage or loss was reasonably
foreseeable or Xilinx had been advised of the possibility of the same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-safe, or for use in any
application requiring fail-safe performance, such as life-support or safety
devices or systems, Class III medical devices, nuclear facilities, applications
related to the deployment of airbags, or any other applications that could lead
to death, personal injury, or severe property or environmental damage
(individually and collectively, "Critical Applications"). Customer assumes the
sole risk and liability of any use of Xilinx products in Critical Applications,
subject only to applicable laws and regulations governing limitations on product
liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT
ALL TIMES.

*******************************************************************************/

#include <iostream>
#include <cmath>
using namespace std;
#define MAX_ARRAY_SIZE 4096


void matrix_mul ( volatile int *cmd, volatile int *resp, int a[MAX_ARRAY_SIZE], int b[MAX_ARRAY_SIZE], int result[MAX_ARRAY_SIZE]  ) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis port=cmd
#pragma HLS INTERFACE axis port=resp
#pragma HLS INTERFACE bram depth=1024 port=a
#pragma HLS INTERFACE bram depth=1024 port=b
#pragma HLS INTERFACE bram depth=1024 port=result

#pragma HLS RESOURCE variable=a core=RAM_1P_BRAM
#pragma HLS RESOURCE variable=b core=RAM_1P_BRAM
#pragma HLS RESOURCE variable=result core=RAM_1P_BRAM

	int  AB_common;
	int  A_rows;
	int  B_cols;
	int temp;

	For_loop: while (1)
	{
		A_rows =*cmd;
		B_cols =*cmd;
		AB_common = *cmd;

		///////Matrix Multiplication process///////////
		I_LOOP:  for(int i = 0; i < A_rows; i++)
		{
			J_LOOP:   for(int j = 0; j < B_cols; j++)
			{
				temp=0;
				K_LOOP:   for(int k = 0; k < AB_common; k++)
				{
					#pragma AP PIPELINE
					temp += a[i*AB_common+k] * b[k*B_cols+j];
					if(k == (AB_common-1))
					{
						 result[i*B_cols+j] = temp; //Write in C BRAM the result of matrix multiplication
						 if ( (i==A_rows-1) && (j==B_cols -1))
							 *resp = 1;
					}
				}
			}
		}

	}


}
