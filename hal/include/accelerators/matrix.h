#ifndef _MATRIX_H_
#define _MATRIX_H_

#include <httype.h>

extern Hint poly_matrix_m (void * a_ptr, void * b_ptr, void * c_ptr, Huint a_rows, Huint a_cols, Huint b_cols);
extern void	sw_matrix_multiply(Hint * a, Hint * b, Hint * c,  char a_rows, char a_cols, char b_rows, char b_cols);

#endif
