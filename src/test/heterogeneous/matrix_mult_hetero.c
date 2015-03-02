#include <hthread.h>

#define USE_FAST
//#define DEBUG_DISPATCH
#define NUM_TRIALS      (10)
#define NUM_THREADS     (6)
#define MATRIX_A_ROW    (20)
#define MATRIX_A_COL    (20)
#define MATRIX_B_ROW    (20)
#define MATRIX_B_COL    (20)

typedef struct
{
  int currentRow;
  int matrixA[MATRIX_A_ROW][MATRIX_A_COL];
  int matrixB[MATRIX_B_ROW][MATRIX_B_COL];
  int matrixC[MATRIX_A_ROW][MATRIX_B_COL];
  hthread_mutex_t lock;			//used to read currentRow
} data;

//static int currentRow = 0;  //gives a thread a unique row

hthread_mutex_t create_mutex ();
hthread_attr_t create_attr ();
//hthread_cond_t create_cond();

void
show_matrix (int matrix[][MATRIX_B_COL])
{
  int i, j;
  printf ("\n");
  for (i = 0; i < MATRIX_B_ROW; i++) {
	for (j = 0; j < MATRIX_B_COL; j++) {
	  printf ("%d ", matrix[i][j]);
	}
	printf ("\n");
  }
}


void *
matrix_mult_thread (void *arg)
{

  int myRow, colA, colB;

  data *targ = (data *) arg;
  myRow = 0;
  while (1) {
	hthread_mutex_lock (&(targ->lock));
	if (targ->currentRow >= MATRIX_A_ROW) {
	  break;
	}
	else {
	  myRow = targ->currentRow++;
	}
	hthread_mutex_unlock (&(targ->lock));

#ifdef USE_FAST
	int fastRow[MATRIX_A_COL];
	int result;
	for (colA = 0; colA < MATRIX_A_COL; colA++) {
	  fastRow[colA] = targ->matrixA[myRow][colA];
	}

	for (colB = 0; colB < MATRIX_B_COL; colB++) {
	  result = 0;
	  for (colA = 0; colA < MATRIX_A_COL; colA++) {
		result += fastRow[colA] * targ->matrixB[colA][colB];
	  }
	  targ->matrixC[myRow][colB] = result;
	}
#else

	for (colB = 0; colB < MATRIX_B_COL; colB++) {
	  for (colA = 0; colA < MATRIX_A_COL; colA++) {
		targ->matrixC[myRow][colB] +=
		  targ->matrixA[myRow][colA] * targ->matrixB[colA][colB];
	  }
	}
#endif
  }
  hthread_mutex_unlock (&(targ->lock));
  return (void *) 0;
}

#ifndef HETERO_COMPILATION
#include "matrix_mult_hetero_prog.h"
//#include "hetero_time_lib.h"
#endif

#ifdef HETERO_COMPILATION
int
main ()
{
  return 0;
}
#else
int
main ()
{

  int i, j;
  hthread_t threads[NUM_THREADS];
  hthread_attr_t attr = create_attr ();
  //hthread_mutex_t my_mutex = create_mutex(); 

  // Create timer
  unsigned int start, stop;
  //xps_timer_t timer;
  //xps_timer_create (&timer, (int *) 0x20400000);

  // Start timer
  //xps_timer_start (&timer);


  printf("MATRIX MULT (begin)\n");
  data matrices;
  printf ("Size: %d\n", sizeof (matrices));
  matrices.lock = create_mutex ();
  matrices.currentRow = 0;

  //Initialize the matrices : row-major
   printf("MATRIX MULT (init data)\n");
  for (i = 0; i < MATRIX_A_ROW; i++) {	//A
	for (j = 0; j < MATRIX_A_COL; j++) {
	  matrices.matrixA[i][j] = i + j;
	  matrices.matrixB[i][j] = i + j;
	  matrices.matrixC[i][j] = 0;
	}
  }

  printf ("ROW x ROW\n");
  float sum = 0.0;
  int counter = 0, trials = 0;
  //    for (counter = 1; counter <= NUM_THREADS; counter++){
  for (counter = NUM_THREADS; counter > 0; counter--) {
	printf ("Number of threads %d\n", counter);

    for (trials = 0; trials < NUM_TRIALS; trials++) {
	  //printf("MATRIX MULT (create threads)\n");
	  //start = xps_timer_read_counter (&timer);

      matrices.currentRow = 0;

      for (i = 0; i < counter; i++) {
		//if ( hthread_create(&threads[i],&attr,matrix_mult_thread,(void *) &matrices ) ) {
		if (dynamic_create_smart(&threads[i], &attr, matrix_mult_thread_FUNC_ID,(void *) &matrices)) {
		  printf ("Error when creating threads\n");
		  return 0;
		}
	  }

	  //Join
	  printf("MATRIX MULT (join threads)\n");
	  for (i = 0; i < counter; i++) {
		if (hthread_join (threads[i], NULL)) {
		  printf ("Error when joining threads\n");
		  return 0;
		}
	  }
	  //stop = xps_timer_read_counter (&timer);
	  if (trials != 0) {
		sum += (stop - start);
	  }
	}
	sum /= (NUM_TRIALS - 1);
	printf ("%0.2f\n", sum);
	sum = 0.0;
  }

  printf("MATRIX MULT (complete!)\n");

  //Stop timer
  //    show_matrix(matrices.matrixA);
  printf ("Timing = %d - %d = %d\n", stop, start, (stop - start));
  //printf("%d\n", (stop - start));

  return 0;
}
#endif

hthread_cond_t
create_cond ()
{

  static int num = 0;

  //Create attribute for conditional variable
  hthread_condattr_t attr;
  hthread_condattr_init (&attr);
  hthread_condattr_setnum (&attr, num++);	//not compatible with pthreads

  //Create conditional variable
  hthread_cond_t condv;
  hthread_cond_init (&condv, &attr);

  return condv;
}

hthread_mutex_t
create_mutex ()
{

  static int num = 0;
  //Initialze attribute for mutex
  hthread_mutexattr_t attr;
  hthread_mutexattr_init (&attr);
  hthread_mutexattr_setnum (&attr, num++);	//not compatible with pthreads

  //Create Mutex
  hthread_mutex_t my_mutex;
  hthread_mutex_init (&my_mutex, &attr);

  return my_mutex;
}

hthread_attr_t
create_attr ()
{

  hthread_attr_t attr;
  hthread_attr_init (&attr);
  //For portability reasons when changing to pthreads
  hthread_attr_setdetachstate (&attr, HTHREAD_CREATE_JOINABLE);

  return attr;
}
