#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <hthread.h>

#include "stringMatching.h"

#define LOG_SERIAL 1
#include <log/log.h>

#define NUMBER_STRINGS 129
#define NUMBER_PACKETS 1
#define NUMBER_THREADS 1
#define PACKET_LENGTH 1024

struct subString {
    Huint charString;
    Huint ignore;
    Huint stringNumber;
    struct subString * parrallelPtr;
    struct subString * nextPtr;
};

struct threadArgument {
    hthread_mutex_t * packetMutex;
    hthread_mutex_t * foundStringMutex;
    Huint * packetIndex;
    Huint * foundStringIndex;
    Huint * foundStrings;
    Huint sPrimaryCount;
    Huint sSecondaryCount;
    char * T;
};

struct subString * globalSPrimary;
hthread_mutex_t * globalFoundStringMutex;
Huint * globalFoundStringIndex;
Huint * globalFoundStrings;
Huint globalSPrimaryCount;

void reportString( Huint stringNum ) {
	Huint index;
	
	//printf( "String %d was found\n", stringNum );
	hthread_mutex_lock( globalFoundStringMutex );
	index = *globalFoundStringIndex;
	globalFoundStrings[ index ] = stringNum;
	*globalFoundStringIndex = index+1;
	hthread_mutex_unlock( globalFoundStringMutex );
}

//If match is called, that means there is match, thus far, including all
//words up to and including tIndex.  
void match( char * T, Huint tIndex, struct subString * subStringPtr ) {
	Huint charString;
	
	//printf( "Running match with tIndex=%d\n", tIndex );
	if ( tIndex >= 1020 ) return;
	
	charString = *(Huint *)&T[ tIndex+4 ];
	//printf( " charString = %x\n", charString );
	//printf( " charString = %x\n", subStringPtr->charString );
	//printf( " ignore = %x\n", subStringPtr->ignore );
	
	if ( (subStringPtr->ignore==0 && charString == subStringPtr->charString)
		|| (subStringPtr->ignore==1 && (charString & 0xFFFFFF00) == (subStringPtr->charString & 0xFFFFFF00) )
		|| (subStringPtr->ignore==2 && (charString & 0xFFFF0000) == (subStringPtr->charString & 0xFFFF0000) )
		|| (subStringPtr->ignore==3 && (charString & 0xFF000000) == (subStringPtr->charString & 0xFF000000) ) ) {
		if ( subStringPtr->stringNumber > 0 ) {
			reportString( subStringPtr->stringNumber );
		}
		if ( subStringPtr->nextPtr != NULL ) {
			match( T, tIndex+4, subStringPtr->nextPtr );
		}
	}
	
	if ( subStringPtr->parrallelPtr != NULL ) {
		match( T, tIndex, subStringPtr->parrallelPtr );
	}
	
}

struct subString * search (Huint charString) {
	Huint lowIndex = 0;
	Huint highIndex = globalSPrimaryCount-1;
	Huint midIndex;
	
	//printf( "Running search with charString = %x low=%x high=%x\n", charString, globalSPrimary[lowIndex].charString, globalSPrimary[highIndex].charString );
	if ( charString < globalSPrimary[lowIndex].charString ) return NULL;
	if ( charString == globalSPrimary[lowIndex].charString ) return &globalSPrimary[lowIndex];
	if ( charString > globalSPrimary[highIndex].charString ) return NULL;
	if ( charString == globalSPrimary[highIndex].charString ) return &globalSPrimary[highIndex];
	
	while ( lowIndex <= highIndex ) {
		midIndex = (lowIndex + highIndex) / 2;
		//printf( " midIndex=%d\n", midIndex );
		if ( charString > globalSPrimary[midIndex].charString ) lowIndex = midIndex+1;
		else if ( charString < globalSPrimary[midIndex].charString ) highIndex = midIndex-1;
		else return &globalSPrimary[midIndex];
	}
	
	return NULL;
}

