#ifndef _VECTOR_H_
#define _VECTOR_H_

#include <httype.h>

extern Hint vector(void * a_ptr, void * b_ptr, void * c_ptr, Huint size, Huint op_code);
extern Hint vector_add(void * a_ptr, void * b_ptr, void * c_ptr, Huint size);
extern Hint vector_multiply(void * a_ptr, void * b_ptr, void * c_ptr, Huint size);
extern Hint vector_innerProduct(void * a_ptr, void * b_ptr, void * c_ptr, Huint size);

#endif
