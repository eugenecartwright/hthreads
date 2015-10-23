/* ***************************************************************
 * Filename: matrix.c
 * Description: Code provided for interaction with the crc core.
 * Also, a software version of crc is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/
 
#include <accelerator.h>
#include <matrix.h>
#include <htconst.h>

Hint	poly_matrix_mul(int * a, int * b, int * c,  char a_rows, char a_cols ,  char b_rows , char b_cols)
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
   return SUCCESS;
}	

