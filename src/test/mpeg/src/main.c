/*
 * main.c
 *
 *  Created on: Sep 9, 2009
 *      Author: yonga
 */

#include "Jpeg.h"

// Add the embedded image
#ifdef HTHREADS_BUILD
#include "vga_lib.h"
#include "image_lib.h"
#endif


 ////////////////////
// GLOBAL VARIABLES //
 ////////////////////

Scan_2D InPackage;
Scan_2D OutPackage;
Scan_1D_2D InPackagem;
Scan_1D_2D OutPackagem;
Scan_1D_1D InPackagem2;
Scan_1D_1D OutPackagem2;
scancodeDC DCDiff;
scancodeAC ACCoef;
scancodeDC DCDiff_inv;
scancodeAC ACCoef_inv;
List_int* SCAN_CODE;
uint8_t Nb_Col = 8;
uint8_t quantumY[SIZE_OF_BLOCK] = {
									16,11,12,14,12,10,16,14,13,14,18,17,16,19,24,
									40,26,24,22,22,24,49,35,37,29,40,58,51,61,60,
									57,51,56,55,64,72,92,78,64,68,87,69,55,56,80,
									109,81,87,95,98,103,104,103,62,77,113,121,112,
									100,120,92,101,103,99,
								  };

uint8_t quantumRB[SIZE_OF_BLOCK] = {
									 17,18,18,24,21,24,47,26,
									 26,47,99,66,56,66,99,99,
									 99,99,99,99,99,99,99,99,
									 99,99,99,99,99,99,99,99,
									 99,99,99,99,99,99,99,99,
									 99,99,99,99,99,99,99,99,
									 99,99,99,99,99,99,99,99,
									 99,99,99,99,99,99,99,99,
				   	   	   	   	   };

#ifdef HTHREADS_BUILD
void exit(int retcode) {
    printf("EXIT (%d)!\n", retcode);
    while(1){};
}

void wait(float seconds) {
    float factor = CLOCKS_PER_SEC * seconds;
    float done = _arch_get_time() + factor;
    float current_time = _arch_get_time();

    while (current_time < done) {
        current_time = _arch_get_time(); // Busy-wait loop
    }
}


void hexToBytes(void *ptr) {
    //unsigned char *data = ptr;

    int count = 0;
    unsigned char cur;

    int bytes = sizeof(image_array);

    while (count <= bytes) {
        cur = (unsigned char)image_array[count];
        //fwrite(&cur, sizeof(char), 1, data);
    }
}


// Little endian read bytes
void readBytes(void *src, void *dst, int bytes) { 
    int i = 0;
    char *src_data;
    char *dst_data;

    src_data = src;
    dst_data = dst;

    src_data += bytes-1;

    // Save bytes into the destination
    for (i=0; i < bytes; i++) {
        *dst_data = *src_data;

        src_data--;
        dst_data++;

        // Increase the main data pointer
        (char *)src++;
        char *bla = src;
        printf("SRC == 0x%08X\n", (unsigned int)bla);
    }   
}


#endif


 ////////
// MAIN //
 ////////

