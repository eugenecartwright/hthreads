/* File: accelerate.c
 * Author: Eugene Cartwright 
 * Description: Modelled using Abazar's hw_acc.c file 
 * This is used to test the accelerator libraries for 
 * both host and slave processors. */
#include <hthread.h>
#include <stdio.h>
#include <accelerator.h>

// Create on slaves? define it...
#define HARDWARE_THREAD
// Dynamically choose which slave? define it...
//#define DYNAMIC
//#define TUNING
//#define DEBUG_DISPATCH


#define NUM_TRIALS          (500)

// For sort
#define LIST_LENGTH        1024

// For crc and vector
#define ARRAY_SIZE         2048
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
    Hint * startAddr;
    Hint * endAddr;    
} Data;

typedef struct {
   Hint * dataA;
   Hint * dataB; 
   Hint * dataC;  
   Huint size;  //The size of vector for crc,sort, vectoradd and vectormul. For Matrix Multiply, it's the size of the dimension of the squre matrix.
} data;

typedef struct {
	Hint * startAddr1;
	Hint * endAddr1;
	Hint * startAddr2;
	Hint * endAddr2;
	Hint * startAddr3;
	Hint * endAddr3;	
} Data3;

//====================================================================================
void * sort_thread(void * arg) 
{

   // Get size of list
   unsigned int size = LIST_LENGTH;
   // Call sort
   //return (void *) sw_bubblesort(arg, (Huint) size);
   return (void *) (poly_bubblesort(arg, (Huint) size));
}

void * crc_thread(void * arg) 
{
    // Get size of list
    unsigned int size = ARRAY_SIZE;
   
    // Call crc
    return (void *) (poly_crc(arg, (Huint) size));
}

void * matrix_multiply_thread(void * arg) 
{
	data * package = (data *) arg;
   return (void *) poly_matrix_mul (package->dataA,  package->dataB, package->dataC, package->size,package->size,package->size);  
}

void * vector_add_thread(void * arg) 
{
    Data3 * package = (Data3 *) arg;

    // Get size of list
    unsigned int size = ARRAY_SIZE;
    
    // Call sort
    return (void *) (poly_vectoradd((void *) package->startAddr1,(void *) package->startAddr2, (void *) package->startAddr3, (Huint) size));
}

void * vector_sub_thread(void * arg) 
{
    Data3 * package = (Data3 *) arg;

    // Get size of list
    unsigned int size = ARRAY_SIZE;
    
    // Call sort
    return (void *) (poly_vectorsub((void *) package->startAddr1,(void *) package->startAddr2, (void *) package->startAddr3, (Huint) size));
}

void * vector_multiply_thread(void * arg) 
{
    Data3 * package = (Data3 *) arg;

    // Get size of list
    unsigned int size = ARRAY_SIZE;
    
    // Call sort
    return (void *) (poly_vectormul((void *) package->startAddr1,(void *) package->startAddr2, (void *) package->startAddr3, (Huint) size));
}

void * vector_divide_thread(void * arg) 
{
    Data3 * package = (Data3 *) arg;

    // Get size of list
    unsigned int size = ARRAY_SIZE;
    
    // Call sort
    return (void *) (poly_vectordiv((void *) package->startAddr1,(void *) package->startAddr2, (void *) package->startAddr3, (Huint) size));
}

#include <arch/arch.h>
#include <pr.h>
#include "pvr.h"
void * test_PR_thread(void * arg)
{
   Hint success = 0, i, trials = (int) arg;
#ifdef PR
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
#include "accelerate_prog.h"
#include <arch/htime.h>

int main(){

   printf("HOST: START\n");
   // Initialize various host tables once.
   init_host_tables();

   int i = 0; unsigned int j = 0, h,k;
   int ret[NUM_AVAILABLE_HETERO_CPUS];
   Hint * ptr;
	Data3 input3[NUM_AVAILABLE_HETERO_CPUS];

   printf("HOST: Creating thread & attribute structures\n");
   hthread_t * child = (hthread_t *) malloc(sizeof(hthread_t) * NUM_AVAILABLE_HETERO_CPUS);
   hthread_attr_t * attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * NUM_AVAILABLE_HETERO_CPUS);
   assert (child != NULL);
   assert (attr != NULL);

#ifdef TEST_PR
   printf("------------------------------------\n");
   printf("HOST: Testing PR\n");
      
   // Set up attributes for a hardware thread
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) { 
      hthread_attr_init(&attr[i]);
      hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
   }

   // Creating threads
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      if (thread_create (&child[i], &attr[i],test_PR_thread_FUNC_ID, (void *)(NUM_TRIALS),
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
   }

   // Joining threads
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      // Join on child thread
      if( hthread_join(child[i], (void *) &ret[i])) {
         printf("Error joining child thread\n");
         while(1);
      }
      if (ret[i] != SUCCESS)
         printf("Thread %02d Failed:  %d\n",i, ret[i]);
   }
   printf("HOST: Done\n");
