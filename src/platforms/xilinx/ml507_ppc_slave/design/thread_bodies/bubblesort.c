

// Thread argument definition
typedef struct
{
    int * data;
    unsigned int length;
} targ_t;

void bubblesort(int *array, unsigned int len )
{

    int swapped = 1;
    unsigned int i, n, n_new, temp;
    n = len - 1;
    n_new = n;

    while ( swapped ) {
        swapped = 0;
        for ( i = 0; i < n; i++ ) {
            if ( array[i] > array[i + 1] ) {
                temp = array[i];
                array[i] = array[i + 1];
                array[i + 1] = temp;
                n_new = i;
                swapped = 1;
            }
        }
        n = n_new;
    }
}

void * bubblesort_thread (void * arg)
{
    targ_t * targ = (targ_t *)arg;

    // Sort the data
    bubblesort(targ->data, targ->length);

    return (void*)(0xff);
}



int main()
{
	bubblesort_thread((void*)5);
	return 0;
}


