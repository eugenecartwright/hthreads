/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Arkansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <hthread.h>
#include <config.h>
#include <util/rops.h>

#define ARRAY_SIZE 20
#define MAX_VALUE  500

#define LOG_SERIAL 1
#include <log/log.h>

#define BUBBLE_THRESHHOLD 8
#define USE_HWTI 1
#define HWTI_BASEADDR (void*)(0x63000000)

hthread_mutex_t mutexHw;

struct sortData {
    Huint * data;
	Huint size;
};

void  FillBuffer( Huint * );
void* QuickSort(void* input);
void* BubbleSort(void* input);
void  swap(Huint* x, Huint* y);

int main(int argc, char *argv[]) {
    hthread_t thread;
    struct sortData input;
    Huint sum;
	Huint * Buffer;
	log_t log;

	hthread_mutex_init( &mutexHw, NULL );

    Buffer = (Huint*) malloc(ARRAY_SIZE * sizeof(Huint));

    FillBuffer( Buffer );

    sum = 0;
    input.data = Buffer;
    input.size = ARRAY_SIZE;

    //for( i = 0; i<ARRAY_SIZE; i++ ) { printf( "%d=>%d\n", i, Buffer[i] ); }
    //for( i = 0; i<ARRAY_SIZE; i++ ) { sum += Buffer[i]; }
	log_create( &log, 1024 );
	log_time( &log );

    hthread_create(&thread, NULL, QuickSort, (void*) &input);
    hthread_join(thread, NULL);

	log_time( &log );
    //for( i = 0; i<ARRAY_SIZE; i++ ) { printf( "%d=>%d\n", i, Buffer[i] ); }
    //for( i = 0; i<ARRAY_SIZE; i++ ) { sum -= Buffer[i]; }
	//printf( "Sum = %d\n", sum );

    printf( "Program Completed Successfull\n" );
	log_close( &log );
    free(Buffer);

    return EXIT_SUCCESS;
}

void FillBuffer( Huint * Buffer ) {
    Huint counter;
    Huint blah;
    Huint ModParam = MAX_VALUE + 1;

    blah = 119;
    for(counter = 0; counter < ARRAY_SIZE; counter++)
		//Erik's random number generator 
        Buffer[counter] = (Huint) (blah * counter + 71)%ModParam;
}

