/*
 * Jpeg.h
 *
 *  Created on: Sep 29, 2009
 *      Author: yonga
 */
#define HTHREADS_BUILD

#ifndef JPEG_H_
#define JPEG_H_
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#ifdef HTHREADS_BUILD
#include <hthread.h>
// Location of the image in memory
#define SRC_ADDR 0x9F800000 // 0x9F300000 to 0x9FBFFFFF allows for 4MB
#define DST_ADDR 0x9FBFFFFF // 0x9FBFFFFF to 0x9FFFFFFE allows for 4MB
#endif

#define SIZE_OF_BLOCK 64
#define N 8

/* Image data structure */
typedef struct {
    int height;
    int width;
    int widthStep;
    int nChannels;
    int depth;

    unsigned long dataSize;
    unsigned char *imageData;

} IplImage;


/* JPEG marker */
typedef enum
{
  M_SOF0  = 0xc0,
  M_SOF1  = 0xc1,
  M_SOF2  = 0xc2,
  M_SOF3  = 0xc3,

  M_SOF5  = 0xc5,
  M_SOF6  = 0xc6,
  M_SOF7  = 0xc7,

  M_JPG   = 0xc8,
  M_SOF9  = 0xc9,
  M_SOF10 = 0xca,
  M_SOF11 = 0xcb,

  M_SOF13 = 0xcd,
  M_SOF14 = 0xce,
  M_SOF15 = 0xcf,

  M_DHT   = 0xc4,
  M_DAC   = 0xcc,

  M_RST0  = 0xd0,
  M_RST1  = 0xd1,
  M_RST2  = 0xd2,
  M_RST3  = 0xd3,
  M_RST4  = 0xd4,
  M_RST5  = 0xd5,
  M_RST6  = 0xd6,
  M_RST7  = 0xd7,

  M_SOI   = 0xd8,
  M_EOI   = 0xd9,
  M_SOS   = 0xda,
  M_DQT   = 0xdb,
  M_DNL   = 0xdc,
  M_DRI   = 0xdd,
  M_DHP   = 0xde,
  M_EXP   = 0xdf,
  M_APP0  = 0xE0,
  M_APP1  = 0xe1,
  M_APP2  = 0xe2,
  M_APP3  = 0xe3,
  M_APP4  = 0xe4,
  M_APP5  = 0xe5,
  M_APP6  = 0xe6,
  M_APP7  = 0xe7,
  M_APP8  = 0xe8,
  M_APP9  = 0xe9,
  M_APP10 = 0xea,
  M_APP11 = 0xeb,
  M_APP12 = 0xec,
  M_APP13 = 0xed,
  M_APP14 = 0xee,
  M_APP15 = 0xef,

  M_JPG0  = 0xf0,
  M_JPG13 = 0xfd,
  M_COM   = 0xfe,

  M_TEM   = 0x01,

  M_ERROR = 0x100
} JPEG_MARKER;
/* --------------------------------------------------------------------------------------------------------------------*/
typedef struct {
	uint8_t index;
	uint8_t length;
	uint16_t Vcode;
} WORD;

/*----- a 8*8 Block -----*/
typedef struct {
	int32_t data[8][8];
} Block_2D;

typedef struct {
	int32_t data[64];
} Block_1D;

typedef struct {
	uint8_t NOZ;
	uint8_t amplitude;
} ELEMENT;

typedef struct {
	ELEMENT VLC;
	uint16_t VLI;
} SYMBOL;

typedef struct {
	Block_2D Y[250][150];
	Block_2D Cb[150][75];
	Block_2D Cr[150][75];
} Scan_2D;

typedef struct {
	Block_2D Y[250*150];
	Block_2D Cb[150*75];
	Block_2D Cr[150*75];
} Scan_1D_2D;

typedef struct {
	Block_1D Y[250*150];
	Block_1D Cb[150*75];
	Block_1D Cr[150*75];
} Scan_1D_1D;

struct NODE {
	SYMBOL content;
	struct NODE* next;
	struct NODE* previous;
};

struct NODE_int {
	uint8_t content;
	struct NODE_int* next;
	struct NODE_int* previous;
};

typedef struct NODE List;
typedef struct NODE_int List_int;

typedef struct {
   List* Y[250*150];
   List* Cb[150*75];
   List* Cr[150*75];
} scancodeAC;

typedef struct {
	SYMBOL Y[250*150];
	SYMBOL Cb[150*75];
	SYMBOL Cr[150*75];
} scancodeDC;

typedef struct {
	uint8_t channel;
	uint16_t width;
	uint16_t height;
	uint16_t thumbwidth;
	uint16_t thumbheight;
} FramePop;

/* ----------------- Matrix Fucntions ---------------------*/
void Trans(int32_t A[][8], int32_t B[][8]);
/*------------------- Function for List --------------------*/
List* push(List *, SYMBOL);
List_int* push_int(List_int *, uint8_t);
/*---------------------------------------*/
void RGB_to_YCbCr(IplImage*);
void DownSampling(IplImage*, Scan_2D*);
void DCT(Scan_1D_2D*, Scan_1D_2D*, FramePop);
void ZigZagScan(Scan_1D_2D*, Scan_1D_1D*, FramePop);
void UnZigZagScan(Scan_1D_1D*, Scan_1D_2D*, FramePop);
void Quantification(Scan_1D_1D*, Scan_1D_1D*, FramePop);
void Coding(Scan_1D_1D*, scancodeDC*, scancodeAC*, FramePop);
void Huffmann_encoder(scancodeDC*, scancodeAC*, FramePop, List_int*);
void Huffmann_decoder(List_int*, scancodeDC*, scancodeAC*);
void SaveJPEG(char*, List_int*, FramePop, uint8_t[], uint8_t[]);
void LoadJPEG(char*, List_int*, FramePop*, uint8_t[], uint8_t[]);
void Decoding(scancodeDC*, scancodeAC*, Scan_1D_1D*, FramePop);
void IQuantification(Scan_1D_1D*, Scan_1D_1D*, FramePop);
void IDCT(Scan_1D_2D*, Scan_1D_2D*, FramePop);
void YCbCr_to_RGB(IplImage*);
void UpSampling(IplImage*, Scan_2D*, FramePop);
void BlockToImage_150(IplImage*, Block_2D[][150], uint16_t, uint16_t);
void BlockToImage_75(IplImage*, Block_2D[][75],  uint16_t, uint16_t);
void BlockMaker(Scan_2D* ,Scan_1D_2D*, FramePop);
void InvBlockMaker(Scan_1D_2D*, Scan_2D*, FramePop);

void SaveBMP(IplImage *img, FramePop prop);
#ifndef HTHREADS_BUILD
IplImage *createImage(char *fileName);
void loadImage(IplImage *img, char *fileName);
int checkBMP(FILE *fp);
#else
IplImage *createImage(void *src);
void loadImage(IplImage *img, void *src);
int checkBMP(void *src);
#endif

#endif /* JPEG_H_ */
