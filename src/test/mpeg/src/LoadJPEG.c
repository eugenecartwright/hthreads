/*
 * LoadJPEG.cpp
 *
 *  Created on: Sep 24, 2009
 *      Author: yonga
 */

#include "Jpeg.h"

#ifndef HTHREADS_BUILD
static FILE* file;
#else
unsigned char *file;
unsigned int data_size = 0;
#endif

#ifndef HTHREADS_BUILD
void Quantization_Filter(uint8_t quantumY[],uint8_t quantumRB[])
{
    uint8_t a[1],b[2],c[3];
    /* Find Define Quantization Table Marker*/
    do
        fread((void*)b,2,1,file);
    while((feof(file) == 0) && (b[0] != 0xFF || b[1] != M_DQT));
    fread((void*)c,3,1,file);/* Length + Table identifier */
    /* Load Luminance Quantization Coefficients */
    uint8_t i;
    for( i = 0; i < SIZE_OF_BLOCK; i++)
    {
        fread((void*)a,1,1,file);
        quantumY[i] = a[0];
    }
    /* Find Define Quantization Table Marker*/
    do
        fread((void*)b,2,1,file);
    while((feof(file) == 0) && (b[0] != 0xFF || b[1] != M_DQT));
    fread((void*)c,3,1,file);/* Length + Table identifier */
    /* Load Chrominance Quantization Coefficients */
    for( i = 0; i < SIZE_OF_BLOCK; i++)
    {
        fread((void*)a,1,1,file);
        quantumRB[i] = a[0];
    }
}

void Extract_Image_Property(FramePop *property)
{
    //uint8_t a[1];
    uint8_t b[2],c[3];
    /* Find Start Of Frame Marker*/
    do
        fread((void*)b,2,1,file);
    while((feof(file) == 0) && (b[0] != 0xFF || b[1] != M_SOF0));

    fread((void*)c,3,1,file); /* Length + precision */
    fread((void*)b,2,1,file); /* Height */
    (*property).height = (b[0] << 8) | b[1];
    fread((void*)b,2,1,file); /* Width */
    (*property).width  = (b[0] << 8) | b[1];
    (*property).thumbheight = (*property).height/2;
    (*property).thumbwidth  = (*property).width/2;
}

void Scan_Filter(List_int *scan_code)
{
    uint8_t a[1] = {0},b[2],prev = 0;
    /* Find Start Of Scan Marker*/
    do
        fread((void*)b,2,1,file);
    while((feof(file) == 0) && (b[0] != 0xFF || b[1] != M_SOS));
    fread((void*)b,2,1,file);/* Length of the Scan header*/
    uint16_t cnt = ((b[0] << 8) | b[1]) - 2;
    uint16_t i;
    for ( i = 0; i < cnt; i++)
        fread((void*)a,1,1,file);
    /* Read scan code */
    fread((void*)a,1,1,file);
    List_int *cur = scan_code;
    do
    {
        cur = push_int(cur, prev);
        prev = a[0];
        fread((void*)a,1,1,file);
    }
    while((feof(file) == 0) && (prev != 0xFF || a[0] != M_EOI));
}

