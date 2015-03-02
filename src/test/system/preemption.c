#include <stdlib.h>
#include <stdio.h>
#include <hthread.h>

#define MAXCNT					    1
#define CONCUR					    5
#define LOOP_CNT					1
#define GOOD_PRIORITY               10+CONCUR
#define PRINT
#define PRIORITIES

// Global mutex
hthread_mutex_t mutex;

// Global history buffer and index
// * Each thread writes into the history buffer atomically before they exit
// * IDs in history buffer indicate execution order
int hist[CONCUR];
int my_index;

void set_priority( hthread_t th, Hint pri )
{
    Hint status;
    struct sched_param pr;

    pr.sched_priority = pri;
    status = hthread_setschedparam( th, SCHED_OTHER, &pr );
    if( status < 0 )
    {
        printf( "Set Priority Error: 0x%8.8x\n", status );
    }
}

void* simpleThread( void *arg )
{
    Huint 	i;
	Huint	cnt;
	Huint	tid;
    Huint   pri;
#ifdef PRIORITIES
    Hint    pol;
    struct sched_param pr;
#endif


	cnt = (Huint)arg;
	tid = hthread_self();

    printf("Thread (TID=%u) locking...\n",tid);
    hthread_mutex_lock(&mutex);
    printf("Thread (TID=%u) is awake!\n",tid);
#ifdef PRIORITIES
    hthread_getschedparam( tid, &pol, &pr );
    pri = pr.sched_priority;
#else
    pri = 0;
#endif
    
#ifdef PRINT
	printf( "Starting Thread:   (TID=%u) (CNT=%u) (PRI=%d)\n", tid, cnt, pri );
#endif
	
	for( i = 0; i < LOOP_CNT; i++ )
	{
#ifdef PRINT
		printf("Running Thread:    (TID=%u) (CNT=%u) (PRI=%d)\n",tid,cnt,pri);
#endif

		hthread_yield();
	}
	

    printf("Thread (TID=%u) unlocking...\n",tid);
    hthread_mutex_unlock(&mutex);

#ifdef PRINT
	printf( "Exiting Thread:    (TID=%u) (CNT=%u) (PRI=%d)\n", tid, cnt, pri );
#endif

    // Atomically update history buffer
    hthread_mutex_lock(&mutex);
    hist[my_index++] = cnt;
    hthread_mutex_unlock(&mutex);
    return NULL;
}

hthread_t create_new_thread( int ctr )
{
	hthread_t	tid;
    Huint 		status;

    printf("Before create...\r\n");
    status = hthread_create( &tid, NULL, simpleThread, (void*)ctr );
    printf("After create...\r\n");
	if( status != SUCCESS )
	{
		printf( "Create Error: (STA=0x%8.8x) (TID=%u) (CNT=%u)\n",status,tid, ctr );
        while(1);
	}
	
    return tid;
}

int main( int argc, char *argv[] )
{
	hthread_t	tid[ CONCUR ];
    Huint		status;
	Huint		cnt;
    Huint       pri;
	Huint		i;
	Huint		j;

    my_index = 0;

    printf( "Running preemption test...\n" );

    // Init. and pre-lock mutex
    hthread_mutex_init( &mutex, NULL );
    hthread_mutex_lock(&mutex);
    printf("Main thread pre-locking mutex\n");

	cnt = 0;
    pri = 100;
    for( i = 0; i < MAXCNT; i++ )
	{
        printf( "Create Iteration: %u\n", i );
		for( j = 0; j < CONCUR; j++ )
		{
        	tid[j] = create_new_thread( j );

			printf( "Created Thread: (TID=%u) (CNT=%u) (PRI=%u)\n", tid[j], cnt, pri);
            printf( "Improving priority...");
            set_priority( tid[j], GOOD_PRIORITY-j );
            printf( "DONE\n");

		}

        // Release mutex to let others continue
        printf("Main thread un-locking mutex...");
        hthread_mutex_unlock(&mutex);
        printf("UNLOCK DONE\n");
		
        printf( "Join Iteration: %u\n", i );
		for( j = 0; j < CONCUR; j++ )
		{
			printf( "Joining Thread:     (TID=%u)\n", tid[j] );
        	status = hthread_join( tid[j], NULL );
			printf( "Joined Thread:     (TID=%u) (STA=0x%08x)\n", tid[j],status);
		}
    }

    j = CONCUR - 1;
    int error = 0;
    for (i = 0; i < CONCUR; i++)
    {
        printf("History[%d] = %d (EXP = %d)\n",i,hist[i],j);
        if (hist[i] != j )
        {
            error++;
        }
        j--;
    }    
	printf( "--DONE-- (%d errors)\n", error);
	return 1;
}
