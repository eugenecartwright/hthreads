/*
 * Coding.c
 *
 *  Created on: Sep 21, 2009
 *      Author: yonga
 */
#include "Jpeg.h"

uint16_t IntToHex(int32_t n, uint16_t amplitude)
{
	if( n < 0 )
		n = ((n - 1) << amplitude ) >> amplitude;
	return (uint16_t)n;
}

/* write DCT coefficient matrix into 1D array in zigzag order */

void RunLengthEnc(int32_t input[SIZE_OF_BLOCK], List* output)
{
	 uint16_t numb, length = 0, size = 32;/* sizeof(int) x 8 */
	 SYMBOL sym;
	 List* cur = output;
	 uint8_t i;
	 for( i = 1; i < SIZE_OF_BLOCK; i++)
	 {
		  if(input[i] != 0)
		  {
			  while(length >= 16)
			  {
				  sym.VLC.NOZ = 15;
				  sym.VLC.amplitude = 0;
				  cur = push(cur, sym);
				  length -= 16;
			  }
			  sym.VLC.NOZ = length;
			  length      = 0;
			  numb 		  = (uint16_t)(log2(abs(input[i]))) + 1;
			  sym.VLC.amplitude = numb;
			  sym.VLI           = IntToHex(input[i],(size - numb));
			  cur = push(cur, sym);
		  }
		  else length++;
	 }
	 if(input[63] == 0)
	 {
		 /*------------- EOB(end of Block) value => (0,0) -------------*/
		 sym.VLC.NOZ = 0;
		 sym.VLC.amplitude = 0;
		 sym.VLI = 0;
		 cur = push(cur, sym);
	 }
}

void Coding(Scan_1D_1D *InPackage, scancodeDC *DCDiff, scancodeAC *ACCoef, FramePop property)
{
  Block_1D input;
  SYMBOL sym;
  uint32_t pos = 0;
  uint16_t numb;
  int16_t dc_value = 0, size = 32;//sizeof(int) * 8
  uint16_t height = property.height/8, width = property.width/8;
  uint32_t lim = width * height;
  uint32_t i;
  for( i = 0; i < lim; i++)
  {
	 input = (*InPackage).Y[i];
	 dc_value = input.data[0] - dc_value;
	 sym.VLC.NOZ = 0;
	 if(dc_value == 0)
		 sym.VLC.amplitude = 0;
	 else
	 {
		 numb = (uint16_t)(log2(abs(dc_value))) + 1;
		 sym.VLC.amplitude = numb;
		 sym.VLI = IntToHex(dc_value, size - numb);
	 }
	 (*DCDiff).Y[pos] = sym;
	 dc_value = input.data[0];
	 (*ACCoef).Y[pos] = (List *)malloc(sizeof(List));
	 (*ACCoef).Y[pos]->content.VLC.NOZ = 0;
	 (*ACCoef).Y[pos]->content.VLC.amplitude = 0;
	 (*ACCoef).Y[pos]->content.VLI= 0;
	 (*ACCoef).Y[pos]->next = NULL;
	 (*ACCoef).Y[pos]->previous = NULL;
	 RunLengthEnc(input.data, (*ACCoef).Y[pos]);
	 pos++;
  }
  height = property.thumbheight/8;
  width  = property.thumbwidth/8;
  lim    = width * height;
  dc_value   = 0;
  pos    = 0;
  for(i = 0; i < lim; i++)
  {
	 input = (*InPackage).Cb[i];
	 dc_value = input.data[0] - dc_value;
	 if(dc_value == 0)
		 sym.VLC.amplitude = 0;
	 else
	 {
		 numb = (uint16_t)(log2(abs(dc_value))) + 1;
		 sym.VLC.amplitude = numb;
		 sym.VLI = IntToHex(dc_value, size - numb);
	 }
	 (*DCDiff).Cb[pos] = sym;
	 dc_value = input.data[0];
	 (*ACCoef).Cb[pos] = (List *)malloc(sizeof(List));
	 (*ACCoef).Cb[pos]->content.VLC.NOZ = 0;
	 (*ACCoef).Cb[pos]->content.VLC.amplitude = 0;
	 (*ACCoef).Cb[pos]->content.VLI= 0;
	 (*ACCoef).Cb[pos]->next = NULL;
	 (*ACCoef).Cb[pos]->previous = NULL;
	 RunLengthEnc(input.data, (*ACCoef).Cb[pos]);
	 pos++;
  }
  dc_value = 0;
  pos  = 0;
  for( i = 0; i < lim; i++)
  {
	 input = (*InPackage).Cr[i];
	 dc_value  = input.data[0] - dc_value;
	 if(dc_value == 0)
		 sym.VLC.amplitude = 0;
	 else
	 {
		 numb = (uint16_t)(log2(abs(dc_value))) + 1;
		 sym.VLC.amplitude = numb;
		 sym.VLI = IntToHex(dc_value, size - numb);
	 }
	 (*DCDiff).Cr[pos] = sym;
	 dc_value = input.data[0];
	 (*ACCoef).Cr[pos] = (List *)malloc(sizeof(List));
	 (*ACCoef).Cr[pos]->content.VLC.NOZ = 0;
	 (*ACCoef).Cr[pos]->content.VLC.amplitude = 0;
	 (*ACCoef).Cr[pos]->content.VLI= 0;
	 (*ACCoef).Cr[pos]->next = NULL;
	 (*ACCoef).Cr[pos]->previous = NULL;
	 RunLengthEnc(input.data, (*ACCoef).Cr[pos]);
	 pos++;
  }
}
