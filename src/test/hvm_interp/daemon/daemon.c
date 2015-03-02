#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <hthread.h>
//#include <sched.h>

#include "common/tcb.h"
#include "common/types.h"
#include "common/export_buffer.h"
#include "common/import_buffer.h"

#include <daemon.h>
#include <hvm_utils.h>
#include "interpreter/interpreter.h"


// The daemon_init function provides an interface to the main thread
// to start the daemon. It should only be called once and will run
// in the main thread.
void daemon_init(DaemonComm *dc)
{
	// Initialize the Daemon Communication Struct.
	// This struct is used to pass information from the
	// main thread to the daemon thread.
	UNSET(dc->new_code);
	UNSET(dc->in_hw);
	dc->new_code_address = NULL;
	dc->new_code_size = 0;

	// Create the daemon thread.
	hthread_create(&dc->tid, NULL, daemon_thread, (void *)dc);
}

// The daemon_create_thread is used by the main thread to create user
// threads. This will run in the main thread.
void daemon_create_thread(DaemonComm *dc, byte *code, unsigned int code_size)
{
	// Change the state of dc to reflect the presence of new bytecode to execute.
	SET(dc->new_code);
	UNSET(dc->in_hw);   // (HW/SW is unspecified)
	dc->new_code_address = code;
	dc->new_code_size = code_size;

	// Yield to allow the daemon thread to process this create.
    hthread_yield();
}

// The daemon_create_thread is used by the main thread to create user
// threads. This will run in the main thread.
void daemon_create_hw_thread(DaemonComm *dc, byte *code, unsigned int code_size)
{
	// Change the state of dc to reflect the presence of new bytecode to execute.
	SET(dc->new_code);
	SET(dc->in_hw);     // (Specify in HW)
	dc->new_code_address = code;
	dc->new_code_size = code_size;

	// Yield to allow the daemon thread to process this create.
    hthread_yield();
}


