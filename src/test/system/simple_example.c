#include<hthread.h>
#include <stdio.h>

int my_func(int a, int b, int c)
{
    return a + b + c;
}

typedef struct
{
    int a;
    int b;
    int c;
    int result;
} thread_arg_t;

void * my_func_thread(void * arg)
{
    thread_arg_t * targ;

    // Casting the (void*) arg into a real thread arg
    targ = (thread_arg_t *)arg;

    // Calculate answer, and place back in argument struct
    targ->result = my_func(targ->a, targ->b, targ->c);
    
    return (void *) targ->result;
}

int main()
{
    int a;
    int b;
    int c;
    int result;

    a = 5;
    b = 6;
    c = 10;

    // Normal Call
    result = my_func(a, b, c);
    printf("Answer = %d\n",result);

    // Thread Call
    thread_arg_t xx;
    xx.a = a;
    xx.b = b;
    xx.c = c;
    xx.result = 0;

    hthread_t tid;
    hthread_create(&tid, NULL, my_func_thread, (void*)&xx);
    hthread_join(tid, NULL);
    printf("Answer = %d\n",xx.result);


    return 0;
}