#endif

    
#ifdef USER_SORT
   int list[NUM_AVAILABLE_HETERO_CPUS][LIST_LENGTH];
   printf("------------------------------------\n");
   printf("HOST: Testing SORT\n");
   // initialized the list 
   for (j = 0; j < NUM_TRIALS; j++) {

      for (h = 0; h < NUM_AVAILABLE_HETERO_CPUS; h++) {
         for (i = 0; i < LIST_LENGTH; i++) {
            //list[h][i] = rand() % 1000;
            list[h][i] = LIST_LENGTH-i;
         }
      }

      #if 0 
      printf("Printing original lists\n");
      for (h = 0; h < NUM_AVAILABLE_HETERO_CPUS; h++) {
         printf("List[%d]: ", h);
         for (i = 0; i < LIST_LENGTH; i++) {
            printf("..%d", list[h][i]);
         }
         printf("\n");
      }
      #endif

      // Set up attributes for a hardware thread
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) { 
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
      }

      // Creating threads
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         if (thread_create (&child[i], &attr[i],sort_thread_FUNC_ID, (void *)(&list[i][0]),
                     #ifndef HARDWARE_THREAD
                       SOFTWARE_THREAD,
                     #elif DYNAMIC
                       DYNAMIC_HW,
                     #else
                       STATIC_HW0 + i,
                     #endif
                       0)) 
         {
            printf("hthread_create error on HW THREAD %d\n", i);
            while(1);
         }
       }

      // Joining threads
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if( hthread_join(child[i], (void *) &ret[i])) {
            printf("Error joining child thread\n");
            while(1);
         }
         //printf("Thread %02d Result = %d\n",i,ret[i]);
      }

      // Check results
      //printf("Now checking the lists\n");
      for (h = 0; h < NUM_AVAILABLE_HETERO_CPUS; h++) {
         //printf("List[%d]: ", h);
         //for (i = LIST_LENGTH - (LIST_LENGTH-1); i < LIST_LENGTH; i++) {
         for (i = 0; i < LIST_LENGTH-1; i++) {
            //printf("..%d", list[h][i]);
            if (list[h][i] > list[h][i+1]) {
               printf("*");
               printf("[TRIAL %d, Slave %d] Sort failed!\n", j, h);
               i = LIST_LENGTH;
            }
         }
         // Print last element
         //printf("..%d", list[h][i]);
         //printf("\n");
      }
   }
   printf("HOST: Done\n");
#endif


#ifdef USER_CRC
   printf("------------------------------------\n");
   printf("HOST: Testing CRC\n");
   
   Hint * input;
   Hint * check, index = 0;
   for (j = 0; j < NUM_TRIALS; j++) {
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         input = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint));
         check = (Hint *) malloc(ARRAY_SIZE * sizeof(Hint)); 
         assert(input != NULL);
         assert(check != NULL);

         // Initializing the data
         ptr = input;
         for(index = 0; index < ARRAY_SIZE; index++) {
            *ptr = (rand() % 1000)*8;	
            *(check+index) = *ptr;
            ptr++;
         }
     
         // Generating the CRC of that data
         if (poly_crc(check, ARRAY_SIZE)) {
            printf("Host failed to generate CRC check of data\n");
            while(1);
         }
         
         // Set up attributes for a hardware thread
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);


         // Creating threads
         if (thread_create (&child[i], &attr[i], crc_thread_FUNC_ID, (void *)input,
                        #ifndef HARDWARE_THREAD
                           SOFTWARE_THREAD,
                        #elif DYNAMIC
                           DYNAMIC_HW,
                        #else
                           STATIC_HW0 + i,
                        #endif
                        0)) 
         {
            printf("hthread_create error on HW THREAD %d\n", i);
            while(1);
         }
      
         // Join on child thread
         int status;
         status = hthread_join(child[i], (void *) &ret[i]); 
         if (status) {
            printf("Error joining child thread: %d\n", status);
            while(1);
         }
         //printf("Thread %02d Result = %d\n",i,ret[i]);

         // For CRC Results
         for ( h = 0; h < ARRAY_SIZE; h++) {
            if (*(input+h) != *(check+h) )  {
               printf("[TRIAL %d, Slave %d] CRC failed!\n", j, i);
               h = ARRAY_SIZE;
            }
         } 
         // Release memory
         free(input);
         free(check);
      }
   }
   printf("HOST: Done\n");
