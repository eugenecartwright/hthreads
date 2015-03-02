#include <stdio.h>
#include <errno.h>
#include <hthread.h>
#include <stdarg.h>
#include <arch/arch.h>
#include <arch/htime.h>


#define NUM_THREADS (10)

/*
 * <Variable Initialization>
 */

// Task structure
struct task {
  int task_id;
  void (*function_pointer) (void *);
  void * data;
  struct task *next;
};

// Thread pool structure
struct threadpool {
    int total_tasks;
    int request_errors;
    hthread_mutex_t * task_queue_mutex;
    hthread_cond_t * active_task;
    int thr_id[NUM_THREADS];
    hthread_t p_threads[NUM_THREADS];
    struct task * head_ptr;
    struct task * tail_ptr;
};
// Utility Prototypes
void aprintf(char* fmt, ...);
void wait(int seconds);
void wait_on_lock(hthread_mutex_t * lock);
void set_priority(hthread_t, Hint);
Huint get_priority(void);

// Global Mutex used to prevent interleaved printf output
hthread_mutex_t print_mutex;

/*
 * <ThreadPool Methods>
 */

void add_task(struct threadpool * tp, int task_num, void (*fp) (void *), void * data)
{
  struct task *enqueue_task;
  int rs;

  // Create task structure to add to work queue
  enqueue_task = (struct task *) malloc(sizeof(struct task));

  if (!enqueue_task) {
    tp->request_errors++;
    return;
  }

  enqueue_task->task_id = task_num;
  enqueue_task->function_pointer = fp;
  enqueue_task->data = data;
  enqueue_task->next = NULL;

  // Lock mutex to update shared queue info
  rs = hthread_mutex_lock(tp->task_queue_mutex);

  if (tp->total_tasks == 0) {
    tp->head_ptr = enqueue_task;
    tp->tail_ptr = enqueue_task;
  } else {
    tp->tail_ptr->next = enqueue_task;
    tp->tail_ptr = enqueue_task;
  }

  tp->total_tasks++;

  // Release mutex and signal worker threads
  rs = hthread_mutex_unlock(tp->task_queue_mutex);

  rs = hthread_cond_signal(tp->active_task);
}

struct task * get_task(struct threadpool * tp)
{
  struct task * task;

  // Return a task from the queue if possible (no need to lock mutexes as they are pre-locked before entering this function)
  if (tp->total_tasks > 0) {
    task = tp->head_ptr;
    tp->head_ptr = task->next;

    if (tp->head_ptr == NULL) {
      tp->tail_ptr = NULL;
    }
    tp->total_tasks--;
  } else {
    task = NULL;
  }

  return task;
}

void execute_task(struct task *task)
{
  // If task is non-NULL execute it
  if (task) {
    (task->function_pointer)(task->data);
  }
}

void *handle_requests_loop(void *data)
{
  int rs;
  struct task *task;
  struct threadpool * tp = (struct threadpool *)data;

  // Pre-lock mutex
  rs = hthread_mutex_lock(tp->task_queue_mutex);

  while (1) {
    // Check to see if there are any tasks to execute
    if (tp->total_tasks > 0) {
      // If so, then grab one
      task = get_task(tp);
      aprintf("TID %d, got task!\n",hthread_self());


      if (task) {
    	// If the task is valid, then release lock
	    rs = hthread_mutex_unlock(tp->task_queue_mutex);

    	// Execute task
	    execute_task(task);
    	free(task);

        // Yield to allow another thread to do some work if possible
        hthread_yield();

    	// Re-acquire for next round
	    rs = hthread_mutex_lock(tp->task_queue_mutex);
      } else {
    	// Otherwise, wait for tasks
	    rs = hthread_cond_wait(tp->active_task, tp->task_queue_mutex);
      }
    } else {
      // Release lock and processor, let someone else do some work
      hthread_mutex_unlock(tp->task_queue_mutex);
      hthread_yield();

      // Re-acquire
      hthread_mutex_lock(tp->task_queue_mutex);
    }
  }
  return (void*)99;
}

