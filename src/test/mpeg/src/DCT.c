/*
 * DCT.cpp
 *
 *  Created on: Sep 11, 2009
 *      Author: yonga
 */
#include "Jpeg.h"
#define FIX_0_298631336  2446	/* FIX(0.298631336) */
#define FIX_0_390180644  3196	/* FIX(0.390180644) */
#define FIX_0_541196100  4433	/* FIX(0.541196100) */
#define FIX_0_765366865  6270	/* FIX(0.765366865) */
#define FIX_0_899976223  7373	/* FIX(0.899976223) */
#define FIX_1_175875602  9633	/* FIX(1.175875602) */
#define FIX_1_501321110  12299	/* FIX(1.501321110) */
#define FIX_1_847759065  15137	/* FIX(1.847759065) */
#define FIX_1_961570560  16069	/* FIX(1.961570560) */
#define FIX_2_053119869  16819	/* FIX(2.053119869) */
#define FIX_2_562915447  20995	/* FIX(2.562915447) */
#define FIX_3_072711026  25172	/* FIX(3.072711026) */
#define CONST_BITS  13

void DCT_One_Dim_1(int32_t input[], int32_t output[])
{
	/*---------------- Step 1 ----------------------*/
		int16_t tmp0 = input[0] + input[7];
		int16_t tmp7 = input[0] - input[7];
		int16_t tmp1 = input[1] + input[6];
		int16_t tmp6 = input[1] - input[6];
		int16_t tmp2 = input[2] + input[5];
		int16_t tmp5 = input[2] - input[5];
		int16_t tmp3 = input[3] + input[4];
		int16_t tmp4 = input[3] - input[4];
		/*---------------- Step 2 ----------------------*/
		int16_t tmp10 = tmp0 + tmp3;
		int16_t tmp13 = tmp0 - tmp3;
		int16_t tmp11 = tmp1 + tmp2;
		int16_t tmp12 = tmp1 - tmp2;
		/*---------------- Step 3 ----------------------*/
		output[0]      = tmp10 + tmp11;
		output[4]      = tmp10 - tmp11;
		int16_t z0     = tmp4 + tmp7;
		int16_t z1_1   = tmp12 + tmp13;
		int16_t z2     = tmp5 + tmp6;
		int16_t z3     = tmp4 + tmp6;
		int16_t z4     = tmp5 + tmp7;
		int32_t tmp4_2 = tmp4 * FIX_0_298631336;
		int32_t tmp5_2 = tmp5 * FIX_2_053119869;
		int32_t tmp6_2 = tmp6 * FIX_3_072711026;
		int32_t tmp7_2 = tmp7 * FIX_1_501321110;
		int32_t tmp14  = tmp13 * FIX_0_765366865;
		int32_t tmp15  = tmp12 * FIX_1_847759065;
		/*---------------- Step 4 - a ------------------*/
		int32_t mlz5 =  z3 + z4;
		int32_t mlz1 =  z1_1* FIX_0_541196100;
		int32_t z1   = -z0 * FIX_0_899976223;
		int32_t z2_2 = -z2 * FIX_2_562915447;
		int32_t z3_2 = -z3 * FIX_1_961570560;
		int32_t z4_2 = -z4 * FIX_0_390180644;
		/*---------------- Step 4 - b ------------------*/
		output[2]  = (mlz1 + tmp14) >> CONST_BITS;
		output[6]  = (mlz1 - tmp15) >> CONST_BITS;
		int32_t z5 =  mlz5 * FIX_1_175875602;
		/*---------------- Step 5 ----------------------*/
		z3_2   += z5;
		z4_2   += z5;
		tmp4_2 += z1;
		tmp5_2 += z2_2;
		tmp6_2 += z2_2;
		tmp7_2 += z1;
		/*---------------- Step 6 ----------------------*/
		output[7] = (tmp4_2 + z3_2) >> CONST_BITS;
		output[5] = (tmp5_2 + z4_2) >> CONST_BITS;
		output[3] = (tmp6_2 + z3_2) >> CONST_BITS;
		output[1] = (tmp7_2 + z4_2) >> CONST_BITS;
}

