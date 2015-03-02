/*
 * Quantification.cpp
 *
 *  Created on: Sep 14, 2009
 *      Author: yonga
 */
#include "Jpeg.h"

const uint8_t ORD[8][8] = {
							 {0,1,5,6,14,15,27,28},
							 {2,4,7,13,16,26,29,42},
							 {3,8,12,17,25,30,41,43},
							 {9,11,18,24,31,40,44,53},
							 {10,19,23,32,39,45,52,54},
							 {20,22,33,38,46,51,55,60},
							 {21,34,37,47,50,56,59,61},
							 {35,36,48,49,57,58,62,63}
						  };

void ZigZag(int32_t input[][8], int32_t output[64])
{
	int16_t abs_value;
	uint8_t i,j;
	for( i = 0; i < 8; i++)
		for( j = 0; j < 8; j++)
		{
			abs_value = (abs(input[i][j]) >> 3);
			/* 8 = post processing step after FDCT */
			if(input[i][j] < 0)
				output[ORD[i][j]] = -abs_value;
			else
				output[ORD[i][j]] = abs_value;
		}
}

/* write zig zag ordered coefficients into matrix */
void unZigZag(int32_t input[64], int32_t output[][8])
{
	uint8_t i,j;
    for( i = 0; i < 8; i++)
        for( j = 0; j < 8; j++)
            output[i][j] = input[ORD[i][j]];
}

void ZigZagComponent(Block_2D componentIn[], Block_1D componentOut[],uint16_t width, uint16_t height)
{
	uint32_t lim = width * height,i;
	for( i = 0; i < lim; i++)
		ZigZag(componentIn[i].data, componentOut[i].data);
}

void UnZigZagComponent(Block_1D componentIn[], Block_2D componentOut[],uint16_t width, uint16_t height)
{
	uint32_t lim = width * height,i;
	for( i = 0; i < lim; i++)
		unZigZag(componentIn[i].data, componentOut[i].data);
}
//****************************************************************
void ZigZagScan(Scan_1D_2D *InPackage, Scan_1D_1D *OutPackage, FramePop property)
{
  ZigZagComponent((*InPackage).Y,  (*OutPackage).Y,  property.width/8, property.height/8);
  ZigZagComponent((*InPackage).Cb, (*OutPackage).Cb, property.thumbwidth/8, property.thumbheight/8);
  ZigZagComponent((*InPackage).Cr, (*OutPackage).Cr, property.thumbwidth/8, property.thumbheight/8);
}

void UnZigZagScan(Scan_1D_1D *InPackage, Scan_1D_2D *OutPackage, FramePop property)
{
  UnZigZagComponent((*InPackage).Y,  (*OutPackage).Y,  property.width/8, property.height/8);
  UnZigZagComponent((*InPackage).Cb, (*OutPackage).Cb, property.thumbwidth/8, property.thumbheight/8);
  UnZigZagComponent((*InPackage).Cr, (*OutPackage).Cr, property.thumbwidth/8, property.thumbheight/8);
}
