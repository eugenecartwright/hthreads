#ifndef _MATRIX_H_
#define _MATRIX_H_

#include <httype.h>

extern Hint poly_matrix_mul (void * a_ptr, void * b_ptr, void * c_ptr, Huint a_rows, Huint a_cols, Huint b_cols);
extern Hint  sw_matrix_multiply (void * a_ptr, void * b_ptr, void * c_ptr, Huint a_rows, Huint a_cols, Huint b_cols);

#endif
