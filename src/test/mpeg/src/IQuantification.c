/*
 * IQuantification.c
 *
 *  Created on: Sep 22, 2009
 *      Author: yonga
 */
#include "Jpeg.h"

extern uint8_t quantumY[SIZE_OF_BLOCK], quantumRB[SIZE_OF_BLOCK];

void IQuantifOneComponentLum(Block_1D componentIn[], Block_1D componentOut[], uint16_t width, uint16_t height)
{
	uint32_t lim = width * height;
	uint32_t j;
	for( j = 0;j < lim; j++)
	{
		Block_1D output;
		uint8_t i;
		for ( i = 0; i < SIZE_OF_BLOCK; i++)
			 output.data[i] = componentIn[j].data[i] * quantumY[i];
		 componentOut[j] = output;
	}
}

void IQuantifOneComponentChr(Block_1D componentIn[], Block_1D componentOut[], uint16_t width, uint16_t height)
{
	uint32_t lim = width * height;
	uint32_t j;
	for( j = 0;j < lim; j++)
	{
		Block_1D output;
		uint8_t i;
		for ( i = 0; i < SIZE_OF_BLOCK; i++)
			 output.data[i] = componentIn[j].data[i] * quantumRB[i];
		 componentOut[j] = output;
	}
}

void IQuantification(Scan_1D_1D *InPackage, Scan_1D_1D *OutPackage, FramePop property)
{
	IQuantifOneComponentLum((*InPackage).Y,  (*OutPackage).Y, property.width/8, property.height/8);
	IQuantifOneComponentChr((*InPackage).Cb, (*OutPackage).Cb, property.thumbwidth/8, property.thumbheight/8);
	IQuantifOneComponentChr((*InPackage).Cr, (*OutPackage).Cr, property.thumbwidth/8, property.thumbheight/8);
}
