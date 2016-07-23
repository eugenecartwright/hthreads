/*

   Application-Specific Thread Table

*/


// ---------------------------------------------------------------- //
//                     Preprocessor Directives                      //
// ---------------------------------------------------------------- //

// Used for thread_create function
// -- SOFTWARE_THREAD - to indicate create software thread
// -- DYNAMIC_HW - to indicate create hardware threads dynamically
// -- STATIC_HWXX  - to indicate create hardware threads on specific slave number
#define SOFTWARE_THREAD 0
#define DYNAMIC_HW      1
#define STATIC_HW0      2
#define STATIC_HW1      3
#define STATIC_HW2      4
#define STATIC_HW3      5
#define STATIC_HW4      6
#define STATIC_HW5      7
#define STATIC_HW6      8
#define STATIC_HW7      9
#define STATIC_HW8      10
#define STATIC_HW9      11
#define STATIC_HW10     12
#define STATIC_HW11     13
#define STATIC_HW12     14
#define STATIC_HW13     15
#define STATIC_HW14     16
#define STATIC_HW15     17
#define STATIC_HW16     18
#define STATIC_HW17     19
#define STATIC_HW18     20
#define STATIC_HW19     21
#define STATIC_HW20     22
#define STATIC_HW21     23
#define STATIC_HW22     24
#define STATIC_HW23     25
#define STATIC_HW24     26
#define STATIC_HW25     27
#define STATIC_HW26     28
#define STATIC_HW27     29
#define STATIC_HW28     30
#define STATIC_HW29     31
#define STATIC_HW30     32
#define STATIC_HW31     33
#define STATIC_HW32     34

// TODO: Remove above in favour of enums below
#define STATIC_HW(i) STATIC_HW ## i
typedef enum {
   SOFTWARE_THREAD,
   DYNAMIC_HW,
   STATIC_HW
} dunno_name_yet;

#define STATIC_HW_OFFSET (-2)


// Macro used to enable/disable dynamic dispatch DEBUG output
// * Uncomment the following line to see debug info
//#define DEBUG_DISPATCH

// Table Init (Magic Number)
#define TABLE_INIT      (0xDEADBEEF)
#define MAGIC_NUMBER    TABLE_INIT  

#define NOT_FOUND                   (-1)
#define ENQUEUE_THREAD              (-2)
#define FREE_SLAVES_THRESHOLD       (0.30f * NUM_AVAILABLE_HETERO_CPUS)

// Function Prototypes
void load_my_table(void);
Hbool check_valid_slave_num (Huint slave_num);
void init_host_tables();
Hint thread_create(hthread_t * tid, hthread_attr_t * attr, Huint func_id,void * arg, Huint type, Huint dma_length);
Hint thread_join(hthread_t th, void **retval, hthread_time_t *exec_time);
void init_tuning_table();

// OS overhead instrumentation data structure
volatile hthread_time_t create_overhead PRIVATE_MEMORY = 0;
volatile hthread_time_t join_overhead PRIVATE_MEMORY = 0;
volatile hthread_time_t randomize_overhead PRIVATE_MEMORY = 0;
volatile hthread_time_t START PRIVATE_MEMORY = 0;
volatile hthread_time_t STOP PRIVATE_MEMORY = 0;
volatile hthread_time_t DIFF PRIVATE_MEMORY = 0;
volatile hthread_time_t START_RANDOM PRIVATE_MEMORY = 0;
volatile hthread_time_t STOP_RANDOM PRIVATE_MEMORY = 0;
volatile hthread_time_t DIFF_RANDOM PRIVATE_MEMORY = 0;

// Global variables used to provide statistics of
// finding the best match when doing thread_create.
// find_best_match() uses these variables.
volatile Huint _index PRIVATE_MEMORY;
volatile Hint best_match PRIVATE_MEMORY;
volatile Hint better_match PRIVATE_MEMORY;
volatile Hint possible_match PRIVATE_MEMORY;
volatile Huint slave PRIVATE_MEMORY;

volatile Huint total_calls PRIVATE_MEMORY = 0;
volatile Huint perfect_match_counter PRIVATE_MEMORY = 0;
volatile Huint best_match_counter PRIVATE_MEMORY = 0;
volatile Huint better_match_counter PRIVATE_MEMORY = 0;
volatile Huint possible_match_counter PRIVATE_MEMORY = 0;

// Create Queue - For testing purposes
#define THREAD_QUEUE_MAX 100
volatile Qnode_t ThreadQueue[THREAD_QUEUE_MAX] PRIVATE_MEMORY;
volatile Qnode_t * head PRIVATE_MEMORY;
volatile Qnode_t * tail PRIVATE_MEMORY;
volatile Huint thread_head_index PRIVATE_MEMORY;
volatile Huint thread_tail_index PRIVATE_MEMORY;
volatile Huint thread_entries PRIVATE_MEMORY;

// This is the tuning table used to keep track 
// of profiling data for slave execution.
#ifndef TUNING_TABLE_H
tuning_table_t tuning_table[NUM_AVAILABLE_HETERO_CPUS][NUM_ACCELERATORS][(BRAM_SIZE/BRAM_GRANULARITY_SIZE)] GLOBAL_MEMORY;
#endif

#ifdef TUNING_TABLE_H
#ifdef PR
void init_tuning_table(){

   Huint i = 0; 
   unsigned int j = 0;
   Huint data_size;
#ifdef FORCE_POLYMORPHIC_HW   // Slaves will prefer HW for poly functions
   printf("Forcing POLYMORPHIC_HW\n");
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      for (j = 0; j < NUM_ACCELERATORS; j++) {
         for (data_size = 0; data_size < BRAM_GRANULARITY_SIZE; data_size++) {
            tuning_table[i][j][data_size].hw_time = 0.0f;
            tuning_table[i][j][data_size].sw_time = 100.0f + PR_OVERHEAD + HW_SW_THRESHOLD;
         }
      }
   }
   printf("Done\n");
#elif defined (FORCE_POLYMORPHIC_SW) // Slaves will prefer SW for poly functions
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      for (j = 0; j < NUM_ACCELERATORS; j++) {
         for (data_size = 0; data_size < BRAM_GRANULARITY_SIZE; data_size++) {
            tuning_table[i][j][data_size].hw_time = 100.0f + HW_SW_THRESHOLD;
            tuning_table[i][j][data_size].sw_time = 0.0f;
         }
      }
   }
#else // Exhaustively test HW vs SW, and store results for the given data size
   hthread_time_t exec_time[NUM_AVAILABLE_HETERO_CPUS];
   hthread_t child[NUM_AVAILABLE_HETERO_CPUS];
   hthread_attr_t attr[NUM_AVAILABLE_HETERO_CPUS];
   void * ret[NUM_AVAILABLE_HETERO_CPUS];
   Huint pr_flag[NUM_AVAILABLE_HETERO_CPUS];
   Huint current_acc[NUM_AVAILABLE_HETERO_CPUS];

   // ------------------------------------ BUBBLESORT --------------------------------- //
#ifdef DEBUG_DISPATCH
   printf("Initializing BUBBLESORT values in Tuning table...");
