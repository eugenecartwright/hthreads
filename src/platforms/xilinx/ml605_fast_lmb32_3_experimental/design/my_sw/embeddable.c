#include "proc_hw_thread.h"
#include "pvr.h"

typedef struct{
	int x;
	char a;
	int y;
	char * str1;
	char * str2;
} targ_t;

int fdelay(int a)
{
	int delay = 0;
	int x, y;
	
	for (delay = 0; delay < 90000; delay++)
	{
		x = x + y + delay + a;
	}
	
	return x;
}


void * blink_thread(void * arg)
{
	int id;
	int count = 0;
	int cur_val = 0;
	int mask = (int)arg;
	volatile int *dir = (int*)0x81400004;
	volatile int *val = (int*)0x81400000;
	
	*dir = 0;

	getpvr(1,id);
	
	for (count = 0; count < 2; count++)
	{
		// *****************************
		// Set LED 
		// *****************************
		hthread_mutex_lock(0);
		
		// Read current LED value
		*dir = 0xFFFFFFFF;
		cur_val = *val;
		*dir = 0x00000000;
		
		// Set new LED value
		*val =  cur_val | mask;
		fdelay(22);

		// *****************************
		// Reset LED 
		// *****************************

		// Reset new LED value
		*val =  cur_val;
		fdelay(33);

		hthread_mutex_unlock(0);

	}

	return (void*)id;
}

void* crazy_thread(void *arg)
{
	targ_t *targ = (targ_t *)arg;
	int temp;
	
	targ->x = targ-> x + 10;
	targ->y = targ-> y + 20;
	
	temp = (int)targ->str1;
	targ->str1 = targ->str2;
	targ->str2 = (char*)temp;
	
	return (void*)(targ->y);
}

int factorial(int arg)
{
    if ((arg == 0) || (arg == 1)){
        return 1;
    }   
    else
    {
        return arg*factorial(arg-1);
    }
}

void* factorial_thread(void * arg)
{
    int x = (int)arg;
	 
	 x = factorial(x);

    return (void*)(x);
}

void* double_thread(void * arg)
{
    int x = (int)arg;
	 
	 x = x*2;

    return (void*)(x);
}

int main()
{
	int x = 5;
	factorial_thread((void*)x);
	return 0;
}