#endif

#ifdef USER_MATRIXMUL
   printf("------------------------------------\n");
   printf("HOST: Testing MatrixMul\n");

   data package[NUM_AVAILABLE_HETERO_CPUS];
   for (j = 0; j < NUM_TRIALS; j++) {
   
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         package[i].dataA = (Hint*) malloc(MATRIX_SIZE * MATRIX_SIZE * sizeof(Hint)); 	
         package[i].dataB = (Hint*) malloc(MATRIX_SIZE * MATRIX_SIZE * sizeof(Hint)); 	
         package[i].dataC = (Hint*) malloc(MATRIX_SIZE * MATRIX_SIZE * sizeof(Hint));
         assert(package[i].dataA != NULL);   
         assert(package[i].dataB != NULL);   
         assert(package[i].dataC != NULL);
         Huint l;   
         for (k = 0; k < MATRIX_SIZE; k++) {
            for (l = 0; l < MATRIX_SIZE; l++) {
               package[i].dataA[k*MATRIX_SIZE + l] = k;
               package[i].dataB[k*MATRIX_SIZE + l] = l;
               package[i].dataC[k*MATRIX_SIZE + l] = 0;
            }
         }
         package[i].size = MATRIX_SIZE;
         unsigned int row, col;
#if 0
         printf("Original Matrix A: 0x%08x\n", package[i].dataA);
         for (row=0 ; row < MATRIX_SIZE; row++) {
            for (col=0 ; col < MATRIX_SIZE; col++) {
               printf("%02d ", package[i].dataA[row*MATRIX_SIZE+col]);
            }
            printf("\n");
         }
         printf("Original Matrix B: 0x%08x\n", package[i].dataB);
         for (row=0 ; row < MATRIX_SIZE; row++) {
            for (col=0 ; col < MATRIX_SIZE; col++) {
               printf("%02d ", package[i].dataB[row*MATRIX_SIZE+col]);
            }
            printf("\n");
         }

         printf("Original Matrix C: 0x%08x\n", package[i].dataC);
         for (row=0 ; row < MATRIX_SIZE; row++) {
            for (col=0 ; col < MATRIX_SIZE; col++) {
               printf("%02d ", package[i].dataC[row*MATRIX_SIZE+col]);
            }
            printf("\n");
         }
#endif    

         // Set up attributes for a hardware thread
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);

         // Creating threads
         if (thread_create (&child[i], &attr[i], matrix_multiply_thread_FUNC_ID, (void *)(&package[i]),
                           #ifndef HARDWARE_THREAD
                              SOFTWARE_THREAD,
                           #elif DYNAMIC
                              DYNAMIC_HW,
                           #else
                              STATIC_HW0 + i,
                           #endif
                           0)) 
         {
            printf("hthread_create error on HW THREAD %d\n", i);
            while(1);
         }
      
         // Join on child thread
         if( hthread_join(child[i], (void *) &ret[i])) {
            printf("Error joining child thread\n");
            while(1);
         }
         if (ret[i] != SUCCESS)
            printf("Return value for thread indicates an error!\n");
         #if 0 
         printf("New Matrix C:\n");
         for (row=0 ; row < MATRIX_SIZE; row++) {
            for (col=0 ; col < MATRIX_SIZE; col++) {
               printf("%02d ", package[i].dataC[row*MATRIX_SIZE+col]);
            }
            printf("\n");
         }
         #endif
         // Check results
         Hint temp[MATRIX_SIZE][MATRIX_SIZE];
         poly_matrix_mul(package[i].dataA, package[i].dataB, &temp, MATRIX_SIZE, MATRIX_SIZE, MATRIX_SIZE);
         int r, c;
         for (r=0 ; r < MATRIX_SIZE; r++) {
            for (c=0 ; c < MATRIX_SIZE; c++) {
               if ( temp[r][c] != package[i].dataC[r*MATRIX_SIZE + c])  {
                  printf("[TRIAL %d, Slave %d] Matrix Mul failed!\n", j, i);
                  r = c = MATRIX_SIZE;
               }
            }
         }
         
         // Release memory
         free(package[i].dataA); 
         free(package[i].dataB); 
         free(package[i].dataC);
      }
   }
   printf("HOST: Done\n");
#endif

