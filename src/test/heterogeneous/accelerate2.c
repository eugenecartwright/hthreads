/* File: accelerate2.c
 * Author: Eugene Cartwright 
 * Description: Modelled using Abazar's hw_acc.c file 
 * This is used to test the accelerator libraries for
 * varying data sizes. 
 *
 * NOTE: Changed the return value of useHW() function
 * with  the testing of this file. Also use a 1 slave
 * system with the slave configured with all co-processors. */

#include <hthread.h>
#include <stdio.h>
#include <accelerator.h>

// Create on slaves? define it...
#define HARDWARE_THREAD

//#define PERFORM_PR
//#define DEBUG_DISPATCH
#define VERIFY

#define NUM_TRIALS          (500)

// For sort
#define LIST_LENGTH        4096

// For crc and vector
#define ARRAY_SIZE         4096
// For matrix
#define MATRIX_SIZE        64

/* Enable/disable tests */
//#define TEST_PR
#define USER_SORT
#define USER_VECTORADD
#define USER_VECTORSUB
#define USER_VECTORMUL
#define USER_VECTORDIV
#define USER_CRC
#define USER_MATRIXMUL

//====================================================================================
// Author: Abazar

typedef struct {
   Hint * dataA;
   Hint * dataB; 
   Hint * dataC;  
   Huint size;  //The size of vector for crc,sort, vectoradd and vectormul. For Matrix Multiply, it's the size of the dimension of the squre matrix.
} data;


//====================================================================================
void * sort_thread(void * arg) 
{
   data * temp = (data *) arg;
   // Get size of list
   unsigned int size = temp->size;
   // Call sort
   return (void *) (poly_bubblesort(temp->dataA, (Huint) size));
}

void * crc_thread(void * arg) 
{
   data * temp = (data *) arg;
   // Get size of list
   unsigned int size = temp->size;
   
    // Call crc
    return (void *) (poly_crc(temp->dataA, (Huint) size));
}

void * matrix_multiply_thread(void * arg) 
{
	data * package = (data *) arg;
   return (void *) poly_matrix_mul (package->dataA,  package->dataB, package->dataC, package->size,package->size,package->size);  
}

void * vector_add_thread(void * arg) 
{
    data * package = (data *) arg;

    // Get size of list
    unsigned int size = package->size;
    
    // Call Vector Add
    return (void *) (poly_vectoradd((void *) package->dataA,(void *) package->dataB, (void *) package->dataC, (Huint) size));
}

void * vector_sub_thread(void * arg) 
{
    data * package = (data *) arg;

    // Get size of list
    unsigned int size = package->size;
    
    // Call Vectorsub
    return (void *) (poly_vectorsub((void *) package->dataA,(void *) package->dataB, (void *) package->dataC, (Huint) size));
}

void * vector_multiply_thread(void * arg) 
{
    data * package = (data *) arg;

    // Get size of list
    unsigned int size = package->size;
    
    // Call vector multiply
    return (void *) (poly_vectormul((void *) package->dataA,(void *) package->dataB, (void *) package->dataC, (Huint) size));
}

void * vector_divide_thread(void * arg) 
{
    data * package = (data *) arg;

    // Get size of list
    unsigned int size = package->size;
    
    // Call divide
    return (void *) (poly_vectordiv((void *) package->dataA,(void *) package->dataB, (void *) package->dataC, (Huint) size));
}

#include <arch/arch.h>
#include <pr.h>
#include "pvr.h"
void * test_PR_thread(void * arg)
{
   Hint success = 0;
#ifdef PR
   Hint i, trials = (Hint) arg;
   unsigned char cpuid;
   getpvr(0,cpuid);
   for (i = 0; i < trials; i++) {
      success += perform_PR(cpuid, CRC);
      success += perform_PR(cpuid, BUBBLESORT);
      success += perform_PR(cpuid, VECTORADD);
      success += perform_PR(cpuid, VECTORMUL);
      success += perform_PR(cpuid, MATRIXMUL);
   }
#endif
   return (void *) success;
}


#ifndef HETERO_COMPILATION
#include "accelerate2_prog.h"
#include <arch/htime.h>
hthread_time_t exec_time PRIVATE_MEMORY;
hthread_t child PRIVATE_MEMORY;
hthread_attr_t attr PRIVATE_MEMORY;
void * ret PRIVATE_MEMORY;