int thread_pool_init(struct threadpool * tp, int num_threads)
{
  int iterator;

  for (iterator = 0; iterator < num_threads; iterator++) {
    tp->thr_id[iterator] = iterator;
    hthread_create(&(tp->p_threads[iterator]), NULL, handle_requests_loop, (void *) tp);
  }
  return 0;
}


/*
 * </ThreadPool Methods>
 */

void func(void * x)
{
  aprintf("Hello %d\n",(int)x);
}

void func2(void * x)
{
  aprintf("Arf %d Arf %d\n",(int)x,(int)x*2);
}


int main()
{
  struct threadpool tp;
  hthread_mutex_t task_queue_mutex;
  hthread_cond_t active_task;

  // Init. global print mutex
  hthread_mutex_init(&print_mutex, NULL);

  // Setup mutex
  printf("Setting up mutex...");
  hthread_mutexattr_t mta;
  hthread_mutexattr_settype(&mta, HTHREAD_MUTEX_RECURSIVE_NP);
  hthread_mutexattr_setnum(&mta, 1);
  hthread_mutex_init(&task_queue_mutex, &mta);
  printf("DONE\n");

  // Setup cond. var
  printf("Setting up cond.var...");
  hthread_condattr_t cta;
  hthread_condattr_init(&cta);
  hthread_cond_init(&active_task, &cta);
  printf("DONE\n");

  // Setup threadpool struct
  tp.task_queue_mutex = &task_queue_mutex;
  tp.active_task = &active_task;
  tp.total_tasks = 0;
  tp.request_errors = 0;
  tp.head_ptr = NULL;
  tp.tail_ptr = NULL;

  // Init threadpool
  printf("Creating thread pool...");
  thread_pool_init(&tp, 8);
  printf("DONE\n");

  int i;
  void (*x) (void *);
  void (*y) (void *);
  x = func;
  y = func2; 
  for (i = 0; i < 15; i++) {
    aprintf("Adding task %d...\n", i);
    if (i %4 == 0)
    {
        add_task(&tp, i, *x, (void*)i);
    }
    else
    {
        add_task(&tp, i, *y, (void*)i);
    }
  }

  aprintf("Waiting for completion...\n");
  while (tp.total_tasks > 0) {
    aprintf("Main running (%d)...\n", tp.total_tasks);
    hthread_yield();
  }
  aprintf("DONE!!!\n");

  /*
    while(1)
    {
    hthread_yield();
    }
  */
  return 0;
}

// Non-blocking busy-wait for a mutex.  Unlike the usual mutex_lock, this
// doesn't force a scheduling decision, and thus won't lead to a context
// switch.
void wait_on_lock(hthread_mutex_t * lock)
{
    while(hthread_mutex_trylock(lock) != SUCCESS)
    {
        wait(1);
    }
}


// An "atomic" printf function.  Any process calling this function spins
// on the global print_mutex; this prevents the output from printfs by
// physically concurrent threads from being interleaved.
void aprintf(char* fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    wait_on_lock(&print_mutex);
    vprintf(fmt, args);
    hthread_mutex_unlock(&print_mutex);
    va_end(args);
}


// Non-blocking wait.
void wait(int seconds)
{
    arch_clock_t done = _arch_get_time() + CLOCKS_PER_SEC * seconds;
    while(_arch_get_time() < done)
    {
        int i;
        int a = 0;
        for(i = 0; i < 10000; i++)
            a = a + 1;
    }
}


// Set the priority of the given thread.
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


// Return the priority of the currently-running thread.
Huint get_priority(void)
{
    struct sched_param pr;
    Hint pol;
    hthread_getschedparam(hthread_self(), &pol, &pr);
    Huint priority = pr.sched_priority;
    return priority;
}
