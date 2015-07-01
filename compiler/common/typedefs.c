// Tuning table
typedef struct {
    unsigned char chunks;
    unsigned int hw_time;
    unsigned int sw_time;
    unsigned char optimal_thread_num;
} tuning_table_t;


// --------------------------------------------------------- //
//                  Slave free/busy table                    //
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
    Huint last_used_acc;
    Huint processor_type;
} slave_t;

// ---------------------------------------------------------------- //
//                  Thread Table Structures                         //
// ---------------------------------------------------------------- //
// Table entry type
//      id - function id number 
//      handles - pointers to functions within ELF images
//      intermediate_array - pointers to ELF images
//      size - size of ELF images
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