int main(){

   printf("HOST: START\n");
   // Initialize various host tables once.
   init_host_tables();

   int i = 0; unsigned int j = 0, h;
   Huint data_size = 64;

#ifdef TEST_PR
   printf("------------------------------------\n");
   printf("HOST: Testing PR\n");
      
   // Set up attributes for a hardware thread
   hthread_attr_init(&attr);
   hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_JOINABLE);

   // Creating threads
   if (thread_create (&child, &attr,test_PR_thread_FUNC_ID, (void *)(NUM_TRIALS),
                  #ifndef HARDWARE_THREAD
                    SOFTWARE_THREAD,
                  #else
                    STATIC_HW0 + i,
                  #endif
                    0))
   {
      printf("hthread_create error on HW THREAD %d\n", i);
      while(1);
   }

   // Join on child thread
   if( hthread_join(child, (void *) &ret)) {
      printf("Error joining child thread\n");
      while(1);
   }
   if (ret != SUCCESS)
      printf("Thread %02d Failed:  %d\n",i, ret);
   printf("HOST: Done\n");
#endif

    
#ifdef USER_SORT
   printf("------------------------------------\n");
   printf("HOST: Testing SORT\n");
   for (data_size = 64; data_size < LIST_LENGTH; data_size+=64) {

      data package;
      package.dataA = (Hint *) malloc(sizeof(Hint) * data_size);
      assert(package.dataA != NULL);
      package.size = data_size;

      for (i = 0; i < data_size; i++) {
         package.dataA[i] = rand() % 1000;
      }

      // Set up attributes for a hardware thread
      hthread_attr_init(&attr);
      hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_JOINABLE);

      #ifdef PERFORM_PR    
      // Perform PR for Slave 0      
      if(perform_PR(0, BUBBLESORT)) {
         printf("Error performing PR\n");
         while(1);
      }
      #endif

      // Creating thread
      if (thread_create (&child, &attr,sort_thread_FUNC_ID, (void *)(&package),
                    STATIC_HW0,
                    0)) 
      {
         printf("hthread_create error on HW THREAD\n");
         while(1);
      }

      // Join on child thread
      if (thread_join(child, &ret, &exec_time)){
         printf("Join error!\n");
         while(1);
      }
      if (ret != SUCCESS)
         printf("Thread %02d Failed:  %d\n", (unsigned int) child, (unsigned int) ret);

      // Check results
#ifdef VERIFY
      for (i = 0; i < data_size-1; i++) {
         if (package.dataA[i] > package.dataA[i+1]) {
            printf("[Data Size = %d] Sort failed!\n", data_size);
            break;
         }
      }
#endif

      // Print out size and Execution time
      printf("%d,%f\n", data_size, hthread_time_usec(exec_time));

      free(package.dataA);
   }
   printf("HOST: Done\n");
#endif


#ifdef USER_CRC
   printf("------------------------------------\n");
   printf("HOST: Testing CRC\n");
   for (data_size = 64; data_size < ARRAY_SIZE; data_size+=64) {
      data package;
      package.dataA = (Hint *) malloc(sizeof(Hint) * data_size);
      assert(package.dataA != NULL);
      package.size = data_size;
      
      Hint * check = (Hint *) malloc(data_size * sizeof(Hint));
      assert(check != NULL);

      // Initializing the data
      Hint * ptr = package.dataA;
      Hint index;
      for(index = 0; index < data_size; index++) {
         *ptr = (rand() % 1000)*8;	
         *(check+index) = *ptr;
         ptr++;
      }
  
      // Generating the CRC of that data
      if (poly_crc(check, data_size)) {
         printf("Host failed to generate CRC check of data\n");
         while(1);
      }
      
      // Set up attributes for a hardware thread
      hthread_attr_init(&attr);
      hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_JOINABLE);

      #ifdef PERFORM_PR    
      // Perform PR for Slave 0      
      if(perform_PR(0, CRC)) {
         printf("Error performing PR\n");
         while(1);
      }
      #endif

      // Creating threads
      if (thread_create (&child, &attr, crc_thread_FUNC_ID, (void *) &package,
                        STATIC_HW0, 0)) {
         printf("hthread_create error on HW THREAD\n");
         while(1);
      }
   
      // Join on child thread
      int status;
      status = thread_join(child, &ret, &exec_time); 
      if (status) {
         printf("Error joining child thread: %d\n", status);
         while(1);
      }
      if (ret != SUCCESS)
         printf("Thread %02d Failed:  %d\n", (unsigned int) child, (unsigned int) ret);

      #ifdef VERIFY
      // For CRC Results
      for ( h = 0; h < data_size; h++) {
         if (*(package.dataA+h) != *(check+h) )  {
            printf("[Data size =  %d] CRC failed!\n", data_size);
            h = data_size;
         }
      }
      #endif 
      
      // Print out size and Execution time
      printf("%d,%f\n", data_size, hthread_time_usec(exec_time));
      // Release memory
      free(package.dataA);
      free(check);
   }
   printf("HOST: Done\n");
