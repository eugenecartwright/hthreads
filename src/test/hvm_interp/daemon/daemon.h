#include <hthread.h>
#include "common/types.h"
#include "common/tcb.h"
#include "interpreter/interpreter.h"

#define MAX_SW_THREAD 10

typedef struct
{
	flag new_code;
	flag in_hw;
	byte *new_code_address;
	unsigned int new_code_size;
	hthread_t tid;
} DaemonComm;

typedef struct
{
	TCB entry;
	flag valid;
	byte memory[ADDRESS_SPACE_SIZE];
} TCBNode;


void *daemon_thread(void *arg);
void daemon_init(DaemonComm *dc);
void daemon_create_thread(DaemonComm *dc, byte *code, unsigned int code_size);
void daemon_create_hw_thread(DaemonComm *dc, byte *code, unsigned int code_size);


