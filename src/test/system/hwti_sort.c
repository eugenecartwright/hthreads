#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <util/rops.h>

#define LOG_SERIAL 1
#include <log/log.h>

#define ARRAY_SIZE 2000
#define HWTI_ZERO_BASEADDR (void*)(0x63000000)
#define HWTI_ONE_BASEADDR (void*)(0x63010000)

struct sortData {
    Huint * startAddr;
    Huint * endAddr;
	Huint cacheOption;
};

void createData(struct sortData *);
void quickSort(Huint *, Huint *);
void* quickSortThread(void*);

void readHWTStatus( void* baseAddr) {
    printf( "  HWT Thread ID %x \n", read_reg(baseAddr) );
    printf( "  HWT Status  %x \n", read_reg(baseAddr + 0x00000008) );
    printf( "  HWT Command %x \n", read_reg(baseAddr + 0x0000000C) );
    printf( "  HWT Argument %x \n", read_reg(baseAddr + 0x00000010) );
    printf( "  HWT Result %x \n", read_reg(baseAddr + 0x00000014) );
    printf( "  HWT Reg Master Write %x \n", read_reg(baseAddr + 0x00000024) );
    printf( "  HWT DEBUG SYSTEM %x \n", read_reg(baseAddr + 0x00000028) );
    printf( "  HWT DEBUG USER %x \n", read_reg(baseAddr + 0x0000002C) );
    printf( "  HWT Timer %d \n", read_reg(baseAddr + 0x00000034) );
    printf( "  HWT Stack Pointer %x \n", read_reg(baseAddr + 0x00000038) );
    printf( "  HWT Frame Pointer %x \n", read_reg(baseAddr + 0x0000003C) );
    printf( "  HWT Heap Pointer %x \n", read_reg(baseAddr + 0x00000040) );
}

int main(int argc, char *argv[]) {
    hthread_t thread[4];
    hthread_attr_t attr[4];
    struct sortData input[4];
    log_t log;
	Huint i;

	printf( "Starting...\n" );
	for( i=0; i<4; i++ )
    	hthread_attr_init( &attr[i] );
    hthread_attr_sethardware( &attr[0], HWTI_ZERO_BASEADDR );
    hthread_attr_sethardware( &attr[1], HWTI_ONE_BASEADDR );

    input[0].startAddr = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint));
    input[1].startAddr = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint));
    input[2].startAddr = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint));
    input[3].startAddr = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint));
    //input[0].startAddr = (void*)0x63002000;
    //input[1].startAddr = (void*)0x63012000;
	input[0].endAddr = input[0].startAddr + ARRAY_SIZE - 1;
	input[1].endAddr = input[1].startAddr + ARRAY_SIZE - 1;
	input[2].endAddr = input[2].startAddr + ARRAY_SIZE - 1;
	input[3].endAddr = input[3].startAddr + ARRAY_SIZE - 1;

	for( i=0; i<4; i++ )
	    createData(&input[i]);

    log_create( &log, 1024 );

    log_time( &log );
    hthread_create(&thread[0], &attr[0], NULL, (void*)&input[0]);
    //hthread_create(&thread[1], &attr[1], NULL, (void*)&input[1]);
    //hthread_create(&thread[0], &attr[0], quickSortThread, (void*)&input[0]);
    //hthread_create(&thread[1], &attr[1], quickSortThread, (void*)&input[1]);
    //hthread_create(&thread[2], &attr[2], quickSortThread, (void*)&input[2]);
    //hthread_create(&thread[3], &attr[3], quickSortThread, (void*)&input[3]);
    hthread_join(thread[0], NULL);
    //hthread_join(thread[1], NULL);
    //hthread_join(thread[2], NULL);
    //hthread_join(thread[3], NULL);
    log_time( &log );

	//for( ptr = input[0].startAddr; ptr <= input[0].endAddr; ptr++ ) {
	//	printf( "%d\n", *ptr );
	//}

	readHWTStatus( HWTI_ZERO_BASEADDR );
	//readHWTStatus( HWTI_ONE_BASEADDR );
    printf( "Program Completed Successfull\n" );
    log_close_ascii( &log );

	for( i=0; i<4; i++ )
		free( input[i].startAddr );
    return EXIT_SUCCESS;
}

void createData( struct sortData * data) {
	Huint * ptr;
	//if ( data->startAddr == 0 ) printf( "Warning\n" );
	for( ptr = data->startAddr; ptr <= data->endAddr; ptr++ ) {
		*ptr = rand() % 1000;
	}
	data->cacheOption = 0;
}

void * quickSortThread( void * input ) {
	struct sortData * data;
	Huint * startAddr, * endAddr;

	//printf( "Inside quickSortThread\n" );
	data = (struct sortData *) input;
	startAddr = data->startAddr;
	endAddr = data->endAddr;

	fflush( stdout );
    quickSort( startAddr, endAddr );

	return NULL;
}

void quickSort(Huint * startPtr, Huint * endPtr) {
	Huint pivot;
	Huint * leftPtr, * rightPtr;
	Huint temp, * tempPtr;

	fflush( stdout );
	if ( startPtr == endPtr ) { return; }

	leftPtr = startPtr;
	rightPtr = endPtr;

	pivot = (*leftPtr + *rightPtr)/2;

	while (leftPtr < rightPtr) {
		while ((leftPtr < rightPtr) && (*leftPtr <= pivot) ) {
			leftPtr++;
		}

		while((leftPtr <= rightPtr) && (*rightPtr > pivot) ) {
			rightPtr--;
		}

		if ( leftPtr < rightPtr ) {
			temp = *leftPtr;
			*leftPtr = *rightPtr;
			*rightPtr = temp;
		}
	}
	
	if ( leftPtr == rightPtr ) {
		if ( *rightPtr >= pivot ) {
			leftPtr = rightPtr - 1;
		} else {
			rightPtr++;
		}
	} else {
		if ( *rightPtr > pivot ) {
			leftPtr = rightPtr - 1;
		} else {
			tempPtr = leftPtr;
			leftPtr = rightPtr;
			rightPtr = tempPtr;
		}
	}
	
	quickSort( rightPtr, endPtr );
	quickSort( startPtr, leftPtr );
}

