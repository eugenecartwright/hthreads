#ifndef _HOST_CALL_H_
#define _HOST_CALL_H_

#include <hthread.h>
#include <accelerator.h>
#include <hwti/hwti.h>
#include "pvr.h"

// Structures
typedef struct {
    int * data;
    Huint size;
} sort_t;

typedef struct {
    int * data;
    Huint size;
} crc_t;

typedef struct {
    int * dataA;
    int * dataB;
    int * dataC;
    Huint size;
} vector_t;


typedef union {
    struct {
        void * data;
        Huint size;
        Huint * done;

    } sort;

    struct {
        void * data;
        Huint size;
        Huint * done;

    } crc;

    struct {
        void * dataA;
        void * dataB;
        void * dataC;
        Huint size;
        Huint * done;

    } vector;
} thread_arg_t;


int min(int x, int y)
{
    if (x < y)
       return x;
    else
       return y; 

}
// ---------------------------------------------------------- //
// Primitive functions: These functions are called by us and
// not directly from the USER!!!!
// ---------------------------------------------------------- //
void * crc_thread( void * arg) {

    crc_t * package = (crc_t *) arg;
    Hint result = 0;

    result = crc((void *) package->data, package->size);

    return (void *) result;
}

void * sort_thread( void * arg) {
    
    sort_t * package = (sort_t *) arg;
    Hint result = 0;

    result = sort((void *) package->data, package->size);


    return (void *) result;

}

void * vector_add_thread( void * arg) {

    vector_t * package = (vector_t *) arg;
    Hint result = 0;

    result = vector_add((void *) package->dataA, (void *) package->dataB, (void *) package->dataC, package->size);

    return (void *) result;

}


// ----------------------------------------------//
// Intermediate Functions. Used by host-level
// calls (software detached threads call these
// functions.
// ----------------------------------------------//
#ifndef HETERO_COMPILATION
    