#endif

#ifdef USER_MATRIXMUL
   printf("------------------------------------\n");
   printf("HOST: Testing MATRIX_MUL\n");
   data package;
   for (data_size = 8; data_size < MATRIX_SIZE; data_size+=8) {
   
      package.dataA = (Hint*) malloc(data_size * data_size * sizeof(Hint)); 	
      package.dataB = (Hint*) malloc(data_size * data_size * sizeof(Hint)); 	
      package.dataC = (Hint*) malloc(data_size * data_size * sizeof(Hint));
      assert(package.dataA != NULL);   
      assert(package.dataB != NULL);   
      assert(package.dataC != NULL);
      Huint l,k;   
      for (k = 0; k < data_size; k++) {
         for (l = 0; l < data_size; l++) {
            package.dataA[k*data_size + l] = k;
            package.dataB[k*data_size + l] = l;
            package.dataC[k*data_size + l] = 0;
         }
      }
      package.size = data_size;

      // Set up attributes for a hardware thread
      hthread_attr_init(&attr);
      hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_JOINABLE);
      
      #ifdef PERFORM_PR    
      // Perform PR for Slave 0      
      if(perform_PR(0, MATRIXMUL)) {
         printf("Error performing PR\n");
         while(1);
      }
      #endif

      // Creating threads
      if (thread_create (&child, &attr, matrix_multiply_thread_FUNC_ID, (void *)(&package),
                        STATIC_HW0, 0)) {
         printf("hthread_create error on HW THREAD\n");
         while(1);
      }
   
      // Join on child thread
      if( thread_join(child, &ret, &exec_time)) {
         printf("Error joining child thread\n");
         while(1);
      }
      if (ret != SUCCESS)
         printf("Thread %02d Failed:  %d\n", (unsigned int) child, (unsigned int) ret);
      
      #ifdef VERIFY
      // Check results
      Hint * temp = (Hint *) malloc(data_size * data_size * sizeof(Hint));
      assert (temp != NULL);
      poly_matrix_mul(package.dataA, package.dataB, temp, data_size, data_size, data_size);
      int r, c;
      for (r=0 ; r < data_size; r++) {
         for (c=0 ; c < data_size; c++) {
            if ( temp[r*data_size + c] != package.dataC[r*data_size + c])  {
               printf("[TRIAL %d, Slave %d] Matrix Mul failed!\n", j, i);
               r = c = data_size;
            }
         }
      }
      #endif
      
      // Print out size and Execution time
      printf("%d,%f\n", data_size, hthread_time_usec(exec_time));

      // Release memory
      free(package.dataA); 
      free(package.dataB); 
      free(package.dataC);
   }
   printf("HOST: Done\n");
#endif

