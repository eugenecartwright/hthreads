/*
 * ImageBlock.c
 *
 *  Created on: Sep 14, 2009
 *      Author: yonga
 */
#include "Jpeg.h"

uint8_t Nb_Col_dow = 8;
void DownSampling(IplImage *img, Scan_2D* InPackage)
{
  //uchar *data        = (uchar *)(img->imageData);
  //char *data        = (char *)(img->imageData);
  unsigned char *data        = (unsigned char *)(img->imageData);

  uint16_t height    = img->height / Nb_Col_dow;
  uint16_t width     = img->width / Nb_Col_dow;
  uint8_t nb_channel = img->nChannels;
  uint16_t step      = img->widthStep;
  Block_2D block_Y, block_Cb, block_Cr;
  uint8_t is_4th_block = 0;
  uint16_t i,j;
  for(i = 0; i < height; i++)
  {
	  uint32_t offset = i*step*Nb_Col_dow;
	  for(j = 0; j < width; j++)
	  {
		 uint32_t xpos = j*Nb_Col_dow*nb_channel;
		 uint8_t ii,jj;
		 for(ii = 0; ii< Nb_Col_dow; ii++)
		 {
			uint32_t ypos = 0;
			for(jj=  0; jj< Nb_Col_dow; jj++)
			{
				 block_Y.data[ii][jj] = data[offset + xpos + ypos];
				 if(i%2 == 0 && j%2 == 0 && ii%2 == 0 && jj%2 == 0)
				 {
					 block_Cr.data[ii/2][jj/2] = ((data[offset+xpos+ypos+1] + data[offset+xpos+ypos+1+nb_channel])/2 + (data[offset+(xpos+step)+ypos+1] + data[offset+(xpos+step)+ypos+1+nb_channel])/2)/2;
					 block_Cb.data[ii/2][jj/2] = ((data[offset+xpos+ypos+2] + data[offset+xpos+ypos+2+nb_channel])/2 + (data[offset+(xpos+step)+ypos+2] + data[offset+(xpos+step)+ypos+2+nb_channel])/2)/2;

					 block_Cr.data[ii/2][Nb_Col_dow/2+jj/2] = ((data[offset+xpos+(ypos+Nb_Col_dow*nb_channel)+1]   + data[offset+xpos+(ypos+nb_channel*(Nb_Col_dow+1))+1])/2 +
														  (data[offset+(xpos+step)+(ypos+Nb_Col_dow*nb_channel)+1] + data[offset+(xpos+step)+(ypos+nb_channel*(Nb_Col_dow+1))+1])/2)/2;
					 block_Cb.data[ii/2][Nb_Col_dow/2+jj/2] = ((data[offset+xpos+(ypos+Nb_Col_dow*nb_channel)+2]   + data[offset+xpos+(ypos+nb_channel*(Nb_Col_dow+1))+2])/2 +
													      (data[offset+(xpos+step)+(ypos+Nb_Col_dow*nb_channel)+2] + data[offset+(xpos+step)+(ypos+nb_channel*(Nb_Col_dow+1))+2])/2)/2;

					 block_Cr.data[Nb_Col_dow/2+ii/2][jj/2] = ((data[offset+(xpos+Nb_Col_dow*step)+ypos+1] + data[offset+(xpos+Nb_Col_dow*step)+ypos+1+nb_channel])/2 +
													      (data[offset+(xpos+step*(Nb_Col_dow+1))+ypos+1]  + data[offset+(xpos+step*(Nb_Col_dow+1))+ypos+1+nb_channel])/2)/2;
					 block_Cb.data[Nb_Col_dow/2+ii/2][jj/2] = ((data[offset+(xpos+Nb_Col_dow*step)+ypos+2] + data[offset+(xpos+Nb_Col_dow*step)+ypos+2+nb_channel])/2 +
														  (data[offset+(xpos+step*(Nb_Col_dow+1))+ypos+2]  + data[offset+(xpos+step*(Nb_Col_dow+1))+ypos+2+nb_channel])/2)/2;

					 block_Cr.data[Nb_Col_dow/2+ii/2][Nb_Col_dow/2+jj/2] = ((data[offset+(xpos+Nb_Col_dow*step)+(ypos+Nb_Col_dow*nb_channel)+1] + data[offset+(xpos+Nb_Col_dow*step)+(ypos+nb_channel*(Nb_Col_dow+1))+1])/2 +
																   (data[offset+(xpos+step*(Nb_Col_dow+1))+(ypos+Nb_Col_dow*nb_channel)+1] + data[offset+(xpos+step*(Nb_Col_dow+1))+(ypos+nb_channel*(Nb_Col_dow+1))+1])/2)/2;
					 block_Cb.data[Nb_Col_dow/2+ii/2][Nb_Col_dow/2+jj/2] = ((data[offset+(xpos+Nb_Col_dow*step)+(ypos+Nb_Col_dow*nb_channel)+2] + data[offset+(xpos+Nb_Col_dow*step)+(ypos+nb_channel*(Nb_Col_dow+1))+2])/2 +
																   (data[offset+(xpos+step*(Nb_Col_dow+1))+(ypos+Nb_Col_dow*nb_channel)+2] + data[offset+(xpos+step*(Nb_Col_dow+1))+(ypos+nb_channel*(Nb_Col_dow+1))+2])/2)/2;
					 is_4th_block = 1;
				 }
				 ypos += nb_channel;
			 }
			xpos = xpos + step;
		 }
		 (*InPackage).Y[i][j] = block_Y;
		 if(is_4th_block)
		 {
			 (*InPackage).Cr[i/2][j/2] = block_Cr;
			 (*InPackage).Cb[i/2][j/2] = block_Cb;
			 is_4th_block = 0;
		 }
	  }
	}
}
