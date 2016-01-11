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

#define STATIC_HW_OFFSET (-2)


// Macro used to enable/disable dynamic dispatch DEBUG output
// * Uncomment the following line to see debug info
//#define DEBUG_DISPATCH

// Table Init (Magic Number)
#define TABLE_INIT      (0xDEADBEEF)
#define MAGIC_NUMBER    TABLE_INIT  

#define NOT_FOUND                   (-1)

// Function Prototypes
void load_my_table(void);
Hbool check_valid_slave_num (Huint slave_num);

// Global variables used to provide statistics of
// finding the best match when doing thread_create.
// find_best_match() uses these variables.
Huint no_free_slaves_num;
Huint possible_slaves_num;
Huint best_slaves_num;
// ---------------------------------------------------------------- //
//        Partial Reconfiguration Shared Data structures            //
// ---------------------------------------------------------------- //

// This is the tuning table used to keep track of profiling data
// for slave execution.
#ifdef TUNING
    tuning_table_t tuning_table[NUM_ACCELERATORS*NUM_OF_SIZES] = {
    {2,54,259,2}, {4,77,504,2}, {4,121,994,2}, {8,207,1975,2}, {8,377,3936,2}, {16,714,7855,2}, {16,1383,15716,2},
    {4,114,345,1}, {4,250,741,2}, {8,604,1537,2}, {8,1510,3238,2}, {16,3983,7053,2}, {16,10548,14703,2}, {16,30558,30894,2},
    {1,52,85,2}, {1,65,150,2}, {1,90,283,2}, {2,133,548,2}, {2,215,1079,2}, {2,380,2146,2}, {2,705,4294,2}
    };
#else
    tuning_table_t tuning_table[NUM_ACCELERATORS*NUM_OF_SIZES] = {
    {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1},
    {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1},
    {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}, {1, 1, 100000,1}
    };
#endif

Hbool pr_initialized = 0;

// Initialize all of the PR data
void init_slaves() {
    
   // Create accelerate profiles - containers that hold
   // pointers to each accelerator specific for each slave.
   unsigned int i;
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) { 
      // Write pointer for last_used_accelerator so slave can update the table
      _hwti_set_last_accelerator_ptr( (Huint) hwti_array[i], (Huint) &slave_table[i].acc);
      
      // Write which accelerator the slave has in last_used/currently loaded.
      _hwti_set_last_accelerator((Huint) hwti_array[i], slave_table[i].acc);
             
      // Write pointer to tuning_table
      _hwti_set_tuning_table_ptr((Huint) hwti_array[i], (Huint) &tuning_table);

      #ifdef PR
      // If PR is defined, write to slave that they have PR capability
      _hwti_set_PR_flag((Huint) hwti_array[i], PR_FLAG);
      #else
      _hwti_set_PR_flag((Huint) hwti_array[i], 0);
      #endif
   }
   #ifdef PR
   // Set up PR controller
   pr_config_mb();
   #endif
   
   // Reset thread create statistical data 
   no_free_slaves_num = 0;
   possible_slaves_num = 0;
   best_slaves_num = 0;
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
unsigned int table_initialized_flag = 0;


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


//------------------------------------------//
// Software_Create                          //
// Description: Function used to create     //
// software threads only. Used if creating  //
// a hardware thread fails.                 //
//------------------------------------------//
Huint software_create (
        hthread_t * tid,
        hthread_attr_t * attr,
        Huint func_id,
        void * arg)
{
    
    void * func;

    // ---------------------------------------------
    // Make sure tables are setup
    // ---------------------------------------------
    if (!table_initialized_flag) {
        
        // Assert flag
        table_initialized_flag = 1;

        // Init thread table
        init_thread_table(&global_thread_table);

        // Load entries with app-specific data
        load_my_table();

        // Init function-to-accelerator table
        init_func_2_acc_table();

        init_slaves();
    }

    #ifdef DEBUG_DISPATCH
    printf("Software thread\n");
    #endif

    // Create a native/software thread on the host processor
    func = lookup_thread(&global_thread_table, func_id, TYPE_HOST);
  
    // Increment thread counter
    thread_counter++; 
        
    return (hthread_create(tid, attr, func, arg));
}

