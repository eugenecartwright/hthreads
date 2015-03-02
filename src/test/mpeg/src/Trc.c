/*
 * Trc.cpp
 *
 *  Created on: Sep 11, 2009
 *      Author: yonga
 */
#include "Jpeg.h"

uint8_t CvY(uint8_t r, uint8_t g, uint8_t b)
{
	uint32_t tmp = r*77 + g*150 + b*29;
	return (tmp >> 8);
}

uint8_t CvCb(uint8_t r, uint8_t g, uint8_t b)
{
	uint32_t tmp = b*128 - r*43 - g*85;
			 tmp = tmp >> 8;
	return (tmp + 128);
}

uint8_t CvCr(uint8_t r, uint8_t g, uint8_t b)
{
	uint32_t tmp = r*128 - g*107 - b*21;
			 tmp = tmp >> 8;
	return (tmp + 128);
}

void RGB_to_YCbCr(IplImage *img)
{
	uint16_t nl   = img->height;
	uint16_t nc   = img->width;
	uint16_t step = img->widthStep;
	uint16_t i,j;
	for(i = 0; i < nl; i++)
	{
	  //uchar *data = (uchar *)(img->imageData + i*step);
	  //char *data = (char *)(img->imageData + i*step);
	  char *data = (char *)(img->src_image + i*step);
	  for(j = 0;j < nc; j++)
	  {
		  uint8_t Y   = CvY(data[3*j+2],data[3*j+1],data[3*j]);
		  uint8_t Cb  = CvCb(data[3*j+2],data[3*j+1],data[3*j]);
		  uint8_t Cr  = CvCr(data[3*j+2],data[3*j+1],data[3*j]);
		  data[3*j+2] = Cb;
		  data[3*j+1] = Cr;
		  data[3*j]   = Y;
	  }
	}
}
//********************************* YCbCr_to_RGB *************************************************
uint8_t CvR(uint8_t y, uint8_t cr)
{
	int32_t tmp = y*298 + cr*409;
			tmp = (tmp >> 8) - 223;
			tmp = (tmp < 0) ? 0 : ((tmp > 255) ? 255 : tmp);
	return  tmp;
}

uint8_t CvG(int y, int cb, int cr)
{
	int32_t tmp = y*298 - cb*100 - cr*208;
			tmp = (tmp >> 8) + 136;
			tmp = (tmp < 0) ? 0 : ((tmp > 255) ? 255 : tmp);
	return  tmp;
}

uint8_t CvB(uint8_t y, uint8_t cb)
{
	int32_t tmp = y*298 + cb*516;
			tmp = (tmp >> 8) - 277;
			tmp = (tmp < 0) ? 0 : ((tmp > 255) ? 255 : tmp);
	return  tmp;
}

void YCbCr_to_RGB(IplImage *img)
{
	uint16_t nl   = img->height;
	uint16_t nc   = img->width;
	uint32_t step = img->widthStep;
	uint16_t i,j;
	for(i = 0; i < nl; i++)
	{
		//uchar *data = (uchar *)(img->imageData + i*step);
		//char *data = (char *)(img->imageData + i*step);
		char *data = (char *)(img->src_image + i*step);
	  for(j = 0; j < nc; j++)
	  {
		  uint8_t r   = CvR(data[3*j],data[3*j+1]);
		  uint8_t g   = CvG(data[3*j],data[3*j+2],data[3*j+1]);
		  uint8_t b   = CvB(data[3*j],data[3*j+2]);
		  data[3*j+2] = r;
		  data[3*j+1] = g;
		  data[3*j]   = b;
	  }
	}
}
