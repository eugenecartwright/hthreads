/* ***************************************************************
 * Filename: vector.c
 * Description: Code provided for interaction with the vector core.
 * Also, a software version of vector is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/
 
#include <accelerator.h>
#include <vector.h>
#include "fsl.h"
#include "pvr.h"
#include <hwti/hwti.h>

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
      // TODO: Turn on data caching if bram addr is in cacheable range
	   Hint * brama = (Hint *) ACC_BRAMA;
      Hint * bramb = (Hint *) ACC_BRAMB;
      Hint * bramc = (Hint *) ACC_BRAMC;
      if (acc == VECTOR_ADD_SUB) {      
	      if (op_code == 1)
	         for (e = 0; e < size; e++)     bramc[e] = brama[e] + bramb[e];	
	      else if (op_code == 2)
	         for (e = 0; e < size; e++)     bramc[e] = brama[e] - bramb[e];
      } else if (acc == VECTOR_MUL_DIVIDE) {
	      if (op_code == 1)
	         for (e = 0; e < size; e++)     bramc[e] = brama[e] * bramb[e];	
	      else if (op_code == 2)
	         for (e = 0; e < size; e++) if (bramb[e] != 0) bramc[e] = brama[e] / bramb[e];
      }
      // TODO: Turn off data caching
	}

   // Start transferring data from BRAM
   if(transfer_dma( (void *) ACC_BRAMC, (void *) c_ptr, size *4))
      return FAILURE;
   
   return result;
}


Hint poly_vectoradd (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
   return poly_vector(a_ptr,b_ptr, c_ptr, size, 1, VECTOR_ADD_SUB);
}

Hint poly_vectorsub (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
   return poly_vector(a_ptr,b_ptr, c_ptr, size, 2, VECTOR_ADD_SUB);
}

Hint poly_vectormul (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
   return poly_vector(a_ptr,b_ptr, c_ptr, size, 1, VECTOR_MUL_DIVIDE);
}

Hint poly_vectordivide (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
   return poly_vector(a_ptr,b_ptr, c_ptr, size, 2, VECTOR_MUL_DIVIDE);
}

