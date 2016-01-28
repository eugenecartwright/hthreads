/*
   Imagine Filtering - Convolution
   Reference: http://lodev.org/cgtutor/filtering.html#Convolution
   Date: 1/25/2016
   TODO: NOT FINISHED
   */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <hthread.h>
#include <arch/htime.h>

#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS
//#define OPCODE_FLAGGING
#define DEBUG_DISPATCH

#define filterWidth 9 
#define filterHeight 9 
#define imageWidth   12
#define imageHeight 10
#define max(a,b)    ((a) > (b) ? (a):(b))
#define min(a,b)    ((a) < (b) ? (a):(b))

typedef struct {
   float r;
   float g;
   float b;
} volatile ColorRGB;

typedef struct {
   ColorRGB ** image;
   ColorRGB ** result;
} volatile targ_t;

// Motion Blur
float filter[filterWidth][filterHeight] =
{
    1, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 1, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 1, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 1, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 1, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 1,
};
       
float factor = 1.0f / 9.0f; 
float bias = 0.0f; 

void * convolve_thread(void * arg) {

   targ_t * data = (targ_t *) arg;

   //declare image buffers 
   ColorRGB ** image = data->image;; 
   ColorRGB ** result = data-> result;

   // Create/Load an image
   int x, y, w = imageWidth, h = imageHeight;
    
   //apply the filter 
   for(x = 0; x < w; x++) { 
      for(y = 0; y < h; y++) { 
         float red = 0.0f, green = 0.0f, blue = 0.0f; 
            
         //multiply every value of the filter with corresponding image pixel 
         int filterX, filterY;
         for(filterX = 0; filterX < filterWidth; filterX++) {
            for(filterY = 0; filterY < filterHeight; filterY++) { 
               int imageX = (x - filterWidth / 2 + filterX + w) % w; 
               int imageY = (y - filterHeight / 2 + filterY + h) % h; 
               red += image[imageX][imageY].r * filter[filterX][filterY]; 
               green += image[imageX][imageY].g * filter[filterX][filterY]; 
               blue += image[imageX][imageY].b * filter[filterX][filterY]; 
            }
         } 
            
         //truncate values smaller than zero and larger than 255 
         result[x][y].r = min(max((int)(factor * red + bias), 0), 255); 
         result[x][y].g = min(max((int)(factor * green + bias), 0), 255); 
         result[x][y].b = min(max((int)(factor * blue + bias), 0), 255);
      }
   }
   return (void *) SUCCESS;
}

#ifndef HETERO_COMPILATION
#include "convolve_prog.h"

hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;

hthread_time_t start PRIVATE_MEMORY, stop PRIVATE_MEMORY;
       
int main(int argc, char *argv[]) {
   
   printf("--- Convolve benchmark ---\n"); 
   printf("Image Width: %d\n", imageWidth);
   printf("Image Height: %d\n", imageHeight);
   printf("filter Width: %d\n", filterWidth);
   printf("filter Height: %d\n", filterHeight);
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();

   //declare image buffers 
   ColorRGB image[imageWidth][imageHeight]; 
   ColorRGB result[imageWidth][imageHeight];
   targ_t data[NUM_THREADS];
   Huint i = 0;
   ColorRGB ** e = result;
   // Create/Load an image
   int x, y, w = imageWidth, h = imageHeight;
   for(x = 0; x < w; x++) {
      for(y = 0; y < h; y++) {
         image[x][y].r = (float) (rand() % 256) + (1.0f / ((float) (rand() % 100) + 1));
         image[x][y].g = (float) (rand() % 256) + (1.0f / ((float) (rand() % 100) + 1));
         image[x][y].b = (float) (rand() % 256) + (1.0f / ((float) (rand() % 100) + 1));
         result[x][y].r = 1.0f;
         result[x][y].g = 2.0f;
         result[x][y].b = 3.0f;
         //e[x][y].r = 1.0f;
         //e[x][y].g = 2.0f;
         //e[x][y].b = 3.0f;
      }
   }

   for (i = 0; i < NUM_THREADS; i++) {
      hthread_attr_init(&attr[i]);
      data[i].image =  image;
      data[i].result = result;
      printf("data[%d].result = 0x%08x\n", i, (unsigned int) data[i].result);
      printf("&result[%d][0][0] = 0x%08x\n",i, (unsigned int) &result[0][0]);
   }

   start = hthread_time_get();
#if 0 
   for (i = 0; i < NUM_THREADS; i++) 
      thread_create(&tid[i], &attr[i], convolve_thread_FUNC_ID, (void *) &data[i], DYNAMIC_HW, 0);
   
   for (i = 0; i < NUM_THREADS; i++) {
      if (thread_join(tid[i], &ret[i], &exec_time[i]))
         printf("Join error!\n");
   }
#endif
   stop = hthread_time_get();
   
#if 1
   // Display result image
   for (i = 0; i < NUM_THREADS; i++) { 
      for(x = 0; x < w; x++) {
         for(y = 0; y < h; y++) {
            ColorRGB ** temp = data[i].result;
            printf("(%f, %f, %f), ", result[x][y].r, result[x][y].g, result[x][y].b);
            //printf("(%f, %f, %f), ", data[i].result[x][y].r, data[i].result[x][y].g, data[i].result[x][y].b);
            //printf("(%f, %f, %f), ", temp[x][y].r, temp[x][y].g, temp[x][y].b);
            //printf("(%f, %f, %f), ", image[x][y].r, image[x][y].g, image[x][y].b);
         }
         printf("\n");
      }
   } 
#endif
  
   // Display thread times
   for (i = 0; i < NUM_THREADS; i++) { 
      // Determine which slave ran this thread based on address
      Huint slave_num;
      if (attr[i].hardware) {
         Huint base = attr[i].hardware_addr - HT_HWTI_COMMAND_OFFSET;
         slave_num = (base & 0x00FF0000) >> 16;
      }
      else
         slave_num = -1;
      printf("Execution time (TID : %d, Slave : %d)  = %f usec\n", tid[i], slave_num, hthread_time_usec(exec_time[i]));
   }

   // Display OS overhead
   printf("Total OS overhead (thread_create) = %f usec\n", hthread_time_usec(create_overhead));
   printf("Total OS overhead (thread_join) = %f usec\n", hthread_time_usec(join_overhead));
   create_overhead=0;
   join_overhead=0;

   // Display overall time
   hthread_time_t diff; hthread_time_diff(diff, stop, start);
   printf("Total time = %f usec\n", hthread_time_usec(diff));

   printf("--- Done ---\n");



    
   
   return 0;
}
#endif
