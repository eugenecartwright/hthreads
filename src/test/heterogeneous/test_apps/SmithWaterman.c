/* SmithWaterman.c program
 * Author: Eugene Cartwright
 * Date: Unknown
 * Modified 1/20/2015
 *
 * TODO: Program is too memory bound. Need to localize
 * the data.
 */
#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <arch/htime.h>

#define NUM_THREADS (5)
#define QUERY_SIZE  (32+2)
#define LIB_SIZE    (32+2)
#define EMPTY       (-1)    // Empty means this cell hasn't been put on queue
#define TAKEN       (-2)    // Means this cell is currently beeing computed by another thread
#define AVAILABLE   (-3)    // Means this cell is on the queue
#define max(a,b)    ((a) > (b) ? (a):(b))
#define min(a,b)    ((a) < (b) ? (a):(b))
#define match       (2)
#define mismatch    (-1)
#define deletion    mismatch
#define insertion   mismatch
#define QUEUE_SIZE  (min(QUERY_SIZE,LIB_SIZE)*2)    //How big?

#define OPCODE_FLAGGING

typedef struct {
    int **ptr;              
    hthread_mutex_t * lock; 
    int * queue;            
    int * head;
    int * tail;
} data;

//prototypes
void * SmithW_thread (void * arg );
int **make_matrix(int rows, int cols);
void check(int ** ptr, int x, int y);
void printArray(int** table, int row, int col);
hthread_mutex_t create_mutex();
hthread_attr_t create_attr();

#ifndef     HETERO_COMPILATION
#include    "SmithWaterman_prog.h"
#endif

#ifndef HETERO_COMPILATION

hthread_time_t start PRIVATE_MEMORY, stop PRIVATE_MEMORY;
hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;

int main(void) {

   printf("--- SmithWaterman ---\n"); 
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();

   int ** table = make_matrix(QUERY_SIZE, LIB_SIZE);

   char QUERY[QUERY_SIZE] = {'T','C','T','A','A','A','T','A','C',
       'T','C','T','C','A','A','T','G','C','C','G','G',
       'G','G','G','G','G','A','T','T','A','T','C'};

   char LIB[LIB_SIZE] = {'T','C','T','G','A','A','T','A','C','T',
       'C','T','C','A','A','C','G','C','C','G','G','G',
       'G','G','G','G','A','T','T','A','T','C' };

   // Malloc some stuff
   int * queue = malloc(sizeof(int)*QUEUE_SIZE);
   if (queue == NULL) { 
       printf("MALLOC error!\n");
       while(1);
   }

   // insert trials here
   // Initialize table
   int j=0,i=0;
   for(i=0;i<QUERY_SIZE;i++){
       for(j=0;j<LIB_SIZE;j++){
           table[i][j] = EMPTY;
           if(i==1 || j == 1)
               table[i][j] = 0;
       }
   }
   for (i=2; i< QUERY_SIZE;i++)
       table[i][0] = (int)QUERY[i-2];
   for(j=2; j<LIB_SIZE+2;j++)
       table[0][j] = (int)LIB[j-2];

   int tail = 0, head = 0;
   hthread_mutex_t lock = create_mutex();
   for (i = 0; i < NUM_THREADS; i++) 
     hthread_attr_init(&attr[i]);

   //set up data package
   data temp;   temp.ptr = table;  temp.queue = queue; temp.head = &head;  
   temp.tail = &tail;   temp.lock = &lock;

   
   //push first item to queue (x,y) = (2,2) and update head and tail
   queue[0] = 2; queue[1] = 2;
   head = 0; tail = 2;

   start = hthread_time_get();
   //create threads
   for (j = 0; j < NUM_THREADS; j++) {       
       if (thread_create(&tid[j],&attr[j],SmithW_thread_FUNC_ID,(void *) &temp, DYNAMIC_HW, 0)) {
           printf("Error creating thread %d\n", j+1);
           while(1);
       }
   }

   //join threads
   for(j = 0; j < NUM_THREADS; j++) {
      if (thread_join(tid[j],&ret[j],&exec_time[j] )) {
         printf("Error when joining threads\n");
         return 0;
      }
   }
   stop = hthread_time_get();
   
   // Display thread times
   for (i = 0; i < NUM_THREADS; i++) { 
      // Determine which slave ran this thread based on address
      Huint base = attr[i].hardware_addr - HT_HWTI_COMMAND_OFFSET;
      Huint slave_num = (base & 0x00FF0000) >> 16;
      printf("Execution time (TID : %d, Slave : %d, Iterations : %d)  = %f usec\n", tid[i], slave_num, (unsigned) ret[i], hthread_time_usec(exec_time[i]));
   }

   // Display OS overhead
   printf("Total OS overhead (thread_create) = %f usec\n", hthread_time_usec(create_overhead));
   printf("Total OS overhead (thread_join) = %f usec\n", hthread_time_usec(join_overhead));
   create_overhead=0;
   join_overhead=0;

   // Display overall time
   hthread_time_t diff; hthread_time_diff(diff, stop, start);
   printf("Total time = %f usec\n", hthread_time_usec(diff));

   printArray(table, QUERY_SIZE, LIB_SIZE);

   return 0;
}
#endif