//X => how many chunks , n=> size of data ; n should be divisible by x, x should be less than MAX
void merge_sort(int x, int n, int * src , int * des){

	#define TimerEnINTtMask   0x00000040
	#define TimerDisINTtMask  0xffffffBf

	#define base_timer0  XPAR_XPS_TIMER_0_BASEADDR
	volatile int *TCSR0 = (int*) (base_timer0+0x0);
	*TCSR0&=TimerDisINTtMask; //disable the timer;

	int chunck_size = n/x;
	int remainder = n %x ;
		
		

	// this is  not slave calling, so it does not data and ptr in lmb
	// this is host, I have to do it manuall; otherwise it assigns them in dram, and merge sort takes a long time.
	int * ptr= (int *) 0x00000200;	//For making it locally on BRAm of host.
	int * data= (int *) 0x00000400;	//For making it locally on BRAm of host.

	
	int register  i,j, min, index = 0;

	if (remainder !=0)		x++;

	//INITILIZe the ptrs and data for chunks
	for ( i=0; i < x; i++){
		ptr[i]=0;
		data[i]=*((int *)src + i *chunck_size);
		
	}

	//write final data into bramB one by one
	for ( i=0; i < n; i++){
		min=0x7fffffff;
		for ( j=0; j < x-1; j++)
		{
			if (  ( data[j] < min) &&    (ptr[j]<chunck_size)  )
			{
				min=data[j];
				index=j;
			}
			
		}
		if (  ( data[j] < min)){
			if ((remainder ==0) &&    (ptr[j]<chunck_size)  ) {min=data[j];	index=j;}
			else if ((remainder !=0) &&    (ptr[j]<remainder)  ) {min=data[j];	index=j;}
		}

		* ( (int *)(des)+i) =min;

		ptr[index]= ptr[index]+1;
		data[index]= *( (int *)src+ index * chunck_size +ptr[index]);
				
	}

	*TCSR0|=TimerEnINTtMask; //enable the timer;	

}
#endif
Hint vector_add_sw_thread(void * arg) {

#ifdef HETERO_COMPILATION
    return SUCCESS;
#else
    thread_arg_t * top_package = (thread_arg_t *) arg;


    Huint size   = top_package->vector.size;
    void * a_ptr = top_package->vector.dataA;
    void * b_ptr = top_package->vector.dataB;
    void * c_ptr = top_package->vector.dataC;
    Huint * done = top_package->vector.done;
   
    // Read index in tuning table
    Huint index = get_index(size);

    // Read # of optimal number of chunks
    Huint chunks = min (get_num_free_slaves() , tuning_table[VECTOR*NUM_OF_SIZES + index].optimal_thread_num);
    
    Huint chunk_size = size / chunks;
    Huint remainder = size % chunks;

    // Determine if we will create an extra software thread @ the end
    Huint extra_thread = (remainder == 0) ? 0 : 1;

    // Create "threads" number of packages.
    vector_t * package = (vector_t *) malloc(sizeof(vector_t) * (chunks + extra_thread));
    assert(package != NULL);

    // Return values
    int * ret = (int *) malloc(sizeof(int) * (chunks + extra_thread));
    assert(ret != NULL);

    Huint i = 0;
    for (i = 0; i < chunks; i++) {
        package[i].size = chunk_size;

        Huint * startPtrA = (Huint *) a_ptr + chunk_size*i;
        Huint * startPtrB = (Huint *) b_ptr + chunk_size*i;
        Huint * startPtrC = (Huint *) c_ptr + chunk_size*i;

        package[i].dataA = (void *) startPtrA; 
        package[i].dataB = (void *) startPtrB; 
        package[i].dataC = (void *) startPtrC; 
    }

    // if we are crating an extra (software) thread,
    // create an extra package.
    if (extra_thread) {
        package[i].size = remainder;

        Huint * startPtrA = (Huint *) a_ptr + size - remainder;
        Huint * startPtrB = (Huint *) b_ptr + size - remainder;
        Huint * startPtrC = (Huint *) c_ptr + size - remainder;

        package[i].dataA = (void *) startPtrA; 
        package[i].dataB = (void *) startPtrB; 
        package[i].dataC = (void *) startPtrC; 
    }

    // Define thread and attribute structure
    hthread_t * threads = (hthread_t *) malloc(sizeof(hthread_t) * (chunks + extra_thread));
    hthread_attr_t * attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * (chunks + extra_thread));
    assert(threads != NULL); assert(attr != NULL);

    for (i = 0; i < chunks; i++) {
        hthread_attr_init( &attr[i] );

        // Create hardware threads 
        thread_create(
            &threads[i],
            &attr[i],
            vector_add_thread_FUNC_ID, 
            (void *)(&package[i]),
            DYNAMIC_HW,
            (Huint) 0);
    }

    // If we need to create an extra (software) thread
    if (extra_thread) {
        hthread_attr_init( &attr[chunks] );
        thread_create(
            &threads[chunks],
            &attr[chunks],
            vector_add_thread_FUNC_ID, 
            (void *)(&package[chunks]),
            SOFTWARE_THREAD,
            (Huint) 0);
    }

    for (i = 0; i < chunks+extra_thread; i++) {

        hthread_join(threads[i], (void *) &ret[i]);

    }

    // Unallocate memory occupied by package.
    free(package);
    free(threads);
    free(attr);
    free(ret);
    
    // Indicate that this thread is done
    *done = 1;

    return SUCCESS;
#endif

}

