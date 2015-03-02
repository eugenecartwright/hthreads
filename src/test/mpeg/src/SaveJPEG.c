/*
 * Save.cpp
 *
 *  Created on: Oct 5, 2009
 *      Author: yonga
 */

#include "Jpeg.h"

#ifndef HTHREADS_BUILD
static FILE* file;
#else
unsigned char *file;
#endif

/*---------------------------------------------- ZIGZAG MATRIX ----------------------------------------------------*/
const uint8_t zigzag[8][8] = {
								 {0,1,5,6,14,15,27,28},
								 {2,4,7,13,16,26,29,42},
								 {3,8,12,17,25,30,41,43},
								 {9,11,18,24,31,40,44,53},
								 {10,19,23,32,39,45,52,54},
								 {20,22,33,38,46,51,55,60},
								 {21,34,37,47,50,56,59,61},
								 {35,36,48,49,57,58,62,63}
							 };
/* -------------------------------------------------  HUFFMAN PARAMETER ------------------------------------------------------------ */
const uint8_t HUFFMAN_LUMDC_SIZE[17] = {0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0};
const uint8_t HUFFMAN_LUMAC_SIZE[17] = {0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,125};
const uint8_t HUFFMAN_CHRDC_SIZE[17] = {0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0};
const uint8_t HUFFMAN_CHRAC_SIZE[17] = {0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,119};

const uint8_t HUFFMAN_LUMDC_CODE[12]  = {0,1,2,3,4,5,6,7,8,9,10,11};
const uint8_t HUFFMAN_LUMAC_CODE[162] = {
											 1,2,3,0,4,17,5,18,33,49,65,6,19,81,97,7,34,113,20,50,129,
											 145,161,8,35,66,177,193,21,82,209,240,36,51,98,114,130,9,10,
											 22,23,24,25,26,37,38,39,40,41,42,52,53,54,55,56,57,58,67,68,
											 69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,
											 104,105,106,115,116,117,118,119,120,121,122,131,132,133,134,135,
											 136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,
											 166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,
											 196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,
											 225,226,227,228,229,230,231,232,233,234,241,242,243,244,245,246,247,248,249,250
										 };
const uint8_t HUFFMAN_CHRDC_CODE[12]  = {0,1,2,3,4,5,6,7,8,9,10,11};
const uint8_t HUFFMAN_CHRAC_CODE[162] = {
											 0,1,2,3,17,4,5,33,49,6,18,65,81,7,97,113,19,34,50,129,8,20,66,145,
											 161,177,193,9,35,51,82,240,21,98,114,209,10,22,36,52,225,37,241,23,
											 24,25,26,38,39,40,41,42,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,
											 84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,
											 120,121,122,130,131,132,133,134,135,136,137,138,146,147,148,149,150,151,
											 152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,
											 184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,
											 216,217,218,226,227,228,229,230,231,232,233,234,242,243,244,245,246,247,248,249,250
										 };
/* -----------------------------------------------------------------------------------------------------------------------------*/
/* Write a byte */
void writeByte(uint8_t val)
{
	uint8_t wrap[1] = {val};
	fwrite((void*)wrap,1,1,file);
}

/* Write a 2-byte integer; MSB first and then LSB value */
void write2Bytes(uint16_t value)
{
  writeByte((value >> 8) & 0xFF);
  writeByte(value & 0xFF);
}

/* Write a marker code */
void writeMarker (JPEG_MARKER mark)
{
  writeByte(0xFF);
  writeByte((uint8_t) mark);
}

void zigzagMatrix(uint8_t A[],const uint8_t B[][8])
{
	uint8_t i,j;
	for ( i = 0; i < 8; i++)
		for ( j = 0; j < 8; j++)
			A[zigzag[i][j]]=B[i][j];
}

/* Write a Quantization Table */
void writeDQT(uint8_t quantumY[], uint8_t quantumRB[])
{
	/* Write Luminance table */
	writeMarker(M_DQT);        /* Marker */
	write2Bytes(0x0043);       /* Length */
	writeByte(0);			   /* Table Identifier */
	uint8_t i;
	for ( i = 0; i < 64; i++)
	  writeByte(quantumY[i]);  /* Quantization coefficients */

	/* Write Chrominance table */
	writeMarker(M_DQT);		   /* Marker */
	write2Bytes(0x0043);	   /* Length */
	writeByte(1); 			   /* table identifier */
	for ( i = 0; i < 64; i++)
	  writeByte(quantumRB[i]); /* Quantization coefficients */
}

void writeDHT(const uint8_t Table_Size[], uint8_t size_tableS, const uint8_t Table_Code[], uint8_t size_tableC, uint8_t identifier, uint16_t length)
{
	writeMarker(M_DHT);
	write2Bytes(length);
	writeByte(identifier);
	uint8_t i;
	for ( i = 0; i < size_tableS; i++)
		writeByte(Table_Size[i]);
	for ( i = 0; i < size_tableC; i++)
		writeByte(Table_Code[i]);
}