int main(int argc, char **argv) {
#ifndef HTHREADS_BUILD
  	//char* file = (char *)malloc(sizeof("/home/fyonga/Workspace_JPEG/JPEG/Images/Compress_Image/Result.jpg") + 1);
	//strcpy(file, "/home/fyonga/Workspace_JPEG/JPEG/Images/Compress_Image/Result.jpg");
	//char* file1 = (char *)malloc(sizeof("/home/fyonga/Workspace_JPEG/JPEG/Images/Compress_Image/Result.jpg") + 1);
	//strcpy(file1, "/home/fyonga/Workspace_JPEG/JPEG/Images/Compress_Image/Result.jpg");
	//const char* namefile = "/home/fyonga/Workspace_JPEG/JPEG/Images/HDTV1440/promo.bmp";
  	char* file = (char *)malloc(sizeof("/home/abaez/mpeg_encoder/JPEG_C/Images/Compress_Image/Result.jpg") + 1);
	strcpy(file, "/home/abaez/mpeg_encoder/JPEG_C/Images/Compress_Image/Result.jpg");
	char* file1 = (char *)malloc(sizeof("/home/abaez/mpeg_encoder/JPEG_C/Images/Compress_Image/Result.jpg") + 1);
	strcpy(file1, "/home/abaez/mpeg_encoder/JPEG_C/Images/Compress_Image/Result.jpg");
	const char* namefile = "/home/abaez/mpeg_encoder/JPEG_C/Images/HDTV1440/promo.bmp";

	//IplImage *img = cvLoadImage( namefile, CV_LOAD_IMAGE_ANYCOLOR);
	//upsize(&img);
	//cvNamedWindow("ORIGINAL",CV_WINDOW_AUTOSIZE);
	//cvShowImage("ORIGINAL",img);
    
    // Load the image data into the image data structure
    IplImage *img = createImage("/home/abaez/mpeg_encoder/JPEG_C/Images/Others/cake.bmp");
    loadImage(img, "/home/abaez/mpeg_encoder/JPEG_C/Images/Others/cake.bmp");
#else
    // Load the image data into the image data structure
    printf("Creating image data structure...\n");
    IplImage *img = createImage((void *)&image_array[0]);
    printf("Loading image data...\n");
    loadImage(img, (void *)&image_array[0]);

    // Allocate memory for the destination image
    img->jpeg_data = (unsigned char *)malloc((img->height*img->width));
    if (img->jpeg_data == NULL) {
        printf("ERROR - Unable to allocate memory for the destination image!\n");
        exit(1);
    }
    IplImage *file = img;

    // Set file1 the same as file
    IplImage *file1 = file;
#endif
    printf("Image properties:\n");
    printf("-----------------\n");
    printf("height: %d\n", img->height);
    printf("width: %d\n", img->width);
    printf("nchannels: %d\n", img->nChannels);
    printf("depth: %d\n", img->depth);
    exit(1);
    //printf("data addr3: 0x%08X\n", img->imageData);
    //printf("data size: %d\n", sizeof(&img->imageData));
    //printf("data: ");
    //int i=0, j=0;
    //for (i=0; i < 64; i++) {
    //    printf("%08X ", img->imageData[i]);
    //}
    //printf("\n");
    //exit(1);

	FramePop property;
	property.channel 	 = img->nChannels;
	property.height  	 = img->height;
	property.width       = img->width;
    property.thumbheight = img->height/2;
    property.thumbwidth  = img->width/2;

    /*----------------------------- ENCODER ----------------------------*/
    printf("Encoding...\n");
    RGB_to_YCbCr(img);
    DownSampling(img, &InPackage);
	BlockMaker(&InPackage, &OutPackagem, property);
	DCT(&OutPackagem, &InPackagem, property);
	ZigZagScan(&InPackagem, &OutPackagem2, property);
	Quantification(&OutPackagem2, &InPackagem2, property);
	Coding(&InPackagem2, &DCDiff, &ACCoef, property);
	SCAN_CODE = (List_int *)malloc(sizeof(List_int));
	SCAN_CODE->content = 0;
	SCAN_CODE->next = NULL;
	SCAN_CODE->previous = NULL;
	Huffmann_encoder(&DCDiff, &ACCoef, property, SCAN_CODE);
	SaveJPEG(file, SCAN_CODE, property, quantumY, quantumRB);

	/*----------------------------- DECODER ----------------------------*/
    printf("Decoding...\n");
	SCAN_CODE = (List_int *)malloc(sizeof(List_int));
	SCAN_CODE->content = 0;
	SCAN_CODE->next = NULL;
	SCAN_CODE->previous = NULL;
	LoadJPEG(file1, SCAN_CODE, &property, quantumY, quantumRB);
    printf("property.height=%d, property.width=%d\n", property.height, property.width);
	List_int *cur = SCAN_CODE;
	SCAN_CODE = SCAN_CODE->next;
	free(cur);
    Huffmann_decoder(SCAN_CODE, &DCDiff_inv, &ACCoef_inv);
	Decoding(&DCDiff_inv, &ACCoef_inv, &InPackagem2, property);
	IQuantification(&InPackagem2, &OutPackagem2, property);
	UnZigZagScan(&OutPackagem2, &InPackagem, property);
	IDCT(&InPackagem, &OutPackagem, property);
	InvBlockMaker(&OutPackagem, &InPackage, property);
	//cvReleaseImage(&img);
	//img = cvLoadImage(namefile, CV_LOAD_IMAGE_ANYCOLOR);
	//upsize(&img);
    //cvZero(img);
	UpSampling(img, &InPackage, property);
	YCbCr_to_RGB(img);
#ifndef HTHREADS_BUILD
    printf("Saving to bmp file...\n");
    SaveBMP(img, property);
#endif
    printf("-- DONE --\n");
	//cvNamedWindow("JPEG", CV_WINDOW_AUTOSIZE);
	//cvShowImage("JPEG", img);
	//cvWaitKey(0);
	//cvDestroyAllWindows();
	//cvReleaseImage(&img);
	return 0;
}


 ///////////////////
