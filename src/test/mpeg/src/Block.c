/*
 * Block.cpp
 *
 *  Created on: Mar 4, 2010
 *      Author: yonga
 */

#include "Jpeg.h"

void Matrix_to_Table(int32_t input[][8], int32_t output[][8])
{
	int32_t  tmp[8][8];
	//Trans(input, tmp);
	uint8_t i,j;
	for(  i = 0; i < 8; i++)
		for( j = 0; j < 8; j++)
			output[i][j] = (tmp[i][j] - 128);/* level shift */
}

void Table_to_Matrix(int32_t input[][8], int32_t output[][8])
{
	int16_t val;
	int32_t tmp[8][8];
	//Trans(input, tmp);
	uint8_t i,j;
	for( i = 0; i < 8; i++)
		for( j = 0; j < 8; j++)
		{
		   val = tmp[i][j] + 128;
		   output[i][j] = (val < 0) ? 0 : ((val > 255) ? 255 : val);
		}
}

void BlockMaker(Scan_2D *input, Scan_1D_2D *output, FramePop property)
{
	uint16_t width = property.width/8, height = property.height/8;
	uint32_t x = 0;
	uint16_t i,j;
	for( i = 0; i < height; i += 2)
	{
		for( j = 0; j< width; j += 2)
		{
			Matrix_to_Table((*input).Y[i][j].data, (*output).Y[x++].data);
			Matrix_to_Table((*input).Y[i][j+1].data, (*output).Y[x++].data);
			Matrix_to_Table((*input).Y[i+1][j].data, (*output).Y[x++].data);
			Matrix_to_Table((*input).Y[i+1][j+1].data, (*output).Y[x++].data);
		}
	}
	width  = property.thumbwidth/8;
	height = property.thumbheight/8;
	x = 0;
	for( i = 0; i < height; i++)
		for( j = 0; j < width; j++)
			Matrix_to_Table((*input).Cb[i][j].data, (*output).Cb[x++].data);
	x = 0;
	for( i = 0; i < height; i++)
			for( j = 0; j < width; j++)
				Matrix_to_Table((*input).Cr[i][j].data, (*output).Cr[x++].data);
}

void InvBlockMaker(Scan_1D_2D *input, Scan_2D *output, FramePop property)
{
	uint16_t width = property.width/8,height = property.height/8;
	uint32_t x = 0;
	uint16_t i,j;
	for( i = 0; i < height; i += 2)
	{
		for( j = 0; j < width; j += 2)
		{
			Table_to_Matrix((*input).Y[x++].data, (*output).Y[i][j].data);
			Table_to_Matrix((*input).Y[x++].data, (*output).Y[i][j+1].data);
			Table_to_Matrix((*input).Y[x++].data, (*output).Y[i+1][j].data);
			Table_to_Matrix((*input).Y[x++].data, (*output).Y[i+1][j+1].data);
		}
	}
	width  = property.thumbwidth/8;
	height = property.thumbheight/8;
	x = 0;
	for( i = 0; i < height; i++)
		for( j = 0; j < width; j++)
			Table_to_Matrix((*input).Cb[x++].data, (*output).Cb[i][j].data);
	x = 0;
	for( i = 0; i < height; i++)
		for( j = 0; j < width; j++)
			Table_to_Matrix((*input).Cr[x++].data, (*output).Cr[i][j].data);
}
