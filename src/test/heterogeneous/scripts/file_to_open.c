	// Instantiate threads and thread attribute structures
	hthread_t threads[32];
	hthread_attr_t attr[32];
	unsigned int ee = 0;
	for(ee = 0; ee < 32; ee++) {
		hthread_attr_init(&attr[ee]);
		hthread_attr_setdetachstate(&attr[ee], HTHREAD_CREATE_DETACHED);
	}

	volatile Data package[32];
	/*************** Package 0 **********/
	// Initalize the size for this package
	package[0].sort_size = 4095;
	package[0].crc_size = 1024;
	package[0].vectoradd_size = 3500;
	package[0].vectorsub_size = 3500;
	package[0].vectormul_size = 3500;
	
	/*************** Package 1 **********/
	// Initalize the size for this package
	package[1].sort_size = 2048;
	package[1].crc_size = 3500;
	package[1].vectoradd_size = 1024;
	package[1].vectorsub_size = 1024;
	package[1].vectormul_size = 1024;
	
	/*************** Package 2 **********/
	// Initalize the size for this package
	package[2].sort_size = 2048;
	package[2].crc_size = 4095;
	package[2].vectoradd_size = 1024;
	package[2].vectorsub_size = 1024;
	package[2].vectormul_size = 1024;
	
	/*************** Package 3 **********/
	// Initalize the size for this package
	package[3].sort_size = 2048;
	package[3].crc_size = 64;
	package[3].vectoradd_size = 3500;
	package[3].vectorsub_size = 3500;
	package[3].vectormul_size = 3500;
	
	/*************** Package 4 **********/
	// Initalize the size for this package
	package[4].sort_size = 512;
	package[4].crc_size = 3500;
	package[4].vectoradd_size = 64;
	package[4].vectorsub_size = 64;
	package[4].vectormul_size = 64;
	
	/*************** Package 5 **********/
	// Initalize the size for this package
	package[5].sort_size = 2048;
	package[5].crc_size = 1024;
	package[5].vectoradd_size = 4095;
	package[5].vectorsub_size = 4095;
	package[5].vectormul_size = 4095;
	
	/*************** Package 6 **********/
	// Initalize the size for this package
	package[6].sort_size = 3500;
	package[6].crc_size = 2048;
	package[6].vectoradd_size = 2048;
	package[6].vectorsub_size = 2048;
	package[6].vectormul_size = 2048;
	
	/*************** Package 7 **********/
	// Initalize the size for this package
	package[7].sort_size = 2048;
	package[7].crc_size = 4095;
	package[7].vectoradd_size = 1024;
	package[7].vectorsub_size = 1024;
	package[7].vectormul_size = 1024;
	
	/*************** Package 8 **********/
	// Initalize the size for this package
	package[8].sort_size = 3500;
	package[8].crc_size = 64;
	package[8].vectoradd_size = 4095;
	package[8].vectorsub_size = 4095;
	package[8].vectormul_size = 4095;
	
	/*************** Package 9 **********/
	// Initalize the size for this package
	package[9].sort_size = 2048;
	package[9].crc_size = 64;
	package[9].vectoradd_size = 2048;
	package[9].vectorsub_size = 2048;
	package[9].vectormul_size = 2048;
	
	/*************** Package 10 **********/
	// Initalize the size for this package
	package[10].sort_size = 1024;
	package[10].crc_size = 2048;
	package[10].vectoradd_size = 3500;
	package[10].vectorsub_size = 3500;
	package[10].vectormul_size = 3500;
	
	/*************** Package 11 **********/
	// Initalize the size for this package
	package[11].sort_size = 1024;
	package[11].crc_size = 1024;
	package[11].vectoradd_size = 512;
	package[11].vectorsub_size = 512;
	package[11].vectormul_size = 512;
	
	/*************** Package 12 **********/
	// Initalize the size for this package
	package[12].sort_size = 512;
	package[12].crc_size = 2048;
	package[12].vectoradd_size = 3500;
	package[12].vectorsub_size = 3500;
	package[12].vectormul_size = 3500;
	
	/*************** Package 13 **********/
	// Initalize the size for this package
	package[13].sort_size = 1024;
	package[13].crc_size = 512;
	package[13].vectoradd_size = 2048;
	package[13].vectorsub_size = 2048;
	package[13].vectormul_size = 2048;
	
	/*************** Package 14 **********/
	// Initalize the size for this package
	package[14].sort_size = 64;
	package[14].crc_size = 512;
	package[14].vectoradd_size = 64;
	package[14].vectorsub_size = 64;
	package[14].vectormul_size = 64;
	
	/*************** Package 15 **********/
	// Initalize the size for this package
	package[15].sort_size = 4095;
	package[15].crc_size = 3500;
	package[15].vectoradd_size = 2048;
	package[15].vectorsub_size = 2048;
	package[15].vectormul_size = 2048;
	
	/*************** Package 16 **********/
	// Initalize the size for this package
	package[16].sort_size = 64;
	package[16].crc_size = 4095;
	package[16].vectoradd_size = 3500;
	package[16].vectorsub_size = 3500;
	package[16].vectormul_size = 3500;
	
	/*************** Package 17 **********/
	// Initalize the size for this package
	package[17].sort_size = 64;
	package[17].crc_size = 1024;
	package[17].vectoradd_size = 1024;
	package[17].vectorsub_size = 1024;
	package[17].vectormul_size = 1024;
	
	/*************** Package 18 **********/
	// Initalize the size for this package
	package[18].sort_size = 512;
	package[18].crc_size = 3500;
	package[18].vectoradd_size = 2048;
	package[18].vectorsub_size = 2048;
	package[18].vectormul_size = 2048;
	
	/*************** Package 19 **********/
	// Initalize the size for this package
	package[19].sort_size = 2048;
	package[19].crc_size = 2048;
	package[19].vectoradd_size = 4095;
	package[19].vectorsub_size = 4095;
	package[19].vectormul_size = 4095;
	
	/*************** Package 20 **********/
	// Initalize the size for this package
	package[20].sort_size = 2048;
	package[20].crc_size = 512;
	package[20].vectoradd_size = 4095;
	package[20].vectorsub_size = 4095;
	package[20].vectormul_size = 4095;
	
	/*************** Package 21 **********/
	// Initalize the size for this package
	package[21].sort_size = 64;
	package[21].crc_size = 512;
	package[21].vectoradd_size = 1024;
	package[21].vectorsub_size = 1024;
	package[21].vectormul_size = 1024;
	
	/*************** Package 22 **********/
	// Initalize the size for this package
	package[22].sort_size = 1024;
	package[22].crc_size = 512;
	package[22].vectoradd_size = 4095;
	package[22].vectorsub_size = 4095;
	package[22].vectormul_size = 4095;
	
	/*************** Package 23 **********/
	// Initalize the size for this package
	package[23].sort_size = 3500;
	package[23].crc_size = 64;
	package[23].vectoradd_size = 64;
	package[23].vectorsub_size = 64;
	package[23].vectormul_size = 64;
	
	/*************** Package 24 **********/
	// Initalize the size for this package
	package[24].sort_size = 4095;
	package[24].crc_size = 4095;
	package[24].vectoradd_size = 64;
	package[24].vectorsub_size = 64;
	package[24].vectormul_size = 64;
	
	/*************** Package 25 **********/
	// Initalize the size for this package
	package[25].sort_size = 4095;
	package[25].crc_size = 512;
	package[25].vectoradd_size = 4095;
	package[25].vectorsub_size = 4095;
	package[25].vectormul_size = 4095;
	
	/*************** Package 26 **********/
	// Initalize the size for this package
	package[26].sort_size = 2048;
	package[26].crc_size = 512;
	package[26].vectoradd_size = 2048;
	package[26].vectorsub_size = 2048;
	package[26].vectormul_size = 2048;
	
	/*************** Package 27 **********/
	// Initalize the size for this package
	package[27].sort_size = 4095;
	package[27].crc_size = 4095;
	package[27].vectoradd_size = 3500;
	package[27].vectorsub_size = 3500;
	package[27].vectormul_size = 3500;
	
	/*************** Package 28 **********/
	// Initalize the size for this package
	package[28].sort_size = 4095;
	package[28].crc_size = 1024;
	package[28].vectoradd_size = 1024;
	package[28].vectorsub_size = 1024;
	package[28].vectormul_size = 1024;
	
	/*************** Package 29 **********/
	// Initalize the size for this package
	package[29].sort_size = 1024;
	package[29].crc_size = 4095;
	package[29].vectoradd_size = 512;
	package[29].vectorsub_size = 512;
	package[29].vectormul_size = 512;
	
	/*************** Package 30 **********/
	// Initalize the size for this package
	package[30].sort_size = 1024;
	package[30].crc_size = 3500;
	package[30].vectoradd_size = 512;
	package[30].vectorsub_size = 512;
	package[30].vectormul_size = 512;
	
	/*************** Package 31 **********/
	// Initalize the size for this package
	package[31].sort_size = 64;
	package[31].crc_size = 2048;
	package[31].vectoradd_size = 4095;
	package[31].vectorsub_size = 4095;
	package[31].vectormul_size = 4095;
	
	// Allocate memory
	unsigned int e = 0, k = 0;
	for ( k = 0; k < 32; k++) {
	    package[k].sort_data = (void *) malloc(sizeof(int) * package[k].sort_size);
	    package[k].crc_data = (void *) malloc(sizeof(int) * package[k].crc_size);
	    package[k].crc_data_check = (void *) malloc(sizeof(int) * package[k].crc_size);
	    package[k].dataA = (void *) malloc(sizeof(int) * package[k].vectoradd_size);
	    package[k].dataB = (void *) malloc(sizeof(int) * package[k].vectoradd_size);
	    package[k].dataC = (void *) malloc(sizeof(int) * package[k].vectoradd_size);
	    package[k].sort_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].crc_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].vectoradd_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].vectorsub_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].vectormul_valid = (Huint *) malloc(sizeof(Huint));
	
	    // Check to see if we were able to allocate said memory
	    assert(package[k].sort_valid != NULL);
	    assert(package[k].crc_valid != NULL);
	    assert(package[k].vectoradd_valid != NULL);
	    assert(package[k].vectorsub_valid != NULL);
	    assert(package[k].vectormul_valid != NULL);
	
	    assert(package[k].sort_data != NULL);
	    assert(package[k].crc_data != NULL);
	    assert(package[k].dataA != NULL);
	    assert(package[k].dataB != NULL);
	    assert(package[k].dataC != NULL);
	
	    // Initialize all the valid signals to zero
	    *(package[k].sort_valid) = 0;
	    *(package[k].crc_valid) = 0;
	    *(package[k].vectoradd_valid) = 0;
	    *(package[k].vectorsub_valid) = 0;
	    *(package[k].vectormul_valid) = 0;
	
	    // Initialize the CRC data here
	    for (e = 0; e < package[k].crc_size; e++) { 
	        Hint * data = (Hint *) package[k].crc_data;
	        Hint * data_check = (Hint *) package[k].crc_data_check;
	        data[e] = data_check[e] = (rand() % 1000) * 8;
	    }
	    
	    // Initialize Vector Data 
	    for (e = 0; e < package[k].vectoradd_size; e++) {
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
	

	start = hthread_time_get();

	thread_create(&threads[0], &attr[0], worker_sort_crc_vectoradd_thread_FUNC_ID, (void *) &package[0], DYNAMIC_HW, 0);
	thread_create(&threads[1], &attr[1], worker_sort_vectormul_crc_thread_FUNC_ID, (void *) &package[1], DYNAMIC_HW, 0);
	thread_create(&threads[2], &attr[2], worker_vectorsub_sort_thread_FUNC_ID, (void *) &package[2], DYNAMIC_HW, 0);
	thread_create(&threads[3], &attr[3], worker_vectorsub_thread_FUNC_ID, (void *) &package[3], DYNAMIC_HW, 0);
	thread_create(&threads[4], &attr[4], worker_crc_vectorsub_sort_thread_FUNC_ID, (void *) &package[4], DYNAMIC_HW, 0);
	thread_create(&threads[5], &attr[5], worker_vectorsub_thread_FUNC_ID, (void *) &package[5], DYNAMIC_HW, 0);
	thread_create(&threads[6], &attr[6], worker_vectormul_thread_FUNC_ID, (void *) &package[6], DYNAMIC_HW, 0);
	thread_create(&threads[7], &attr[7], worker_vectorsub_sort_crc_thread_FUNC_ID, (void *) &package[7], DYNAMIC_HW, 0);
	thread_create(&threads[8], &attr[8], worker_vectorsub_sort_thread_FUNC_ID, (void *) &package[8], DYNAMIC_HW, 0);
	thread_create(&threads[9], &attr[9], worker_vectoradd_thread_FUNC_ID, (void *) &package[9], DYNAMIC_HW, 0);
	thread_create(&threads[10], &attr[10], worker_crc_thread_FUNC_ID, (void *) &package[10], DYNAMIC_HW, 0);
	thread_create(&threads[11], &attr[11], worker_crc_thread_FUNC_ID, (void *) &package[11], DYNAMIC_HW, 0);
	thread_create(&threads[12], &attr[12], worker_vectorsub_sort_thread_FUNC_ID, (void *) &package[12], DYNAMIC_HW, 0);
	thread_create(&threads[13], &attr[13], worker_sort_thread_FUNC_ID, (void *) &package[13], DYNAMIC_HW, 0);
	thread_create(&threads[14], &attr[14], worker_vectorsub_sort_thread_FUNC_ID, (void *) &package[14], DYNAMIC_HW, 0);
	thread_create(&threads[15], &attr[15], worker_crc_thread_FUNC_ID, (void *) &package[15], DYNAMIC_HW, 0);
	thread_create(&threads[16], &attr[16], worker_sort_crc_vectoradd_thread_FUNC_ID, (void *) &package[16], DYNAMIC_HW, 0);
	thread_create(&threads[17], &attr[17], worker_vectormul_thread_FUNC_ID, (void *) &package[17], DYNAMIC_HW, 0);
	thread_create(&threads[18], &attr[18], worker_sort_thread_FUNC_ID, (void *) &package[18], DYNAMIC_HW, 0);
	thread_create(&threads[19], &attr[19], worker_vectoradd_thread_FUNC_ID, (void *) &package[19], DYNAMIC_HW, 0);
	thread_create(&threads[20], &attr[20], worker_vectormul_thread_FUNC_ID, (void *) &package[20], DYNAMIC_HW, 0);
	thread_create(&threads[21], &attr[21], worker_crc_vectormul_thread_FUNC_ID, (void *) &package[21], DYNAMIC_HW, 0);
	thread_create(&threads[22], &attr[22], worker_vectoradd_thread_FUNC_ID, (void *) &package[22], DYNAMIC_HW, 0);
	thread_create(&threads[23], &attr[23], worker_vectorsub_thread_FUNC_ID, (void *) &package[23], DYNAMIC_HW, 0);
	thread_create(&threads[24], &attr[24], worker_vectormul_thread_FUNC_ID, (void *) &package[24], DYNAMIC_HW, 0);
	thread_create(&threads[25], &attr[25], worker_vectoradd_thread_FUNC_ID, (void *) &package[25], DYNAMIC_HW, 0);
	thread_create(&threads[26], &attr[26], worker_vectorsub_thread_FUNC_ID, (void *) &package[26], DYNAMIC_HW, 0);
	thread_create(&threads[27], &attr[27], worker_vectormul_thread_FUNC_ID, (void *) &package[27], DYNAMIC_HW, 0);
	thread_create(&threads[28], &attr[28], worker_sort_vectorsub_thread_FUNC_ID, (void *) &package[28], DYNAMIC_HW, 0);
	thread_create(&threads[29], &attr[29], worker_vectoradd_thread_FUNC_ID, (void *) &package[29], DYNAMIC_HW, 0);
	thread_create(&threads[30], &attr[30], worker_crc_vectormul_thread_FUNC_ID, (void *) &package[30], DYNAMIC_HW, 0);
	thread_create(&threads[31], &attr[31], worker_vectorsub_sort_crc_thread_FUNC_ID, (void *) &package[31], DYNAMIC_HW, 0);

	while(get_num_free_slaves() < NUM_AVAILABLE_HETERO_CPUS);

	stop = hthread_time_get();

	#if 0
	   for (e = 0; e < 32; e++) {
	      // Determine which slave ran this thread based on address
	      Huint base = attr[e].hardware_addr - HT_HWTI_COMMAND_OFFSET;
	      Huint slave_num = (base & 0x00FF0000) >> 16;
	      printf("Thread %03d -> Slave : %02d\n", e, slave_num);
	   }
	#endif
	
	int number_of_errors = 0;
	for (e = 0; e < 32; e++) {
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
	
	        poly_crc((void *) crc_check, package[e].crc_size);
	
	        for (b = 0; b < package[e].crc_size; b++) {
	            if (crc[b] != crc_check[b]) {
	                printf("\tCRC: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	
	    // Check VectorAdd for this package
	    if (*(package[e].vectoradd_valid)) {
	        unsigned int b = 0;
	        Hint * A = (Hint *) package[e].dataA;
	        Hint * B = (Hint *) package[e].dataB;
	        Hint * C = (Hint *) package[e].dataC;
	        for (b = 0; b < package[e].vectoradd_size; b++) {
	            if (C[b] != A[b] +B[b]) { 
	                printf("\tVectorAdd: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	    
	    // Check VectorSub for this package
	    if (*(package[e].vectorsub_valid)) {
	        unsigned int b = 0;
	        Hint * A = (Hint *) package[e].dataA;
	        Hint * B = (Hint *) package[e].dataB;
	        Hint * C = (Hint *) package[e].dataC;
	        for (b = 0; b < package[e].vectorsub_size; b++) {
	            if (C[b] != A[b] -B[b]) { 
	                printf("\tVectorSub: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	
	    // Check VectorMul for this package
	    if (*(package[e].vectormul_valid)) {
	        unsigned int b = 0;
	        Hint * A = (Hint *) package[e].dataA;
	        Hint * B = (Hint *) package[e].dataB;
	        Hint * C = (Hint *) package[e].dataC;
	        for (b = 0; b < package[e].vectormul_size; b++) {
	            if (C[b] != A[b] *B[b]) { 
	                printf("\tVectorMul: Package %u failed\n", e);
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