#endif
   for (data_size = BRAM_GRANULARITY_SIZE-1; data_size < _LIST_LENGTH; data_size+=BRAM_GRANULARITY_SIZE) {
      _data package[NUM_AVAILABLE_HETERO_CPUS];
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         package[i].dataA = (Hint *) malloc(sizeof(Hint) * data_size);
         assert(package[i].dataA != NULL);
         package[i].size = data_size;

         for (j = 0; j < data_size; j++) {
            package[i].dataA[j] = rand() % 1000;
         }
         // Set up attributes for a hardware thread
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);

         // Temporarily mark this slave as not having PR and no accelerator attached
         pr_flag[i] = _hwti_get_PR_flag( (Huint) hwti_array[i]);
         current_acc[i] = _hwti_get_last_accelerator( (Huint) hwti_array[i]);

         _hwti_set_PR_flag((Huint) hwti_array[i], 0);
         _hwti_set_last_accelerator((Huint) hwti_array[i], NO_ACC);
        
         // Creating thread
         if (thread_create (&child[i], &attr[i],sort_thread_FUNC_ID, (void *)(&package[i]),
                       STATIC_HW0+i,
                       0)) 
         {
            printf("hthread_create error on HW THREAD\n");
            while(1);
         }
      }
         
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if (thread_join(child[i], &ret[i], &exec_time[i])){
            printf("Join error!\n");
            while(1);
         }

         if (ret[i] != SUCCESS)
            printf("Thread %02d Failed:  %d, Slave %d\n", (unsigned int) child[i], (unsigned int) ret, i);
      }
        
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Check results
         #ifdef VERIFY
         for (j = 0; j < data_size-1; j++) {
            if (package[i].dataA[j] > package[i].dataA[j+1]) {
               printf("[data Size = %d] Sort failed on Slave %d!\n", data_size, i);
               break;
            }
         }
         #endif
      }

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Write software execution in tuning table
         tuning_table[i][BUBBLESORT][(data_size/BRAM_GRANULARITY_SIZE)].sw_time = hthread_time_usec(exec_time[i]);

         // Restore PR flag and Last accelerator
         _hwti_set_PR_flag((Huint) hwti_array[i], pr_flag[i]);
         _hwti_set_last_accelerator((Huint) hwti_array[i], current_acc[i]);

         if (perform_PR(i,BUBBLESORT)) {
            printf("ERROR (init_tuning_table): Unable to PR BUBBLE_SORT\n");
            while(1);
         }
         // Update Slave table
         slave_table[i].acc = BUBBLESORT;
         
         for (j = 0; j < data_size; j++) {
            package[i].dataA[j] = rand() % 1000;
         }

         // Creating thread
         if (thread_create (&child[i], &attr[i],sort_thread_FUNC_ID, (void *)(&package[i]),
                       STATIC_HW0+i,
                       0)) 
         {
            printf("hthread_create error on HW THREAD\n");
            while(1);
         }
      }

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if (thread_join(child[i], &ret[i], &exec_time[i])){
            printf("Join error!\n");
            while(1);
         }

         if (ret[i] != SUCCESS)
            printf("Thread %02d Failed:  %d, Slave %d\n", (unsigned int) child[i], (unsigned int) ret[i], i);
      }

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Check results
         #ifdef VERIFY
         for (j = 0; j < data_size-1; j++) {
            if (package[i].dataA[j] > package[i].dataA[j+1]) {
               printf("[data Size = %d] Sort failed on slave %d\n", data_size, i);
               break;
            }
         }
         #endif
         
         // Write hardware execution in tuning table
         tuning_table[i][BUBBLESORT][(data_size/BRAM_GRANULARITY_SIZE)].hw_time = hthread_time_usec(exec_time[i]);
         
         free(package[i].dataA);
      }
   }
#ifdef DEBUG_DISPATCH
   printf("Done\n");
   printf("Initializing CRC values in Tuning table...");
#endif

   // --------------------------------------- CRC ------------------------------------- //
   for (data_size = BRAM_GRANULARITY_SIZE-1; data_size < _ARRAY_SIZE; data_size+=BRAM_GRANULARITY_SIZE) {
      _data package[NUM_AVAILABLE_HETERO_CPUS];
      Hint * check[NUM_AVAILABLE_HETERO_CPUS];
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      
         package[i].dataA = (Hint *) malloc(sizeof(Hint) * data_size);
         assert(package[i].dataA != NULL);
         package[i].size = data_size;
         check[i] = (Hint *) malloc(data_size * sizeof(Hint));
         assert(check[i] != NULL);

         // Initializing the data
         Hint * ptr = package[i].dataA;
         for(_index = 0; _index < data_size; _index++) {
            *ptr = (rand() % 1000)*8;	
            *(check[i]+_index) = *ptr;
            ptr++;
         }
 
         #ifdef VERIFY
         // Generating the CRC of that data
         if (poly_crc(check[i], data_size)) {
            printf("Host failed to generate CRC check of data\n");
            while(1);
         }
         #endif

         // Set up attributes for a hardware thread
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);

         // Temporarily mark this slave as not having PR and no accelerator attached
         pr_flag[i] = _hwti_get_PR_flag( (Huint) hwti_array[i]);
         current_acc[i] = _hwti_get_last_accelerator( (Huint) hwti_array[i]);

         _hwti_set_PR_flag((Huint) hwti_array[i], 0);
         _hwti_set_last_accelerator((Huint) hwti_array[i], NO_ACC);
        
         // Creating thread
         if (thread_create (&child[i], &attr[i],crc_thread_FUNC_ID, (void *)(&package[i]),
                       STATIC_HW0+i,
                       0)) 
         {
            printf("hthread_create error on HW THREAD\n");
            while(1);
         }
      }
         
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if (thread_join(child[i], &ret[i], &exec_time[i])){
            printf("Join error!\n");
            while(1);
         }

         if (ret[i] != SUCCESS)
            printf("Thread %02d Failed:  %d, Slave %d\n", (unsigned int) child[i], (unsigned int) ret, i);
      }
        
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         #ifdef VERIFY
         // For CRC Results
         for ( j = 0; j < data_size; j++) {
            if (*(package[i].dataA+j) != *(check[i]+j) )  {
               printf("[Data size =  %d] CRC failed!\n", data_size);
               j = data_size;
            }
         }
         #endif 
      }

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Write software execution in tuning table
         tuning_table[i][CRC][(data_size/BRAM_GRANULARITY_SIZE)].sw_time = hthread_time_usec(exec_time[i]);

         // Restore PR flag and Last accelerator
         _hwti_set_PR_flag((Huint) hwti_array[i], pr_flag[i]);
         _hwti_set_last_accelerator((Huint) hwti_array[i], current_acc[i]);

         if (perform_PR(i,CRC)) {
            printf("ERROR (init_tuning_table): Unable to PR CRC\n");
            while(1);
         }
         // Update Slave table
         slave_table[i].acc = CRC;
         
         // Initializing the data
         Hint * ptr = package[i].dataA;
         for(_index = 0; _index < data_size; _index++) {
            *ptr = (rand() % 1000)*8;	
            *(check[i]+_index) = *ptr;
            ptr++;
         }
         
         #ifdef VERIFY
         // Generating the CRC of that data
         if (poly_crc(check[i], data_size)) {
            printf("Host failed to generate CRC check of data\n");
            while(1);
         }
         #endif

         // Creating thread
         if (thread_create (&child[i], &attr[i],crc_thread_FUNC_ID, (void *)(&package[i]),
                       STATIC_HW0+i,
                       0)) 
         {
            printf("hthread_create error on HW THREAD\n");
            while(1);
         }
      }

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if (thread_join(child[i], &ret[i], &exec_time[i])){
            printf("Join error!\n");
            while(1);
         }

         if (ret[i] != SUCCESS)
            printf("Thread %02d Failed:  %d, Slave %d\n", (unsigned int) child[i], (unsigned int) ret[i], i);
      }
      
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         #ifdef VERIFY
         // For CRC Results
         for ( j = 0; j < data_size; j++) {
            if (*(package[i].dataA+j) != *(check[i]+j) )  {
               printf("[Data size =  %d] CRC failed!\n", data_size);
               j = data_size;
            }
         }
         #endif 

         
         // Write hardware execution in tuning table
         tuning_table[i][CRC][(data_size/BRAM_GRANULARITY_SIZE)].hw_time = hthread_time_usec(exec_time[i]);
         
         free(package[i].dataA);
         free(check[i]);
      }
   }

