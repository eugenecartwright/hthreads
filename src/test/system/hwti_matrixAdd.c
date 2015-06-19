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

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <util/rops.h>

// The base address of the hardware thread we are creating
#define HWT_ZERO_BASEADDR              (void*)(0x63000000)
#define HWT_ONE_BASEADDR               (void*)(0x63010000)
#define MATRIXSIZE 7000

#define LOG_SERIAL 1
#include <log/log.h>

void readHWTStatus( void * HWTI_BASEADDR ) {
    printf( "  HWT Thread ID %x \n", read_reg(HWTI_BASEADDR) );
    printf( "  HWT Verify %x \n", read_reg(HWTI_BASEADDR + 0x00000400) );
    printf( "  HWT Status  %x \n", read_reg(HWTI_BASEADDR + 0x00000800) );
    printf( "  HWT Command %x \n", read_reg(HWTI_BASEADDR + 0x00000C00) );
    printf( "  HWT Argument %x \n", read_reg(HWTI_BASEADDR + 0x00001000) );
    printf( "  HWT Result %x \n", read_reg(HWTI_BASEADDR + 0x00001400) );
    printf( "  HWT Reg Master Write %x \n", read_reg(HWTI_BASEADDR + 0x00002400) );
    printf( "  HWT DEBUG SYSTEM %x \n", read_reg(HWTI_BASEADDR + 0x00002800) );
    printf( "  HWT DEBUG USER %x \n", read_reg(HWTI_BASEADDR + 0x00002C00) );
    printf( "  HWT DEBUG CONTROL %x \n", read_reg(HWTI_BASEADDR + 0x00003000) );
    printf( "  HWT Timer %x \n", read_reg(HWTI_BASEADDR + 0x00003400) );
}

struct matrix {
	Huint size;
	Huint index;
	Huint * X;
	Huint * Y;
	Huint * Z;
	hthread_mutex_t * matrixMutex;
};

void * matrixAdd( void * inputData ) {
	struct matrix * inputMatrix;
	Huint size, count, myindex, x, y;

	printf( "Software thread starting\n" );
	inputMatrix = (struct matrix *) inputData;
	size = inputMatrix->size;
	count = 0;

	while ( 1 ) {
		//Increment matrix.index, to tell the next thread what element to add
		//printf( "Address of mutex is %x\n", inputMatrix->matrixMutex );
		hthread_mutex_lock( inputMatrix->matrixMutex );
		myindex = inputMatrix->index;
		inputMatrix->index = myindex+1;
		hthread_mutex_unlock( inputMatrix->matrixMutex );
		///hthread_yield();

		if ( myindex < size ) {
			x = inputMatrix->X[myindex];
			y = inputMatrix->Y[myindex];
			inputMatrix->Z[myindex] = x + y;
			count++;
		} else {
			break;
		}
	}
	printf( "count=%i\n", count );
	return NULL;
}

int main( int argc, char *argv[] ) {
    hthread_t       tid1, tid2, tid3, tid4;
    hthread_attr_t  attr1, attr2, attr3, attr4;
	hthread_mutex_t mutex;
    struct matrix	matrixData;
	Huint           i, j;
	log_t           log;

    // Initialize the hybridthreads system
	log_create( &log, 1024 );
	hthread_mutex_init( &mutex, NULL );
	matrixData.matrixMutex = &mutex;
	printf( "matrixMutex address is %x\n", (Huint)matrixData.matrixMutex );

    // Initialize the attributes for the threads
    hthread_attr_init( &attr1 );
    hthread_attr_init( &attr2 );
    hthread_attr_init( &attr3 );
    hthread_attr_init( &attr4 );

    // Setup the attributes for the hardware threads
    hthread_attr_sethardware( &attr1, HWT_ZERO_BASEADDR );
    hthread_attr_sethardware( &attr2, HWT_ONE_BASEADDR );

	// Initialize matrixData
	matrixData.size = MATRIXSIZE;
	matrixData.index = 0;
	matrixData.X = (Huint *) malloc( sizeof( Huint ) * MATRIXSIZE );
	matrixData.Y = (Huint *) malloc( sizeof( Huint ) * MATRIXSIZE );
	matrixData.Z = (Huint *) malloc( sizeof( Huint ) * MATRIXSIZE );
	printf( "X=%x\n", (Huint) matrixData.X );
	printf( "Y=%x\n", (Huint) matrixData.Y );
	printf( "Z=%x\n", (Huint) matrixData.Z );
	if ( matrixData.X == 0 
		|| matrixData.Y == 0
		|| matrixData.Z == 0 ) {
		printf( "malloc error\n" );
		return 0;
	}
	for( i = 0; i < MATRIXSIZE; i++ ) {
		matrixData.X[i] = i;
		matrixData.Y[i] = i;
		matrixData.Z[i] = 0;
	}

    // Create the hardware thread
    readHWTStatus( HWT_ZERO_BASEADDR );
    readHWTStatus( HWT_ONE_BASEADDR );
	//log_time( &log );
	j = hthread_create( &tid1, &attr1, NULL, (void*)(&matrixData) );
	printf( "hthread_create tid1 returned %x\n", j );
    j = hthread_create( &tid2, &attr2, NULL, (void*)(&matrixData) );
	printf( "hthread_create tid2 returned %x\n", j );
    j = hthread_create( &tid3, &attr3, matrixAdd, (void*)(&matrixData) );
	printf( "hthread_create tid3 returned %x\n", j );
    j = hthread_create( &tid4, &attr4, matrixAdd, (void*)(&matrixData) );
	printf( "hthread_create tid4 returned %x\n", j );

    //readHWTStatus( HWT_ZERO_BASEADDR );
    //readHWTStatus( HWT_ONE_BASEADDR );
	printf( "index = %i \n", matrixData.index );

    // Wait for the threads to exit
    j = hthread_join( tid1, NULL );
	printf( "hthread_join tid1 returned %x\n", j );
    j = hthread_join( tid2, NULL );
	printf( "hthread_join tid2 returned %x\n", j );
    j = hthread_join( tid3, NULL );
	printf( "hthread_join tid3 returned %x\n", j );
    j = hthread_join( tid4, NULL );
	printf( "hthread_join tid4 returned %x\n", j );
	//log_time( &log );

    readHWTStatus( HWT_ZERO_BASEADDR );
    readHWTStatus( HWT_ONE_BASEADDR );

	for( i = 0; i < MATRIXSIZE; i+=1 ) {
		//printf( "Z[%i]=%i\n", i, matrixData.Z[i] );
		if ( matrixData.Z[i] != 2 * i )
			printf( "Error at %i, matrix is %i \n", i, matrixData.Z[i] );
	}

    // Clean up the attribute structure
	printf( "attribute clean up\n" );
    hthread_attr_destroy( &attr1 );
    hthread_attr_destroy( &attr2 );
    hthread_attr_destroy( &attr3 );
    hthread_attr_destroy( &attr4 );

	//printf( "log dump\n" );
	//log_close_ascii( &log );
	free( matrixData.X );
	free( matrixData.Y );
	free( matrixData.Z );
    printf( "-- QED --\n" );

    // Return from main
    return 1;
}
