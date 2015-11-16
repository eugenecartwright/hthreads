#define PRIVATE_MEMORY __attribute__ ((section ("local")))

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
   Hbool mul32;
   Hbool mul64;
   
   // Reserved for future use 
   Hbool fpu_ratio;
   Hbool mul32_ratio;
   Hbool mul64_ratio;
   Hbool idiv_ratio;
   Hbool barrel_ratio;
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
    void * handles[MAX_HANDLES_PER_ENTRY];
    void * intermediate_array[MAX_HANDLES_PER_ENTRY];
    Huint size[MAX_HANDLES_PER_ENTRY];
} thread_entry_t;

// Table type/processor architecture
typedef struct {
    thread_entry_t table[MAX_ENTRIES_PER_TABLE];    
} thread_table_t;