void DCT_One_Dim_2(int32_t input[], int32_t output[])
{
	/*---------------- Step 1 ----------------------*/
	int16_t tmp0 = input[0] + input[7];
	int16_t tmp7 = input[0] - input[7];
	int16_t tmp1 = input[1] + input[6];
	int16_t tmp6 = input[1] - input[6];
	int16_t tmp2 = input[2] + input[5];
	int16_t tmp5 = input[2] - input[5];
	int16_t tmp3 = input[3] + input[4];
	int16_t tmp4 = input[3] - input[4];
	/*---------------- Step 2 ----------------------*/
	int16_t tmp10 = tmp0 + tmp3;
	int16_t tmp13 = tmp0 - tmp3;
	int16_t tmp11 = tmp1 + tmp2;
	int16_t tmp12 = tmp1 - tmp2;
	/*---------------- Step 3 ----------------------*/
	output[0]      = tmp10 + tmp11;
	output[4]      = tmp10 - tmp11;
	int16_t z0     = tmp4 + tmp7;
	int16_t z1_1   = tmp12 + tmp13;
	int16_t z2     = tmp5 + tmp6;
	int16_t z3     = tmp4 + tmp6;
	int16_t z4     = tmp5 + tmp7;
	int32_t tmp4_2 = tmp4 * FIX_0_298631336;
	int32_t tmp5_2 = tmp5 * FIX_2_053119869;
	int32_t tmp6_2 = tmp6 * FIX_3_072711026;
	int32_t tmp7_2 = tmp7 * FIX_1_501321110;
	int32_t tmp14  = tmp13 * FIX_0_765366865;
	int32_t tmp15  = tmp12 * FIX_1_847759065;
	/*---------------- Step 4 - a ------------------*/
	int32_t mlz5 =  z3 + z4;
	int32_t mlz1 =  z1_1* FIX_0_541196100;
	int32_t z1   = -z0 * FIX_0_899976223;
	int32_t z2_2 = -z2 * FIX_2_562915447;
	int32_t z3_2 = -z3 * FIX_1_961570560;
	int32_t z4_2 = -z4 * FIX_0_390180644;
	/*---------------- Step 4 - b ------------------*/
	output[2]  = (mlz1 + tmp14) >> CONST_BITS;
	output[6]  = (mlz1 - tmp15) >> CONST_BITS;
	int32_t z5 = mlz5 * FIX_1_175875602;
	/*---------------- Step 5 ----------------------*/
	z3_2   += z5;
	z4_2   += z5;
	tmp4_2 += z1;
	tmp5_2 += z2_2;
	tmp6_2 += z2_2;
	tmp7_2 += z1;
	/*---------------- Step 6 ----------------------*/
	output[7] = (tmp4_2 + z3_2) >> CONST_BITS;
	output[5] = (tmp5_2 + z4_2) >> CONST_BITS;
	output[3] = (tmp6_2 + z3_2) >> CONST_BITS;
	output[1] = (tmp7_2 + z4_2) >> CONST_BITS;
}

void DCT_Two_Dim(int32_t input[][8], int32_t output[][8])
{
	/*--------- Row wise ---------------*/
	int32_t tmp[8][8],tmp2[8][8];
    //int32_t tmp3[8][8];
	uint8_t i;
	for(i = 0; i < 8; i++)
		DCT_One_Dim_1(input[i], tmp[i]);
	/*--------- Column wise ------------*/
	//Trans(tmp, tmp2);
	for(i = 0; i < 8; i++)
		DCT_One_Dim_2(tmp2[i], output[i]);
}

void DCTOneComponent(Block_2D componentIn[], Block_2D componentOut[],uint16_t width, uint16_t height)
{
	uint32_t lim = width * height, i;
	for(i = 0; i < lim; i++)
	    DCT_Two_Dim(componentIn[i].data, componentOut[i].data);
}

void DCT(Scan_1D_2D *InPackage, Scan_1D_2D *OutPackage, FramePop property)
{
     DCTOneComponent((*InPackage).Y,  (*OutPackage).Y, property.width/8, property.height/8);
     DCTOneComponent((*InPackage).Cb, (*OutPackage).Cb, property.thumbwidth/8, property.thumbheight/8);
     DCTOneComponent((*InPackage).Cr, (*OutPackage).Cr, property.thumbwidth/8, property.thumbheight/8);
}