// Function: Get_num_free_slaves()
// Description: This function simply loops through all of the
// slave processors to determine the number of free slaves. It
// returns this amount back to the callee.
Huint get_num_free_slaves() {

    Huint free = 0, i = 0;

    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        if (_hwti_get_utilized_flag(hwti_array[i]) == FLAG_HWTI_FREE) 
            free++;
    }

    return free;
}

// Function: find_best_match()
// Description: This function loops through all of the free
// slave processors to determine the best match for a particular
// function ID. This function was written in a generic way to allow
// it to be called for Static accelerator based systems, PR-configured
// systems, or non-accelerator, non-PR based systems.
// TODO: What if nothing is available?
Huint find_best_match(Huint func_id) {
    
    //Hint possible_target = MAGIC_NUMBER;
    Huint slave_num, index;

   // For all slaves.
   for (index = 0; index < NUM_AVAILABLE_HETERO_CPUS; index++) {

#ifdef OPCODE_FLAGGING
      // Get most preferred slave according to co-processor support  
      slave_num = thread_affinity[func_id][index];
#else
      slave_num = index;
#endif

      // Is this slave available?
      if (_hwti_get_utilized_flag(hwti_array[slave_num]) == FLAG_HWTI_FREE) {
         return slave_num;
      }
   }
   
   return 0;
     
#if 0 
      // If there is a free slave
        if (_hwti_get_utilized_flag(hwti_array[slave_num]) == FLAG_HWTI_FREE) {
          
            // If we still don't know what accelerator type associated with
            // this function id, break as soon as possible. This is similar to
            // breaking out of this loop as soon as possible for systems that 
            // do not have an accelerator or PR capabilities.
            if (func_2_acc_table[func_id] == MAGIC_NUMBER) {
                #ifdef DEBUG_DISPATCH
                printf("No known accelerator type matched with Func ID %d\n", func_id);
                #endif
                // Increment possible slaves_num
                possible_slaves_num++;
                return slave_num;
            }
            
            // ----------------------------------------------------//
            // For this function, does the first_accelerator_used  //
            // match what is currently PR'ed at this slave? If so, //
            // schedule it here! This is the best-case scenario.   //
            // If the first accelerator used is NULL, this means   //
            // the function did not use any accelerators, or we    //
            // have not reached a free slave that ran this same    //
            // function.                                           //
            // ----------------------------------------------------//
            if (func_2_acc_table[func_id] == slave_table[slave_num].acc)
            {
                #ifdef DEBUG_DISPATCH
                printf("We found the best match!\n");
                #endif
                // Increment best_slaves_num
                best_slaves_num++;
                // schedule on this slave
                return slave_num;
            
            // else if possible_target has not been updated
            // to reflect a possible target.
            } else if (possible_target == MAGIC_NUMBER)
                possible_target = slave_num;

        } // End check for if this slave (slave_num) is free
    }
    // If we did not find any free slaves
    if (possible_target == MAGIC_NUMBER)
        no_free_slaves_num++;
    else
        possible_slaves_num++;

    return possible_target;
#endif

}

