#ifndef TUNING_TABLE_H
#define TUNING_TABLE_H
#include <hthread.h>
#include <accelerator.h>

// For sort
#define _LIST_LENGTH        4096

// For crc and vector
#define _ARRAY_SIZE         4096
// For matrix
#define _MATRIX_SIZE        64

typedef struct {
   Hint * dataA;
   Hint * dataB; 
   Hint * dataC;  
   Huint size;  //The size of vector for crc,sort, vectoradd and vectormul. For Matrix Multiply, it's the size of the dimension of the squre matrix.
} _data;


void * sort_thread(void * arg) 
{
   _data * temp = (_data *) arg;
   // Get size of list
   unsigned int size = temp->size;
   // Call sort
   return (void *) (poly_bubblesort(temp->dataA, (Huint) size));
}

void * crc_thread(void * arg) 
{
   _data * temp = (_data *) arg;
   // Get size of list
   unsigned int size = temp->size;
   
    // Call crc
    return (void *) (poly_crc(temp->dataA, (Huint) size));
}

void * matrix_multiply_thread(void * arg) 
{
	_data * package = (_data *) arg;
   return (void *) poly_matrix_mul (package->dataA,  package->dataB, package->dataC, package->size,package->size,package->size);  
}

void * vector_add_thread(void * arg) 
{
    _data * package = (_data *) arg;

    // Get size of list
    unsigned int size = package->size;
    
    // Call Vector Add
    return (void *) (poly_vectoradd((void *) package->dataA,(void *) package->dataB, (void *) package->dataC, (Huint) size));
}

void * vector_sub_thread(void * arg) 
{
    _data * package = (_data *) arg;

    // Get size of list
    unsigned int size = package->size;
    
    // Call Vectorsub
    return (void *) (poly_vectorsub((void *) package->dataA,(void *) package->dataB, (void *) package->dataC, (Huint) size));
}

void * vector_multiply_thread(void * arg) 
{
    _data * package = (_data *) arg;

    // Get size of list
    unsigned int size = package->size;
    
    // Call vector multiply
    return (void *) (poly_vectormul((void *) package->dataA,(void *) package->dataB, (void *) package->dataC, (Huint) size));
}

void * vector_divide_thread(void * arg) 
{
    _data * package = (_data *) arg;

    // Get size of list
    unsigned int size = package->size;
    
    // Call divide
    return (void *) (poly_vectordiv((void *) package->dataA,(void *) package->dataB, (void *) package->dataC, (Huint) size));
}
#endif
