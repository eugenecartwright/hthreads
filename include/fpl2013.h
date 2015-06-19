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
    Huint vector_size;
    Huint * vector_valid; 
    hthread_time_t exe_time;
    char * thread_type;
} Data;




#ifndef HETERO_COMPILATION

 void print_finer_info(){
// Grab the total number of calls statistic.
    int i;
    Huint total_num_of_calls = best_slaves_num + no_free_slaves_num + possible_slaves_num; 

     printf("Total number of thread_create (DYNAMIC) calls: %d\n", total_num_of_calls);
    printf("---------------------------------------------------\n");
    printf("Best Ratio:     %03d / %03d = %0.2f\n", best_slaves_num, total_num_of_calls, best_slaves_num / (0.01 * total_num_of_calls));
    printf("No Free Ratio:  %03d / %03d = %0.2f\n", no_free_slaves_num, total_num_of_calls, no_free_slaves_num / (0.01 * total_num_of_calls));
    printf("Possible Ratio: %03d / %03d = %0.2f\n", possible_slaves_num, total_num_of_calls, possible_slaves_num / (0.01* total_num_of_calls));

    Huint hw_counter[NUM_AVAILABLE_HETERO_CPUS];
    Huint sw_counter[NUM_AVAILABLE_HETERO_CPUS];
    Huint pr_counter[NUM_AVAILABLE_HETERO_CPUS];
    Huint total_hw_count = 0;
    Huint total_sw_count = 0;
    Huint total_pr_count = 0;

    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        hw_counter[i] = _hwti_get_accelerator_hw_counter(base_array[i]);
        sw_counter[i] = _hwti_get_accelerator_sw_counter(base_array[i]);
        pr_counter[i] = _hwti_get_accelerator_pr_counter(base_array[i]);

        total_hw_count += hw_counter[i];
        total_sw_count += sw_counter[i];
        total_pr_count += pr_counter[i];
    }
    printf("Total acc creating on slaves: %d\n", total_hw_count+ total_sw_count);
    printf("Total HW Counter: %d\n", total_hw_count);
    printf("Total SW Counter: %d\n", total_sw_count);
    printf("Total PR Counter: %d\n", total_pr_count);
    printf("-----------------------\n");
    if (total_hw_count)     // if total_hw_count != 0
        printf("Total PR Counter / HW+sw Counter = %f\n", total_pr_count / (0.01 *(total_hw_count+total_sw_count)));
    printf("Total hw Counter / HW+SW Counter = %f\n", total_hw_count / (0.01 *(total_hw_count+total_sw_count)));

}
void init_package(Data * package,int sort_size,int crc_size,int vector_size)
{

	int e;
	package->crc_size = crc_size;
	package->sort_size =sort_size;
	package->vector_size = vector_size;
/*
	if (package->sort_data != NULL) free(package->sort_data);
	if (package->crc_data != NULL)free(package->crc_data);
	if (package->crc_data_check!= NULL)free(package->crc_data_check);
	if (package->dataA != NULL)free(package->dataA); 
	if (package->dataB != NULL)free(package->dataB);
	if (package->dataC != NULL)free(package->dataC);
	if (package->sort_valid != NULL)free(package->sort_valid);
	if (package->crc_valid != NULL)free(package->crc_valid);
	if (package->vector_valid != NULL)free(package->vector_valid);
*/


	    package->sort_data = (void *) malloc(sizeof(int) * package->sort_size);
	    package->crc_data = (void *) malloc(sizeof(int) * package->crc_size);
	    package->crc_data_check = (void *) malloc(sizeof(int) * package->crc_size);
	    package->dataA = (void *) malloc(sizeof(int) * package->vector_size);
	    package->dataB = (void *) malloc(sizeof(int) * package->vector_size);
	    package->dataC = (void *) malloc(sizeof(int) * package->vector_size);
	    package->sort_valid = (Huint *) malloc(sizeof(Huint));
	    package->crc_valid = (Huint *) malloc(sizeof(Huint));
	    package->vector_valid = (Huint *) malloc(sizeof(Huint));
	
	    // Check to see if we were able to allocate said memory
	    assert(package->sort_valid != NULL);
	    assert(package->crc_valid != NULL);
	    assert(package->vector_valid != NULL);
	
	    assert(package->sort_data != NULL);
	    assert(package->crc_data != NULL);
	    assert(package->dataA != NULL);
	    assert(package->dataB != NULL);
	    assert(package->dataC != NULL);
	
	    // Initialize all the valid signals to zero
	    *(package->sort_valid) = 0;
	    *(package->crc_valid) = 0;
	    *(package->vector_valid) = 0;
	
	    // Initialize the CRC data here
                Hint * data = (Hint *) package->crc_data;
	        Hint * data_check = (Hint *) package->crc_data_check;
	    for (e = 0; e < package->crc_size; e++) { 
	       
	        data[e] = data_check[e] = (rand() % 1000) * 8;
	    }
	    
	    // Initialize Vector Data
                Hint * dataA = package->dataA;
	        Hint * dataB = package->dataB;
	        Hint * dataC = package->dataC; 
	    for (e = 0; e < package->vector_size; e++) {
	        
	        dataA[e] = rand() % 1000;
	        dataB[e] = rand() % 1000;
	        dataC[e] = 0;
	    }
	
	    // Initialize Sort Data 
	    Hint * sort_data = (Hint *) package->sort_data;
	    for (e = 0; e < package->sort_size; e++) {
	        sort_data[e] = package->sort_size - e;
	    }
	
}

