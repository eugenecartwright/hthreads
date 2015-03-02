/*
 * IDCT.c
 *
 *  Created on: Sep 11, 2009
 *      Author: yonga
 */
#include "Jpeg.h"

const uint8_t SCALE = 11;
uint16_t p1 = 1448;
uint16_t p2 = 1448;
uint16_t p3 = 2008;
uint16_t p4 = 399;
uint16_t p5 = 1892;
uint16_t p6 = 783;
uint16_t p7 = 1702;
uint16_t p8 = 1137;
uint16_t p9 = 2896;
inline int32_t Multiply(int16_t a, int32_t b) {return ((a * b) >> SCALE);}

void InvDCT_One_Dim(int32_t input[], int32_t output[])
{
	/*--------------- Step 1 ---------------*/
	int16_t t00 = Multiply(p1, input[4]);
	int16_t t10 = Multiply(p2, input[4]);
	int16_t t01 = Multiply(p1, input[0]);
	int16_t t11 = Multiply(p2, input[0]);
	int16_t t02 = Multiply(p3, input[1]);
	int16_t t12 = Multiply(p4, input[1]);
	int16_t t03 = Multiply(p3, input[7]);
	int16_t t13 = Multiply(p4, input[7]);
	int16_t t04 = Multiply(p5, input[2]);
	int16_t t14 = Multiply(p6, input[2]);
	int16_t t05 = Multiply(p5, input[6]);
	int16_t t15 = Multiply(p6, input[6]);
	int16_t t06 = Multiply(p7, input[3]);
	int16_t t16 = Multiply(p8, input[3]);
	int16_t t07 = Multiply(p7, input[5]);
	int16_t t17 = Multiply(p8, input[5]);
	/*--------------- Step 2 ---------------*/
	int32_t b0 = ((t00 + t11) << 4);
	int32_t b1 = ((t04 + t15) << 4);
	int32_t b2 = ((t01 - t10) << 4);
	int32_t b3 = ((t05 - t14) << 4);
	int32_t b4 = ((t02 + t13) << 4);
	int32_t b5 = ((t06 + t17) << 4);
	int32_t b6 = ((t03 - t12) << 4);
	int32_t b7 = ((t07 - t16) << 4);
	/*--------------- Step 3 ---------------*/
	int32_t c0 = ((b4 + b5) >> 1);
	int32_t c1 = ((b6 - b7) >> 1);
	int32_t c2 = b0;
	int32_t c3 = ((b4 - b5) >> 1);
	int32_t c4 = b1;
	int32_t c5 = b2;
	int32_t c6 = b3;
	int32_t c7 = ((b6 + b7) >> 1);
	/*--------------- Step 4 ---------------*/
	int32_t d5 = Multiply(p9,c3);
	int32_t d7 = Multiply(p9,c7);
	/*--------------- Step 5 ---------------*/
	int32_t f0 = ((c2 + c4) >> 1);
	int32_t f2 = ((c5 + d5) >> 1);
	int32_t f3 = ((c6 + d7) >> 1);
	int32_t f4 = ((c2 - c4) >> 1);
	int32_t f6 = ((c5 - d5) >> 1);
	int32_t f7 = ((c6 - d7) >> 1);
	/*--------------- Step 6 ---------------*/
	output[0] = ((f0 + c0) >> 1);
	output[1] = ((f2 - f3) >> 1);
	output[2] = ((f2 + f3) >> 1);
	output[3] = ((f4 - c1) >> 1);
	output[4] = ((f4 + c1) >> 1);
	output[5] = ((f6 + f7) >> 1);
	output[6] = ((f6 - f7) >> 1);
	output[7] = ((f0 - c0) >> 1);
	uint8_t i;
	for(i = 0; i < 8; i++)
		output[i] = (output[i] < 0) ? ((output[i] - 4) >> 3) : ((output[i] + 4) >> 3);
}

void InvDCT_Two_Dim(int32_t input[][8], int32_t output[][8])
{
	/*-------------- Row wise ---------------*/
	int32_t tmp[8][8],tmp2[8][8];
    //int32_t tmp3[8][8];
	uint8_t i;
	for(i = 0; i < 8; i++)
		InvDCT_One_Dim(input[i],tmp[i]);
	//Trans(tmp,tmp2);
	/*-------------- Column wise ---------------*/
	for(i = 0; i < 8; i++)
		InvDCT_One_Dim(tmp2[i],output[i]);
}

void IDCTOneComponent(Block_2D componentIn[], Block_2D componentOut[], uint16_t width, uint16_t height)
{
	uint32_t lim = width * height, i;
	for(i = 0; i < lim; i++)
		 InvDCT_Two_Dim(componentIn[i].data,componentOut[i].data);
}

void IDCT(Scan_1D_2D *InPackage, Scan_1D_2D *OutPackage, FramePop property)
{
     IDCTOneComponent((*InPackage).Y,  (*OutPackage).Y, property.width/8, property.height/8);
     IDCTOneComponent((*InPackage).Cb, (*OutPackage).Cb, property.thumbwidth/8, property.thumbheight/8);
     IDCTOneComponent((*InPackage).Cr, (*OutPackage).Cr, property.thumbwidth/8, property.thumbheight/8);
}