// FUNCTION BODIES //
 ///////////////////

//void upsize(IplImage ** img) {
//	uint16_t width  = (2 * Nb_Col) * (cvCeil((double)((*img)->width)  / (double)(2 * Nb_Col)));
//	uint16_t height = (2 * Nb_Col) * (cvCeil((double)((*img)->height) / (double)(2 * Nb_Col)));
//	IplImage *newImage = cvCreateImage( cvSize(width,height), (*img)->depth, (*img)->nChannels );
//	cvZero( newImage );
//	cvSetImageROI( newImage, cvRect((width - (*img)->width)/2, (height - (*img)->height)/2, (*img)->width, (*img)->height));
//	cvCopy((*img), newImage, NULL);
//	cvResetImageROI(newImage);
//	cvReleaseImage(img);
//	*img = newImage;
//}



//void Trans(int32_t src[][8], int32_t dst[][8])
//{
//	uint8_t i,j;
//	CvMat *mat = cvCreateMat(N, N, CV_32FC1);
//	for ( i = 0; i < N; i++)
//		 for (j = 0; j < N; j++)
//			  cvSetReal2D(mat,i,j, src[i][j]);
//	cvTranspose(mat,mat);
//	for(i = 0; i < N; ++i )
//		  for(j = 0; j < N; ++j )
//			   dst[i][j] = cvGetReal2D(mat,i,j);
//		cvReleaseMat(&mat);
//}


// Transpose a square matrix
void Trans(int32_t src[][8], int32_t dst[][8]) {
    if (sizeof(&src[0])/sizeof(int32_t) != 8 || sizeof(&dst[0])/sizeof(int32_t) != 8) {
        printf("The input matrix is not a square matrix!\n");
        exit(1);
    }

    uint8_t i=0,j=0;

    int colSize = 8;
    int rowSize = 8;

    // Transpose the matrix
    for (i=0; i < colSize; i++) {
        for (j=0; j < rowSize; j++) {
            dst[j][i] = src[i][j];
        }
    }
}


#ifndef HTHREADS_BUILD
IplImage *createImage(char *filename) {
    FILE *fp = fopen(filename, "rb");
    if (fp == NULL) {
        printf("ERROR - Unable to open input file '%s'!\n", filename);
        exit(1);
    }

    // Check that the input file is bmp
    int isBMP = checkBMP(fp);
    if (isBMP != 0) {
        printf("ERROR - The input file is not a BMP file!\n");
        exit(1);
    }

    // Allocate memory for the image data structure
    IplImage *img = (IplImage *)malloc(sizeof(IplImage));

    // Gather input image data
    int width = 0;
    int height = 0;
    short depth = 0;
    int channels = 3; // Always handle RGB

    fseek(fp, 14, SEEK_SET); // Skip the header (Always 14 bytes)
    fseek(fp, 4, SEEK_CUR); // Skip the bitmap header size
    fread(&width, 4, 1, fp);
    fread(&height, 4, 1, fp);
    fseek(fp, 2, SEEK_CUR); // Skip the number of bit planes
    fread(&depth, 2, 1, fp);

    // Initialize the image structure
    img->width = width;
    img->height = height;
    img->depth = depth/channels;
    img->nChannels = channels;

    return img;
}
#else
IplImage *createImage(void *src) {
    //unsigned char *src_img = src;
    unsigned char *src_img = (unsigned char *)src;

    // Check that the input file is bmp
    int isBMP = checkBMP(src_img);
    if (isBMP != 0) {
        printf("ERROR - The input data does not contain BMP data!\n");
        exit(1);
    }

    // Allocate memory for the image data structure
    IplImage *img = (IplImage *)malloc(sizeof(IplImage));
    if (img == NULL) {
        printf("ERROR - Unable to allocate memory for the image data structure!\n");
        exit(1);
    }

    // Gather input image data
    int width = 0;
    int height = 0;
    short depth = 0;
    int channels = 3; // Always handle RGB

    src_img += 18;
    readBytes((void *)src_img, (void *)&width, 4);
    readBytes((void *)src_img, (void *)&height, 4);
    readBytes((void *)src_img, (void *)&depth, 2);

    // Initialize the image structure
    img->width = width;
    img->height = height;
    img->depth = depth/channels;
    img->nChannels = channels;

    return img;
}
#endif

