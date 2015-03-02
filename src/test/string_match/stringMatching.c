#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <hthread.h>
#include "stringMatching.h"

#define LOG_SERIAL 1
#include <log/log.h>

#define HWTI_ZERO_BASEADDR (void*)(0x63000000)
#define HWTI_ONE_BASEADDR (void*)(0x63010000)
#define HWTI_ZERO_INITHEAP (void*)(0x63007600)
#define HWTI_ONE_INITHEAP (void*)(0x63017600)

#define NUMBER_STRINGS 129
#define NUMBER_PACKETS 1
#define NUMBER_THREADS 1
#define PACKET_LENGTH 1024

void readHWTStatus( void* baseAddr) {
    printf( "  HWT Thread ID %x \n", read_reg(baseAddr) );
    printf( "  HWT Status  %x \n", read_reg(baseAddr + 0x00000008) );
    printf( "  HWT Command %x \n", read_reg(baseAddr + 0x0000000C) );
    printf( "  HWT Argument %x \n", read_reg(baseAddr + 0x00000010) );
    printf( "  HWT Result %x \n", read_reg(baseAddr + 0x00000014) );
    printf( "  HWT Reg Master Write %x \n", read_reg(baseAddr + 0x00000024) );
    //printf( "  HWT DEBUG SYSTEM %x \n", read_reg(baseAddr + 0x00000028) );
	//printf( "  HWT DEBUG USER %x \n", read_reg(baseAddr + 0x0000002C) );
    printf( "  HWT Timer %d \n", read_reg(baseAddr + 0x00000004) );
    //printf( "  HWT Stack Pointer %x \n", read_reg(baseAddr + 0x00000030) );
    //printf( "  HWT Frame Pointer %x \n", read_reg(baseAddr + 0x00000034) );
    //printf( "  HWT Heap Pointer %x \n", read_reg(baseAddr + 0x00000038) );
    //printf( "  HWT 8B Dynamic Table %x \n", read_reg(baseAddr + 0x00000040) );
    //printf( "  HWT 32B Dynamic Table %x \n", read_reg(baseAddr + 0x00000044) );
    //printf( "  HWT 1024B Dynamic Table %x \n", read_reg(baseAddr + 0x00000048) );
    //printf( "  HWT Unlimited Dynamic Table %x \n", read_reg(baseAddr + 0x0000004C) );
}


struct subString {
    Huint charString;
    Huint ignore;
    Huint stringNumber;
    struct subString * parrallelPtr;
    struct subString * nextPtr;
	Huint * threadAddr;
};

struct threadArgument {
    hthread_mutex_t * packetMutex;
    Huint * packetIndex;
    Huint * foundStringIndex;
    Huint * foundStrings;
    Huint sPrimaryCount;
    Huint sSecondaryCount;
    char * T;
};

Huint stringMatch( char* a, char* b, Huint length ) {
	Huint i;
	
	if ( strlen( a ) < length ) return 0;
	if ( strlen( b ) < length ) return 0;

	for( i=0; i<length; i++ ) {
		if ( a[i] != b[i] ) return 0;
	}
	return 1;
}
								
