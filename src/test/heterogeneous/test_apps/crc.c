/* CRC.c program
 * Author: Eugene Cartwright
 * Date: 1/20/2016
 * Code reference from: https://www.pololu.com/docs/0J44/6.7.6
 */

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <arch/htime.h>

#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS
#define OPCODE_FLAGGING
#define MESSAGE_LENGTH  100
const unsigned char CRC7_POLY = 0x91;

typedef struct {
   unsigned char * message;
   unsigned char length;
   unsigned char crc;
} volatile crc_t;

/* While we could generate the CRC for each byte (2^8 = 256 table)
   ahead of time, this benchmark is used for cpu stress testing. */
void * getCRC_thread(void * arg) {
   crc_t * data = (crc_t *) arg;
   unsigned char j, crc = 0;
   unsigned int i = 0, length = data->length;

   for (i = 0; i < length; i++) {
      // Grab byte and XOR with crc
      crc ^= data->message[i];
      for (j = 0; j < 8; j++) {
         // Mask off all bits except bit 0
         if (crc & 1) 
            crc ^= CRC7_POLY;
         // Shift right crc by 1
         crc >>= 1;
      }
   }
   data->crc = crc;
   return (void *) SUCCESS;
}


//====================================================================================
// Author: Abazar
#define G_INPUT_WIDTH 32
#define G_DIVISOR_WIDTH 4

Hint gen_crc_thread( Hint input)
{
  unsigned int result;
  result=input;
  unsigned int i=0;  
  volatile unsigned int divisor = 0xb0000000;     
  volatile unsigned int mask     =0x80000000; 
     
       while(1){   
             
              if ( ( i < G_INPUT_WIDTH - G_DIVISOR_WIDTH + 1 ) && ( (result&mask) == 0 ) ) {
                i++;
                divisor=divisor  /2U;
                mask = mask /2U;
              }
              else if ( ( i < G_INPUT_WIDTH - G_DIVISOR_WIDTH + 1 ) ) {
               
                i++;
                result = result ^ divisor;
                divisor=divisor  /2U;
                mask=mask /2U;               
              }
              else {              
               return result;
              }
       }
      return 0;
} 
Hint poly_crc(void * list_ptr, Huint size) {

    Hint *array = (Hint *) list_ptr;

    for (array = list_ptr; array < (Hint *) list_ptr + size; array++) {
        *array = gen_crc_thread(*array);
    }
    
    return SUCCESS;
}


#ifndef HETERO_COMPILATION
#include "crc_prog.h"
hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;
hthread_time_t start PRIVATE_MEMORY, stop PRIVATE_MEMORY;

int main(int argc, char * argv[]) {
   
   printf("--- CRC benchmark ---\n"); 
   printf("Message Length: %d\n", MESSAGE_LENGTH);
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();

   // create a message array that has one extra byte to hold the CRC:
   unsigned char * message = (unsigned char *) malloc(sizeof(unsigned char) * (MESSAGE_LENGTH+1));
   assert(message != NULL);
   Huint i = 0;
   for (i = 0; i < MESSAGE_LENGTH; i++) {
      // Generate a random byte
      message[i] = rand() % 256;
   }
   
   crc_t data[NUM_THREADS];
   for (i = 0; i < NUM_THREADS; i++) { 
      hthread_attr_init(&attr[i]);
      data[i].message = message;
      data[i].length = MESSAGE_LENGTH;
   }

   start = hthread_time_get();
   
   for (i = 0; i < NUM_THREADS; i++) 
      thread_create(&tid[i], &attr[i], getCRC_thread_FUNC_ID, (void *) &data[i], DYNAMIC_HW, 0);
   
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