#ifndef HTHREADS_BUILD
// Loads the pixel data into the image data structure
void loadImage(IplImage *img, char *fileName) {
    // Read the image data to place in the image structure
    printf("Reading '%s'...\n", fileName);
    FILE *fp = fopen(fileName, "rb");
    if (fp == NULL) {
        printf("ERROR - Unable to open image file '%s'!\n", fileName);
        exit(1);
    }

    // Check that the input file is bmp
    int isBMP = checkBMP(fp);
    if (isBMP != 0) {
        printf("ERROR - The input file is not a BMP file!\n");
        exit(1);
    }

    // Pointer that will contain the image data
    unsigned char *buffer;
    
    unsigned int file_size = 0;
    unsigned int dataOffset = 0;
    unsigned int dataSize = 0;

    // Skip the magic number
    fseek(fp, 2, SEEK_SET);

    // Get the total file size
    fread(&file_size, 4, 1, fp);
    printf("File size: %d\n", file_size);

    // Get the offset to read the data from
    fseek(fp, 4, SEEK_CUR);
    fread(&dataOffset, 4, 1, fp);
    printf("Data offset: %d\n", dataOffset);

    // Get the size of the image pixel data
    dataSize = file_size - dataOffset;
    printf("Data size: %d\n", dataSize);

    // Allocate memory for the image data
    buffer = (unsigned char *)malloc(dataSize);
    if (buffer == NULL) {
        printf("ERROR - Unable to allocate memory for the file buffer!\n");
        exit(1);
    }

    // Read the image pixel data
    fseek(fp, dataOffset, SEEK_SET);
    fread(buffer, dataSize, 1, fp);

    // Place the data into the image
    img->src_image = buffer;
    // Save the size of the buffer
    img->dataSize = dataSize;

    fclose(fp);
}
#else
// Loads the pixel data into the image data structure
void loadImage(IplImage *img, void *src) {
    unsigned char *src_img = (unsigned char *)src;
    // Pointer that will contain the image data
    unsigned char *buffer = (unsigned char *)img->imageData;
    
    unsigned int file_size = 0;
    unsigned int dataOffset = 0;
    unsigned int dataSize = 0;

    // Skip the magic number (2 bytes)
    src_img += 2;

    printf("src_img more before = 0x%08X\n", src_img);
    // Get the total file size
    readBytes((void *)src_img, (void *)&file_size, 4);
    printf("File size: %d\n", file_size);

    printf("src_img before = 0x%08X\n", src_img);
    // Skip 4 bytes
    src_img += 4;
    printf("src_img after = 0x%08X\n", src_img);
exit(0);
    // Get the offset to read the data from (offset from the beginning of the file)
    readBytes((void *)src_img, (void *)&dataOffset, 4);
    printf("Data offset: %d\n", dataOffset);

    // Get the size of the image pixel data
    dataSize = file_size - dataOffset;
    printf("Data size: %d\n", dataSize);

    // Allocate memory for the image data
    buffer = (unsigned char *)malloc(dataSize);
    if (buffer == NULL) {
        printf("ERROR - Unable to allocate memory for the file buffer!\n");
        exit(1);
    }

    // Skip to the RGB data
    src_img = src; // Reset the pointer to the data
    src_img += dataOffset;

    // Read the image pixel data
    readBytes((void *)src_img, (void *)buffer, dataSize);

    // Save the size of the buffer
    img->dataSize = dataSize;
}
#endif