int main(int argc, char *argv[]) {
    char * T;    //The text string(s) to analize
    char * S[NUMBER_STRINGS];
    int sLocation[NUMBER_STRINGS];
    struct subString* sPrimary;
    struct subString* sSecondary;
    struct threadArgument threadArguments[NUMBER_THREADS];
    hthread_mutex_t packetMutex;
    hthread_t threads[NUMBER_THREADS];
	hthread_attr_t attributes[2];
    int i, j, k, packetIndex, foundStringIndex, foundStrings[1000];
	int sPrimaryCount, sSecondaryCount;
    int secondaryIndex, maxStringLength;
	Huint *sPtr, value;

    //printf( "Creating data packets\n" );
    // Create the data packets
    T = (char *) malloc( NUMBER_PACKETS * PACKET_LENGTH * sizeof( char ) );
    for( i=0; i< NUMBER_PACKETS * PACKET_LENGTH; i++ ) {
    	T[i] = 65 + (rand() % 3);
    }
    printf( T );

	// Create search strings
	string129_8( S );
    
    printf( "creating S'-Primary\n" );
    // Create S'-Primary
    sPrimary = (struct subString *) malloc( NUMBER_STRINGS * sizeof( struct subString ) );
    maxStringLength = 0;
    j = 0;
    for( i=0; i< NUMBER_STRINGS; i++ ) {
    	// Only create a new struct if first four characters is not the same as previous
    	if ( i == 0 || (i>0 && *(Huint *)S[i] != *(Huint *)S[i-1] )) {
			// Copy the first four characters into the struct
			sPrimary[j].charString = *(Huint *)S[i];
			
			// Don't ignore any of the characters
			sPrimary[j].ignore = 0;
			
			// Initialize the string number
			sPrimary[j].stringNumber = (strlen( S[i] ) == 4) ? (i+1) : 0;
			
			// void out the parrallel and next ptr
			sPrimary[j].parrallelPtr = NULL;
			sPrimary[j].nextPtr = NULL;
			
			j++;
		}
		
		sLocation[i] = (0-j);
		maxStringLength = (maxStringLength < strlen( S[i] ) ) ? strlen( S[i] ) : maxStringLength;
    }
	sPrimaryCount = j;

    printf( "creating S'-Secondary\n" );
    // Create S'-Secondary
    sSecondary = (struct subString *) malloc( NUMBER_STRINGS * 2 * sizeof( struct subString ) );
    secondaryIndex=-1;
    for( i=1; i<((maxStringLength / 4) + maxStringLength % 4); i++ ) {
    k=0;
		//for( i=1; i<2; i++ )
		for( j=0; j< NUMBER_STRINGS; j++ ) {
			//printf( "sLocation[%d]=%d\n", j, sLocation[j] );
			
			// Build sSecondary for strings longer than i*4
			if ( strlen( S[j] ) > 4*i ) {
				//Check to see if we need to create a new sSecondary dataset
				// we do if 1) j==0
				// or 2) current and previous strings don't match thus far
				if ( j==0 || ! stringMatch( S[j], S[j-1], 4*(i+1) ) ) {
					secondaryIndex++;
					sSecondary[ secondaryIndex ].charString = *(Huint *)(S[j]+4*i);
					
					//set default pointers
					sSecondary[ secondaryIndex ].parrallelPtr = NULL;
					sSecondary[ secondaryIndex ].nextPtr = NULL;
					
					//set the ignore
					if ( strlen( S[j] ) >= 4*(i+1) )
						sSecondary[ secondaryIndex ].ignore = 0;
					else
						sSecondary[ secondaryIndex ].ignore = 4 - strlen( S[j] ) % 4;
					
					//For each new secondary dataset we create, may need to update a next ptr
					//printf( "Loop %d, Looking to update nextPtr for %d with loc=%d\n", i, j, sLocation[j] );
					if ( sLocation[j] < 0 ) {
						//Update a primary next pointer
						if ( sPrimary[ (0-sLocation[j])-1 ].nextPtr == NULL ) {
							sPrimary[ (0-sLocation[j])-1 ].nextPtr = &sSecondary[ secondaryIndex ];
						}
					} else {
						//Update s secondary next pointer
						if ( sSecondary[ sLocation[j] ].nextPtr == NULL ) {
							sSecondary[ sLocation[j] ].nextPtr = &sSecondary[ secondaryIndex ];
						}
					}
	
	
					//Check to see if we need to update the parrallel pointer
					if ( k>0 
						&& sLocation[j-1] == secondaryIndex-1 
						&& stringMatch( S[j], S[j-1], 4*(i) ) ) {
						sSecondary[ secondaryIndex-1 ].parrallelPtr = &sSecondary[ secondaryIndex ];
					}
	
					//Check to see if this is the end of the string
					if ( strlen( S[j] ) <= 4*(i+1) ) {
						sSecondary[ secondaryIndex ].stringNumber = j+1;
					}
				k++;
				}
				sLocation[ j ] = secondaryIndex;
				
			}
			//printf( "sLocation[%d]=%d\n", j, sLocation[j] );
		}
	}
	sSecondaryCount = (secondaryIndex >= 0) ? secondaryIndex + 1 : 0;

	//Assign each s structure an address
	sPtr = (Huint *) HWTI_ZERO_INITHEAP;
	sPtr = sPtr - 2*(sPrimaryCount + sSecondaryCount);
    for( i=0; i< sPrimaryCount; i++ ) {
		sPrimary[i].threadAddr = sPtr;
		sPtr += 2;
	}
    for( i=0; i< sSecondaryCount; i++ ) {
		sSecondary[i].threadAddr = sPtr;
		sPtr += 2;
	}

if ( 1 ) {
    printf( "Primary\n" );
    for( i=0; i< sPrimaryCount; i++ ) {
    	printf( "i=%d, %x charString=%x ignore=%d stringNumber=%d, par=%x, next=%x, addr=%x\n", 
			i, 
			(Huint) &sPrimary[i], 
			sPrimary[i].charString, 
			sPrimary[i].ignore, 
			sPrimary[i].stringNumber, 
			(Huint) sPrimary[i].parrallelPtr, 
			(Huint) sPrimary[i].nextPtr,
			(Huint) sPrimary[i].threadAddr );
    }

    printf( "Secondary\n" );
    for( i=0; i < sSecondaryCount; i++ ) {
    	printf( "i=%d, %x charString=%x ignore=%d stringNumber=%d, par=%x, next=%x, addr=%x\n", 
			i, 
			(Huint) &sSecondary[i], 
			sSecondary[i].charString, 
			sSecondary[i].ignore, 
			sSecondary[i].stringNumber, 
			(Huint) sSecondary[i].parrallelPtr, 
			(Huint) sSecondary[i].nextPtr,
			(Huint) sSecondary[i].threadAddr );
    }
}


	//Stuff sPrimary into the hardware threads local memory
	printf( "Primary\n" );
    for( i=0; i<sPrimaryCount; i++ ) {
		//Record the control data
		value = 0;
		
		value = sPrimary[i].ignore << 30;

		value = value | sPrimary[i].stringNumber << 18;

		if ( sPrimary[i].nextPtr != NULL ) {
			value = value | ( ( (Huint) (sPrimary[i].nextPtr)->threadAddr ) & 0x000FFFF8 ) >> 3;
		}

		if ( sPrimary[i].parrallelPtr != NULL ) {
			value = value | 0x00020000;
		}

		sPtr = sPrimary[i].threadAddr;
		*(sPtr + 1) = value;
		*(sPtr) = sPrimary[i].charString;

		//printf( "%x data=%x control=%x\n", 
		//	(Huint) sPtr, 
		//	*(sPtr), 
		//	*(sPtr + 1) );
	}

	//Stuff sSecondary into the hardware threads local memory
	printf( "Secondary\n" );
    for( i=0; i<sSecondaryCount; i++ ) {
		//Record the control data
		value = 0;
		
		value = sSecondary[i].ignore << 30;

		value = value | sSecondary[i].stringNumber << 18;

		if ( sSecondary[i].nextPtr != NULL ) {
			value = value | ( ( (Huint) (sSecondary[i].nextPtr)->threadAddr ) & 0x000FFFF8 ) >> 3;
		}

		if ( sSecondary[i].parrallelPtr != NULL ) {
			value = value | 0x00020000;
		}

		sPtr = sSecondary[i].threadAddr;
		*(sPtr + 1) = value;
		*(sPtr) = sSecondary[i].charString;

		//printf( "%x data=%x control=%x\n", 
		//	(Huint) sPtr, 
		//	*(sPtr), 
		//	*(sPtr + 1) );
	}

if ( 1 ) {
    //printf( "initializaing stuff\n" );
    //Initialize the packetMutex and packetIndex
    hthread_mutex_init(&packetMutex, NULL);
    packetIndex=0;
    foundStringIndex=0;
	for( i=0; i<1000; i++ ) {foundStrings[i] = 0;}
   
    // Create the thread attributes, to say they are hardware threads
	hthread_attr_init( &attributes[0] );
	hthread_attr_init( &attributes[1] );
	hthread_attr_sethardware( &attributes[0], HWTI_ZERO_BASEADDR );
	hthread_attr_sethardware( &attributes[1], HWTI_ONE_BASEADDR );

	readHWTStatus( HWTI_ZERO_BASEADDR );

    // Create the thread arguments and then create the threads
    for( i=0; i < NUMBER_THREADS; i++ ) {
    	printf( "Creating thread %d\n", i );
    	threadArguments[i].packetMutex = &packetMutex;
    	threadArguments[i].packetIndex = &packetIndex;
    	threadArguments[i].foundStringIndex = &foundStringIndex;
    	threadArguments[i].foundStrings = &foundStrings[0];
    	threadArguments[i].sPrimaryCount = sPrimaryCount;
    	threadArguments[i].sSecondaryCount = sSecondaryCount;
    	threadArguments[i].T = T;

		printf( " argument %x \n", (Huint) &threadArguments[i] );
		printf( " mutex    %x %x \n", (Huint) &threadArguments[i].packetMutex, (Huint) threadArguments[i].packetMutex );
		printf( " index    %x %x \n", (Huint) &threadArguments[i].packetIndex, (Huint) threadArguments[i].packetIndex );
		printf( " fs index %x %x \n", (Huint) &threadArguments[i].foundStringIndex, (Huint) threadArguments[i].foundStringIndex );
		printf( " foundStr %x %x \n", (Huint) &threadArguments[i].foundStrings, (Huint) threadArguments[i].foundStrings );
		printf( " sPrimCnt %x %x \n", (Huint) &threadArguments[i].sPrimaryCount, (Huint) threadArguments[i].sPrimaryCount);
		printf( " sSecCnt  %x %x \n", (Huint) &threadArguments[i].sSecondaryCount, (Huint) threadArguments[i].sSecondaryCount);
		printf( " T        %x %x \n", (Huint) &threadArguments[i].T, (Huint) threadArguments[i].T );

        hthread_create( &threads[i], &attributes[i], NULL, (void*) &threadArguments[i] );
    }
    
	readHWTStatus( HWTI_ZERO_BASEADDR );

    // Idle while the threads do their thing
    for( i=0; i < NUMBER_THREADS; i++ ) {
    	printf( "Joining on thread%d\n", i );
    	hthread_join( threads[i], NULL );
    }

    for( i=0; i < foundStringIndex; i++ ) {
    	printf( "Found string %d\n", foundStrings[i] );
    }
    
}
    free( T );
    free( sPrimary );
    free( sSecondary );
    printf( " -- End of Program --\n" );

	return 0;
}