void* QuickSort(void* input) {
    Huint Pivot, Max, Min, CurrentValue, CompareIndex, SwapIndex;
    hthread_t thread1, thread2;
    struct sortData * myInput, input1, input2;
	hthread_attr_t attrHw;
    Huint Start, End, i, joinThread1, joinThread2;
	Huint * Buffer;

	hthread_attr_init( &attrHw );
	hthread_attr_sethardware( &attrHw, HWTI_BASEADDR );

	myInput = (struct sortData*) input;
	Buffer = myInput->data;
    Start = 0;
    End = myInput->size - 1;
	joinThread1 = 0;
	joinThread2 = 0;

    printf( "Inside QuickSort start=%d, end=%d\n", Start, End );

    //Use the average between the start and end value for pivot
    Pivot = Buffer[Start];
    Max = Pivot;
    Min = Pivot;

    CurrentValue = 0;
    CompareIndex = Start;
    SwapIndex = End;

    //Move the value to one of two buckets, > or < pivot
    while(CompareIndex < SwapIndex) {
        if (Buffer[CompareIndex] > Pivot) {
            swap(&Buffer[CompareIndex], &Buffer[SwapIndex]);
            SwapIndex--;
        } else {
            CompareIndex++;
        }

        CurrentValue = Buffer[CompareIndex];

        Max = ( Max > CurrentValue ? Max : CurrentValue );
        Min = ( Min < CurrentValue ? Min : CurrentValue );
    }

    //printf( "Max = %d, Min = %d \n", Max, Min );
    if ( Min == Max ) {
        return NULL;
    }

    if( !(CurrentValue > Pivot) )
        CompareIndex++;

    if(Pivot == Max) {
        swap(&Buffer[Start], &Buffer[End]);
        CompareIndex = End;
    }

    //Create two new threads to sort pivotted data
	input1.data = &Buffer[Start];
	input1.size = CompareIndex;
	if ( input1.size == 1 ) {
	    //do nothing, sequence of 1 already is sorted
	} else if ( input1.size <= BUBBLE_THRESHHOLD ) {
		//create a bubble sort thread to sort
	    if ( USE_HWTI ) {
            printf( "addr = %p, data = %p count = %d\n", &input1, input1.data, input1.size );
			for(i=0; i<input1.size; i++) {printf( " %d->%d\n", i, input1.data[i] );}
			hthread_mutex_lock( &mutexHw );
            hthread_create(&thread1, &attrHw, NULL, (void*)&input1);
            hthread_join(thread1, NULL);
			printf( "  HWT Result %x \n", read_reg(HWTI_BASEADDR + 0x00001400) );
			printf( "  HWT Argument %x \n", read_reg(HWTI_BASEADDR + 0x00001000) );
			hthread_mutex_unlock( &mutexHw );
			for(i=0; i<input1.size; i++) {printf( " %d->%d\n", i, input1.data[i] );}
		} else {
            hthread_create(&thread1, NULL, BubbleSort, (void*) &input1);
		    joinThread1 = 1;
		}
	} else {
	    //create a quick sort thread to sort
        hthread_create(&thread1, NULL, QuickSort, (void*) &input1);
		joinThread1 = 1;
	}

    input2.data = &Buffer[CompareIndex];
	input2.size = End - CompareIndex + 1;
	if ( input2.size == 1 ) {
	    //do nothing, sequence of 1 already is sorted
	} else if ( input2.size <= BUBBLE_THRESHHOLD ) {
		//create a bubble sort thread to sort
	    if ( USE_HWTI ) {
            printf( "addr = %p, data = %p count = %d\n", &input2, input2.data, input2.size );
			for(i=0; i<input2.size; i++) {printf( " %d->%d\n", i, input2.data[i] );}
			hthread_mutex_lock( &mutexHw );
            hthread_create(&thread2, &attrHw, NULL, (void*)&input2);
            hthread_join(thread2, NULL);
			printf( "  HWT Result %x \n", read_reg(HWTI_BASEADDR + 0x00001400) );
			printf( "  HWT Argument %x \n", read_reg(HWTI_BASEADDR + 0x00001000) );
			hthread_mutex_unlock( &mutexHw );
			for(i=0; i<input2.size; i++) {printf( " %d->%d\n", i, input2.data[i] );}
		} else {
            hthread_create(&thread2, NULL, BubbleSort, (void*) &input2);
		    joinThread2 = 1;
		}
	} else {
	    //create a quick sort thread to sort
        hthread_create(&thread2, NULL, QuickSort, (void*) &input2);
		joinThread2 = 1;
	}

	hthread_attr_destroy( &attrHw );
	if ( joinThread1 ) hthread_join(thread1, NULL);
    if ( joinThread2 ) hthread_join(thread2, NULL);

    return NULL;
}

void* BubbleSort(void* input) {
	struct sortData * myInput;
    Huint Start, End;
	Huint * Buffer;
    Huint OuterCounter;
    Huint InnerCounter;

    Huint OCUBound;
    Huint ICUBound;

	myInput = (struct sortData*) input;
	Buffer = myInput->data;
    Start = 0;
    End = myInput->size - 1;

    //printf( "Inside BubbleSort start=%d, end=%d\n", Start, End );

    OCUBound = End - Start;
    for(OuterCounter = 0; OuterCounter < OCUBound; OuterCounter++) {
       ICUBound = End - OuterCounter;
       for(InnerCounter = Start; InnerCounter < ICUBound; InnerCounter++) {
         if(Buffer[InnerCounter] > Buffer[InnerCounter+1])
            swap(&Buffer[InnerCounter], &Buffer[InnerCounter+1]);
       }
    }
    return NULL;
}

void swap(Huint* x, Huint* y)
{
    Huint temp = *x;
    *x = *y;
    *y = temp;
}