#ifdef DEBUG_DISPATCH
   printf("Done\n");
   printf("Initializing VectorAdd/VectorSub values in Tuning table...");
#endif
   
   // --------------------------------------- VECTORADD/SUB ------------------------------------- //
   for (data_size = BRAM_GRANULARITY_SIZE-1; data_size < _ARRAY_SIZE; data_size+=BRAM_GRANULARITY_SIZE) {
      _data package[NUM_AVAILABLE_HETERO_CPUS];
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         
         package[i].dataA = (Hint*) malloc(data_size * sizeof(Hint)); 
         package[i].dataB = (Hint*) malloc(data_size * sizeof(Hint)); 	
         package[i].dataC = (Hint*) malloc(data_size * sizeof(Hint)); 	
         assert(package[i].dataA != NULL);
         assert(package[i].dataB != NULL);
         assert(package[i].dataC != NULL);
         package[i].size = data_size;

         // Initializing the data
         for (j=0 ; j < data_size; j++) {
            package[i].dataA[j] = (Hint) (rand() % 1000);
            package[i].dataB[j] = (Hint) (rand() % 1000);
            package[i].dataC[j] = 0;
         }
      
         // Set up attributes for a hardware thread
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);

         // Temporarily mark this slave as not having PR and no accelerator attached
         pr_flag[i] = _hwti_get_PR_flag( (Huint) hwti_array[i]);
         current_acc[i] = _hwti_get_last_accelerator( (Huint) hwti_array[i]);

         _hwti_set_PR_flag((Huint) hwti_array[i], 0);
         _hwti_set_last_accelerator((Huint) hwti_array[i], NO_ACC);
        
         // Creating thread
         if (thread_create (&child[i], &attr[i],vector_sub_thread_FUNC_ID, (void *)(&package[i]),
                       STATIC_HW0+i,
                       0)) 
         {
            printf("hthread_create error on HW THREAD\n");
            while(1);
         }
      }
         
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if (thread_join(child[i], &ret[i], &exec_time[i])){
            printf("Join error!\n");
            while(1);
         }

         if (ret[i] != SUCCESS)
            printf("Thread %02d Failed:  0x%08x, Slave %d\n", (unsigned int) child[i], (unsigned int) ret, i);
      }
        
      #ifdef VERIFY
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // For VectorSub Results
         for (j=0 ; j < data_size; j++) {
            if ( (package[i].dataC[j]) != (package[i].dataA[j] - package[i].dataB[j]))  {
               printf("%d: [Data size =  %d] Vector Sub failed!\n", i,data_size);
               break;
            }
         }
      }
      #endif 

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Write software execution in tuning table
         tuning_table[i][VECTORSUB][(data_size/BRAM_GRANULARITY_SIZE)].sw_time = hthread_time_usec(exec_time[i]);

         // Restore PR flag and Last accelerator
         _hwti_set_PR_flag((Huint) hwti_array[i], pr_flag[i]);
         _hwti_set_last_accelerator((Huint) hwti_array[i], current_acc[i]);

         if (perform_PR(i,VECTORSUB)) {
            printf("ERROR (init_tuning_table): Unable to PR VectorSub\n");
            while(1);
         }
         // Update Slave table
         slave_table[i].acc = VECTORSUB;
         
         // Initializing the data
         for (j=0 ; j < data_size; j++) {
            package[i].dataA[j] = (Hint) (rand() % 1000);
            package[i].dataB[j] = (Hint) (rand() % 1000);
            package[i].dataC[j] = 0;
         }
         
         // Creating thread
         if (thread_create (&child[i], &attr[i],vector_sub_thread_FUNC_ID, (void *)(&package[i]),
                       STATIC_HW0+i,
                       0)) 
         {
            printf("hthread_create error on HW THREAD\n");
            while(1);
         }
      }

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if (thread_join(child[i], &ret[i], &exec_time[i])){
            printf("Join error!\n");
            while(1);
         }

         if (ret[i] != SUCCESS)
            printf("Thread %02d Failed:  %d, Slave %d\n", (unsigned int) child[i], (unsigned int) ret[i], i);
      }

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         #ifdef VERIFY
         // For VectorSub Results
         for (j=0 ; j < data_size; j++) {
            if ( (package[i].dataC[j]) != (package[i].dataA[j] - package[i].dataB[j]))  {
               printf("[Data size =  %d] Vector Sub failed!\n", data_size);
               break;
            }
         }
         #endif 
         
         // Write hardware execution in tuning table
         tuning_table[i][VECTORSUB][(data_size/BRAM_GRANULARITY_SIZE)].hw_time = hthread_time_usec(exec_time[i]);
         
         free(package[i].dataA);
         free(package[i].dataB);
         free(package[i].dataC);
      }
   }

#ifdef DEBUG_DISPATCH
   printf("Done\n");
   printf("Initializing VectorMul/VectorDiv values in Tuning table...");
