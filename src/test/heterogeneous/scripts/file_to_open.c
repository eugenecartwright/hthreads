	// Instantiate threads and thread attribute structures
	hthread_t threads[1];
	hthread_attr_t attr[1];
	unsigned int ee = 0;
	for(ee = 0; ee < 1; ee++) {
		hthread_attr_init(&attr[ee]);
		hthread_attr_setdetachstate(&attr[ee], HTHREAD_CREATE_DETACHED);
	}

	volatile Data package[1];
	/*************** Package 0 **********/
	// Initalize the size for this package
	package[0].sort_size = 10000;
	package[0].crc_size = 40;
	package[0].vector_size = 100;
	
	// Allocate memory
	unsigned int e = 0, k = 0;
	for ( k = 0; k < 1; k++) {
	    package[k].sort_data = (void *) malloc(sizeof(int) * package[k].sort_size);
	    package[k].crc_data = (void *) malloc(sizeof(int) * package[k].crc_size);
	    package[k].crc_data_check = (void *) malloc(sizeof(int) * package[k].crc_size);
	    package[k].dataA = (void *) malloc(sizeof(int) * package[k].vector_size);
	    package[k].dataB = (void *) malloc(sizeof(int) * package[k].vector_size);
	    package[k].dataC = (void *) malloc(sizeof(int) * package[k].vector_size);
	    package[k].sort_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].crc_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].vector_valid = (Huint *) malloc(sizeof(Huint));
	
	    // Check to see if we were able to allocate said memory
	    assert(package[k].sort_valid != NULL);
	    assert(package[k].crc_valid != NULL);
	    assert(package[k].vector_valid != NULL);
	
	    assert(package[k].sort_data != NULL);
	    assert(package[k].crc_data != NULL);
	    assert(package[k].dataA != NULL);
	    assert(package[k].dataB != NULL);
	    assert(package[k].dataC != NULL);
	
	    // Initialize all the valid signals to zero
	    *(package[k].sort_valid) = 0;
	    *(package[k].crc_valid) = 0;
	    *(package[k].vector_valid) = 0;
	
	    // Initialize the CRC data here
	    for (e = 0; e < package[k].crc_size; e++) { 
	        Hint * data = (Hint *) package[k].crc_data;
	        Hint * data_check = (Hint *) package[k].crc_data_check;
	        data[e] = data_check[e] = (rand() % 1000) * 8;
	    }
	    
	    // Initialize Vector Data 
	    for (e = 0; e < package[k].vector_size; e++) {
	        Hint * dataA = package[k].dataA;
	        Hint * dataB = package[k].dataB;
	        Hint * dataC = package[k].dataC;
	        dataA[e] = rand() % 1000;
	        dataB[e] = rand() % 1000;
	        dataC[e] = 0;
	    }
	
	    // Initialize Sort Data 
	    for (e = 0; e < package[k].sort_size; e++) {
	        Hint * sort_data = (Hint *) package[k].sort_data;
	        sort_data[e] = package[k].sort_size - e;
	    }
	}
	

	printf("Starting Timer!\n");

	hthread_time_t start = hthread_time_get();

	thread_create(&threads[0], &attr[0], worker_vector1_thread_FUNC_ID, (void *) &package[0], DYNAMIC_HW, 0);

	while((thread_counter + (NUM_AVAILABLE_HETERO_CPUS - get_num_free_slaves()) ) > 0);

	hthread_time_t stop = hthread_time_get();

	int number_of_errors = 0;
	for (e = 0; e < 1; e++) {
	    // Check SORT for this package
	    if (*(package[e].sort_valid)) {
	        unsigned int b = 0;
	        Hint * sorted_list = package[e].sort_data;
	        for (b = 0; b < package[e].sort_size-1; b++) {
	            if (sorted_list[b] > sorted_list[b+1]) {
	                number_of_errors++;
	                printf("\tSORT: Package %u failed\n", e);
	                break;
	            }
	        }
	    }
	    
	    // Check CRC for this package
	    if (*(package[e].crc_valid)) {
	        unsigned int b = 0;
	        Hint * crc = (Hint *) package[e].crc_data;
	        Hint * crc_check = (Hint *) package[e].crc_data_check;
	
	        _crc((void *) crc_check, package[e].crc_size);
	
	        for (b = 0; b < package[e].crc_size; b++) {
	            if (crc[b] != crc_check[b]) {
	                printf("\tCRC: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	
	    // Check Vector for this package
	    if (*(package[e].vector_valid)) {
	        unsigned int b = 0;
	        Hint * A = (Hint *) package[e].dataA;
	        Hint * B = (Hint *) package[e].dataB;
	        Hint * C = (Hint *) package[e].dataC;
	        for (b = 0; b < package[e].vector_size; b++) {
	            if (C[b] != A[b] +B[b]) { 
	                printf("\tVector: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	}
	
	printf("---------------------------\n");
	printf("\nNumber of Errors = %d\n\n", number_of_errors);
	hthread_time_t diff;
	hthread_time_diff(diff, stop, start);
	printf("Total Execution Time: %.2f ms\n", hthread_time_msec(diff));
	printf("Total Execution Time: %.2f us\n", hthread_time_usec(diff));
