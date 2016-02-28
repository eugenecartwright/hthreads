#ifndef _VECTOR_H_
#define _VECTOR_H_

#include <accelerator.h>
#include "fsl.h"
#include "pvr.h"
#include <hwti/hwti.h>
#include <arch/htime.h>
#include <httype.h>

Hint poly_vector (void * a_ptr, void * b_ptr, void * c_ptr, Huint size, Huint op_code, Hint acc);
Hint poly_vectoradd (void * a_ptr, void * b_ptr, void * c_ptr, Huint size);
Hint poly_vectorsub (void * a_ptr, void * b_ptr, void * c_ptr, Huint size);
Hint poly_vectormul (void * a_ptr, void * b_ptr, void * c_ptr, Huint size);
Hint poly_vectordiv (void * a_ptr, void * b_ptr, void * c_ptr, Huint size);

#endif