#endif
   
   // --------------------------------------- VECTORMUL/DIV ------------------------------------- //
   for (data_size = BRAM_GRANULARITY_SIZE-1; data_size < _ARRAY_SIZE; data_size+=BRAM_GRANULARITY_SIZE) {
      _data package[NUM_AVAILABLE_HETERO_CPUS];
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         
         package[i].dataA = (Hint*) malloc(data_size * sizeof(Hint)); 
         package[i].dataB = (Hint*) malloc(data_size * sizeof(Hint)); 	
         package[i].dataC = (Hint*) malloc(data_size * sizeof(Hint)); 	
         assert(package[i].dataA != NULL);
         assert(package[i].dataB != NULL);
         assert(package[i].dataC != NULL);
         package[i].size = data_size;

         // Initializing the data
         for (j=0 ; j < data_size; j++) {
            package[i].dataA[j] = (Hint) (rand() % 1000);
            package[i].dataB[j] = (Hint) (rand() % 1000);
            package[i].dataC[j] = 0;
         }
      
         // Set up attributes for a hardware thread
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);

         // Temporarily mark this slave as not having PR and no accelerator attached
         pr_flag[i] = _hwti_get_PR_flag( (Huint) hwti_array[i]);
         current_acc[i] = _hwti_get_last_accelerator( (Huint) hwti_array[i]);

         _hwti_set_PR_flag((Huint) hwti_array[i], 0);
         _hwti_set_last_accelerator((Huint) hwti_array[i], NO_ACC);
        
         // Creating thread
         if (thread_create (&child[i], &attr[i],vector_multiply_thread_FUNC_ID, (void *)(&package[i]),
                       STATIC_HW0+i,
                       0)) 
         {
            printf("hthread_create error on HW THREAD\n");
            while(1);
         }
      }
         
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if (thread_join(child[i], &ret[i], &exec_time[i])){
            printf("Join error!\n");
            while(1);
         }

         if (ret[i] != SUCCESS)
            printf("Thread %02d Failed:  %d, Slave %d\n", (unsigned int) child[i], (unsigned int) ret, i);
      }
        
      #ifdef VERIFY
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // For VectorMul Results
         for (j=0 ; j < data_size; j++) {
            if ( (package[i].dataC[j]) != (package[i].dataA[j] * package[i].dataB[j]))  {
               printf("Vector multiply incorrect!\n");
               break;
            }
         }
      }
      #endif 

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Write software execution in tuning table
         tuning_table[i][VECTORMUL][(data_size/BRAM_GRANULARITY_SIZE)].sw_time = hthread_time_usec(exec_time[i]);

         // Restore PR flag and Last accelerator
         _hwti_set_PR_flag((Huint) hwti_array[i], pr_flag[i]);
         _hwti_set_last_accelerator((Huint) hwti_array[i], current_acc[i]);

         if (perform_PR(i,VECTORMUL)) {
            printf("ERROR (init_tuning_table): Unable to PR VectorSub\n");
            while(1);
         }
         // Update Slave table
         slave_table[i].acc = VECTORMUL;
         
         // Initializing the data
         for (j=0 ; j < data_size; j++) {
            package[i].dataA[j] = (Hint) (rand() % 1000);
            package[i].dataB[j] = (Hint) (rand() % 1000);
            package[i].dataC[j] = 0;
         }
         
         // Creating thread
         if (thread_create (&child[i], &attr[i],vector_multiply_thread_FUNC_ID, (void *)(&package[i]),
                       STATIC_HW0+i,
                       0)) 
         {
            printf("hthread_create error on HW THREAD\n");
            while(1);
         }
      }

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         // Join on child thread
         if (thread_join(child[i], &ret[i], &exec_time[i])){
            printf("Join error!\n");
            while(1);
         }

         if (ret[i] != SUCCESS)
            printf("Thread %02d Failed:  %d, Slave %d\n", (unsigned int) child[i], (unsigned int) ret[i], i);
      }

      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
         #ifdef VERIFY
         // For VectorMul Results
         for (j=0 ; j < data_size; j++) {
            if ( (package[i].dataC[j]) != (package[i].dataA[j] * package[i].dataB[j]))  {
               printf("[Data size =  %d] Vector Mul failed!\n", data_size);
               break;
            }
         }
         #endif 
         
         // Write hardware execution in tuning table
         tuning_table[i][VECTORMUL][(data_size/BRAM_GRANULARITY_SIZE)].hw_time = hthread_time_usec(exec_time[i]);
         
         free(package[i].dataA);
         free(package[i].dataB);
         free(package[i].dataC);
      }
   }

#ifdef DEBUG_DISPATCH
   printf("Done\n");
   printf("Initializing Matrix Multiply values in Tuning table...");
#endif


#if BRAM_GRANULARITY_SIZE != 64
#error "ERROR: Matrix Multiplication tuning table entries will be incorrect as BRAM_GRANULARITY_SIZE != 64 (largest matrix size)!"
#endif
   
   // --------------------------------------- MATRIX MULTIPLY ------------------------------------- //
   // TODO: data_size and entry insertions are generic to BRAM_GRANULARITY_SIZE
   _data package;
   for (data_size = 2; data_size < _MATRIX_SIZE; data_size++) {
      package.dataA = (Hint*) malloc(data_size * data_size *sizeof(Hint)); 
      package.dataB = (Hint*) malloc(data_size * data_size *sizeof(Hint)); 
      package.dataC = (Hint*) malloc(data_size * data_size *sizeof(Hint)); 
      assert(package.dataA != NULL);
      assert(package.dataB != NULL);
      assert(package.dataC != NULL);
      package.size = data_size;
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {

         // Initializing the data
         Huint l,k;   
         for (k = 0; k < data_size; k++) {
            for (l = 0; l < data_size; l++) {
               package.dataA[k*data_size + l] = k;
               package.dataB[k*data_size + l] = l;
               package.dataC[k*data_size + l] = 0;
            }
         }
      
         // Set up attributes for a hardware thread
         hthread_attr_init(&attr[i]);
         hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);

         // Temporarily mark this slave as not having PR and no accelerator attached
         pr_flag[i] = _hwti_get_PR_flag( (Huint) hwti_array[i]);
         current_acc[i] = _hwti_get_last_accelerator( (Huint) hwti_array[i]);

         _hwti_set_PR_flag((Huint) hwti_array[i], 0);
         _hwti_set_last_accelerator((Huint) hwti_array[i], NO_ACC);
        
         // Creating thread
         if (thread_create (&child[i], &attr[i],matrix_multiply_thread_FUNC_ID, (void *)(&package),
                       STATIC_HW0+i,
                       0)) 
         {
            printf("hthread_create error on HW THREAD\n");
            while(1);
         }
         
         // Join on child thread
         if (thread_join(child[i], &ret[i], &exec_time[i])){
            printf("Join error!\n");
            while(1);
         }

         if (ret[i] != SUCCESS)
            printf("Thread %02d Failed:  %d, Slave %d\n", (unsigned int) child[i], (unsigned int) ret, i);
        
         #ifdef VERIFY
         // Check results
         Hint * temp = (Hint *) malloc(data_size * data_size * sizeof(Hint));
         assert (temp != NULL);
         poly_matrix_mul(package.dataA, package.dataB, temp, data_size, data_size, data_size);
         int r, c;
         for (r=0 ; r < data_size; r++) {
            for (c=0 ; c < data_size; c++) {
               if ( temp[r*data_size + c] != package.dataC[r*data_size + c])  {
                  printf("[Slave %d] Matrix Mul failed!\n", i);
                  r = c = data_size;
               }
            }
         }
         free(temp);
         #endif 

         // Write software execution in tuning table
         tuning_table[i][MATRIXMUL][data_size].sw_time = hthread_time_usec(exec_time[i]);


         // Restore PR flag and Last accelerator
         _hwti_set_PR_flag((Huint) hwti_array[i], pr_flag[i]);
         _hwti_set_last_accelerator((Huint) hwti_array[i], current_acc[i]);

         if (perform_PR(i,MATRIXMUL)) {
            printf("ERROR (init_tuning_table): Unable to PR VectorSub\n");
            while(1);
         }
         // Update Slave table
         slave_table[i].acc = MATRIXMUL;
         
         // Initializing the data
         for (k = 0; k < data_size; k++) {
            for (l = 0; l < data_size; l++) {
               package.dataA[k*data_size + l] = k;
               package.dataB[k*data_size + l] = l;
               package.dataC[k*data_size + l] = 0;
            }
         }
         
         // Creating thread
         if (thread_create (&child[i], &attr[i],matrix_multiply_thread_FUNC_ID, (void *)(&package),
                       STATIC_HW0+i,
                       0)) 
         {
            printf("hthread_create error on HW THREAD\n");
            while(1);
         }

         // Join on child thread
         if (thread_join(child[i], &ret[i], &exec_time[i])){
            printf("Join error!\n");
            while(1);
         }

         if (ret[i] != SUCCESS)
            printf("Thread %02d Failed:  %d, Slave %d\n", (unsigned int) child[i], (unsigned int) ret[i], i);

         #ifdef VERIFY
         temp = (Hint *) malloc(data_size * data_size * sizeof(Hint));
         assert (temp != NULL);
         // Check results
         poly_matrix_mul(package.dataA, package.dataB, temp, data_size, data_size, data_size);
         for (r=0 ; r < data_size; r++) {
            for (c=0 ; c < data_size; c++) {
               if ( temp[r*data_size + c] != package.dataC[r*data_size + c])  {
                  printf("[Slave %d] Matrix Mul failed!\n", i);
                  r = c = data_size;
               }
            }
         }
         free(temp);
         #endif 
         
         // Write hardware execution in tuning table
         tuning_table[i][MATRIXMUL][data_size].hw_time = hthread_time_usec(exec_time[i]);
      }
      free(package.dataA);
      free(package.dataB);
      free(package.dataC);
   }
