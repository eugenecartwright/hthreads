/* ***************************************************************
 * Filename: matrix_mblaze.c
 * Description: Code provided for interaction with the matrix 
 * multiply core.
 * ***************************************************************/
 
#include <matrix.h>

Hint poly_matrix_mul (void * a_ptr, void * b_ptr, void * c_ptr, Huint a_rows, Huint a_cols, Huint b_cols) {
   
   Hint result = SUCCESS;
   
   // Use Accelerator?
   Hbool use_accelerator = poly_init(MATRIXMUL, a_rows * b_cols);
    
   // Start transferring data to BRAM
   if(transfer_dma( (void *) a_ptr, (void *) ACC_BRAMA, a_rows * a_cols *4))
      return FAILURE;
   if(transfer_dma( (void *) b_ptr, (void *) ACC_BRAMB, a_cols * b_cols *4))
      return FAILURE;

	//computation		
	if (use_accelerator) {  
	   int e;
		putfslx( a_rows, 0,FSL_DEFAULT);
		putfslx( b_cols, 0,FSL_DEFAULT);
		putfslx( a_cols, 0,FSL_DEFAULT);
		getfslx(e, 0, FSL_DEFAULT);
	}else
	   result = sw_matrix_multiply((Hint *)ACC_BRAMA, (Hint *) ACC_BRAMB, (Hint *)ACC_BRAMC, a_rows, a_cols , b_cols);
	   
   // Start transferring data from BRAM
   if(transfer_dma( (void *) ACC_BRAMC, (void *) c_ptr, a_rows * b_cols *4))
      return FAILURE;

   return result;
   
}

Hint  sw_matrix_multiply (void * a_ptr, void * b_ptr, void * c_ptr, Huint a_rows, Huint a_cols, Huint b_cols)
{
   Hint * a = a_ptr;
   Hint * b = b_ptr;
   Hint * c = c_ptr;
   assert( a_cols == a_rows);
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
   return SUCCESS;
}	