void writeFrameHeader(FramePop property)
{
	writeMarker(M_SOF0);		  /* Marker */
	write2Bytes(0x0011);		  /* Length of the frame in Byte */
	writeByte(8);				  /* Precision */
	write2Bytes(property.height); /* Number of lines (Max. value) */
	write2Bytes(property.width);  /* Number of columns (Max. value) */
	writeByte(3);				  /* Number of components (channel) */
	/* Component Luminance (Y) */
	writeByte(1);  				  /* Identifier */
	writeByte(0x22);			  /* H0V0 => horizontal and vertical sampling factor for Y */
	writeByte(0);				  /* Quantization table selector for Y */
	/* Component Chrominance (Cb) */
	writeByte(2);				  /* identifier */
	writeByte(0x11);              /* H1V1 => horizontal and vertical sampling factor for Cb */
	writeByte(1);                 /* Quantization table selector for Cb */
	/* Component Chrominance (Cr) */
	writeByte(3);				  /* identifier */
	writeByte(0x11);			  /* H2V2 => horizontal and vertical sampling factor for Cr */
	writeByte(1);				  /* Quantization table selector for Cr */
}

void writeScanHeader(uint8_t channel)
{
	writeMarker(M_SOS); /* Marker */
	write2Bytes(0x000C);/* Length */
	writeByte(3);       /* Number of Components */
	/* component Luminance (Y) */
	writeByte(1);       /* ID of Component */
	writeByte(0);       /*Identifier of DC and AC's Huffman Table */
	/* component Chrominance (Cb) */
	writeByte(2);       /* ID of Component */
	writeByte(0X11);    /*Identifier of DC and AC's Huffman Table */
	/* component Chrominance (Cr) */
	writeByte(3);       /* ID of Component */
	writeByte(0x11);    /*Identifier of DC and AC's Huffman Table */

	writeByte(0);       /* Start of spectral or predictor selection */
	writeByte(63);      /* End of spectral selection */
	writeByte(0);       /* Successive approximation bit position high + Successive approximation bit position low or point transform */
}

void writeAPP0()
{
	writeMarker(M_APP0); /* Marker */
	write2Bytes(0x0010); /* Length */
	/* JFIF */
	  writeByte(0x4A);
	  writeByte(0x46);
	  writeByte(0x49);
	  writeByte(0x46);
	  writeByte(0x00);
	/* END JFIF */
	write2Bytes(0x0100); /* revision */
	writeByte(0x00); 	 /* units */
	write2Bytes(0x0001); /* Xdensity */
	write2Bytes(0x0011); /* Ydensity */
	writeByte(0x00); 	 /* XThumbnail */
	writeByte(0x00); 	 /* YThumbnail */
}

void writeScan(List_int *Head)
{
    do
    {
    	writeByte(Head->content);
		List_int *cur = Head;
		Head = Head->next;
		free(cur);
    }
    while(Head);
}

#ifndef HTHREADS_BUILD
void SaveJPEG(char* namefile, List_int *SCAN_CODE, FramePop property, uint8_t quantumY[], uint8_t quantumRB[])
{
	if ((file = fopen(namefile, "wb")) == NULL)
	{
	    fprintf(stderr, "can't open %s\n", namefile);
	    return;
	}
	writeMarker(M_SOI);                 /* Start Of Image */
	writeAPP0();                        /* write APP0 */
	writeDQT(quantumY,quantumRB);       /* Write Luminance and Chrominance Quantization tables */
	writeFrameHeader(property);         /* Frame Header */
	/* Huffman Table */
	writeDHT(HUFFMAN_LUMDC_SIZE,17,HUFFMAN_LUMDC_CODE,12,0x00,0x1F);/* DC table Luminance   */
	writeDHT(HUFFMAN_LUMAC_SIZE,17,HUFFMAN_LUMAC_CODE,162,0x10,0xB5);/* AC table Luminance   */
	writeDHT(HUFFMAN_CHRDC_SIZE,17,HUFFMAN_CHRDC_CODE,12,0x01,0x1F);/* DC table Chrominance */
	writeDHT(HUFFMAN_CHRAC_SIZE,17,HUFFMAN_CHRAC_CODE,162,0x11,0xB5);/* AC table Chrominance */
	/*----------------*/
	writeScanHeader(property.channel);  /* Scan Header */
	writeScan(SCAN_CODE); 					/* write image data */
	writeMarker(M_EOI); 				/* End of Image Marker */
	fclose(file);
}
#else
void SaveJPEG(IplImage *dstImg, List_int *SCAN_CODE, FramePop property, uint8_t quantumY[], uint8_t quantumRB[]) {
    file = dstImg->jpeg_data;
	writeMarker(M_SOI);                 /* Start Of Image */
	writeAPP0();                        /* write APP0 */
	writeDQT(quantumY,quantumRB);       /* Write Luminance and Chrominance Quantization tables */
	writeFrameHeader(property);         /* Frame Header */
	/* Huffman Table */
	writeDHT(HUFFMAN_LUMDC_SIZE,17,HUFFMAN_LUMDC_CODE,12,0x00,0x1F);/* DC table Luminance   */
	writeDHT(HUFFMAN_LUMAC_SIZE,17,HUFFMAN_LUMAC_CODE,162,0x10,0xB5);/* AC table Luminance   */
	writeDHT(HUFFMAN_CHRDC_SIZE,17,HUFFMAN_CHRDC_CODE,12,0x01,0x1F);/* DC table Chrominance */
	writeDHT(HUFFMAN_CHRAC_SIZE,17,HUFFMAN_CHRAC_CODE,162,0x11,0xB5);/* AC table Chrominance */
	/*----------------*/
	writeScanHeader(property.channel);  /* Scan Header */
	writeScan(SCAN_CODE); 					/* write image data */
	writeMarker(M_EOI); 				/* End of Image Marker */
}
#endif