#ifdef DEBUG_DISPATCH
   printf("Done\n");
#endif
#endif
   join_overhead = 0;
   randomize_overhead = 0;
   create_overhead = 0;
   //   ----> For printing out tuning table and store in bitstream.h
   int k;
   // Print out tuning table
   printf("tuning_table_t tuning_table[NUM_AVAILABLE_HETERO_CPUS][NUM_ACCELERATORS][(BRAM_SIZE/BRAM_GRANULARITY_SIZE)] = {\n");
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      printf("{");
      for (j = 0; j < NUM_ACCELERATORS; j++) {
         printf("{");
         for (k = 0; k < BRAM_GRANULARITY_SIZE-1; k++) {
            printf("{%f,%f},", tuning_table[i][j][k].hw_time, tuning_table[i][j][k].sw_time);
         }
         printf("{%f,%f}", tuning_table[i][j][k].hw_time, tuning_table[i][j][k].sw_time);
         if (j != NUM_ACCELERATORS-1)
            printf("},");
         else
            printf("}");

      }
      if (i != NUM_AVAILABLE_HETERO_CPUS-1)
         printf("},\n");
      else
         printf("}\n");
   }
   printf("};");
}
#else
#warning "WARNING: Trying to init tuning table on a non-PR system or you are including tuning_table.h!"
#endif
#endif

// Initialize all of the PR data
void init_slaves() {
    
   // Create accelerate profiles - containers that hold
   // pointers to each accelerator specific for each slave.
   unsigned int i;
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) { 
      // Write pointer for last_used_accelerator so slave can update the table
      _hwti_set_last_accelerator_ptr( (Huint) hwti_array[i], (Huint) &(slave_table[i].acc));
      
      // Write which accelerator the slave has in last_used/currently loaded.
      _hwti_set_last_accelerator((Huint) hwti_array[i], slave_table[i].acc);
             
      // Write pointer to tuning_table
      _hwti_set_tuning_table_ptr((Huint) hwti_array[i], (Huint) tuning_table);

      #ifdef PR
      // If PR is defined, write to slave that they have PR capability
      _hwti_set_PR_flag((Huint) hwti_array[i], PR_FLAG);
      slave_table[i].pr = PR_FLAG;
      #else
      _hwti_set_PR_flag((Huint) hwti_array[i], 0);
      slave_table[i].pr = 0;
      #endif
   }

   #ifdef PR
   // Set up PR controller
   pr_config_mb();
   
   // Now run self-test on PR regions.
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) { 
      unsigned int accelerator_type = 0U;
      for (accelerator_type = 0U; accelerator_type < NUM_ACCELERATORS; accelerator_type++) {
         if (perform_PR(i, accelerator_type)) {
            printf("Failed to perform PR as part of the PR selftest\n");
            printf("\tAccelerator ID = %d, slave %d\n", accelerator_type, i);
            while(1);
         }
         // Update slave table
         slave_table[i].acc = accelerator_type;
      }
   }
   #endif
}

// ---------------------------------------------------------------- //
//                      Debugging Functions                         //
// ---------------------------------------------------------------- //

// Check if user specified a correct address. Returns true if so.
Hbool check_valid_slave_num (Huint slave_num) {
    if ((slave_num > NUM_AVAILABLE_HETERO_CPUS) || (slave_num < 0)) {
        #ifdef DEBUG_DISPATCH
        printf("ERROR: Invalid slave processor index specified = %d\n", slave_num);
        #endif

        return 0;
    } else
        return 1;
}


// Application-specific table load function
thread_table_t global_thread_table;

// Global Variable to indicate if tables were initialized.
unsigned int table_initialized_flag PRIVATE_MEMORY = 0;


// Initialize all table entries to magic number
// Author: Jason Agron
void init_thread_table (thread_table_t * tb)
{
    Huint e,t;
    
    for (e = 0; e < MAX_ENTRIES_PER_TABLE; e++)
    {
        tb->table[e].id = (Huint) TABLE_INIT;
        for (t = 0; t < MAX_HANDLES_PER_ENTRY; t++)
        {
            tb->table[e].threads[t] = (void*)TABLE_INIT;
            tb->table[e].binary[t] = (void*)TABLE_INIT;
            tb->table[e].binary_size[t] = 0;
        }
    }
}

// ---------------------------------------------------------------- //
//                  Thread Table Functions                          //
// ---------------------------------------------------------------- //

// Insert an entry into the table
// Author: Jason Agron
// Now can include ELF image address and its size into table
void insert_table_entry (
        thread_table_t * t, 
        Huint func_id, 
        Huint type, 
        void * thread_handle, 
        void * binary, 
        Huint intermediate_size)
{
    // Get a pointer to the current entry
    thread_entry_t * e = &(t->table[func_id]);

    // Add in entry info
    // * Always write function ID (overwrite doesn't matter)
    // * Add in handle to appropriate index
    e->id = func_id;
    e->threads[type] = thread_handle;
    e->binary[type] = binary;
    e->binary_size[type] = intermediate_size;
}

// Lookup the thread handle/ptr for a given func_id and type/processor architecture
void * lookup_thread (thread_table_t * t, Huint func_id, Huint type)
{
    return t->table[func_id].threads[type];
}

// Lookup the binary for a given func_id and type/processor architecture
void * lookup_binary (thread_table_t * t, Huint func_id, Huint type)
{
    return t->table[func_id].binary[type];
}

// Lookup the binary_size for a given func_id
Huint lookup_size (thread_table_t * t, Huint func_id, Huint type)
{
    return t->table[func_id].binary_size[type];
}

