/* ***************************************************************
 * Filename: matrix_mblaze.c
 * Description: Code provided for interaction with the crc core.
 * Also, a software version of crc is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/
 
#include <accelerator.h>
#include "fsl.h"
#include "pvr.h"
#include <hwti/hwti.h>
#include <icap.h>

Hint poly_matrix_m (void * a_ptr, void * b_ptr, void * c_ptr, Huint a_rows, Huint a_cols, Huint b_cols) {
   // done variable not used for slave accelerator calls    
   
   Hint result = SUCCESS;
   
   // Use Accelerator?
   Hbool use_accelerator = poly_init(MATRIXMUL, a_rows * b_cols);
    
   // Start transferring data to BRAM
   if(!transfer_dma( (void *) a_ptr, (void *) ACC_BRAMA, a_rows * a_cols *4))
      return FAILURE;
   if(!transfer_dma( (void *) b_ptr, (void *) ACC_BRAMB, b_rows * b_cols *4))
      return FAILURE;

	//computation		
	if (use_accelerator) {  
	   int e;
		putfslx( a_rows, 0,FSL_DEFAULT);
		putfslx( b_cols, 0,FSL_DEFAULT);
		putfslx( a_cols, 0,FSL_DEFAULT);
		getfslx(e, 0, FSL_DEFAULT);
	}else
	   sw_matrix_multiply(BRAMA,BRAMB,  BRAMC, a_rows, a_cols , a_cols , b_cols);
	   
   // Start transferring data from BRAM
   if(!transfer_dma( (void *) ACC_BRAMC, (void *) c_ptr, a_rows * b_cols *4))
      return FAILURE;

#endif
   return result;
   
}

void	sw_matrix_multiply(int * a, int * b, int * c,  char a_rows, char a_cols ,  char b_rows , char b_cols)
{
  assert( a_cols == b_rows);
  	char i, j, k=0;
  	int sum= 0;
   for (i=0; i<a_rows; i++){
      for (j=0; j<b_cols; j++){
         sum = 0;
         for (k=0; k<a_cols; k++){
            sum += a[i*a_cols+k] * b[k*b_cols+j];
            }
         c[i*b_cols+j] = sum;
      }
   }	  
}	