#ifdef USER_VECTORSUB
   printf("------------------------------------\n");
   printf("HOST: Testing VectorSub\n");
   
   for (data_size = 64; data_size < ARRAY_SIZE; data_size+=64) {
   
	   data input;
      input.dataA = (Hint*) malloc(data_size * sizeof(Hint)); 
      input.dataB = (Hint*) malloc(data_size * sizeof(Hint)); 	
      input.dataC = (Hint*) malloc(data_size * sizeof(Hint)); 	
      assert(input.dataA != NULL);
      assert(input.dataB != NULL);
      assert(input.dataC != NULL);
      input.size = data_size;
      // Init Data
      for (h=0 ; h < data_size; h++) {
         input.dataA[h] = (Hint) (rand() % 1000);
         input.dataB[h] = (Hint) (rand() % 1000);
         input.dataC[h] = 0;
      }
      
      // Set up attributes for a hardware thread
      hthread_attr_init(&attr);
      hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_JOINABLE);
      
      #ifdef PERFORM_PR    
      // Perform PR for Slave 0      
      if(perform_PR(0, VECTORADD)) {
         printf("Error performing PR\n");
         while(1);
      }
      #endif

      // Creating threads
      if (thread_create (&child, &attr, vector_sub_thread_FUNC_ID, (void *)(&input),
                           STATIC_HW0, 0)) {
         printf("hthread_create error on HW THREAD\n");
         while(1);
      }
      
      // Join on child thread
      if( thread_join(child, &ret, &exec_time)) {
         printf("Error joining child thread\n");
         while(1);
      }
      if (ret != SUCCESS)
         printf("Thread %02d Failed:  %d\n", (unsigned int) child, (unsigned int) ret);
     
      #ifdef VERIFY 
      // Check results
      for (h=0 ; h < data_size; h++) {
         if ( (input.dataC[h]) != (input.dataA[h] - input.dataB[h]))  {
            printf("[Data size =  %d] Vector Sub failed!\n", data_size);
            h = data_size;
         }
      }
      #endif
      // Release memory
      free(input.dataA); free(input.dataB); free(input.dataC);
      // Print out size and Execution time
      printf("%d,%f\n", data_size, hthread_time_usec(exec_time));
   }
   printf("HOST: Done\n");
#endif

#ifdef USER_VECTORADD
   printf("------------------------------------\n");
   printf("HOST: Testing VectorAdd\n");
   
   for (data_size = 64; data_size < ARRAY_SIZE; data_size+=64) {
   
	   data input;
      input.dataA = (Hint*) malloc(data_size * sizeof(Hint)); 
      input.dataB = (Hint*) malloc(data_size * sizeof(Hint)); 	
      input.dataC = (Hint*) malloc(data_size * sizeof(Hint)); 	
      assert(input.dataA != NULL);
      assert(input.dataB != NULL);
      assert(input.dataC != NULL);
      input.size = data_size;
      // Init Data
      for (h=0 ; h < data_size; h++) {
         input.dataA[h] = (Hint) (rand() % 1000);
         input.dataB[h] = (Hint) (rand() % 1000);
         input.dataC[h] = 0;
      }
      
      // Set up attributes for a hardware thread
      hthread_attr_init(&attr);
      hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_JOINABLE);

      #ifdef PERFORM_PR    
      // Perform PR for Slave 0      
      if(perform_PR(0, VECTORADD)) {
         printf("Error performing PR\n");
         while(1);
      }
      #endif

      // Creating threads
      if (thread_create (&child, &attr, vector_add_thread_FUNC_ID, (void *)(&input),
                           STATIC_HW0, 0)) {
         printf("hthread_create error on HW THREAD\n");
         while(1);
      }
      
      // Join on child thread
      if( thread_join(child, &ret, &exec_time)) {
         printf("Error joining child thread\n");
         while(1);
      }
      if (ret != SUCCESS)
         printf("Thread %02d Failed:  %d\n", (unsigned int) child, (unsigned int) ret);
     
      #ifdef VERIFY 
      // Check results
      for (h=0 ; h < data_size; h++) {
         if ( (input.dataC[h]) != (input.dataA[h] + input.dataB[h]))  {
            printf("[Data size =  %d] Vector Sub failed!\n", data_size);
            h = data_size;
         }
      }
      #endif
      // Release memory
      free(input.dataA); free(input.dataB); free(input.dataC);
      // Print out size and Execution time
      printf("%d,%f\n", data_size, hthread_time_usec(exec_time));
   }
   printf("HOST: Done\n");
#endif