// Lookup the processor type of a given handle
Huint lookup_type (thread_table_t * tb, void * handle)
{
    int e,t;
    int found = 0;
    int found_type = TABLE_INIT;

    for (e = 0; e < MAX_ENTRIES_PER_TABLE; e++)
    {
        for (t = 0; t < MAX_HANDLES_PER_ENTRY; t++)
        {
            if (handle == tb->table[e].threads[t])
            {
                found = 1;
                found_type = t;
            }
        }
    }
    return found_type;
}


// --------------------------------------------------------- //
//                      V-HWTI accessors                     //
//                                                           //
// Description: These functions access V-HWTI entries. We    //
// avoid any context switching here by calling the low level //
// function directly. Therefore, I did not see any need for  //
// bloating the OS with additional API calls since these act //
// as such (these are simply wrappers).                      // 
// --------------------------------------------------------- //

// This function gets the last function that 
// was ran on this particular slave number
Huint get_last_function(Huint slave_num) {

    if (!check_valid_slave_num(slave_num)){
        #ifdef DEBUG_DISPATCH
            printf("ERROR (get_last_function)\n");
        #endif
        while(1);
    }

    return _hwti_get_last_function((Huint)hwti_array[slave_num]);
}

// This function gets the last accelerator that
// was PR'ed on this particular slave
Huint get_last_accelerator(Huint slave_num) {

    if (!check_valid_slave_num(slave_num)){
        #ifdef DEBUG_DISPATCH
            printf("ERROR (get_last_accelerator)!\n");
        #endif
        while(1);
    }

    return _hwti_get_last_accelerator((Huint)hwti_array[slave_num]);
}

// This function gets the first accelerator that
// was PR'ed on this particular slave
Huint get_first_accelerator(Huint slave_num) {

    if (!check_valid_slave_num(slave_num)){
        #ifdef DEBUG_DISPATCH
            printf("ERROR (get_first_accelerator)!\n");
        #endif
        while(1);
    }

    return _hwti_get_first_accelerator((Huint)hwti_array[slave_num]);
}

// --------------------------------------------------------- //
//         Function-to-Accelerator Type table                //
//                                                           //
// Description: This table is meant to associate function ID //
// to Accelerator types. That way, we can intelligently      //
// schedule threads that make use of certain accelerators to //
// slave processors who have that current (last_used_acc)    //
// accelerator configured in their PR region.                //
//                                                           //
// For example, table looks as follows (where NULL is equal  //
// to MAGIC_NUMBER):                                         //
//                                                           //
//  FuncID 0 | FuncID 1 | FuncID 2 |  ...                    //
// ----------+----------+----------+---------                //
//     1     |   NULL   |    0     |  ...                    //
// ----------+----------+----------+---------                //
//                                                           //
// --------------------------------------------------------- //
// Only create MAX_ENTRIES_PER_TABLE ("_thread" functions)
Huint func_2_acc_table[MAX_ENTRIES_PER_TABLE];

// Init function for this table. Note: Global thread table must be initialized!
void init_func_2_acc_table() {
    Huint func_id = 0;

    // For every function ID
    for (func_id = 0; func_id < MAX_ENTRIES_PER_TABLE; func_id++) {

        // Init accelerator type to MAGIC_NUMBER
        func_2_acc_table[func_id] = MAGIC_NUMBER;
    }
}

//----------------------------------------------//
// Function to initialize anything host         //
// related. These tables need to be initialized //
// once, and we don't want to include those     //
// overheads when timing our application.       //
//----------------------------------------------//
void init_host_tables() {

   if (!table_initialized_flag) {
        
      // Assert flag
      table_initialized_flag = 1;

      // Init thread table
      init_thread_table(&global_thread_table);

      // Load entries with app-specific data
      load_my_table();

      // Init function-to-accelerator table
      init_func_2_acc_table();

      // Initialize slaves
      init_slaves();

      #ifdef TUNING_TABLE_H
      // Initialize Tuning Table for PR-based systems
      //init_tuning_table();
      #endif
   
      // Reset OS overhead running time
      join_overhead = 0;
      randomize_overhead = 0;
      create_overhead = 0;

      // Reset slave counters
      Huint i;
      for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
          _hwti_set_accelerator_hw_counter(hwti_array[i], 0);
          _hwti_set_accelerator_sw_counter(hwti_array[i], 0);
          _hwti_set_accelerator_pr_counter(hwti_array[i], 0);
      }
     
      // Reset counters for find_best_match function 
      total_calls = 0;
      perfect_match_counter = 0;
      best_match_counter = 0;
      better_match_counter = 0;
      possible_match_counter = 0;

      head = &ThreadQueue[0];
      tail = &ThreadQueue[0];
      thread_head_index = 0;
      thread_tail_index = 0;
      thread_entries = 0;
   }
}

//------------------------------------------//
// Software_Create                          //
// Description: Function used to create     //
// software threads only. Used if creating  //
// a hardware thread fails.                 //
//------------------------------------------//
Hint software_create (
        hthread_t * tid,
        hthread_attr_t * attr,
        Huint func_id,
        void * arg)
{
   hthread_time_t start = hthread_time_get();
   void * func;

    // ---------------------------------------------
    // Make sure tables are setup
    // ---------------------------------------------
    if (!table_initialized_flag) 
         init_host_tables();

    #ifdef DEBUG_DISPATCH
    printf("Software thread\n");
    #endif

    // Create a native/software thread on the host processor
    func = lookup_thread(&global_thread_table, func_id, TYPE_HOST);
  
    // Increment thread counter
    thread_counter++; 
       
    Huint status = hthread_create(tid, attr, func, arg);
    
    hthread_time_t stop = hthread_time_get();
    hthread_time_t diff = hthread_time_diff(diff,stop,start);
    create_overhead += diff;

    return (status);
}

// Function: Get_num_free_slaves()
// Description: This function simply loops through all of the
// slave processors to determine the number of free slaves. It
// returns this amount back to the callee.
Huint get_num_free_slaves() {

    volatile Huint free = 0, i = 0;

    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        if (_hwti_get_utilized_flag(hwti_array[i]) == FLAG_HWTI_FREE) 
            free++;
    }

    return free;
}

/**
  * Function: find_best_match()
  * Description: This function loops through all of the free
  * slave processors to determine the best match for a particular
  * function ID. This function was written in a generic way to allow
  * it to be called for Static accelerator based systems, PR-configured
  * systems, or non-accelerator, non-PR based systems.
  * TODO: A linked list would be a better design, but that means the data
  * will be on the heap, which is in global memory!
  * NOTE: I don't need to check whether front >= back pointer
  * as I iterate over a fixed amount of data.
  **/