void * workerThread( void * arg ) {
	struct threadArgument * argument;
	struct subString * subStringPtr;
	char * T;
	Huint i, index;
	Huint charString;
	
	argument = (struct threadArgument *) arg;
	
	while( 1 ) {	
		//Determine what, if any work, needs to be done
		hthread_mutex_lock( argument->packetMutex );
		index = *argument->packetIndex;
		*argument->packetIndex = index + 1;
		hthread_mutex_unlock( argument->packetMutex );
		//printf( "Thread %d running with index = %d\n", hthread_self(), index );
		fflush( stdout );
	
		//Exit if all work is done
		if ( index >= NUMBER_PACKETS ) break;
		
		//Create a local copy of T
		T = &argument->T[ index * PACKET_LENGTH ];
		
		//Loop through each character in T
		for( i = 0; i<1021; i++ ) {
			charString = *(Huint *)&T[i];
			//printf( "Loop i=%d, T[i]=%x, charString=%c%c%c%c\n", i, &T[i], charString >> 24, charString >> 16, charString >> 8, charString );
			subStringPtr = search( charString );
			
			if ( subStringPtr != NULL ) {
				if ( subStringPtr->stringNumber > 0 ) {
					reportString( subStringPtr->stringNumber );
				}
				match( T, i, subStringPtr->nextPtr );
			}
		}
	}

	return NULL;
}

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
    hthread_mutex_t foundStringMutex;
    hthread_t threads[NUMBER_THREADS];
    int i, j, k, packetIndex, foundStringIndex, foundStrings[1000];
    int secondaryIndex, maxStringLength;
	log_t log;

	//Create the strings
	string129_4( S );

	//printf( "Creating se
    //printf( "Creating data packets\n" );
    // Create the data packets
    T = (char *) malloc( NUMBER_PACKETS * PACKET_LENGTH * sizeof( char ) );
    for( i=0; i< NUMBER_PACKETS * PACKET_LENGTH; i++ ) {
    	T[i] = 65 + (rand() % 10);
    }
    printf( T );
    
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
    globalSPrimaryCount = j;
    printf( "globalSPrimaryCount = %d\n", globalSPrimaryCount );
    
    printf( "creating S'-Secondary\n" );
    // Create S'-Secondary
    sSecondary = (struct subString *) malloc( NUMBER_STRINGS * 2 * sizeof( struct subString ) );
    secondaryIndex=-1;
    for( i=1; i<((maxStringLength / 4) + maxStringLength % 4); i++ ) {
    k=0;
		//for( i=1; i<2; i++ )
		for( j=0; j< NUMBER_STRINGS; j++ ) {
			printf( "sLocation[%d]=%d\n", j, sLocation[j] );
			
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
					printf( "Loop %d, Looking to update nextPtr for %d with loc=%d\n", i, j, sLocation[j] );
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
			printf( "sLocation[%d]=%d\n", j, sLocation[j] );
		}
	}

    printf( "Primary\n" );
    for( j=0; j< globalSPrimaryCount; j++ ) {
    	printf( "j=%d, %x charString=%x ignore=%d stringNumber=%d, par=%x, next=%x\n", 
			j, 
			(Huint)&sPrimary[j], 
			sPrimary[j].charString, 
			sPrimary[j].ignore, 
			sPrimary[j].stringNumber, 
			(Huint)sPrimary[j].parrallelPtr, 
			(Huint)sPrimary[j].nextPtr );
    }
    printf( "Secondary\n" );
    for( j=0; secondaryIndex > 0 && j <= secondaryIndex; j++ ) {
    	printf( "j=%d, %x charString=%x ignore=%d stringNumber=%d, par=%x, next=%x\n", 
			j, 
			(Huint) &sSecondary[j], 
			sSecondary[j].charString, 
			sSecondary[j].ignore, 
			sSecondary[j].stringNumber, 
			(Huint) sSecondary[j].parrallelPtr, 
			(Huint) sSecondary[j].nextPtr );
    }

if ( 1 ) {    
    //printf( "initializaing stuff\n" );
    //Initialize the packetMutex and packetIndex
    hthread_mutex_init(&packetMutex, NULL);
    hthread_mutex_init(&foundStringMutex, NULL);
    packetIndex=0;
    foundStringIndex=0;
    globalSPrimary = sPrimary;
    globalFoundStringIndex = &foundStringIndex;
    globalFoundStringMutex = &foundStringMutex;
    globalFoundStrings = &foundStrings[0];
   
    log_create( &log, 1024 );
	log_time( &log );
    // Create the thread arguments and then create the threads
    for( i=0; i < NUMBER_THREADS; i++ ) {
    	//printf( "Creating thread %d\n", i );
    	threadArguments[i].packetMutex = &packetMutex;
    	threadArguments[i].foundStringMutex = &foundStringMutex;
    	threadArguments[i].packetIndex = &packetIndex;
    	threadArguments[i].foundStringIndex = &foundStringIndex;
    	threadArguments[i].T = T;
    	threadArguments[i].foundStrings = &foundStrings[0];
    	threadArguments[i].sPrimaryCount = globalSPrimaryCount;
        hthread_create( &threads[i], NULL, workerThread, (void*) &threadArguments[i] );
    }
    
    // Idle while the threads do their thing
    for( i=0; i < NUMBER_THREADS; i++ ) {
    	//printf( "Joining on thread%d\n", i );
    	hthread_join( threads[i], NULL );
    }
	log_time( &log );
    
    for( i=0; i < foundStringIndex; i++ ) {
    	printf( "Found string %d\n", foundStrings[i] );
    }
    
}
    free( T );
    free( sPrimary );
    free( sSecondary );
    printf( " -- End of Program --\n" );
	log_close_ascii( &log );

	return 0;
}
