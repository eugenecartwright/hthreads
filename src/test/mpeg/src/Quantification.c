/*
 * Quantification.cpp
 *
 *  Created on: Sep 14, 2009
 *      Author: yonga
 */
#include "Jpeg.h"
#include <math.h>

#define SCALE 10;
int scale = 1024;
uint8_t luminance[64] = {
							64,94,86,74,86,103,64,74,
							79,74,57,61,64,54,43,26,
							40,43,47,47,43,21,30,28,
							36,26,18,21,17,18,18,21,
							19,19,16,15,12,14,16,16,
							12,15,19,19,13,10,13,12,
							11,11,10,10,10,17,14,10,
							9,10,11,9,12,11,10,11
					    };
uint8_t chrominance[64] = {
							61,57,57,43,49,43,22,40,
							40,22,11,16,19,16,11,11,
							11,11,11,11,11,11,11,11,
							11,11,11,11,11,11,11,11,
							11,11,11,11,11,11,11,11,
							11,11,11,11,11,11,11,11,
							11,11,11,11,11,11,11,11,
							11,11,11,11,11,11,11,11
					      };

void QuantifOneComponentLum(Block_1D componentIn[], Block_1D componentOut[], uint16_t width, uint16_t height)
{
	int32_t lim = width * height;
    //int32_t product;
	//uint8_t last_bit;
	uint32_t j;
	for(j = 0; j < lim; j++)
	{
		Block_1D output;
		uint8_t i;
		for (i = 0; i < SIZE_OF_BLOCK; i++)
			output.data[i] = (int32_t)round((double)(componentIn[j].data[i] * luminance[i])/scale);
		componentOut[j] = output;
	}
}

void QuantifOneComponentChr(Block_1D componentIn[], Block_1D componentOut[], uint16_t width, uint16_t height)
{
	uint32_t lim = width * height;
	uint32_t j;
	for(j = 0; j < lim; j++)
	{
		Block_1D output;
		uint8_t i;
		for (i = 0; i < SIZE_OF_BLOCK; i++)
			output.data[i] = (int32_t)round((double)(componentIn[j].data[i] * chrominance[i])/scale);
		componentOut[j] = output;
	}
}

void Quantification(Scan_1D_1D *InPackage, Scan_1D_1D *OutPackage, FramePop property)
{
  QuantifOneComponentLum((*InPackage).Y,  (*OutPackage).Y, property.width/8, property.height/8);
  QuantifOneComponentChr((*InPackage).Cb, (*OutPackage).Cb, property.thumbwidth/8, property.thumbheight/8);
  QuantifOneComponentChr((*InPackage).Cr, (*OutPackage).Cr, property.thumbwidth/8, property.thumbheight/8);
}
