typedef struct{
	int x;
	char a;
	int y;
	char * str1;
	char * str2;
} targ_t;

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
