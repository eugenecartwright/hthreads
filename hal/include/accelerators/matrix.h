#ifndef _MATRIX_H_
#define _MATRIX_H_

#include <accelerator.h>
#include "fsl.h"
#include "pvr.h"
#include <hwti/hwti.h>
#include <httype.h>

Hint poly_matrix_mul (void * a_ptr, void * b_ptr, void * c_ptr, Huint a_rows, Huint a_cols, Huint b_cols);
Hint  sw_matrix_multiply (void * a_ptr, void * b_ptr, void * c_ptr, Huint a_rows, Huint a_cols, Huint b_cols);

#endif