Hint find_best_match(Huint func_id) {
   total_calls++;
   // Reset match variables
   best_match = -1;
   better_match = -1;
   possible_match = -1;
   Hbool hasPolyFunction = (thread_profile[func_id].first_accelerator != NO_ACC) ? 1 : 0;
   // For all slaves.
//#ifdef CHECK_FIRST_POLYMORPHIC
   for (_index = 0; _index < NUM_AVAILABLE_HETERO_CPUS; _index++) {
//#else
//   //START_RANDOM = hthread_time_get();
//   // Create some random assignment
//   Huint randomized_slave_table[NUM_AVAILABLE_HETERO_CPUS];
//   for (_index = 0; _index < NUM_AVAILABLE_HETERO_CPUS; _index++) {
//      randomized_slave_table[_index] = _index;
//   }
//   // Shuffle 100 times?
//   for (_index = 0; _index < 100; _index++) {
//      Huint pos1 = rand() % NUM_AVAILABLE_HETERO_CPUS;
//      Huint pos2 = rand() % NUM_AVAILABLE_HETERO_CPUS;
//      Huint temp =  randomized_slave_table[pos1];
//      randomized_slave_table[pos1] = randomized_slave_table[pos2];
//      randomized_slave_table[pos2] = temp;
//   }
//   //STOP_RANDOM = hthread_time_get();
//   //hthread_time_diff(DIFF_RANDOM,STOP_RANDOM,START_RANDOM);
//   //randomize_overhead += DIFF_RANDOM;
//   Huint pos = 0;
//   for (pos = 0; pos < NUM_AVAILABLE_HETERO_CPUS; pos++) {
//      _index = randomized_slave_table[pos];
//#endif


#ifdef OPCODE_FLAGGING
      if (!hasPolyFunction) {
         // If there is nothing in preferred list, go to non-preferred list
         if (preferred_list[func_id][0] == -1) {
            slave = non_preferred_list[func_id][_index];
         }
         else {
            // Get most preferred slave according to co-processor support  
            slave = preferred_list[func_id][_index];
         }
         // If you have reached far down the non/preferred_list, it means
         // the non/preferred processors are busy, and you should append
         // this thread
         if (slave == -1)
            return ENQUEUE_THREAD;
      }
      else { // If this thread has poly calls, allow it to do exploration
         if (preferred_list[func_id][_index] == -1) {
            slave = non_preferred_list[func_id][_index];
         }
         else {
            slave = preferred_list[func_id][_index];
         }
      }
#else
      slave = _index;
#endif
      // Is this slave available?
      if (_hwti_get_utilized_flag(hwti_array[slave]) == FLAG_HWTI_FREE) {
         // Does this thread use an accelerator/Make polymorphic calls?
         Huint first_used_accelerator = thread_profile[func_id].first_accelerator;
#ifdef CHECK_FIRST_POLYMORPHIC
         if (first_used_accelerator != NO_ACC) { // if Yes?
            // Does this thread use PR?
            if (thread_profile[func_id].prefer_PR) {
               // Does this slave have PR?
               if (slave_table[slave].pr) { 
                  // Is the current accelerator = 1st called accelerator for thread?
                  if (first_used_accelerator == slave_table[slave].acc) {
                     perfect_match_counter++;
                     return slave;
                  }
                  else {
                     // We found a slave with PR capabilities that this thread
                     // prefers, but its current accelerator != what this thread
                     // first requests.
                     if (best_match == -1) // If we have not set best match
                        best_match = slave;
                  }
               }
               else {
                  // We found a slave without PR capabilities that this thread
                  // prefers, but its current accelerator DOES equal what this 
                  // thread first requests.
                  if (first_used_accelerator == slave_table[slave].acc) {
                     if (better_match == -1) // If we have not set better match
                        better_match = slave;
                  }
                  else {
                     // Maybe, in the future, check curr acc against all poly
                     // calls of the thread, and give more weight over standard cpus.
                     if (possible_match == -1)  // If we have not set a possible match
                        possible_match = slave;
                  }
               }
            }
            else {
               // Is the current accelerator = 1st called accelerator for thread?
               if (first_used_accelerator == slave_table[slave].acc) {
                  // Does this slave have PR?
                  if (slave_table[slave].pr) {
                     if (best_match == -1) 
                        best_match = slave;
                  }
                  else {
                     // This slave doesn't have PR. Great for threads
                     // who don't need PR!
                     perfect_match_counter++; 
                     return slave;
                  }
               }
               else {
                  // Does this slave have PR?
                  if (slave_table[slave].pr) {
                     // This slave has PR for a thread that doesn't need it.
                     // We add this to better match as we want to give more
                     // priority for slaves with PR to threads that make
                     // heavy use of it/possible swap more than 1 acc.
                     if (better_match == -1) 
                        better_match = slave; 
                  }
                  else {
                     if (possible_match == -1)  // If we have not set a possible match
                        possible_match = slave;
                  }
               }
            }
         }
         else  // Thread doesn't use any polymorphic calls
            return slave;
#else    
         if (first_used_accelerator != NO_ACC) { // if Yes?
            if (thread_profile[func_id].prefer_PR) {
               // Does this slave have PR?
               if (slave_table[slave].pr) { 
                  // Is the current accelerator = 1st called accelerator for thread?
                  if (first_used_accelerator == slave_table[slave].acc) {
                     perfect_match_counter++;
                  }
                  else {
                     // We found a slave with PR capabilities that this thread
                     // prefers, but its current accelerator != what this thread
                     // first requests.
                     best_match_counter++;
                  }
               }
               else {
                  // We found a slave without PR capabilities that this thread
                  // prefers, but its current accelerator DOES equal what this 
                  // thread first requests.
                  if (first_used_accelerator == slave_table[slave].acc) {
                     better_match_counter++;
                  }
                  else {
                        // Maybe, in the future, check curr acc against all poly
                        // calls of the thread, and give more weight over standard cpus.
                        possible_match_counter++;
                  }
               }
            }
            else {
               // Is the current accelerator = 1st called accelerator for thread?
               if (first_used_accelerator == slave_table[slave].acc) { 
                  // Does this slave have PR?
                  if (slave_table[slave].pr) {
                     if (best_match == -1) 
                        best_match_counter++;
                  }
                  else {
                     // This slave doesn't have PR. Great for threads
                     // who don't need PR!
                     perfect_match_counter++; 
                  }
               }
               else {
                  // Does this slave have PR?
                  if (slave_table[slave].pr) {
                     // This slave has PR for a thread that doesn't need it.
                     // We add this to better match as we want to give more
                     // priority for slaves with PR to threads that make
                     // heavy use of it/possible swap more than 1 acc.
                     better_match_counter++; 
                  }
                  else 
                     possible_match_counter++;
               }
            }
         }
         return slave;
#endif
      }
   }

   // If you have made it here without finding the perfect match, then check
   // in this order, best, better, possible or else, just return FAILURE
   if (best_match >= 0) {
      best_match_counter++;
      return best_match;
   }
   else if (better_match >= 0) {
      better_match_counter++;
      return better_match;
   }
   else if (possible_match >= 0) {
      possible_match_counter++;
      return possible_match;
   }
   else {
      // Try again
      //return FAILURE;
      return ENQUEUE_THREAD;
      //return find_best_match(func_id);
   }
  
   printf("Should not get here\n"); 
   // Return FAILURE by default
   return FAILURE;
}