#ifdef USER_VECTORSUB
   printf("------------------------------------\n");
   printf("HOST: Testing VectorSub\n");
   
   for (j = 0; j < NUM_TRIALS; j++) {
   
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         input3[i].startAddr1 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr1 = input3[i].startAddr1 + ARRAY_SIZE - 1;
         input3[i].startAddr2 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr2 = input3[i].startAddr2 + ARRAY_SIZE - 1;
         input3[i].startAddr3 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr3 = input3[i].startAddr3 + ARRAY_SIZE - 1;
         
         for( ptr = input3[i].startAddr1; ptr <= input3[i].endAddr1; ptr++ ){*ptr = (Hint) rand() % 1000;	/* printf( " %i \n",*ptr );*/} 
         for( ptr = input3[i].startAddr2; ptr <= input3[i].endAddr2; ptr++ ){*ptr = (Hint) rand() % 1000;	/* printf( " %i \n",*ptr );*/}
      }    
      
      // Set up attributes for a hardware thread
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) { 
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
      }

      // Creating threads
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         if (thread_create (&child[i], &attr[i], vector_sub_thread_FUNC_ID, (void *)(&input3[i]),
                           #ifndef HARDWARE_THREAD
                              SOFTWARE_THREAD,
                           #elif DYNAMIC
                              DYNAMIC_HW,
                           #else
                              STATIC_HW0 + i,
                           #endif
                           0)) 
         {
            printf("hthread_create error on HW THREAD %d\n", i);
            while(1);
         }
      }
      
      // Joining threads
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if( hthread_join(child[i], (void *) &ret[i])) {
            printf("Error joining child thread\n");
            while(1);
         }
      }
      
      // Check results
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         for (h=0 ; h < ARRAY_SIZE; h++) {
            if ( (input3[i].startAddr3[h]) != (input3[i].startAddr1[h] - input3[i].startAddr2[h]))  {
               printf("[TRIAL %d, Slave %d] Vector Sub failed!\n", j, i);
               h = ARRAY_SIZE;
            }
         }
         
         // Release memory
         free(input3[i].startAddr1); free(input3[i].startAddr2); free(input3[i].startAddr3);
      }
   }
   printf("HOST: Done\n");
#endif

#ifdef USER_VECTORADD
   printf("------------------------------------\n");
   printf("HOST: Testing VectorAdd\n");
   
   for (j = 0; j < NUM_TRIALS; j++) {
   
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         input3[i].startAddr1 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr1 = input3[i].startAddr1 + ARRAY_SIZE - 1;
         input3[i].startAddr2 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr2 = input3[i].startAddr2 + ARRAY_SIZE - 1;
         input3[i].startAddr3 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr3 = input3[i].startAddr3 + ARRAY_SIZE - 1;
         
         for( ptr = input3[i].startAddr1; ptr <= input3[i].endAddr1; ptr++ ){*ptr = (Hint) rand() % 1000;	/* printf( " %i \n",*ptr );*/} 
         for( ptr = input3[i].startAddr2; ptr <= input3[i].endAddr2; ptr++ ){*ptr = (Hint) rand() % 1000;	/* printf( " %i \n",*ptr );*/}
      }    
      
      // Set up attributes for a hardware thread
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) { 
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
      }

      // Creating threads
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         if (thread_create (&child[i], &attr[i], vector_add_thread_FUNC_ID, (void *)(&input3[i]),
                           #ifndef HARDWARE_THREAD
                              SOFTWARE_THREAD,
                           #elif DYNAMIC
                              DYNAMIC_HW,
                           #else
                              STATIC_HW0 + i,
                           #endif
                           0)) 
         {
            printf("hthread_create error on HW THREAD %d\n", i);
            while(1);
         }
      }
      
      // Joining threads
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if( hthread_join(child[i], (void *) &ret[i])) {
            printf("Error joining child thread\n");
            while(1);
         }
      }
      
      // Check results
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         for (h=0 ; h < ARRAY_SIZE; h++) {
            if ( (input3[i].startAddr3[h]) != (input3[i].startAddr1[h] + input3[i].startAddr2[h]))  {
               printf("[TRIAL %d, Slave %d] Vector Add failed!\n", j, i);
               h = ARRAY_SIZE;
            }
         }
         
         // Release memory
         free(input3[i].startAddr1); free(input3[i].startAddr2); free(input3[i].startAddr3);
      }
   }
   printf("HOST: Done\n");
#endif

