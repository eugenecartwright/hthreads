#define PRIVATE_MEMORY __attribute__ ((section ("local")))
#define GLOBAL_MEMORY __attribute__ ((section ("main_memory")))

// Tuning table
typedef struct {
    unsigned char chunks;
    unsigned int hw_time;
    unsigned int sw_time;
    unsigned char optimal_thread_num;
} tuning_table_t;

// --------------------------------------------------------- //
//          Thread/Processor profile structure               //
// --------------------------------------------------------- //
//                                                           //
// Description: The structure below holds information about  //
// what accelerators the thread uses/processor has.          //
// --------------------------------------------------------- //
typedef struct {
   // Ordering must match 
   // instruction.xml for now
   Hbool idiv;
   Hbool fpu;
   Hbool barrel;
   Hbool mul;
   
   // Reserved for future use 
   Hbool idiv_ratio;
   Hbool fpu_ratio;
   Hbool barrel_ratio;
   Hbool mul_ratio;

   // First possible accelerator, used
   Hint first_accelerator;

   // PR preference: valid if multiple 
   // polymorphic functions called.
   Hbool prefer_PR;

} thread_profile_t;

// --------------------------------------------------------- //
//                  Slave free/busy table                    //
// --------------------------------------------------------- //
//                                                           //
// Description: This table is meant to keep track of 1) the  //
// processor type in the V-HWTIs, and 2) what is the         //     
// last/current accelerator in a slave's PR region (if any). //
// 'last_used_acc' contains the accelerator type.            //
//                                                           //
// For example, the table looks as follows:                  //
//                                                           //
//    0       |     1    |     2    |  ...                   //
// -----------+----------+----------+---------               //
//   CRC, PPC | SORT,uB  |  CRC, uB |  ...                   //
// -----------+----------+----------+---------               //
//                                                           //
// --------------------------------------------------------- //
typedef struct {
    Huint acc;
    Huint isa;
    Huint vhwti_address;
    Hbool pr;
    thread_profile_t configuration;
} slave_t;


// ----------------------------------------------------------------- //
//                  Thread Table Structures                          //
// ----------------------------------------------------------------- //
// Table entry type                                                  //
//      id - function id number                                      //
//      handles - pointers to functions within ELF images            //
//      intermediate_array - pointers to ELF images                  //
//      size - size of ELF images                                    //
// ----------------------------------------------------------------- //
typedef struct {
   Huint id;
   void * threads[MAX_HANDLES_PER_ENTRY];
   void * binary[MAX_HANDLES_PER_ENTRY];
   Huint binary_size[MAX_HANDLES_PER_ENTRY];
   thread_profile_t configuration;
   Huint preferred_processors[NUM_AVAILABLE_HETERO_CPUS];
} thread_entry_t;

// Table type/processor architecture
typedef struct {
   thread_entry_t table[MAX_ENTRIES_PER_TABLE];    
} thread_table_t;
