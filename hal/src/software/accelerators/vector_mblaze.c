/* ***************************************************************
 * Filename: vector.c
 * Description: Code provided for interaction with the vector core.
 * Also, a software version of vector is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/
#include <vector.h>

Hint poly_vector (void * a_ptr, void * b_ptr, void * c_ptr, Huint size, Huint op_code, Hint acc)
{     

   Hint result = SUCCESS;
    
   // Use Accelerator?
   Hbool use_accelerator = poly_init(acc, size);
    
   // Start transferring data to BRAM
   if(transfer_dma( (void *) a_ptr, (void *) ACC_BRAMA, size *4))
      return FAILURE;
   if(transfer_dma( (void *) b_ptr, (void *) ACC_BRAMB, size *4))
      return FAILURE;
  	
   int e;
   if (use_accelerator) {
      
		int cmd =op_code; 
		int start =0;
		int end =  size ;
	
		putfslx( cmd, 0, FSL_DEFAULT);
		putfslx( end, 0, FSL_DEFAULT);
		putfslx( start, 0, FSL_DEFAULT);
		getfslx(e, 0, FSL_DEFAULT); 
   } else {
      Huint vhwti_base = 0;
   
      // Get VHWTI from PVRs 
      getpvr(1,vhwti_base);
      hthread_time_t start = hthread_time_get();
      // TODO: Turn on data caching if bram addr is in cacheable range
	   Hint * brama = (Hint *) ACC_BRAMA;
      Hint * bramb = (Hint *) ACC_BRAMB;
      Hint * bramc = (Hint *) ACC_BRAMC;
      if (acc == VECTORADD) {      
	      if (op_code == 1)
	         for (e = 0; e < size; e++)     bramc[e] = brama[e] + bramb[e];	
	      else if (op_code == 2)
	         for (e = 0; e < size; e++)     bramc[e] = brama[e] - bramb[e];
      } else if (acc == VECTORMUL) {
	      if (op_code == 1)
	         for (e = 0; e < size; e++)     bramc[e] = brama[e] * bramb[e];	
	      else if (op_code == 2)
	         for (e = 0; e < size; e++) if (bramb[e] != 0) bramc[e] = brama[e] / bramb[e];
      }
      hthread_time_t stop = hthread_time_get();
      hthread_time_t diff;
      hthread_time_diff(diff, stop,start);
      volatile hthread_time_t * ptr = (hthread_time_t *) (vhwti_base + 0x100);
      *ptr += diff;
      // TODO: Turn off data caching
	}

   // Start transferring data from BRAM
   if(transfer_dma( (void *) ACC_BRAMC, (void *) c_ptr, size *4))
      return FAILURE;

   return result;
}


Hint poly_vectoradd (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
   return poly_vector(a_ptr,b_ptr, c_ptr, size, 1, VECTORADD);
}

Hint poly_vectorsub (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
   return poly_vector(a_ptr,b_ptr, c_ptr, size, 2, VECTORADD);
}

Hint poly_vectormul (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
   return poly_vector(a_ptr,b_ptr, c_ptr, size, 1, VECTORMUL);
}

Hint poly_vectordiv (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
   return poly_vector(a_ptr,b_ptr, c_ptr, size, 2, VECTORMUL);
}
