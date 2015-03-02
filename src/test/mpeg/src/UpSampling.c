/*
 * BlockToImage.c
 *
 *  Created on: Sep 21, 2009
 *      Author: yonga
 */

#include "Jpeg.h"

//void UpSamplingOneComponent_150(uchar* data, Block_2D component[][150], uint16_t width, uint16_t height, uint8_t nChannels, uint32_t widthStep)
void UpSamplingOneComponent_150(char* data, Block_2D component[][150], uint16_t width, uint16_t height, uint8_t nChannels, uint32_t widthStep)
{
	Block_2D input;
	uint16_t m;
	for( m = 0; m < height; m++)
	{
		uint16_t n;
		for( n = 0; n < width; n++)
		{
			input = component[m][n];
			uint32_t offset = m*8*widthStep + n*8*nChannels;
			uint8_t i,j;
			for( i = 0; i < 8; i++)
				for( j = 0;j < 8; j++)
					data[offset + widthStep*i + nChannels*j] = input.data[i][j];
		}
	}
}

//void UpSamplingOneComponent_75(uchar* data, Block_2D component[][75], uint16_t width, uint16_t height, uint8_t nChannels, uint32_t widthStep, uint8_t index)
void UpSamplingOneComponent_75(char* data, Block_2D component[][75], uint16_t width, uint16_t height, uint8_t nChannels, uint32_t widthStep, uint8_t index)
{
	Block_2D input;
	uint16_t m;
	for( m = 0; m < height; m++)
	{
		uint16_t n;
		for( n = 0; n < width; n++)
		{
			input = component[m][n];
			uint32_t offset = (m*2*8) * widthStep + n*2*8*nChannels + index, xpos = 0, ypos = 0;
			uint8_t i,j;
			for( i = 0; i < 8; i++)
			{
				for( j = 0; j < 8; j++)
				{
					data[offset+xpos+ypos]           = data[offset+xpos+ypos+nChannels] =
					data[offset+xpos+ypos+widthStep] = data[offset+xpos+ypos+widthStep+nChannels] = input.data[i][j];
					ypos += 2*nChannels;
				}
				ypos  = 0;
				xpos += 2*widthStep;
			}
		}
	}
}

void UpSampling(IplImage* img, Scan_2D *InPackage, FramePop property)
{
	//uchar* data = (uchar*)(img->imageData);
	//char* data = (char*)(img->imageData);
	char* data = (char*)(img->src_image);

	UpSamplingOneComponent_150(data, (*InPackage).Y,  property.width/8, property.height/8, img->nChannels, img->widthStep);
	UpSamplingOneComponent_75(data, (*InPackage).Cb, property.thumbwidth/8, property.thumbheight/8, img->nChannels,img->widthStep, 2);
	UpSamplingOneComponent_75(data, (*InPackage).Cr, property.thumbwidth/8, property.thumbheight/8, img->nChannels,img->widthStep, 1);
}

void BlockToImage_150(IplImage* img, Block_2D component[][150], uint16_t width, uint16_t height)
{
	//uchar* data = (uchar*)(img->imageData);
	//char* data = (char*)(img->imageData);
	char* data = (char*)(img->src_image);

	uint8_t nChannels  = img->nChannels;
	uint32_t widthStep = img->widthStep;
	Block_2D input;
	uint16_t m;
	for( m = 0; m < height; m++)
	{
		uint16_t n;
		for( n = 0; n < width; n++)
		{
			input = component[m][n];
			uint32_t offset = m*8*widthStep + n*8*nChannels;
			uint8_t i,j;
			for( i = 0; i < 8; i++)
				for( j = 0; j < 8; j++)
					data[offset + widthStep*i + nChannels*j] = input.data[i][j];
		}
	}
}

void BlockToImage_75(IplImage* img, Block_2D component[][75], uint16_t width, uint16_t height)
{
	//uchar* data = (uchar*)(img->imageData);
	//char* data = (char*)(img->imageData);
	char* data = (char*)(img->src_image);

	uint8_t nChannels = img->nChannels;
	uint8_t widthStep = img->widthStep;
	Block_2D input;
	uint16_t m;
	for( m = 0; m < height; m++)
	{
		uint16_t n;
		for( n = 0; n < width; n++)
		{
			input = component[m][n];
			uint32_t offset = m*8*widthStep + n*8*nChannels;
			uint8_t i,j;
			for( i = 0; i < 8; i++)
				for( j = 0; j < 8; j++)
					data[offset + widthStep*i + nChannels*j] = input.data[i][j];
		}
	}
}
