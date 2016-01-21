/* Mandel.c program
 * Author: Eugene
 * Reference: http://warp.povusers.org/Mandelbrot/
 * Date: 1/14/2016
 */

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <arch/htime.h>

#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS
//#define OPCODE_FLAGGING

#define  MAX_ITERATIONS  100
#define  HORIZONTAL_RESOLUTION   50
#define  VERTICAL_RESOLUTION     50

#if 0
void color(Hint red, Hint green, Hint blue)  {
   fputc((char) red);
   fputc((char) green);
   fputc((char) blue);

}
#endif

void * mandel_thread(void * arg) {

   // NOTE: Alot of things compiler is optimizing out, just
   // put  volatile on everything.
   volatile Huint MaxIterations = (Huint) arg;
   volatile Huint ImageHeight = VERTICAL_RESOLUTION, ImageWidth = HORIZONTAL_RESOLUTION;
   volatile float MinRe = -2.0f;
   volatile float MaxRe = 1.0f;
   volatile float MinIm = -1.2f;
   volatile float MaxIm = MinIm + (MaxRe-MinRe)*ImageHeight/ImageWidth;
   volatile Huint count = 0;

   volatile float Re_factor = (MaxRe-MinRe)/((float)ImageWidth-1.0f);
   volatile float Im_factor = (MaxIm-MinIm)/((float)ImageHeight-1.0f);
	
   /* header for PPM output */
	//printf("P6\n# CREATOR: Eugene Cartwright\n");
	//printf("%d %d\n255\n",(int) ImageWidth,(int) ImageHeight);

   volatile Huint x, y;
   for (y = 0; y < ImageHeight; y++) {

      // Caculate imaginary part of complex number for this y
      volatile float c_im = MaxIm - y*Im_factor;

      for (x = 0; x < ImageWidth; x++) {

         // Caculate real part of complex number for this x
         volatile float c_re = MinRe + x*Re_factor;

         /* ------------------------------------------------
          * Determine whether complex number, c, belongs
          * to the Mandelbrot set, and colour appropriately.
          * -----------------------------------------------*/

         volatile float Z_re = c_re;
         volatile float Z_im = c_im;
         volatile Huint withinSet = 1; // Is it in the set?
         volatile Huint n = 0;
         for (n = 0; n < MaxIterations; n++) {
            count++;
            volatile float Z_re2 = Z_re*Z_re;
            volatile float Z_im2 = Z_im*Z_im;
            if ((Z_re2 + Z_im2) > 4.0f) {
               withinSet = 0;
               break;
            }
            // Calculate new Z
            // Z = Z^2 + c = (Z_re * Z_im)^2 + c
            Z_im = 2.0f*Z_re*Z_im + c_im;
            Z_re = Z_re2 - Z_im2 + c_re;
         }
         /* 
         if (withinSet)
            color(0,0,0, &px);
         else
            color(255,0,0, &px);
         */
      }
   }
   return (void *) count;
}


#ifndef HETERO_COMPILATION
#include "mandel_prog.h"

hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;

hthread_time_t start, stop;
int main() {
   
   printf("--- Mandelbrot set benchmark ---\n"); 
   printf("ITERATIONS: %d\n", MAX_ITERATIONS);
   printf("Horizontal Resolution = %d\n", HORIZONTAL_RESOLUTION);
   printf("Vertical Resolution = %d\n", VERTICAL_RESOLUTION);
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();

   Huint i = 0;
   for (i = 0; i < NUM_THREADS; i++) 
      hthread_attr_init(&attr[i]);

   start = hthread_time_get();
   
   for (i = 0; i < NUM_THREADS; i++) 
      thread_create(&tid[i], &attr[i], mandel_thread_FUNC_ID, (void *) MAX_ITERATIONS, DYNAMIC_HW, 0);
   
   for (i = 0; i < NUM_THREADS; i++) {
      if (thread_join(tid[i], &ret[i], &exec_time[i]))
         printf("Join error!\n");
   }
   
   stop = hthread_time_get();
  
   // Display thread times
   for (i = 0; i < NUM_THREADS; i++) { 
      // Determine which slave ran this thread based on address
      Huint base = attr[i].hardware_addr - HT_HWTI_COMMAND_OFFSET;
      Huint slave_num = (base & 0x00FF0000) >> 16;
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