void *daemon_thread(void *arg)
{
    TID_t next_tid = 0;
    TID_t hw_tid   = 0;
    int rv, hw_ret_val, regCount;
    hthread_t junk_tid;
    flag hw_available, hw_done;

    sched_param_t my_priority;
    Hint my_policy;

    // Display the daemon's priority
    hthread_getschedparam(hthread_self(),&my_policy,&my_priority);
    //printf("Daemon priority = %d\n", my_priority.sched_priority);

    // Create a pointer to the Daemon's communication struct with main.
	DaemonComm *dc = (DaemonComm *)arg;

	// Create a buffer for software interpreters to export/import their state to.
	ExportBuffer export_buffer;
	ImportBuffer import_buffer;

	// The software_interpreter_list holds active threads that are being interpreted by
	// the software interpreter.
	TCBNode software_interpreter_list[MAX_SW_THREAD];

	// The cur_tcb and the tcb_index are used to reference TCBs in the software interpreter list.
	TCBNode *cur_tcb;
	TCB *new_tcb;
	int tcb_index;

    // Initialize TCB List
	for (cur_tcb = software_interpreter_list; cur_tcb < software_interpreter_list + MAX_SW_THREAD; cur_tcb++)
	{
        UNSET(cur_tcb->valid);
    }

    // Initialize hardware flags
    SET(hw_available);
    SET(hw_done);


    printf("    ...DAEMON running.\n");
	// The daemon will run forever. Currently we have no clean shutdown mechanism.
	while(1)
	{

		// Process each TCB in the software interpreter list.
		for (cur_tcb = software_interpreter_list; cur_tcb < software_interpreter_list + MAX_SW_THREAD; cur_tcb++)
		{
			// If the TCB is invalid, then skip it.
			if (! ISSET(cur_tcb->valid))
				continue;

			// If a thread is done interpreting, then print its return value and invalidate the TCB.
			if (ISSET(cur_tcb->entry.communication.control.done_interpreting))
			{
				printf("DAEMON: Thread id %u (running in SW) returned %d\n", cur_tcb->entry.tid, cur_tcb->entry.communication.data.return_value);
				UNSET(cur_tcb->valid);
				continue;
			}

			// If the thread is done exporting to hardware, then invalidate the TCB and start
			// the hardware interpretation process.
			if (ISSET(cur_tcb->entry.communication.control.done_exporting))
			{
			  // TODO: If a software thread has finished exporting, but in the meantime a
			  // a new "run this thread only in hardware" request has come in, we need to copy
			  // the thread state from the export buffer *back* into a software thread to make
			  // room for the hw->sw migration we're about to do.
                // If there is new bytecode available to execute, then process it.
                if (ISSET(dc->new_code) & ISSET(dc->in_hw))
		        {
                    // Kick thread back into SW

                    // Find an invalid TCB.
						for (tcb_index = 0; tcb_index < MAX_SW_THREAD; tcb_index++)
						{
	                        if (! ISSET(software_interpreter_list[tcb_index].valid))
								break;
						}
		
						// If an available TCB is found, then tcb_index must be less
						// then MAX_SW_THREAD.
						if (tcb_index < MAX_SW_THREAD)
						{
							// If an invalid TCB exists, initialize it and start
							// the software interpreter.
		
							// Initialize software_interpreter_list[tcb_index]
							new_tcb = &software_interpreter_list[tcb_index].entry;
		
		                    new_tcb->tid = cur_tcb->entry.tid;
		                    new_tcb->virtualization.base_addr = software_interpreter_list[tcb_index].memory;
							new_tcb->communication.data.export_buffer_addr = & export_buffer;
							new_tcb->communication.data.import_buffer_addr = & import_buffer;
							UNSET(new_tcb->communication.control.done_interpreting);
							UNSET(new_tcb->communication.control.start_exporting);
							UNSET(new_tcb->communication.control.done_exporting);
							
							SET(software_interpreter_list[tcb_index].valid);
	
	                        // Copy program/state to interpreter memory space
                            for (regCount = 0; regCount < NUMBER_REGISTERS ;regCount++)
                            {
                                import_buffer.register_file[regCount] = export_buffer.register_file[regCount];
                            }
                            memcpy(software_interpreter_list[tcb_index].memory, cur_tcb->memory, export_buffer.register_file[SP]);
		
							//start_software_interpreter();
							rv = hthread_create(&junk_tid, NULL, interpreter_entry_point_import, (void *)&(software_interpreter_list[tcb_index].entry));
						}
						else
						{
							// If the software_interpreter_list is full, issue an error message.
							fprintf(stderr, "Preallocated TCB list is full.\n");
						}
                   

                }
                else
                {
                    // Move the thread into HW

                    // Grab the SW thread's TID
                    hw_tid = cur_tcb->entry.tid;

                    // Migrate state from export buffer into HW interpreter
	                reset_HVM();
                    printf("DAEMON: Migrating thread id %u from SW to HW...",hw_tid);
                    import_state_HVM(&export_buffer, cur_tcb->memory);
                    printf("COMPLETE\n");

                    // Start HW interpreter execution
                   light_LED(hw_tid);
                   UNSET(hw_done);
                   run_HVM();

                   // Invalidate TCB
                   UNSET(cur_tcb->valid);
                }
			}
		}


		// Is the hardware done interpreting
		if (is_HVM_done())
		{
            // Export HVM state and grab return value
            light_LED(0);
            SET(hw_done);
            export_state_HVM();
            wait_export_complete_HVM();
            hw_ret_val = get_HVM_return_value();

            // Display return value
            printf("DAEMON: Thread id %u (running in HW) returned %d\n", hw_tid, hw_ret_val);

            // Check to see if any SW threads exist that can now be run in HW
            for (tcb_index = 0; tcb_index < MAX_SW_THREAD; tcb_index++)
			{
				if (software_interpreter_list[tcb_index].valid)
					break;
			}

            // If a valid SW thread exists, begin it's export process so that it can be migrated (otherwise, make the HW available again)
            if (tcb_index < MAX_SW_THREAD) {
                SET(software_interpreter_list[tcb_index].entry.communication.control.start_exporting);
            }
			else {
                printf("DAEMON: HW is available for the taking!\n");
				SET(hw_available);
            }
		}


        // If there is new bytecode available to execute, then process it.
        if (ISSET(dc->new_code))
		{
            // Increment the TID counter
            next_tid++;

            // If told to run this thread in HW, check to see if we need to force the HW to be available (migrating a thread from HW to SW)
            if (ISSET(dc->in_hw))
            {
                // Check to see if HW is even available
                if (!ISSET(hw_available) & !ISSET(hw_done))
		        {
                  // It's not, so we must make it available
                  // export hardware to software, if needed
		          printf("DAEMON: Migrating thread id %u from HW to SW...", hw_tid);

                  // Stop HVM and export its state
                  light_LED(0);
                  export_state_HVM();

                  //wait_export_complete_HVM(); // This function waits for exported PC to be all F's and this won't be the case in a pre-empted program
                  delay(99999999);  // Use a delay instead to wait for export process to finish

                  printf("COMPLETE\n");

                  // migrate HW state to import buffer (registers now, and program/stack later - just below)
                  migrate_HVM_registers_to_buffer(&import_buffer);

		          // create new SW based on import buffer

					// Find an invalid TCB.
					for (tcb_index = 0; tcb_index < MAX_SW_THREAD; tcb_index++)
					{
                        if (! ISSET(software_interpreter_list[tcb_index].valid))
							break;
					}
	
					// If an available TCB is found, then tcb_index must be less
					// then MAX_SW_THREAD.
					if (tcb_index < MAX_SW_THREAD)
					{
						// If an invalid TCB exists, initialize it and start
						// the software interpreter.
	
						// Initialize software_interpreter_list[tcb_index]
						new_tcb = &software_interpreter_list[tcb_index].entry;
	
	                    new_tcb->tid = hw_tid;
	                    new_tcb->virtualization.base_addr = software_interpreter_list[tcb_index].memory;
						new_tcb->communication.data.export_buffer_addr = & export_buffer;
						new_tcb->communication.data.import_buffer_addr = & import_buffer;
						UNSET(new_tcb->communication.control.done_interpreting);
						UNSET(new_tcb->communication.control.start_exporting);
						UNSET(new_tcb->communication.control.done_exporting);
						
						SET(software_interpreter_list[tcb_index].valid);

                        // Copy program/state to interpreter memory space
                        //memcpy(software_interpreter_list[tcb_index].memory, dc->new_code_address, dc->new_code_size);
                        memcpy(software_interpreter_list[tcb_index].memory, hvm_prog_mem, get_current_SP_HVM());
	
						//start_software_interpreter();
						rv = hthread_create(&junk_tid, NULL, interpreter_entry_point_import, (void *)&(software_interpreter_list[tcb_index].entry));
					}
					else
					{
						// If the software_interpreter_list is full, issue an error message.
						fprintf(stderr, "Preallocated TCB list is full.\n");
					}
	
                  // Set HW available flag, so the new thread falls through and is created by the code below
                  SET(hw_available);
        		}
                else if (!ISSET(hw_available) & ISSET(hw_done))
                {
                    // If its not available, but the thread in HW is complete, then there is no need to migrate the thread...
                    // Just change the availalbility flag for the code below to take care of
                    SET(hw_available);
                }
            }


    	    // TODO: I don't think we need this else, now.  The dc->in_hw flag just forces a
	        // hw -> sw migration, making the hw available to the new thread.
            // If HW available, run the thread in HW
            if ISSET(hw_available)
			{
                // De-asser ready flag
                UNSET(hw_available);

                // Download fresh code
                hw_tid = next_tid;
                printf("DAEMON: Started thread id %u in HW\n", hw_tid);
                load_memory(hvm_prog_mem, dc->new_code_size, dc->new_code_address);

                // Reset and run the interpreter
                reset_HVM();
                light_LED(hw_tid);
                UNSET(hw_done);
                run_HVM();

			}
            // Otherwise run the thread in SW
            else
			{
				// This bytecode will run in software. Therefore it needs
				// to given a TCB in the software interpreter list.

				// Find an invalid TCB.
				for (tcb_index = 0; tcb_index < MAX_SW_THREAD; tcb_index++)
				{
					if (! ISSET(software_interpreter_list[tcb_index].valid))
						break;
				}

				// If an available TCB is found, then tcb_index must be less
				// then MAX_SW_THREAD.
				if (tcb_index < MAX_SW_THREAD)
				{
					// If an invalid TCB exists, initialize it and start
					// the software interpreter.

					// Initialize software_interpreter_list[tcb_index]
					new_tcb = &software_interpreter_list[tcb_index].entry;

                    new_tcb->tid = next_tid;
                    new_tcb->virtualization.base_addr = software_interpreter_list[tcb_index].memory;
					new_tcb->communication.data.export_buffer_addr = & export_buffer;
					new_tcb->communication.data.import_buffer_addr = & import_buffer;
					UNSET(new_tcb->communication.control.done_interpreting);
					UNSET(new_tcb->communication.control.start_exporting);
					UNSET(new_tcb->communication.control.done_exporting);
					
					SET(software_interpreter_list[tcb_index].valid);
					memcpy(software_interpreter_list[tcb_index].memory, dc->new_code_address, dc->new_code_size);

					//start_software_interpreter();
                    printf("DAEMON: Started thread id %u in SW\n", next_tid);
					rv = hthread_create(&junk_tid, NULL, interpreter_entry_point, (void *)&(software_interpreter_list[tcb_index].entry));
				}
				else
				{
					// If the software_interpreter_list is full, issue an error message.
					fprintf(stderr, "Preallocated TCB list is full.\n");
				}
			}

            // Unset the new_code flag
            UNSET(dc->new_code);
		}

		// Yield control to allow the software interpreter to do some work.
        //printf("Daemon yielding...\n");
		hthread_yield();

	}
    return NULL;
}