#ifndef HTHREADS_BUILD
// Check that the input file is BMP
int checkBMP(FILE *fp) {
    char magicNumber[3] = {'\0'};
    char magic[3] = "BM";

    fseek(fp, 0, SEEK_SET);
    fread(&magicNumber, 2, 1, fp);
    if (strcmp(magicNumber, magic) != 0) {
        return 1;
    }
    else {
        return 0;
    }
}
#else
// Check that the input file is BMP
int checkBMP(void *src) {
    //unsigned char *img = src;
    unsigned char *img = (unsigned char *)src;

    char magicNumber[3] = {'\0'};
    char magic[3] = "BM";

    // Get the first 2 bytes
    magicNumber[0] = img[0];
    magicNumber[1] = img[1];
    printf("magicnum=%s\n", magicNumber);

    if (strcmp(magicNumber, magic) != 0) {
        return 1;
    }
    else {
        return 0;
    }
}
#endif


#ifndef HTHREADS_BUILD
void SaveBMP(IplImage *img, FramePop prop) {
    FILE *fp = fopen("decoded.bmp", "wb");
    if (fp == NULL) {
        printf("ERROR - Unable to create output file!\n");
        exit(1);
    }

    // Header data
    unsigned int fSize = img->dataSize + 14 + 40;  /* File size in bytes */
    unsigned short int reserved1 = 0;
    unsigned short int reserved2 = 0;
    unsigned int offset = 40 + 14;        /* Offset to image data, bytes */

    // File information
    unsigned int infoSize = 40;               /* Header size in bytes      */
    //int width = img->width;                 /* Width of image */
    //int height = img->height;                /* height of image */
    int width = prop.width;                 /* Width of image */
    int height = prop.height;                /* height of image */
    printf("width=%d, height=%d\n", prop.width, prop.height);
    unsigned short int planes = 1;       /* Number of colour planes   */
    unsigned short int bits = img->depth * img->nChannels;         /* Bits per pixel            */
    //unsigned short int bits = img->depth;         /* Bits per pixel            */
    unsigned int compression = 0;        /* Compression type          */
    unsigned int imagesize = 0;          /* Image size in bytes       */
    int xresolution = 0;
    int yresolution = 0;                 /* Pixels per meter          */
    unsigned int ncolours = 0;           /* Number of colours         */
    unsigned int importantcolours = 0;   /* Important colours         */

    printf("Size of data: %ld\n", img->dataSize);
    // Write the header data (14 bytes)
    fwrite("BM", 2, 1, fp);
    fwrite(&fSize, sizeof(fSize), 1, fp);
    fwrite(&reserved1, sizeof(reserved1), 1, fp);
    fwrite(&reserved2, sizeof(reserved2), 1, fp);
    fwrite(&offset, sizeof(offset), 1, fp);
    // Write the file information data (40 bytes)
    fwrite(&infoSize, sizeof(infoSize), 1, fp);
    fwrite(&width, sizeof(width), 1, fp);
    fwrite(&height, sizeof(height), 1, fp);
    fwrite(&planes, sizeof(planes), 1, fp);
    fwrite(&bits, sizeof(bits), 1, fp);
    fwrite(&compression, sizeof(compression), 1, fp);
    fwrite(&imagesize, sizeof(imagesize), 1, fp);
    fwrite(&xresolution, sizeof(xresolution), 1, fp);
    fwrite(&yresolution, sizeof(yresolution), 1, fp);
    fwrite(&ncolours, sizeof(ncolours), 1, fp);
    fwrite(&importantcolours, sizeof(importantcolours), 1, fp);

    // Write the data
    fwrite(img->src_image, img->dataSize, 1, fp);
    //char *r = malloc(img->depth);
    //char *g = malloc(img->depth);
    //char *b = malloc(img->depth);
    //int i=0;

    //for (i=0; i < img->dataSize / (img->depth * img->nChannels); i++) {
    //    *r = img->imageData[i];
    //    *g = img->imageData[i+1];
    //    *b = img->imageData[i+2];

    //    fwrite(&b, img->depth, 1, fp);
    //    fwrite(&g, img->depth, 1, fp);
    //    fwrite(&r, img->depth, 1, fp);
    //}

    printf("File written...\n");
    fclose(fp);
}
//#else
//void SaveBMP(IplImage *img, FramePop prop) {
//    unsigned char *dstImg = {'\0'};
//    // Header data
//    unsigned int fSize = img->dataSize + 14 + 40;  /* File size in bytes */
//    unsigned short int reserved1 = 0;
//    unsigned short int reserved2 = 0;
//    unsigned int offset = 40 + 14;        /* Offset to image data, bytes */
//
//    // File information
//    unsigned int infoSize = 40;               /* Header size in bytes      */
//    //int width = img->width;                 /* Width of image */
//    //int height = img->height;                /* height of image */
//    int width = prop.width;                 /* Width of image */
//    int height = prop.height;                /* height of image */
//    printf("width=%d, height=%d\n", prop.width, prop.height);
//    unsigned short int planes = 1;       /* Number of colour planes   */
//    unsigned short int bits = img->depth * img->nChannels;         /* Bits per pixel            */
//    //unsigned short int bits = img->depth;         /* Bits per pixel            */
//    unsigned int compression = 0;        /* Compression type          */
//    unsigned int imagesize = 0;          /* Image size in bytes       */
//    int xresolution = 0;
//    int yresolution = 0;                 /* Pixels per meter          */
//    unsigned int ncolours = 0;           /* Number of colours         */
//    unsigned int importantcolours = 0;   /* Important colours         */
//
//    // Allocate memory for the destination image
//    dstImg = (unsigned char *)malloc(fSize);
//
//    printf("Size of data: %ld\n", img->dataSize);
//    // Write the header data (14 bytes)
//    fwrite("BM", 2, 1, dstImg);
//    fwrite(&fSize, sizeof(fSize), 1, dstImg);
//    fwrite(&reserved1, sizeof(reserved1), 1, dstImg);
//    fwrite(&reserved2, sizeof(reserved2), 1, dstImg);
//    fwrite(&offset, sizeof(offset), 1, dstImg);
//    // Write the file information data (40 bytes)
//    fwrite(&infoSize, sizeof(infoSize), 1, dstImg);
//    fwrite(&width, sizeof(width), 1, dstImg);
//    fwrite(&height, sizeof(height), 1, dstImg);
//    fwrite(&planes, sizeof(planes), 1, dstImg);
//    fwrite(&bits, sizeof(bits), 1, dstImg);
//    fwrite(&compression, sizeof(compression), 1, dstImg);
//    fwrite(&imagesize, sizeof(imagesize), 1, dstImg);
//    fwrite(&xresolution, sizeof(xresolution), 1, dstImg);
//    fwrite(&yresolution, sizeof(yresolution), 1, dstImg);
//    fwrite(&ncolours, sizeof(ncolours), 1, dstImg);
//    fwrite(&importantcolours, sizeof(importantcolours), 1, dstImg);
//
//    // Write the data
//    fwrite(img->imageData, img->dataSize, 1, dstImg);
//    //char *r = malloc(img->depth);
//    //char *g = malloc(img->depth);
//    //char *b = malloc(img->depth);
//    //int i=0;
//
//    //for (i=0; i < img->dataSize / (img->depth * img->nChannels); i++) {
//    //    *r = img->imageData[i];
//    //    *g = img->imageData[i+1];
//    //    *b = img->imageData[i+2];
//
//    //    fwrite(&b, img->depth, 1, fp);
//    //    fwrite(&g, img->depth, 1, fp);
//    //    fwrite(&r, img->depth, 1, fp);
//    //}
//
//    printf("Image written...\n");
//}
#endif