Hint crc_sw_thread(void * arg) {
#ifdef HETERO_COMPILATION
    return SUCCESS;
#else
    thread_arg_t * top_package = (thread_arg_t *) arg;



    Huint size = top_package->crc.size;
    void * list_ptr = top_package->crc.data;
    Huint * done = top_package->crc.done;
   
    // Read index in tuning table
    Huint index = get_index(size);

    // Read # of optimal number of chunks
    Huint chunks = min (get_num_free_slaves() , tuning_table[CRC*NUM_OF_SIZES + index].optimal_thread_num);
    
    Huint chunk_size = size / chunks;
    Huint remainder = size % chunks;

    // Determine if we will create an extra software thread @ the end
    Huint extra_thread = (remainder == 0) ? 0 : 1;

    // Create "threads" number of packages.
    crc_t * package = (crc_t *) malloc(sizeof(crc_t) * (chunks + extra_thread));
    assert(package != NULL);

    // Return values
    int * ret = (int *) malloc(sizeof(int) * (chunks + extra_thread));
    assert(ret != NULL);

    Huint i = 0;
    for (i = 0; i < chunks; i++) {
        package[i].size = chunk_size;

        Huint * startPtr = (Huint *) list_ptr + chunk_size*i;

        package[i].data = (void *) startPtr; 
    }

    // if we are crating an extra (software) thread,
    // create an extra package.
    if (extra_thread) {
        package[i].size = remainder;

        Huint * startPtr = (Huint *) list_ptr + size - remainder;

        package[i].data = (void *) startPtr; 
    }

    // Define thread and attribute structure
    hthread_t * threads = (hthread_t *) malloc(sizeof(hthread_t) * (chunks + extra_thread));
    hthread_attr_t * attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * (chunks + extra_thread));
    assert(threads != NULL); assert(attr != NULL);

    for (i = 0; i < chunks; i++) {
        hthread_attr_init( &attr[i] );

        // Create hardware threads 
        thread_create(
            &threads[i],
            &attr[i],
            crc_thread_FUNC_ID, 
            (void *)(&package[i]),
            DYNAMIC_HW,
            (Huint) 0);
    }

    // If we need to create an extra (software) thread
    if (extra_thread) {
        hthread_attr_init( &attr[chunks] );
        thread_create(
            &threads[chunks],
            &attr[chunks],
            crc_thread_FUNC_ID, 
            (void *)(&package[chunks]),
            SOFTWARE_THREAD,
            (Huint) 0);
    }

    for (i = 0; i < chunks+extra_thread; i++) {

        hthread_join(threads[i], (void *) &ret[i]);
    }

    // Unallocate memory occupied by package.
    free(package);
    free(threads);
    free(attr);
    free(ret);
    
    // Indicate that this thread is done
    *done = 1;

    return SUCCESS;
#endif
}

Hint sort_sw_thread(void * arg) {
 
#ifdef HETERO_COMPILATION
    return SUCCESS;
#else
    thread_arg_t * top_package = (thread_arg_t *) arg;

  
    Huint size = top_package->sort.size;
    void * list_ptr = top_package->sort.data;
    Huint * done = top_package->sort.done;
   
    // Read index in tuning table
    Huint index = get_index(size);

    // Read # of optimal number of chunks
    Huint chunks = min (get_num_free_slaves() , tuning_table[SORT*NUM_OF_SIZES + index].optimal_thread_num);
    
    Huint chunk_size = size / chunks;
    Huint remainder = size % chunks;

    // Determine if we will create an extra software thread @ the end
    Huint extra_thread = (remainder == 0) ? 0 : 1;

    // Create "threads" number of packages.
    sort_t * package = (sort_t *) malloc(sizeof(sort_t) * (chunks + extra_thread));
    assert(package != NULL);

    // Return values
    int * ret = (int *) malloc(sizeof(int) * (chunks + extra_thread));
    assert(ret != NULL);

    Huint i = 0;
    for (i = 0; i < chunks; i++) {
        package[i].size = chunk_size;

        Huint * startPtr = (Huint *) list_ptr + chunk_size*i;

        package[i].data = (void *) startPtr; 
    }

    // if we are crating an extra (software) thread,
    // create an extra package.
    if (extra_thread) {
        package[i].size = remainder;

        Huint * startPtr = (Huint *) list_ptr + size - remainder;

        package[i].data = (void *) startPtr; 
    }

    // Define thread and attribute structure
    hthread_t * threads = (hthread_t *) malloc(sizeof(hthread_t) * (chunks + extra_thread));
    hthread_attr_t * attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * (chunks + extra_thread));
    assert(threads != NULL); assert(attr != NULL);

    for (i = 0; i < chunks; i++) {
        hthread_attr_init( &attr[i] );

        // Create hardware threads 
        thread_create(
            &threads[i],
            &attr[i],
            sort_thread_FUNC_ID, 
            (void *)(&package[i]),
            DYNAMIC_HW,
            (Huint) 0);
    }

    // If we need to create an extra (software) thread
    if (extra_thread) {
        hthread_attr_init( &attr[chunks] );
        thread_create(
            &threads[chunks],
            &attr[chunks],
            sort_thread_FUNC_ID, 
            (void *)(&package[chunks]),
            SOFTWARE_THREAD,
            (Huint) 0);
    }

    for (i = 0; i < chunks+extra_thread; i++) {

        hthread_join(threads[i], (void *) &ret[i]);
    }

     // Declare  Scratch pad area and then call merge sort
    if (chunks != 1) {

        // Create a scratch area (preferably in local BRAM)
        Hint * scratch = (Hint *) malloc(sizeof(Hint) * size);
        // Hint * scratch = (Hint *) 0x00000050;

        // Copy the sorted chunks from original source to scratchpad
        Hint * src = (Hint *) list_ptr;
        for (i = 0; i < size; i++) 
            *(scratch+i) = *(src+i);

        // Merge the datal.
        merge_sort(chunks, size, scratch, src);

        free(scratch);

    }

    // Unallocate memory occupied by package.
    free(package);
    free(threads);
    free(attr);
    free(ret);
    
    // Indicate that this thread is done
    *done = 1;

    return SUCCESS;
