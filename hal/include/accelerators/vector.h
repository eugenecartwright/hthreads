#ifndef _VECTOR_H_
#define _VECTOR_H_

#include <httype.h>

extern Hint poly_vector (void * a_ptr, void * b_ptr, void * c_ptr, Huint size, Huint op_code, Hint acc)

extern Hint poly_vectoradd (void * a_ptr, void * b_ptr, void * c_ptr, Huint size);
extern Hint poly_vectorsub (void * a_ptr, void * b_ptr, void * c_ptr, Huint size);
extern Hint poly_vectormul (void * a_ptr, void * b_ptr, void * c_ptr, Huint size);
extern Hint poly_vectordivide (void * a_ptr, void * b_ptr, void * c_ptr, Huint size);

#endif