#if 0
// Function: find_best_match()
// Description: This function loops through all of the free
// slave processors to determine the best match for a particular
// function ID. This function was written in a generic way to allow
// it to be called for Static accelerator based systems, PR-configured
// systems, or non-accelerator, non-PR based systems.
Huint find_best_match(Huint func_id) {
    
    Hint possible_target = MAGIC_NUMBER;
    Huint slave_num;

    // For all slaves.
    for (slave_num = 0; slave_num < NUM_AVAILABLE_HETERO_CPUS; slave_num++) {

        // If there is a free slave
        if (_hwti_get_utilized_flag(hwti_array[slave_num]) == FLAG_HWTI_FREE) {
          
            // If we still don't know what accelerator type associated with
            // this function id, break as soon as possible. This is similar to
            // breaking out of this loop as soon as possible for systems that 
            // do not have an accelerator or PR capabilities.
            if (func_2_acc_table[func_id] == MAGIC_NUMBER) {
                #ifdef DEBUG_DISPATCH
                printf("No known accelerator type matched with Func ID %d\n", func_id);
                #endif
                // Increment possible slaves_num
                possible_slaves_num++;
                return slave_num;
            }
            
            // ----------------------------------------------------//
            // For this function, does the first_accelerator_used  //
            // match what is currently PR'ed at this slave? If so, //
            // schedule it here! This is the best-case scenario.   //
            // If the first accelerator used is NULL, this means   //
            // the function did not use any accelerators, or we    //
            // have not reached a free slave that ran this same    //
            // function.                                           //
            // ----------------------------------------------------//
            if (func_2_acc_table[func_id] == slave_table[slave_num].acc)
            {
                #ifdef DEBUG_DISPATCH
                printf("We found the best match!\n");
                #endif
                // Increment best_slaves_num
                best_slaves_num++;
                // schedule on this slave
                return slave_num;
            
            // else if possible_target has not been updated
            // to reflect a possible target.
            } else if (possible_target == MAGIC_NUMBER)
                possible_target = slave_num;

        } // End check for if this slave (slave_num) is free
    }
    // If we did not find any free slaves
    if (possible_target == MAGIC_NUMBER)
        no_free_slaves_num++;
    else
        possible_slaves_num++;

    return possible_target;
}
#endif