//Algorithm, here
void * SmithW_thread (void * arg ) {
    int a, b, c,d_dummy, dest_x, dest_y,Continue = 1;
    data * temp = (data *) arg;
    int iterations = 0;
    while (Continue == 1) {
        
        // Acquire lock
        hthread_mutex_lock(temp->lock);
        
        if (*(temp->head) == *(temp->tail)) { //Empty
            if (temp->ptr[QUERY_SIZE-1][LIB_SIZE-1] >= 0){ //Last one computed?
                Continue = 0;               
            }
            hthread_mutex_unlock(temp->lock);
        }
        else {
            iterations++;
            // dequeue AVAILABLE spot at head of queue
            // and mark TAKEN
            dest_x = temp->queue[*(temp->head)];
            dest_y = temp->queue[*(temp->head)+1];
            temp->ptr[dest_x][dest_y] = TAKEN;
            *(temp->head) = (*(temp->head) + 2) % QUEUE_SIZE;
            
            //Unlock
            hthread_mutex_unlock(temp->lock);

            // Need to check if a,b,c are available before computing
            //Perhaps you don't need this since using a FIFO
            //TODO: Remove
            check(temp->ptr, dest_x, dest_y);
        
            // if same character, d = a
            if ( temp->ptr[dest_x][0] == temp->ptr[0][dest_y]) 
                a = temp->ptr[dest_x-1][dest_y-1] + match;
            else
                a = temp->ptr[dest_x-1][dest_y-1] + mismatch;
            b = temp->ptr[dest_x-1][dest_y] + deletion;
            c = temp->ptr[dest_x][dest_y-1] + insertion;
                temp->ptr[dest_x][dest_y]= min(((temp->ptr[dest_x-1][dest_y-1]) + 2), a);
            d_dummy = max(b,c);
            d_dummy = max(d_dummy,0);
            temp->ptr[dest_x][dest_y] = max(a,d_dummy);

            hthread_mutex_lock(temp->lock);
        
            // TODO: How big should the queue be?

            // Enqueue cell that is to the right
            if (dest_y+1 != LIB_SIZE ) {  //if not last column
                if (temp->ptr[dest_x][dest_y+1] == EMPTY) { //if not on queue
                    temp->queue[*(temp->tail) + 0] =  dest_x;
                    temp->queue[*(temp->tail) + 1] =  dest_y+1;
                    temp->ptr[dest_x][dest_y+1] = AVAILABLE; //mark "on queue"
                    *(temp->tail) = (*(temp->tail) + 2) % QUEUE_SIZE;
                }
            }
            // Enqueue cell that is below
            if (dest_x+1 != QUERY_SIZE ) {  //if not last row
                if (temp->ptr[dest_x+1][dest_y] == EMPTY) { //if not on queue
                    temp->queue[*(temp->tail) + 0] =  dest_x+1;
                    temp->queue[*(temp->tail) + 1] =  dest_y;
                    temp->ptr[dest_x+1][dest_y] = AVAILABLE; //mark "on queue"
                    *(temp->tail) = (*(temp->tail) + 2) % QUEUE_SIZE;
                }
            }
            hthread_mutex_unlock(temp->lock);
        } //end else
    } //end while

    return ( (void *) iterations);
}

int **make_matrix(int rows, int cols) {
    int **ptr;
    ptr = malloc(sizeof(int *) * rows);
    if (ptr == NULL) {
        printf("ROW MALLOC error!\n");
        while(1);
    }
    int i = 0;
    for (i = 0; i < rows; i++) {
        ptr[i] = malloc(sizeof(int) * cols);
        if (ptr[i] == NULL) {
            printf("MALLOC error!\n");
            while(1);
        }
    }
    return ptr;
}

// is a,b,c available?
void check (int ** ptr,int x, int y) {
    int check = 0;
    while (!check) {
        if (ptr[x-1][y-1] >= 0)
            if (ptr[x][y-1] >= 0)
                if (ptr[x-1][y] >= 0)
                    check = 1;
    }
}

void printArray(int** table, int row, int col) {
    int i, j;
    for (i = 0; i < row; i++) {
        for(j = 0; j < col; j++) {
            if( (i == 0 && j>1) || (i>1 && j==0))
                printf("%2c ", (char)table[i][j]);
            else
                printf("%2d ",table[i][j]);
        }
        printf("\n");
    }
}

hthread_mutex_t create_mutex() {
    static int num = 0;
    //Initialze attribute for mutex
    hthread_mutexattr_t attr;
    hthread_mutexattr_init (&attr);
    hthread_mutexattr_setnum (&attr, num++);  //not compatible with pthreads
     
    //Create Mutex
    hthread_mutex_t my_mutex;
    hthread_mutex_init (&my_mutex, &attr);
    return my_mutex;
}

hthread_attr_t create_attr() {
    hthread_attr_t attr;
    hthread_attr_init (&attr);

    //For portability reasons when changing to hthreads
    hthread_attr_setdetachstate (&attr, HTHREAD_CREATE_JOINABLE);
    return attr;
}
