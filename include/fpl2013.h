#ifndef _FPL2013_H_
#define _FPL2013_H_

#include <hthread.h>
#include <accelerator.h>
#include <hwti/hwti.h>
#include "pvr.h"




// Main structure
typedef struct {
    // Sort
    void * sort_data;
    Huint sort_size;
    Huint * sort_valid;

    // CRC
    void * crc_data;
    void * crc_data_check;
    Huint crc_size;
    Huint * crc_valid;

    // Vector
    void * dataA;
    void * dataB; 
    void * dataC;
    Huint vectoradd_size;
    Huint * vectoradd_valid; 
    Huint vectorsub_size;
    Huint * vectorsub_valid; 
    Huint vectormul_size;
    Huint * vectormul_valid; 
    hthread_time_t exe_time;
    char * thread_type;
} Data;



// -------------------------------------------------------- //
// These are the USER thread functions.
// -------------------------------------------------------- //

void * worker_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // SORT
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vectoradd_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get(); 

    Hint result = SUCCESS;
    // VECTORADD
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;
           //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vectorsub_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get(); 

    Hint result = SUCCESS;
    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;
           //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vectormul_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get(); 

    Hint result = SUCCESS;
    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;
           //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_sort_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_sort_vectoradd_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTOR
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_sort_vectorsub_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_sort_vectormul_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_crc_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_crc_vectoradd_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTORADD
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_crc_vectorsub_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_crc_vectormul_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vectoradd_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTORADD
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vectorsub_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vectormul_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vectoradd_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTOR
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vectorsub_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vectormul_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}


void * worker_vectoradd_crc_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTOR
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_vectorsub_crc_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_vectormul_crc_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_vectoradd_sort_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTOR
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_vectorsub_sort_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_vectormul_sort_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_crc_vectoradd_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTOR
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_crc_vectorsub_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_crc_vectormul_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_crc_sort_vectoradd_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTOR
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_crc_sort_vectorsub_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_crc_sort_vectormul_thread( void * arg) {
    Data * myarg = (Data *) arg;
    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_sort_crc_vectoradd_thread( void * arg) {
    Data * myarg = (Data *) arg;

    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTOR
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_sort_crc_vectorsub_thread( void * arg) {
    Data * myarg = (Data *) arg;

    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_sort_crc_vectormul_thread( void * arg) {
    Data * myarg = (Data *) arg;

    //hthread_time_t start,stop;
    //start= hthread_time_get();

    Hint result = SUCCESS;
    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}
void * worker_sort_vectoradd_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;

    //hthread_time_t start,stop;
    //start= hthread_time_get();


    Hint result = SUCCESS;
    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTOR
    if (poly_vectoradd(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectoradd_size))
        result = FAILURE;
    *(myarg->vectoradd_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
    
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 

    return (void *) result;
}

void * worker_sort_vectorsub_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;

    //hthread_time_t start,stop;
    //start= hthread_time_get();


    Hint result = SUCCESS;
    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTORSUB
    if (poly_vectorsub(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectorsub_size))
        result = FAILURE;
    *(myarg->vectorsub_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
    
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 

    return (void *) result;
}

void * worker_sort_vectormul_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;

    //hthread_time_t start,stop;
    //start= hthread_time_get();


    Hint result = SUCCESS;
    // Call sort
    if (poly_bubblesort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTORMUL
    if (poly_vectormul(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vectormul_size))
        result = FAILURE;
    *(myarg->vectormul_valid) = 1;

    // CRC
    if (poly_crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
    
       //stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 

    return (void *) result;
}

#endif
