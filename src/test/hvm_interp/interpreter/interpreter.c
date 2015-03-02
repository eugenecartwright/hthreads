#include "common/types.h"
#include "common/tcb.h"
#include <isa.h>
#include <interpreter.h>
#include <hthread.h>        
//#include <sched.h>	/* just for sched_yield! */
#include <stdlib.h> /* just for NULL! */
#include <stdio.h> /* just for printf! */


/*
word register_file[NUMBER_REGISTERS];
#define rD(i) (register_file[(i).byte0])
#define rA(i) (register_file[(i).byte1])
#define rB(i) (register_file[(i).byte2])
#define rO(i) (register_file[(i).byte2])
#define rT(i) (register_file[(i).byte0])
#define rS(i) (register_file[(i).byte0])
#define rPC   (register_file[PC])
*/

#define rD(i) (register_file[(i).byte0])
#define rA(i) (register_file[(i).byte1])
#define rB(i) (register_file[(i).byte2])
#define rO(i) (register_file[(i).byte2])
#define rT(i) (register_file[(i).byte0])
#define rS(i) (register_file[(i).byte0])
#define rPC   (register_file[PC])




word* mem_value(const TCB_Virtualization const* virt, VirtualAddress virtual) {
  if ( virtual >= ADDRESS_SPACE_SIZE ) { return NULL; }
  else { return (word*) (virt->base_addr + virtual); }
}




void print_register_file(word* register_file) {
  int row = 0;
  int col = 0;
  byte n = 0;

  const int coln = 4;
  
  /* register_file in decimal */
  for (row = 0; row < (256 / coln); ++row) {
    for (col = 0; col < coln; ++col) {
      printf("%02x: %i   ", n, register_file[coln*row+col]);
      ++n;
    }
    printf("\n");
  }

  /* register_file in hex */
  n = 0;
  for (row = 0; row < (256/coln); ++row) {
    for (col = 0; col < coln; ++col) {
      printf("%02x: 0x%08x   ", n, register_file[coln*row+col]);
      ++n;
    }
    printf("\n");
  }
}








ErrorCode decode_and_execute_instruction( TCB* tcb, const Instruction i, word* register_file) {
  switch ( i.opcode ) {
  case ADD:  rD(i) = rA(i) + rB(i); break;
  case SUB:  rD(i) = rA(i) - rB(i); break;
  case MUL:  rD(i) = rA(i) * rB(i); break;

  case AND:  rD(i) = rA(i) & rB(i); break;
  case OR:   rD(i) = rA(i) | rB(i); break;
  case XOR:  rD(i) = rA(i) ^ rB(i); break;

  case SHRA: rD(i) = rA(i) >> 1; break;
  case SHRL: rD(i) = ((int) ((unsigned int) rA(i)) >> 1); break;
  case SHL:  rD(i) = rA(i) << 1; break;

  case LDHI:
    { rD(i) &= 0x0000FFFF;
      rD(i) |= (((word) i.byte1) << 24);
      rD(i) |= (((word) i.byte2) << 16);
    } break;
  case LDLO:
    { rD(i) &= 0xFFFF0000;
      rD(i) |= (((word) i.byte1) << 8);
      rD(i) |= ((word) i.byte2);
    } break;

  case JEZ:  if ( rT(i) == 0x0 ) { rPC = rA(i) - 4; }; break;

  case LOAD:
    { word* p = mem_value( & tcb->virtualization , (VirtualAddress) (rA(i) + rO(i)) );
      if ( NULL == p ) return ERROR_LOAD;
      
      rD(i) = *p;
    } break;
  case STORE:
    { word* p = mem_value( & tcb->virtualization , (VirtualAddress) (rA(i) + rO(i)) );
      if ( NULL == p ) return ERROR_STORE;
      
      *p = rS(i);
    } break;
  }

  return NO_ERROR;
}




void export_thread_into(ExportBuffer* const buffer, word* register_file) {
  unsigned int index;
  for ( index = 0 ; index < NUMBER_REGISTERS ; ++ index )
  {
	buffer->register_file[index] = register_file[index];
    if (buffer->register_file[index] != register_file[index])
    {
        printf("Interpreter export error on register %d!\n",index);
    }
  }
}

void import_thread_from(ImportBuffer* buffer, word* register_file) {
  unsigned int index;
  for ( index = 0 ; index < NUMBER_REGISTERS ; ++ index )
  {
	register_file[index] = buffer->register_file[index];
  }
}

void* interpreter_entry_point_import(void* tcb) {
  word register_file[NUMBER_REGISTERS];
  TCB_Communication* const comm = & ((TCB*)tcb)->communication;

  import_thread_from( comm->data.import_buffer_addr, register_file);

  ErrorCode status = interpreter( (TCB*) tcb, register_file );
  hthread_exit( (void*) status );
}

void* interpreter_entry_point(void* tcb) {
  word register_file[NUMBER_REGISTERS];

  rPC = 0;      // Initialize PC

  ErrorCode status = interpreter( (TCB*) tcb, register_file );
  hthread_exit( (void*) status );
}

ErrorCode interpreter(TCB* tcb, word * register_file) {
  TCB_Communication* const comm = & tcb->communication;


  { /* initialize the interpreter's private state */

    //rPC = 0;

  }


  
  while (1) {

    { /* check for messages */

      if ( ISSET( comm->control.start_exporting ) ) {
    	UNSET( comm->control.start_exporting );
	    export_thread_into( comm->data.export_buffer_addr, register_file);
	    SET( comm->control.done_exporting );

	    return NO_ERROR;
      }
	
    }
    
    

    { /* fetch-decode-execute for a time slice */

      int count;
      for ( count = 0 ; count < TIME_SLICE_SIZE ; ++ count ) {

	if ( 0xFFFFFFFF == rPC ) {    /* thread is halting */
	  comm->data.return_value = register_file[RET_VAL];
	  SET( comm->control.done_interpreting );

	  return NO_ERROR;
	}


	/* fetch instruction */
	word* p = mem_value( & tcb->virtualization, (VirtualAddress) rPC );
	if ( NULL == p ) {
	  return ERROR_FETCH;
	}

	{
	  ErrorCode status =
	    decode_and_execute_instruction( tcb , *((Instruction*) p), register_file);

	  if ( NO_ERROR != status ) {
	    return status;
	  }
	}

	rPC += 4;

      } /* for */
    }



    hthread_yield();

  } /* while */


  return ERROR_DEAD_CODE;
}
