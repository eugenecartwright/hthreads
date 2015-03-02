#include "pvr.h"

// Thread argument definition
typedef struct
{
    int * array;
    int length;
    int max_value;
    int min_value;

    int * hist;
    int num_bins;
} targ_t;

/*
void * histogram_thread (void * arg)
{
    targ_t * targ;
    int i = 0;
    int bin = 0;
    int val = 0;
    int times = 5;
    int accum = 0;
    int tcount = 0;
    for (tcount = 0; tcount < times; tcount++)
    {    
	    // Create a pointer to thread argument
	    targ = (targ_t *)arg;
	
	    // Calculate histogram
	    int diff = (targ->max_value - targ->min_value);
	
	    //int divider = (targ->max_value - targ->min_value) / targ->num_bins;
	    int divider = (diff / targ->num_bins) + (targ->num_bins - (diff % targ->num_bins));
	    for (i = 0; i < targ->length; i++)
	    {
	        // Extract array value
	        val = targ->array[i];
	
	        // Calculate bin number
	        bin = val / divider;
	
	        // Update histogram
	        targ->hist[bin] = targ->hist[bin] + 1;
            accum = accum + diff;
	    }
    }
    return (void*)(accum);
}
*/
void * histogram_thread (void * arg)
{
    targ_t * targ;
    int i = 0;
    int bin = 0;
    int val = 0;
    int times = 10;
    int accum = 0;
    int tcount = 0;
    for (tcount = 0; tcount < times; tcount++)
    {    
	    // Create a pointer to thread argument
	    targ = (targ_t *)arg;
	
	    // Calculate histogram
	    int diff = (targ->max_value - targ->min_value);
	
	    //int divider = (targ->max_value - targ->min_value) / targ->num_bins;
	    int divider = (diff / targ->num_bins) + (targ->num_bins - (diff % targ->num_bins));
	    for (i = 0; i < targ->length; i++)
	    {
	        // Extract array value
	        val = targ->array[i];
	
	        // Calculate bin number
	        bin = val / divider;
	
	        // Update histogram
	        targ->hist[bin] = targ->hist[bin] + 1;
            accum = accum + diff;
	    }
    }
    return (void*)(accum);
}



int main()
{
	histogram_thread((void*)5);
	return 0;
}