void LoadJPEG(char* src, List_int *scan_code, FramePop *property, uint8_t quantumY[], uint8_t quantumRB[])
{
    if ((file = fopen(src, "r")) == NULL)
    {
        fprintf(stderr, "can't open %s\n", src);
        return;
    }
    uint8_t b[2];
    fread((void*)b,2,1,file);
    if(b[0] != 0xFF || b[1] != M_SOI)
    {
        fprintf(stderr, "%s isn't a JPEG frame\n", src);
        return;
    }
    Quantization_Filter(quantumY, quantumRB);
    Extract_Image_Property(property);
    List_int* cur = scan_code;
    Scan_Filter(cur);
    fclose(file);
}
#else
void Quantization_Filter(uint8_t quantumY[],uint8_t quantumRB[]) {
    uint8_t a[1], b[2], c[3];
    unsigned int count = 0;

    /* Find Define Quantization Table Marker*/
    do {
        //fread((void*)b,2,1,file);
        readBytes((void *)file, (void *)b, 2);
        count += 2;
    } while ((count < data_size) && (b[0] != 0xFF || b[1] != M_DQT));

    //fread((void*)c,3,1,file);/* Length + Table identifier */
    readBytes((void *)file, (void *)c, 3);/* Length + Table identifier */

    /* Load Luminance Quantization Coefficients */
    uint8_t i;
    for( i = 0; i < SIZE_OF_BLOCK; i++) {
        //fread((void*)a,1,1,file);
        readBytes((void *)file, (void*)a, 1);
        quantumY[i] = a[0];
    }

    /* Find Define Quantization Table Marker*/
    count = 0;
    do {
        //fread((void*)b,2,1,file);
        readBytes((void *)file, (void*)b, 2);
        count += 2;
    } while((count < data_size) && (b[0] != 0xFF || b[1] != M_DQT));

    //fread((void*)c,3,1,file);/* Length + Table identifier */
    readBytes((void *)file, (void*)c, 3);/* Length + Table identifier */

    /* Load Chrominance Quantization Coefficients */
    for( i = 0; i < SIZE_OF_BLOCK; i++) {
        //fread((void*)a,1,1,file);
        readBytes((void *)file, (void*)a, 1);
        quantumRB[i] = a[0];
    }
}



void Extract_Image_Property(FramePop *property) {
    //uint8_t a[1];
    uint8_t b[2],c[3];
    unsigned int count = 0;

    /* Find Start Of Frame Marker*/
    do {
        readBytes((void *)file, (void*)b, 2);
        count += 2;
    } while((count < data_size) && (b[0] != 0xFF || b[1] != M_SOF0));

    readBytes((void*)file, (void*)c,3); /* Length + precision */
    readBytes((void*)file, (void*)b,2); /* Height */
    (*property).height = (b[0] << 8) | b[1];
    readBytes((void*)file, (void*)b,2); /* Width */
    (*property).width  = (b[0] << 8) | b[1];
    (*property).thumbheight = (*property).height/2;
    (*property).thumbwidth  = (*property).width/2;
}



void Scan_Filter(List_int *scan_code) {
    uint8_t a[1] = {0},b[2],prev = 0;
    unsigned int count = 0;

    /* Find Start Of Scan Marker*/
    do {
        readBytes((void*)file, (void*)b, 2);
        count += 2;
    } while ((count < data_size) && (b[0] != 0xFF || b[1] != M_SOS));

    readBytes((void*)file, (void*)b,2);/* Length of the Scan header*/
    
    uint16_t cnt = ((b[0] << 8) | b[1]) - 2;
    uint16_t i;

    for (i = 0; i < cnt; i++) {
        readBytes((void*)file, (void*)a,1);
    }

    /* Read scan code */
    readBytes((void*)file, (void*)a,1);
    List_int *cur = scan_code;

    count = 0;
    do {
        cur = push_int(cur, prev);
        prev = a[0];
        readBytes((void*)file, (void*)a, 1);
        count += 1;
    } while((count < data_size) && (prev != 0xFF || a[0] != M_EOI));
}



void LoadJPEG(IplImage *src, List_int *scan_code, FramePop *property, uint8_t quantumY[], uint8_t quantumRB[]) {
    file = src->jpeg_data;
    data_size = src->dataSize;

    uint8_t b[2];
    readBytes((void*)file, (void*)b, 2);
    if (b[0] != 0xFF || b[1] != M_SOI) {
        fprintf(stderr, "%s isn't a JPEG frame\n", file);
        return;
    }

    Quantization_Filter(quantumY, quantumRB);
    Extract_Image_Property(property);
    List_int *cur = scan_code;
    Scan_Filter(cur);
}
#endif