int check_package(Data * package)
{

int e;

	int  number_of_errors = 0;
	    // Check SORT for this package
	    if (*(package->sort_valid)) { 
	        unsigned int b = 0;
	        Hint * sorted_list = package->sort_data;
	        for (b = 0; b < package->sort_size-1; b++) {
	            if (sorted_list[b] > sorted_list[b+1]) {
	                number_of_errors++;
	                printf("\tSORT: Package %u failed\n", b);
	                break;
	            }
	        }
	    }
	    
	    // Check CRC for this package
	    if (*(package->crc_valid)) {
	        unsigned int b = 0;
	        Hint * crc_org = (Hint *) package->crc_data;
	        Hint * crc_check = (Hint *) package->crc_data_check;
	
	        crc((void *) crc_check, package->crc_size);
	
	        for (b = 0; b < package->crc_size; b++) {
	            if (crc_org[b] != crc_check[b]) {
	                printf("\tCRC: Package %u failed\n", b);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	
	    // Check Vector for this package
	    if (*(package->vector_valid)) {
	        unsigned int b = 0;
	        Hint * A = (Hint *) package->dataA;
	        Hint * B = (Hint *) package->dataB;
	        Hint * C = (Hint *) package->dataC;
	        for (b = 0; b < package->vector_size; b++) {
	            if (C[b] != A[b] +B[b]) { 
	                printf("\tVector: Package %u failed\n", b);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	

return number_of_errors;
}

void init_tuning_table_manual()
{
int i;
#ifdef BASE_CASE
tuning_table_t temp[NUM_OF_ACCELERATORS*NUM_OF_SIZES] = {
    {2, 48 , 276, 6},  {4, 71 , 501, 2},  {4, 116, 990,  6},   {8, 201,  1971, 4},    {8, 372,  3927, 6},  {16, 709,   7845,  6},   {16, 1384,  15671, 6},
    {2, 149, 354, 1},  {4, 329, 692, 2},  {4, 807, 1468, 5},   {8, 1965, 3228, 3},    {8, 5262, 6758, 3},  {16, 13344, 14254, 3},   {16, 38192, 30906, 5}, 
    {2, 49 , 104, 1},  {1, 55 , 155, 2},  {1, 79 , 290,  3},   {2, 121,  563,  2},    {2, 213,  1110, 4},  {2,  364,   2204,  5},   {2,  728,   4417,  5}
    };
    for (i=0; i<NUM_OF_ACCELERATORS*NUM_OF_SIZES;i++){
	tuning_table[i].sw_time =temp[i].sw_time;	
	tuning_table[i].hw_time =temp[i].hw_time;
	tuning_table[i].chunks = temp[i].chunks;
        tuning_table[i].optimal_thread_num =temp[i].optimal_thread_num;
    }
#else
tuning_table_t temp[NUM_OF_ACCELERATORS*NUM_OF_SIZES] = {
    {2, 48 , 276, 1},  {4, 71 , 501, 1},  {4, 116, 990,  1},   {8, 201,  1971, 1},    {8, 372,  3927, 2},  {16, 709,   7845,  1},   {16, 1384,  15671, 2},
    {2, 149, 354, 2},  {4, 329, 692, 1},  {4, 807, 1468, 2},   {8, 1965, 3228, 1},    {8, 5262, 6758, 2},  {16, 13344, 14254, 5},   {16, 38192, 30906, 5}, 
    {2, 49 , 104, 1},  {1, 55 , 155, 1},  {1, 79 , 290,  1},   {2, 121,  563,  1},    {2, 213,  1110, 1},  {2,  364,   2204,  2},   {2,  728,   4417,  2}
    };
    for (i=0; i<NUM_OF_ACCELERATORS*NUM_OF_SIZES;i++){
	tuning_table[i].sw_time =temp[i].sw_time;	
	tuning_table[i].hw_time =temp[i].hw_time;
	tuning_table[i].chunks = temp[i].chunks;
        tuning_table[i].optimal_thread_num =temp[i].optimal_thread_num;
    }


#endif
printf("This is manual\n");




}
//=================================================================================
void init_tuning_table()
{

	hthread_t threads[3];
	hthread_attr_t attr[3];
	int i;
	for (i=0 ; i<3; i++){
		hthread_attr_init(&attr[i]);
		hthread_attr_setdetachstate(&attr[i], HTHREAD_CREATE_DETACHED);}

	volatile Data package;
	int data_size;
	Huint index;
	tuning_table_t temp_tuning_table[NUM_OF_ACCELERATORS*NUM_OF_SIZES];
//initilzing the tunning table for hw	
	for (i=0; i<NUM_OF_ACCELERATORS*NUM_OF_SIZES;i++){
			temp_tuning_table[i].hw_time =100000;
			tuning_table[i].chunks =0;
			tuning_table[i].optimal_thread_num =-1;}

//====================================================================================
//initilzing the tunning table for sw_time
//====================================================================================
   for(data_size = 64 ; data_size <=  4096 ; data_size*=2) //for all data sizes
   {
       if (data_size == 4096) data_size--;
	/*************** Package 0 **********/
	// Initalize the size for this package
	
        init_package((Data *)&package,data_size,data_size,data_size);
       _hwti_set_accelerator_flags(base_array[0], 0);// force it to run it in sw
       _hwti_set_accelerator_flags(base_array[2], 0);// force it to run it in sw
       _hwti_set_accelerator_flags(base_array[4], 0);// force it to run it in sw

	thread_create(&threads[0], &attr[0], worker_crc_thread_FUNC_ID, (void *) &package, STATIC_HW0, 0);
	thread_create(&threads[1], &attr[1], worker_sort_thread_FUNC_ID, (void *) &package, STATIC_HW2, 0);
	thread_create(&threads[2], &attr[2], worker_vector_thread_FUNC_ID, (void *) &package, STATIC_HW4, 0);

	while(get_num_free_slaves()!=6);

	if (check_package((Data *)&package)) print("Error\n");

        
        Huint index = get_index(data_size);
        tuning_table[CRC*NUM_OF_SIZES+index].sw_time = _hwti_get_execution_time(base_array[0])/100;
        tuning_table[SORT*NUM_OF_SIZES+index].sw_time = _hwti_get_execution_time(base_array[2])/100;
        tuning_table[VECTOR*NUM_OF_SIZES+index].sw_time = _hwti_get_execution_time(base_array[4])/100;
	free(package.sort_data);
	free(package.crc_data);
	free(package.crc_data_check);
	free(package.dataA); 
	free(package.dataB);
	free(package.dataC);
	free(package.sort_valid);
	free(package.crc_valid);
	free(package.vector_valid);
        
   }
   printf ("Tuning for sw_time is done\n");



//====================================================================================
//tuning table for hw_time and hw_chunks
//====================================================================================
#if 1
	for(data_size = 64 ; data_size <=  4096 ; data_size*=2) //for all data sizes
	{
		if (data_size == 4096) data_size--;// temp remedy for current problem with bitstream at last data of brams.
		int chunks;
		 index = get_index(data_size);
		
		for (chunks=1; chunks <=16; chunks*=2)
		{
			// Initalize the size for this package
			
			init_package((Data *)&package,data_size,data_size,data_size);
			_hwti_set_accelerator_flags(base_array[0], 0x80000000);// force it to run it in hw
			_hwti_set_accelerator_flags(base_array[2], 0x80000000);// force it to run it in hw
			_hwti_set_accelerator_flags(base_array[4], 0x80000000);// force it to run it in hw

			int i=0;
			for (i=0; i<NUM_OF_ACCELERATORS*NUM_OF_SIZES;i++)
				tuning_table[i].chunks =chunks;

			thread_create(&threads[0], &attr[0], worker_crc_thread_FUNC_ID, (void *) &package, STATIC_HW0, 0);
			thread_create(&threads[1], &attr[1], worker_sort_thread_FUNC_ID, (void *) &package, STATIC_HW2, 0);
			thread_create(&threads[2], &attr[2], worker_vector_thread_FUNC_ID, (void *) &package, STATIC_HW4, 0);

			while(get_num_free_slaves()!=6);

			if (check_package((Data *)&package)) print("Error\n");
  #ifdef MORE_INFO_TIMING
		printf("CRC    , data size : %i  , chunks = %i, hw_time:%ius \r\n",data_size, chunks , (int) _hwti_get_execution_time(base_array[0])/100);
		printf("SORT   , data size : %i  , chunks = %i, hw_time:%ius \r\n",data_size, chunks , (int)_hwti_get_execution_time(base_array[2])/100);
		printf("VECTOR , data size : %i  , chunks = %i, hw_time:%ius \r\n",data_size, chunks , (int) _hwti_get_execution_time(base_array[4])/100);
                printf("***************\n");
  #endif

			if ((_hwti_get_execution_time(base_array[0])/100) < temp_tuning_table[CRC*NUM_OF_SIZES+index].hw_time ){
				temp_tuning_table[CRC*NUM_OF_SIZES+index].hw_time = _hwti_get_execution_time(base_array[0])/100;
				temp_tuning_table[CRC*NUM_OF_SIZES+index].chunks =chunks;}

			if ((_hwti_get_execution_time(base_array[2])/100) < temp_tuning_table[SORT*NUM_OF_SIZES+index].hw_time ){
				temp_tuning_table[SORT*NUM_OF_SIZES+index].hw_time = _hwti_get_execution_time(base_array[2])/100;
				temp_tuning_table[SORT*NUM_OF_SIZES+index].chunks =chunks;}

			if ((_hwti_get_execution_time(base_array[4])/100) < temp_tuning_table[VECTOR*NUM_OF_SIZES+index].hw_time ){
				temp_tuning_table[VECTOR*NUM_OF_SIZES+index].hw_time = _hwti_get_execution_time(base_array[4])/100;
				temp_tuning_table[VECTOR*NUM_OF_SIZES+index].chunks =chunks;}    

			free(package.sort_data);
			free(package.crc_data);
			free(package.crc_data_check);
			free(package.dataA); 
			free(package.dataB);
			free(package.dataC);
			free(package.sort_valid);
			free(package.crc_valid);
			free(package.vector_valid); 
		}

		
	}

       for (i=0; i<NUM_OF_ACCELERATORS*NUM_OF_SIZES;i++){
		tuning_table[i].chunks =temp_tuning_table[i].chunks;
		tuning_table[i].hw_time =temp_tuning_table[i].hw_time;}




#endif
   printf ("Tuning for hw_time + chunks is done\n");

//====================================================================================
 //tuning table for optimal number of threads, every thing runs in Mb sw, not hw. 
//====================================================================================
#if 1
	int n_slaves;
	hthread_time_t start, stop,diff;
        hthread_time_t crc_time,vector_time,sort_time;
     for(data_size = 60 ; data_size <=  4096 ; data_size*=2) //for all data sizes it should be divisible by 1,2,3,4,5,6
     {
       if (data_size == 4096) data_size--;
	/*************** Package 0 **********/
	// Initalize the size for this package
	
	index = get_index(data_size);
#ifdef BASE_CASE
       _hwti_set_accelerator_flags(base_array[0], 0);// force it to run it in sw
       _hwti_set_accelerator_flags(base_array[2], 0);// force it to run it in sw
       _hwti_set_accelerator_flags(base_array[4], 0);// force it to run it in sw
       _hwti_set_accelerator_flags(base_array[1], 0);// force it to run it in sw
       _hwti_set_accelerator_flags(base_array[3], 0);// force it to run it in sw
       _hwti_set_accelerator_flags(base_array[5], 0);// force it to run it in sw
#else //for static acc. systems. however, we use the same data as an estimate for PR system, since it is difficult to get that timing.
	_hwti_set_accelerator_flags(base_array[0],0x80000000);// force it to run it in hw
       _hwti_set_accelerator_flags(base_array[2], 0x80000000);// force it to run it in hw
       _hwti_set_accelerator_flags(base_array[4], 0x80000000);// force it to run it in hw
       _hwti_set_accelerator_flags(base_array[1], 0x80000000);// force it to run it in hw
       _hwti_set_accelerator_flags(base_array[3], 0x80000000);// force it to run it in hw
       _hwti_set_accelerator_flags(base_array[5], 0x80000000);// force it to run it in hw
#endif  

  	 crc_time= 100000 *100;   
 	 sort_time= 100000 *100;
 	  vector_time= 100000 *100;     
	
     
	for (n_slaves=1 ; n_slaves <=NUM_AVAILABLE_HETERO_CPUS; n_slaves++)
	{
		   //do  crc
		tuning_table[CRC*NUM_OF_SIZES + index].optimal_thread_num=n_slaves;
                init_package((Data *)&package,data_size,data_size,data_size);
                start=hthread_time_get();
		host_crc(package.crc_data, package.crc_size, package.crc_valid); 		
		while(*(package.crc_valid) !=1)	;
		stop=hthread_time_get();
		hthread_time_diff(diff, stop, start);	
                if (   (((crc_time-diff)*100) /crc_time)   >= PERORMANCE_IMPROVED ){ crc_time =diff;    
                  temp_tuning_table[CRC*NUM_OF_SIZES+index].optimal_thread_num = n_slaves; }
	 	    #ifdef MORE_INFO_TIMING
			 printf("CRC   , data size : %4i  , No.slaves: %i , Time: %5.0f us \r\n",data_size, n_slaves,hthread_time_usec(diff));
		  #endif

  		 //do  vector
		tuning_table[VECTOR*NUM_OF_SIZES + index].optimal_thread_num=n_slaves;
               
                start=hthread_time_get();
		host_vector_add(package.dataA, package.dataB, package.dataC, package.vector_size, package.vector_valid);
		while(*(package.vector_valid) !=1)	;
		stop=hthread_time_get();
		hthread_time_diff(diff, stop, start);	
                 if (   (((vector_time-diff)*100) /vector_time)   >= PERORMANCE_IMPROVED ){ vector_time =diff;        
                  temp_tuning_table[VECTOR*NUM_OF_SIZES+index].optimal_thread_num = n_slaves;} 
	 	    #ifdef MORE_INFO_TIMING     
			 printf("VECTOR, data size : %4i  , No.slaves: %i , Time: %5.0f us \r\n",data_size, n_slaves,hthread_time_usec(diff));
		  #endif
 
                //do sort
		tuning_table[SORT*NUM_OF_SIZES + index].optimal_thread_num=n_slaves;
               
                start=hthread_time_get();
		host_sort(package.sort_data, package.sort_size, package.sort_valid);		
		while(*(package.sort_valid) !=1)	;
		stop=hthread_time_get();
		hthread_time_diff(diff, stop, start);	
                 if (   (((sort_time-diff)*100) /sort_time)   >= PERORMANCE_IMPROVED )  {sort_time=diff;  
                  temp_tuning_table[SORT*NUM_OF_SIZES+index].optimal_thread_num = n_slaves; }
	 	   #ifdef MORE_INFO_TIMING
			 printf("SORT  , data size : %4i  , No.slaves: %i , Time: %5.0f us \r\n",data_size, n_slaves,hthread_time_usec(diff));
		  #endif

                if (check_package((Data *)&package)) print("Error\n");
		free(package.sort_data);
		free(package.crc_data);
		free(package.crc_data_check);
		free(package.dataA); 
		free(package.dataB);
		free(package.dataC);
		free(package.sort_valid);
		free(package.crc_valid);
		free(package.vector_valid);

        }

   
   }
  
	 for (i=0; i<NUM_OF_ACCELERATORS*NUM_OF_SIZES;i++)
		tuning_table[i].optimal_thread_num =temp_tuning_table[i].optimal_thread_num;
		
   

#endif
 printf ("Tuning for optimal number of threads is done\n**********************\n");

//====================================================================================
 //resetting every thing back.
//====================================================================================
	best_slaves_num =0;
	no_free_slaves_num =0;
	possible_slaves_num=0;

  for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        _hwti_set_accelerator_hw_counter(base_array[i], 0);
        _hwti_set_accelerator_sw_counter(base_array[i], 0);
        _hwti_set_accelerator_pr_counter(base_array[i], 0);}


	
}


#endif




// -------------------------------------------------------- //
// These are the USER thread functions.
// -------------------------------------------------------- //

void * worker_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // SORT
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vector_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get(); 

    Hint result = SUCCESS;
    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;
           stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_sort_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // Call sort
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_sort_vector_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // Call sort
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_crc_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // Call sort
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_crc_vector_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vector_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;

    // Call sort
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}

void * worker_vector_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;

    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}


void * worker_vector_crc_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;

    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // Call sort
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_vector_sort_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;

    // Call sort
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}

void * worker_crc_vector_sort_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;

    // Call sort
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}
void * worker_crc_sort_vector_thread( void * arg) {
    Data * myarg = (Data *) arg;
    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // Call sort
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;
}
void * worker_sort_crc_vector_thread( void * arg) {
    Data * myarg = (Data *) arg;

    hthread_time_t start,stop;
    start= hthread_time_get();

    Hint result = SUCCESS;
    // Call sort
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;

    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 
    return (void *) result;

}
void * worker_sort_vector_crc_thread( void * arg) {
    Data * myarg = (Data *) arg;

    hthread_time_t start,stop;
    start= hthread_time_get();


    Hint result = SUCCESS;
    // Call sort
    if (sort(myarg->sort_data, myarg->sort_size))
        result = FAILURE;
    *(myarg->sort_valid) = 1;

    // VECTOR
    if (vector_add(myarg->dataA, myarg->dataB, myarg->dataC, myarg->vector_size))
        result = FAILURE;
    *(myarg->vector_valid) = 1;

    // CRC
    if (crc(myarg->crc_data, myarg->crc_size))
        result = FAILURE;
    *(myarg->crc_valid) = 1;
    
       stop= hthread_time_get();  (myarg->exe_time)=(hthread_time_t) (stop-start); 

    return (void *) result;
}

#endif