#ifdef USER_VECTORMUL
   printf("------------------------------------\n");
   printf("HOST: Testing VectorMul\n");
   
   for (data_size = 64; data_size < ARRAY_SIZE; data_size+=64) {
   
	   data input;
      input.dataA = (Hint*) malloc(data_size * sizeof(Hint)); 
      input.dataB = (Hint*) malloc(data_size * sizeof(Hint)); 	
      input.dataC = (Hint*) malloc(data_size * sizeof(Hint)); 	
      assert(input.dataA != NULL);
      assert(input.dataB != NULL);
      assert(input.dataC != NULL);
      input.size = data_size;
      // Init Data
      for (h=0 ; h < data_size; h++) {
         input.dataA[h] = (Hint) (rand() % 1000);
         input.dataB[h] = (Hint) (rand() % 1000);
         input.dataC[h] = 0;
      }
      
      // Set up attributes for a hardware thread
      hthread_attr_init(&attr);
      hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_JOINABLE);
      
      #ifdef PERFORM_PR    
      // Perform PR for Slave 0      
      if(perform_PR(0, VECTORMUL)) {
         printf("Error performing PR\n");
         while(1);
      }
      #endif

      // Creating threads
      if (thread_create (&child, &attr, vector_multiply_thread_FUNC_ID, (void *)(&input),
                           STATIC_HW0, 0)) {
         printf("hthread_create error on HW THREAD\n");
         while(1);
      }
      
      // Join on child thread
      if( thread_join(child, &ret, &exec_time)) {
         printf("Error joining child thread\n");
         while(1);
      }
      if (ret != SUCCESS)
         printf("Thread %02d Failed:  %d\n", (unsigned int) child, (unsigned int) ret);
     
      #ifdef VERIFY 
      // Check results
      for (h=0 ; h < data_size; h++) {
         if ( (input.dataC[h]) != (input.dataA[h] * input.dataB[h]))  {
            printf("[Data size =  %d] Vector Sub failed!\n", data_size);
            h = data_size;
         }
      }
      #endif
      // Release memory
      free(input.dataA); free(input.dataB); free(input.dataC);
      // Print out size and Execution time
      printf("%d,%f\n", data_size, hthread_time_usec(exec_time));
   }
   printf("HOST: Done\n");
#endif

#ifdef USER_VECTORDIV
   printf("------------------------------------\n");
   printf("HOST: Testing VectorDiv\n");
   
   for (data_size = 64; data_size < ARRAY_SIZE; data_size+=64) {
   
	   data input;
      input.dataA = (Hint*) malloc(data_size * sizeof(Hint)); 
      input.dataB = (Hint*) malloc(data_size * sizeof(Hint)); 	
      input.dataC = (Hint*) malloc(data_size * sizeof(Hint)); 	
      assert(input.dataA != NULL);
      assert(input.dataB != NULL);
      assert(input.dataC != NULL);
      input.size = data_size;
      // Init Data
      for (h=0 ; h < data_size; h++) {
         input.dataA[h] = (Hint) (rand() % 1000);
         input.dataB[h] = (Hint) (rand() % 1000) + 1;
         input.dataC[h] = 0;
      }
      
      // Set up attributes for a hardware thread
      hthread_attr_init(&attr);
      hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_JOINABLE);

      #ifdef PERFORM_PR    
      // Perform PR for Slave 0      
      if(perform_PR(0, VECTORMUL)) {
         printf("Error performing PR\n");
         while(1);
      }
      #endif

      // Creating threads
      if (thread_create (&child, &attr, vector_divide_thread_FUNC_ID, (void *)(&input),
                           STATIC_HW0, 0)) {
         printf("hthread_create error on HW THREAD\n");
         while(1);
      }
      
      // Join on child thread
      if( thread_join(child, &ret, &exec_time)) {
         printf("Error joining child thread\n");
         while(1);
      }
      if (ret != SUCCESS)
         printf("Thread %02d Failed:  %d\n", (unsigned int) child, (unsigned int) ret);
     
      #ifdef VERIFY 
      // Check results
      for (h=0 ; h < data_size; h++) {
         if ( (input.dataC[h]) != (input.dataA[h] / input.dataB[h]))  {
            printf("[Data size =  %d] Vector Sub failed!\n", data_size);
            h = data_size;
         }
      }
      #endif
      // Release memory
      free(input.dataA); free(input.dataB); free(input.dataC);
      // Print out size and Execution time
      printf("%d,%f\n", data_size, hthread_time_usec(exec_time));
   }
   printf("HOST: Done\n");
#endif
        
   printf("END\n");
   return 0;
}
#endif

