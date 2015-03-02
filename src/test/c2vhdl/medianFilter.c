#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <util/rops.h>

#define LOG_SERIAL 1
#include <log/log.h>

#define HWTI_ZERO_BASEADDR (void*)(0x63000000)
#define HWTI_ONE_BASEADDR (void*)(0x63010000)

struct imageData {
    Huint * original;
    Huint * filtered;
    Huint xDim; 
	Huint yDim;
};

void createImage(struct imageData *);
void quickSort(Huint *, Huint *);
void* medianFilterThread(void*);

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
    printf( "  HWT Stack Pointer %x \n", read_reg(baseAddr + 0x00000030) );
    printf( "  HWT Frame Pointer %x \n", read_reg(baseAddr + 0x00000034) );
    printf( "  HWT Heap Pointer %x \n", read_reg(baseAddr + 0x00000038) );
    printf( "  HWT 8B Dynamic Table %x \n", read_reg(baseAddr + 0x00000040) );
    printf( "  HWT 32B Dynamic Table %x \n", read_reg(baseAddr + 0x00000044) );
    printf( "  HWT 1024B Dynamic Table %x \n", read_reg(baseAddr + 0x00000048) );
    printf( "  HWT Unlimited Dynamic Table %x \n", read_reg(baseAddr + 0x0000004C) );
}

int main(int argc, char *argv[]) {
    hthread_t thread;
    hthread_attr_t attr;
    struct imageData images;
	Huint x, y;
    log_t log;

	printf( "Starting...\n" );
	//Initialize the HWT's attributes
    hthread_attr_init( &attr );
    hthread_attr_sethardware( &attr, HWTI_ZERO_BASEADDR );

	//Create and initialize the image
    images.original = (Huint*) malloc(100 * 100 * sizeof(Huint));
    images.filtered = (Huint*) malloc(100 * 100 * sizeof(Huint));
	images.xDim = 100;
	images.yDim = 100;
	createImage(&images);

	//Create thelog file
    log_create( &log, 1024 );

	//Create the thread, wait till thread is done working
	printf( "Creating Threads...\n" );
    log_time( &log );
    //hthread_create(&thread, &attr, NULL, (void*)&images);
    hthread_create(&thread, NULL, medianFilterThread, (void*)&images);
    hthread_join(thread, NULL);
    log_time( &log );

	//Check to see if median filter worked, all values should be 1
	for( y=1; y<images.yDim-1; y++ ) {
		for( x=1; x<images.xDim-1; x++ ) {
			if (images.filtered[y*images.yDim + x] != 1) {
				printf( "Error at (%d,%d)\n", x, y );
				break;
			}
		}
	}

    printf( "Program Completed Successfull\n" );
    log_close_ascii( &log );

	free( images.original );
	free( images.filtered );
    return EXIT_SUCCESS;
}

void createImage(struct imageData * images) {
	Huint elements = images->yDim * images->xDim;
	Huint i;
	//Make every ninth element a 2
	for( i=0; i<elements; i++ ) {
		if ( i % 9 == 0 ) {
			images->original[i] = 2;
		} else {
			images->original[i] = 1;
		}
	}
}

void * medianFilterThread( void * input ) {
	struct imageData * images;
	Huint x, y, i, j, k;
	Huint temp[9];

	images = (struct imageData *) input;

	for( y=1; y<images->yDim-1; y++ ) {
		for( x=1; x<images->xDim-1; x++ ) {
			k=0;
			for( j=y-1; j<=y+1; j++ ) {
				for( i=x-1; i<=x+1; i++ ) {
					temp[k] = images->original[j*images->yDim + i];
					k++;
				}
			}
			quickSort( &temp[0], &temp[8] );
			images->filtered[y*images->yDim + x] = temp[4];
		}
	}

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