//--------------------------------------------------------------------------------------------//
//  Thread Create 
//  Description: This function encapsulates all of the thread create functions (i.e. dynamic
//      create smart, microblaze create, hthread create, etc.
//  Arguments:
//      1) Thread ID - Thread ID returned by the OS. Assigned during hthread_setup().
//      2) Thread Attribute - Attribute structure for the thread
//      3) Function ID - The function number the thread will execute
//      4) Argument - Argument to be passed to the function
//      5) Type - The type of thread you want to be created. (i.e. Software, dynamic_hw, etc.
//      6) Dma Length - the length of the parameter, arg. Passing a zero indicates no DMA'ing
//
//      NOTE: DMA LENGTH IS NOT USED AT THIS TIME.
//--------------------------------------------------------------------------------------------//
Hint thread_create(
        hthread_t * tid,        
        hthread_attr_t * attr,  
        Huint func_id,   
        void * arg,             
        Huint type,      
        Huint dma_length)
{

    START = hthread_time_get();
    Huint ret;
    void * func;

    assert(attr!=NULL); // Efficient NULL pointer check

    // ---------------------------------------------
    // Make sure tables are initialized
    // ---------------------------------------------
    if (!table_initialized_flag) 
         init_host_tables();

    if (type == DYNAMIC_HW) {
       // Are all slaves busy? Proceed when we have X% of free slaves
       //while(get_num_free_slaves() <= FREE_SLAVES_THRESHOLD);
#ifdef BASE_SCHEDULER
       while(get_num_free_slaves() == 0);
#else
       while(get_num_free_slaves() == 0) {
         // Pause overhead recording
         STOP = hthread_time_get();
         hthread_time_diff(DIFF,STOP,START);
         create_overhead += DIFF;
         hthread_yield();
         // Resume overhead count
         START = hthread_time_get();
       }
#endif
    }

    //--------------------------------
    // Is this a software thread?
    //--------------------------------
    if (type == SOFTWARE_THREAD) {
       
        // Create a native/software thread on the host processor
       
        // Make sure user didn't call  hthread_attr_sethardware()
        if (attr->hardware) {
            #ifdef DEBUG_DISPATCH
            printf("Your thread attribute is set for hardware but");
            printf(" you are creating a software thread!\n");
            #endif
            ret = FAILURE;
        } else {
            ret = software_create(tid, attr, func_id, arg);
        }
    
    //------------------------------------------------------------
    // For hardware threads, should we dynamically schedule them?
    //------------------------------------------------------------
    } else if(type == DYNAMIC_HW) {

        // Identify a slave processor the best fits our needs (i.e., is 
        // available, is available and has an accelerator we want, etc.)
        Hint slave_num = find_best_match(func_id);

        // If we did not find any processors available.
        if (slave_num == FAILURE) {
            //#ifdef DEBUG_DISPATCH
            printf("No Free Slaves:Creating software thread\n");
            //#endif
            ret = software_create(tid, NULL, func_id, arg);
        } else if (slave_num == ENQUEUE_THREAD) {
           // enqueue thread
           tail->tid = tid;
           tail->attr = attr;
           tail->func_id = func_id;
           tail->arg = arg;

           // point tail to next slot
           thread_tail_index = (thread_tail_index + 1) % THREAD_QUEUE_MAX;
           tail = &ThreadQueue[thread_tail_index];

           // Increase thread entries counter
           thread_entries++;
           ret = SUCCESS;

        } else {
            // Grab the function handle according to the processor type.
            func = lookup_thread(&global_thread_table, func_id, slave_table[slave_num].isa);
            #ifdef DEBUG_DISPATCH
            printf("Creating Hetero Thread (CPU#%d)!\n",slave_num);
            #endif

            // -------------------------------------------------------------- //
            //         Write extra parameters for PR functionality            //
            // -------------------------------------------------------------- //
            // Write pointer for first_used_accelerator so slave can update the table.
            // This assumes that for a particular function (id), slaves will also have 
            // the same first accelerator used.
            _hwti_set_first_accelerator_ptr( (Huint) hwti_array[slave_num], (Huint) &func_2_acc_table[func_id]);

            // -------------------------------------------------------------- //
            //         Create the hardware thread using better target         //
            // -------------------------------------------------------------- //
            hthread_attr_sethardware( attr, (void*)hwti_array[slave_num] );
            ret =  hthread_create(tid, attr, func, arg);
        }
    //-------------------------------------------------------
    // For hardware threads, we will statically schedule them
    //-------------------------------------------------------
    } else { 
        // Determine the exact slave processor number 
        Huint slave_num = type + STATIC_HW_OFFSET;

        // Check if valid slave number. Since 'slave_num' is 
        // and unsigned int, it cannot be negative, right?
        if (slave_num >= NUM_AVAILABLE_HETERO_CPUS) {
            //#ifdef DEBUG_DISPATCH
            printf("Invalid slave number: %d\n", slave_num);
            printf("Creating a software thread instead\n");
            //#endif
            ret = software_create(tid, NULL, func_id, arg);
        }

        // If that slave number exists, is it Free?
        if (_hwti_get_utilized_flag(hwti_array[slave_num]) == FLAG_HWTI_UTILIZED) { 
            //#ifdef DEBUG_DISPATCH
            printf("Slave number %d is busy! Creating software thread\n", slave_num);
            //#endif
            ret = software_create(tid, NULL, func_id, arg);
        }
        else {
            #ifdef DEBUG_DISPATCH
            printf("Creating Hetero Thread (CPU#%d)!\n",slave_num);
            #endif
            
            // -------------------------------------------------------------- //
            //         Write extra parameters for PR functionality            //
            // -------------------------------------------------------------- //
            // Write pointer for first_used_accelerator so slave can update the table.
            // This assumes that for a particular function (id), slaves will also have 
            // the same first accelerator used.
            _hwti_set_first_accelerator_ptr( (Huint) hwti_array[slave_num], (Huint) &func_2_acc_table[func_id]);

            // Grab the function according to the processor type
            func = lookup_thread(&global_thread_table, func_id, slave_table[slave_num].isa);
            
            // -------------------------------------------------------------- //
            //         Create the hardware thread using slave num             //
            // -------------------------------------------------------------- //
            hthread_attr_sethardware( attr, (void*)hwti_array[slave_num] );
            ret = hthread_create(tid, attr, func, arg);
        }
    }

    STOP = hthread_time_get();
    hthread_time_diff(DIFF,STOP,START);
    create_overhead += DIFF;

    return ret;
}

#include <manager/manager.h>
Hint thread_join(hthread_t th, void **retval, hthread_time_t *exec_time) {
  
   START = hthread_time_get(); 
   // Attempt to join on thread and grab execution time.
   // FIXME: Grabbing execution time should be done first 
   // (once thread has exited), in case parent is preempted
   // while joining on child thread.
   Huint status = hthread_join(th, retval);
   *exec_time = threads[th].execution_time;

   STOP = hthread_time_get();
   hthread_time_diff(DIFF,STOP,START);
   join_overhead += DIFF;

   return status;
}


// Get processor utilized flags
unsigned int get_utilized_flags(void * arg)
{
   if (_hwti_get_utilized_flag((unsigned int) arg) == FLAG_HWTI_FREE)
      return 1;
   else
      return 0;
}

// Clear all processor utilized flags
void clear_utilized_flags()
{
    int i = 0;
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)
    {
       _hwti_set_free(hwti_array[i]);
    }
}
