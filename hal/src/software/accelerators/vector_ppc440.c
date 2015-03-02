/* ***************************************************************
 * Filename: vector.c
 * Description: Code provided for interaction with the vector core.
 * Also, a software version of vector is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/
 
#include <vector.h>
#include <dma/dma.h>
#include "pvr.h"
#include <accelerator.h>
#include <hwti/hwti.h>

Hint vector(void * a_ptr, void * b_ptr, void * c_ptr, Huint size, Huint op_code) {
    
    Hint result = SUCCESS;
    
    // Get VHWTI
    Huint vhwti_base = 0;
    
    // Get VHWTI from PVRs 
    getpvr(1, &vhwti_base);
    
    // Increment SW counter 
    Huint sw_counter = _hwti_get_accelerator_sw_counter( vhwti_base );
    _hwti_set_accelerator_sw_counter( vhwti_base, ++sw_counter);

    // if the size is more than 4k words,
    // grab the amount of iterations you
    // need to perform.
    Huint iterations = size / BRAM_SIZE;
    // If there is a remainder in this 
    // division, round up.
    if ((size % BRAM_SIZE) != 0) {
        iterations++;
    }

    Huint i = 0;
    Huint new_size = 0;
    Huint * new_a_ptr = 0;
    Huint * new_b_ptr = 0;
    Huint * new_c_ptr = 0;
    for (i = 0; i < iterations; i++) {

        // Calculate the size for this iteration
        new_size = (size < (BRAM_SIZE*(i+1))) ? size-(BRAM_SIZE*i) : BRAM_SIZE; 

        // Calculate the starting pointer for this iteration
        new_a_ptr = (Huint *) ((Huint *)a_ptr + BRAM_SIZE*i);
        new_b_ptr = (Huint *) ((Huint *)b_ptr + BRAM_SIZE*i);
        new_c_ptr = (Huint *) ((Huint *)c_ptr + BRAM_SIZE*i);

        // Run vector in software
        result =  (sw_vector_add((void *) new_a_ptr, (void *) new_b_ptr, (void *) new_c_ptr, new_size));
        
        if (result != SUCCESS) break;
    } /* end of iterations loop */ 
    return result;
}

Hint sw_vector(void * a_ptr, void * b_ptr, void * c_ptr, Huint size, Huint op_code) {

    Huint * a = (Huint *) a_ptr;
    Huint * b = (Huint *) b_ptr;
    Huint * c = (Huint *) c_ptr;
    Huint i = 0;
    
    for (i = 0; i < size; i++) {
        c[i] = a[i] + b[i];
    }

    return SUCCESS;
}

Hint sw_vector_add(void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
    
    // Set up DMA structure
    dma_t local_dma;
    dma_config_t local_dma_config;
    local_dma_config.base = ACCELERATOR_DMA_BASEADDR;
    dma_create(&local_dma, &local_dma_config);
    
    // Transfer List A to local BRAM A using local dma
    if(transfer_dma(&local_dma, (void *) a_ptr, (void *) ACC_BRAM_A, size*4))
        return FAILURE;

    // Transfer List B to local BRAM B using local dma
    if(transfer_dma(&local_dma, (void *) b_ptr, (void *) ACC_BRAM_B, size*4))
        return FAILURE;

    if (sw_vector((void *) ACC_BRAM_A, (void *) ACC_BRAM_B, (void *) ACC_BRAM_C, size, 0))
        return FAILURE;
    
    // Transfer results back
    if(transfer_dma(&local_dma, (void *) ACC_BRAM_C, (void *) c_ptr, size*4))
        return FAILURE;
    else
        return SUCCESS;

}
Hint sw_vector_multiply(void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {

    return (sw_vector(a_ptr, b_ptr, c_ptr, size, 1));

}

Hint sw_vector_innerProduct(void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {

    return (sw_vector(a_ptr, b_ptr, c_ptr, size, 2));

}

Hint vector_add(void * a_ptr, void * b_ptr, void * c_ptr, Huint size, Huint * done) {
    
    return (vector(a_ptr, b_ptr, c_ptr, size, 0));

}

Hint vector_multiply(void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {

    return (vector(a_ptr, b_ptr, c_ptr, size, 1));
}

Hint vector_innerProduct(void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {

    return (vector(a_ptr, b_ptr, c_ptr, size, 2));

}

