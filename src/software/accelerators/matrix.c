/* ***************************************************************
 * Filename: matrix.c
 * Description: Matrix Multiply code for Host.
 * Author: Unknown
 * ***************************************************************/
 
#include <accelerator.h>
#include <matrix.h>
#include <htconst.h>

Hint  poly_matrix_mul (void * a_ptr, void * b_ptr, void * c_ptr, Huint a_rows, Huint a_cols, Huint b_cols) {
   return sw_matrix_multiply (a_ptr, b_ptr, c_ptr, a_rows, a_cols, b_cols);
}	

Hint  sw_matrix_multiply (void * a_ptr, void * b_ptr, void * c_ptr, Huint a_rows, Huint a_cols, Huint b_cols) {
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