#endif
}


// --------------------------------------------------------- //
// Host level tuned functions. User may call these functions.
// --------------------------------------------------------- //
#ifndef HETERO_COMPILATION

Hint host_sort(void * list_ptr, Huint size, Huint * done) {

    thread_arg_t * package = (thread_arg_t *) malloc(sizeof(thread_arg_t));

    package->sort.data = list_ptr;
    package->sort.size = size;
    package->sort.done = done;

    // Reset done signal
    *done = 0;

    // Create a detached thread
    hthread_t sw_detached_thread;
    hthread_attr_t attr;

    hthread_attr_init(&attr);
    hthread_attr_setdetachstate(&attr, HTHREAD_CREATE_DETACHED);

    // Create software thread
    return (thread_create(
        &sw_detached_thread,
        &attr,
        sort_sw_thread_FUNC_ID, 
        (void *)package,
        SOFTWARE_THREAD,
        (Huint) 0));
}

Hint host_crc(void * list_ptr, Huint size, Huint * done) {

    thread_arg_t * package = (thread_arg_t *) malloc(sizeof(thread_arg_t));

    package->crc.data = list_ptr;
    package->crc.size = size;
    package->crc.done = done;

    // Reset done signal
    *done = 0;

    // Create a detached thread
    hthread_t sw_detached_thread;
    hthread_attr_t attr;

    hthread_attr_init(&attr);
    hthread_attr_setdetachstate(&attr, HTHREAD_CREATE_DETACHED);


    // Create software thread
    return (thread_create(
        &sw_detached_thread,
        &attr,
        crc_sw_thread_FUNC_ID, 
        (void *)package,
        SOFTWARE_THREAD,
        (Huint) 0));
}

Hint host_vector_add(void * a_ptr, void * b_ptr, void * c_ptr, Huint size, Huint * done) {

    thread_arg_t * package = (thread_arg_t *) malloc(sizeof(thread_arg_t));

    package->vector.dataA = a_ptr;
    package->vector.dataB = b_ptr;
    package->vector.dataC = c_ptr;
    package->vector.size = size;
    package->vector.done = done;

    // Reset done signal
    *done = 0;

    // Create a detached thread
    hthread_t sw_detached_thread;
    hthread_attr_t attr;

    hthread_attr_init(&attr);
    hthread_attr_setdetachstate(&attr, HTHREAD_CREATE_DETACHED);

    // Create software thread
    return (thread_create(
        &sw_detached_thread,
        &attr,
        vector_add_sw_thread_FUNC_ID, 
        (void *)package,
        SOFTWARE_THREAD,
        (Huint) 0));
}

#endif



#endif
