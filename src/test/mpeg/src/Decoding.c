/*
 * Decoding.c
 *
 *  Created on: Sep 21, 2009
 *      Author: yonga
 */
#include "Jpeg.h"

int32_t BinToInt(int32_t val1, uint8_t amplitude)
{
	 if(val1 < pow(2,amplitude-1))
	 {
		 /*------- negative number! ----------*/
		 int32_t num = (int32_t)(pow(2, amplitude));
		 int32_t val = (~val1) & (num - 1);
		 return -val;
	 }
	 return val1;
}

void InvRunLengthEnc(List *input, int32_t output[], int16_t dc_value)
{
   uint8_t j;
   for( j = 0; j < SIZE_OF_BLOCK; j++)
	   output[j] = 0;
   output[0] = dc_value;
   uint16_t i = 1;
   List *cur = input;
   while(cur)
   {
	 i += (cur->content).VLC.NOZ;
	 if((cur->content).VLC.amplitude == 0)
		 i++;
	 else
		 output[i++] = BinToInt((cur->content).VLI, (cur->content).VLC.amplitude);
	 List *cr = cur;
	 cur = cur->next;
	 free(cr);
   }
}

void Decoding(scancodeDC *DCDiff, scancodeAC *ACCoef, Scan_1D_1D *InPackage, FramePop property)
{
	 List* input_h;
	 //uint8_t size = 32;//sizeof(int) * 8
	 uint16_t width = property.width/8, height = property.height/8;
	 uint32_t lim = width * height;
	 int16_t dc_value = 0, pos = 0;
	 uint32_t i;
	 for( i = 0; i < lim; i++)
	 {
		 SYMBOL dcVal = (*DCDiff).Y[pos];
		 if(dcVal.VLC.amplitude != 0)
			 dc_value += BinToInt(dcVal.VLI, dcVal.VLC.amplitude);
		 List* cur = (*ACCoef).Y[pos];
		 input_h = (List *)malloc(sizeof(List));
		 input_h->content.VLC.NOZ = 0;
		 input_h->content.VLC.amplitude = 0;
		 input_h->content.VLI = 0;
		 input_h->next = NULL;
		 input_h->previous = NULL;
		 List *input = input_h;
		 while(cur)
		 {
			 if((cur->content).VLC.NOZ != 0 || (cur->content).VLC.amplitude != 0)
				 input = push(input, cur->content);
			 List *cr = cur;
			 cur = cur->next;
			 free(cr);
		 }
		 InvRunLengthEnc(input_h, (*InPackage).Y[i].data, dc_value);
		 pos++;
	 }
	 dc_value = 0;
	 pos = 0;
	 width = property.thumbwidth/8, height = property.thumbheight/8;
	 lim = width * height;
	 for( i = 0; i < lim; i++)
	 {
		 SYMBOL dcVal = (*DCDiff).Cb[pos];
		 if(dcVal.VLC.amplitude != 0)
			 dc_value += BinToInt(dcVal.VLI,dcVal.VLC.amplitude);
		 List* cur = (*ACCoef).Cb[pos];
		 input_h = (List *)malloc(sizeof(List));
		 input_h->content.VLC.NOZ = 0;
		 input_h->content.VLC.amplitude = 0;
		 input_h->content.VLI = 0;
		 input_h->next = NULL;
		 input_h->previous = NULL;
		 List *input = input_h;
		 while(cur)
		 {
			 if((cur->content).VLC.NOZ != 0 || (cur->content).VLC.amplitude != 0)
				 input = push(input, cur->content);
			 List *cr = cur;
			 cur = cur->next;
			 free(cr);
		 }
		 InvRunLengthEnc(input_h, (*InPackage).Cb[i].data, dc_value);
		 pos++;
	 }
	 dc_value = 0;
	 pos  = 0;
	 for( i = 0; i < lim; i++)
	 {
		 SYMBOL dcVal = (*DCDiff).Cr[pos];
		 if(dcVal.VLC.amplitude != 0)
			 dc_value += BinToInt(dcVal.VLI, dcVal.VLC.amplitude);
		 List* cur = (*ACCoef).Cr[pos];
		 input_h = (List *)malloc(sizeof(List));
		 input_h->content.VLC.NOZ = 0;
		 input_h->content.VLC.amplitude = 0;
		 input_h->content.VLI = 0;
		 input_h->next = NULL;
		 input_h->previous = NULL;
		 List *input = input_h;
		 while(cur)
		 {
			 if((cur->content).VLC.NOZ != 0 || (cur->content).VLC.amplitude != 0)
				 input = push(input, cur->content);
			 List *cr = cur;
			 cur = cur->next;
			 free(cr);
		 }
		 InvRunLengthEnc(input_h, (*InPackage).Cr[i].data, dc_value);
		 pos++;
	 }
}
