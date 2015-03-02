#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>

#define NUM_THREADS (4)
#define NUM_JOBS    (10)

// ************************************************
// ThreadPool Data Structures
// ************************************************

// Task structure
struct task {
  int task_id;
  void (*function_pointer) (void *);
  void *data;
  struct task *next;
};

// Thread pool structure
struct threadpool {
  int total_tasks;
  int request_errors;
  hthread_mutex_t *task_queue_mutex;
  hthread_cond_t *active_task;
  int thr_id[NUM_THREADS];
  hthread_t p_threads[NUM_THREADS];
  struct task *head_ptr;
  struct task *tail_ptr;
};

// ************************************************
// ThreadPool Library Functions
// ************************************************

void add_task(struct threadpool *tp, int task_num, void (*fp) (void *), void *data)
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

struct task *get_task(struct threadpool *tp)
{
  struct task *task;

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
  // If task is non-NULL execute it (and pass data pointer to it)
  if (task) {
    (task->function_pointer) (task->data);
  }
}

void *handle_requests_loop(void *data)
{
  int rs;
  struct task *task;
  struct threadpool *tp = (struct threadpool *) data;

  // Pre-lock mutex
  rs = hthread_mutex_lock(tp->task_queue_mutex);

  while (1) {

      // Check to see if there are any tasks to execute
      if (tp->total_tasks > 0) {
          // If so, then grab one
          task = get_task(tp);
          //printf("TID %d, got task!\n",hthread_self());

          if (task) {
              // If the task is valid, then release lock
              rs = hthread_mutex_unlock(tp->task_queue_mutex);

              // Execute task
              execute_task(task);
              free(task);

              // Yield to allow another thread to do some work if possible
              hthread_yield();

              // Re-acquire lock for next round
              rs = hthread_mutex_lock(tp->task_queue_mutex);
          } else {
              // Otherwise, wait for tasks
              rs = hthread_cond_wait(tp->active_task, tp->task_queue_mutex);
          }

      } else {
          // Release lock and processor, let someone else do some work
          hthread_mutex_unlock(tp->task_queue_mutex);
          hthread_yield();

          // Re-acquire lock when the thread resumes execution
          hthread_mutex_lock(tp->task_queue_mutex);

      }

  }
  return (void *) 99;
}

int thread_pool_init(struct threadpool *tp, int num_threads)
{
  int i;

  for (i = 0; i < num_threads; i++) {
      // Setup thread identifier
      tp->thr_id[i] = i;
  
      // Create worker thread and store POSIX ID
      hthread_create(&(tp->p_threads[i]), NULL, handle_requests_loop, (void *) tp);
  }
  return 0;
}


/*
 * </ThreadPool Methods>
 */

typedef struct {
  int tid;
  int done;
} func_arg_t;

void func(void *x)
{
  func_arg_t *targ = (func_arg_t *) x;

  printf("Hello %d\n", targ->tid);

  targ->done = targ->tid + 1;
}

void func2(void *x)
{
  func_arg_t *targ = (func_arg_t *) x;
  int a = targ->tid;

  printf("Arf %d Arf %d\n", a, (int) a * 2);

  targ->done = targ->tid + 1;
}


int main()
{
  struct threadpool tp;
  hthread_mutex_t task_queue_mutex;
  hthread_cond_t active_task;
  func_arg_t args[NUM_JOBS];

  // Setup mutex
  printf("Setting up mutex...");
  hthread_mutexattr_t mta;
  hthread_mutexattr_settype(&mta, HTHREAD_MUTEX_RECURSIVE_NP);
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
  thread_pool_init(&tp, NUM_THREADS);
  printf("DONE\n");

  int i;
  void (*x) (void *);
  void (*y) (void *);
  x = func;
  y = func2;
  for (i = 0; i < NUM_JOBS; i++) {
    printf("Adding task %d...\n", i);

    args[i].tid = i;
    args[i].done = 0;

    if (i % 4 == 0) {
      add_task(&tp, i, *x, (void *) &(args[i]));
    } else {
      add_task(&tp, i, *y, (void *) &(args[i]));
    }
  }

  printf("Waiting for completion...\n");
  for (i = 0; i < NUM_JOBS; i++) {
    while (args[i].done == 0) {
      hthread_yield();
    }
    printf("Job %d complete! - retval = %d\n", i, args[i].done);
  }
  printf("DONE!!!\n");

  return 0;
}