#ifdef USER_VECTORMUL
   printf("------------------------------------\n");
   printf("HOST: Testing VectorMultiply\n");
   
   for (j = 0; j < NUM_TRIALS; j++) {
   
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         input3[i].startAddr1 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr1 = input3[i].startAddr1 + ARRAY_SIZE - 1;
         input3[i].startAddr2 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr2 = input3[i].startAddr2 + ARRAY_SIZE - 1;
         input3[i].startAddr3 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr3 = input3[i].startAddr3 + ARRAY_SIZE - 1;
         
         for( ptr = input3[i].startAddr1; ptr <= input3[i].endAddr1; ptr++ ){*ptr = (Hint) rand() % 1000;	/* printf( " %i \n",*ptr );*/} 
         for( ptr = input3[i].startAddr2; ptr <= input3[i].endAddr2; ptr++ ){*ptr = (Hint) rand() % 1000;	/* printf( " %i \n",*ptr );*/}
      }    
      
      // Set up attributes for a hardware thread
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) { 
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
      }

      // Creating threads
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         if (thread_create (&child[i], &attr[i], vector_multiply_thread_FUNC_ID, (void *)(&input3[i]),
                           #ifndef HARDWARE_THREAD
                              SOFTWARE_THREAD,
                           #elif DYNAMIC
                              DYNAMIC_HW,
                           #else
                              STATIC_HW0 + i,
                           #endif
                           0)) 
         {
            printf("hthread_create error on HW THREAD %d\n", i);
            while(1);
         }
      }
      
      // Joining threads
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if( hthread_join(child[i], (void *) &ret[i])) {
            printf("Error joining child thread\n");
            while(1);
         }
      }
      
      // Check results
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         for (h=0 ; h < ARRAY_SIZE; h++) {
            if ( (input3[i].startAddr3[h]) != (input3[i].startAddr1[h] * input3[i].startAddr2[h]))  {
               printf("[TRIAL %d, Slave %d] Vector Multiply failed!\n", j, i);
               h = ARRAY_SIZE;
            }
         }
         
         // Release memory
         free(input3[i].startAddr1); free(input3[i].startAddr2); free(input3[i].startAddr3);
      }
   }
   printf("HOST: Done\n");
#endif

#ifdef USER_VECTORDIV
   printf("------------------------------------\n");
   printf("HOST: Testing VectorDivide\n");
   
   for (j = 0; j < NUM_TRIALS; j++) {
   
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         input3[i].startAddr1 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr1 = input3[i].startAddr1 + ARRAY_SIZE - 1;
         input3[i].startAddr2 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr2 = input3[i].startAddr2 + ARRAY_SIZE - 1;
         input3[i].startAddr3 = (Hint*) malloc(ARRAY_SIZE * sizeof(Hint)); 	
         input3[i].endAddr3 = input3[i].startAddr3 + ARRAY_SIZE - 1;
         
         for( ptr = input3[i].startAddr1; ptr <= input3[i].endAddr1; ptr++ ){*ptr = (Hint) rand() % 1000;	/* printf( " %i \n",*ptr );*/} 
         for( ptr = input3[i].startAddr2; ptr <= input3[i].endAddr2; ptr++ ){*ptr = (Hint) (rand() % 1000) + 1;	/* printf( " %i \n",*ptr );*/}
      }    
      
      // Set up attributes for a hardware thread
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) { 
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
      }

      // Creating threads
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         if (thread_create (&child[i], &attr[i], vector_divide_thread_FUNC_ID, (void *)(&input3[i]),
                           #ifndef HARDWARE_THREAD
                              SOFTWARE_THREAD,
                           #elif DYNAMIC
                              DYNAMIC_HW,
                           #else
                              STATIC_HW0 + i,
                           #endif
                           0)) 
         {
            printf("hthread_create error on HW THREAD %d\n", i);
            while(1);
         }
      }
      
      // Joining threads
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if( hthread_join(child[i], (void *) &ret[i])) {
            printf("Error joining child thread\n");
            while(1);
         }
      }
      
      // Check results
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         for (h=0 ; h < ARRAY_SIZE; h++) {
            // dividend was generated to be a non-zero number above. Hence, no need to check for / 0
            if ( (input3[i].startAddr3[h]) != (input3[i].startAddr1[h] / input3[i].startAddr2[h]))  {
               printf("[TRIAL %d, Slave %d] Vector Divide failed!\n", j, i);
               h = ARRAY_SIZE;
            }
         }
         
         // Release memory
         free(input3[i].startAddr1); free(input3[i].startAddr2); free(input3[i].startAddr3);
      }
   }
   printf("HOST: Done\n");
#endif
        
   printf("END\n");
   return 0;
}
#endif