//#define SW_THREAD_COUNT 6

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
Huint thread_create(
        hthread_t * tid,        
        hthread_attr_t * attr,  
        Huint func_id,   
        void * arg,             
        Huint type,      
        Huint dma_length)
{

    Huint ret;
    void * func;

    assert(attr!=NULL); // Efficient NULL pointer check

    // ---------------------------------------------
    // Make sure tables are initialized
    // ---------------------------------------------
    if (!table_initialized_flag) {
        
        // Assert flag
        table_initialized_flag = 1;

        // Init thread table
        init_thread_table(&global_thread_table);

        // Load entries with app-specific data
        load_my_table();

        // Init function-to-accelerator table
        init_func_2_acc_table();
       
        // Initialize mutexes, PR, and bitfiles
        // for Partial Reconfiguration.
        init_slaves();
    }

    // Check if we have not passed our threshold
    // TODO: Remove?
    //while( (NUM_AVAILABLE_HETERO_CPUS - get_num_free_slaves() + thread_counter) >  (NUM_AVAILABLE_HETERO_CPUS + SW_THREAD_COUNT))
        //hthread_yield();

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
        } else
            ret = software_create(tid, attr, func_id, arg);
    
    //------------------------------------------------------------
    // For hardware threads, should we dynamically schedule them?
    //------------------------------------------------------------
    } else if(type == DYNAMIC_HW) {

        // Identify a slave processor the best fits our needs (i.e., is 
        // available, is available and has an accelerator we want, etc.)
        Hint slave_num = find_best_match(func_id);

        // If we did not find any processors available.
        if (slave_num == MAGIC_NUMBER) {
            //#ifdef DEBUG_DISPATCH
            printf("No Free Slaves:Creating software thread\n");
            //#endif
            ret = software_create(tid, NULL, func_id, arg);
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
    return ret;
}

#include <manager/manager.h>
Hint thread_join(hthread_t th, void **retval, hthread_time_t *exec_time) {
   
   // Attempt to join on thread and grab execution time.
   // FIXME: Grabbing execution time should be done first 
   // (once thread has exited), in case parent is preempted
   // while joining on child thread.
   Huint status = hthread_join(th, retval);
   *exec_time = threads[th].execution_time;

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

// (SMART) Dynamic thread creation function
Huint dynamic_create_smart(
        hthread_t * tid,
        hthread_attr_t * attr,
        Huint func_id,
        void * arg)
{

    Huint ret;
    void * func;
   
    // Efficient NULL pointer check
    assert(attr!=NULL); 

    // ---------------------------------------------
    // Make sure tables are initialized
    // ---------------------------------------------
    if (table_initialized_flag == 0) {
        
        // Assert flag
        table_initialized_flag = 1;

        // Init thread table
        init_thread_table(&global_thread_table);

        // Load entries with app-specific data
        load_my_table();

        // Init function-to-accelerator table
        init_func_2_acc_table();
    }

    // ---------------------------------------------
    // Look for any free heterogeneous processors
    // ---------------------------------------------
    int i = 0;
    int found = NOT_FOUND;
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)
    {
       if( get_utilized_flags((void *) &i))
       {
            // Mark CPU that was found, and break out of loop
           found = i;
           break;
       }
    }

    // ---------------------------------------------
    // Create a native thread if no hetero CPUs are free
    // ---------------------------------------------
    if (found == NOT_FOUND)
    {
        // Create a native/software thread on MB
        func = lookup_thread(&global_thread_table, func_id, TYPE_HOST);
        if (func == (void*)TABLE_INIT)
        {
            ret =  TABLE_INIT;
        }
        else
        {
            // Ignore passed in attribute
#ifdef DEBUG_DISPATCH
            printf("Creating Native Thread!\n");
#endif
            ret = hthread_create(tid, NULL, func, arg);
        }
    }
    // ---------------------------------------------
    // Otherwise create a hetero thread
    // ---------------------------------------------
    else
    {
         
        // Create a heterogeneous thread
        func = lookup_thread(&global_thread_table, func_id, slave_table[found].isa);
        if (func == (void*)TABLE_INIT)
        {
            ret =  TABLE_INIT;
        }
        else
        {
            // Create thread hetero using V-HWTI[found]
#ifdef DEBUG_DISPATCH
            printf("Creating Hetero Thread (CPU#%d)!\n",found);
#endif
            hthread_attr_init(attr);
            hthread_attr_sethardware( attr, (void*)hwti_array[found] );
            ret = hthread_create(tid, attr, func, arg);
        }
    }
    
    return ret;
}

Huint microblaze_create(
        hthread_t * tid,
        hthread_attr_t * attr,
        Huint func_id,
        void * arg,
        Huint ublaze)
{

    Huint ret;
    void * func;

    assert(attr!=NULL); // Efficient NULL pointer check
    // ---------------------------------------------
    // Make sure tables are initialized
    // ---------------------------------------------
    if (table_initialized_flag == 0) {
        
        // Assert flag
        table_initialized_flag = 1;

        // Init thread table
        init_thread_table(&global_thread_table);

        // Load entries with app-specific data
        load_my_table();

        // Init function-to-accelerator table
        init_func_2_acc_table();
    }
    

    // ---------------------------------------------
    // Check if that specific MB is free
    // ---------------------------------------------
    if( !get_utilized_flags((void *) hwti_array[ublaze])) 
    {
        // Create a native thread
        printf("Microblaze %d is either not Free or does not exist!\n",ublaze);
        func = lookup_thread(&global_thread_table, func_id, TYPE_HOST);
        if (func == (void*)TABLE_INIT)
        {
            ret =  TABLE_INIT;
        }
        else
        {
            // Ignore passed in attribute
#ifdef DEBUG_DISPATCH
            printf("Creating Native Thread!\n");
#endif
            ret = hthread_create(tid, NULL, func, arg);
        }

    }
    // ---------------------------------------------
    // Otherwise create a hetero thread
    // ---------------------------------------------
    else
    {
        // Create a heterogeneous thread
        func = lookup_thread(&global_thread_table, func_id, slave_table[ublaze].isa);
        if (func == (void*)TABLE_INIT)
        {
            ret =  TABLE_INIT;
        }
        else
        {
            // Create thread hetero using V-HWTI[found]
#ifdef DEBUG_DISPATCH
            printf("Creating Hetero Thread (CPU#%d)!\n",ublaze);
#endif
            hthread_attr_init(attr);
            hthread_attr_sethardware( attr, (void*)hwti_array[ublaze] );
            ret = hthread_create(tid, attr, func, arg);

        }
    }
    
    return ret;
}


