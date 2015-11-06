#include <accelerator.h>
#include <vector.h>
#include <htconst.h>

Hint poly_vector(void * a_ptr, void * b_ptr, void * c_ptr, Huint size, Huint op_code, Hint acc) {

   Huint * a = (Huint *) a_ptr;
   Huint * b = (Huint *) b_ptr;
   Huint * c = (Huint *) c_ptr;
   Huint i = 0;
   for (i = 0; i < size; i++) {
     switch(op_code) {
      case 0: c[i] = a[i] + b[i];
      case 1: c[i] = a[i] - b[i];
      case 2: c[i] = a[i] * b[i];
      case 3: if (b[i] != 0) c[i] = a[i] / b[i];
      default: return FAILURE;
     } 
   }
   return SUCCESS;
}

Hint poly_vectoradd (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
    return (poly_vector(a_ptr, b_ptr, c_ptr, size, 0,0));
}

Hint poly_vectorsub (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
    return (poly_vector(a_ptr, b_ptr, c_ptr, size, 1,0));
}

Hint poly_vectormul (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
    return (poly_vector(a_ptr, b_ptr, c_ptr, size, 2,0));
}

Hint poly_vectordiv (void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
    return (poly_vector(a_ptr, b_ptr, c_ptr, size, 3,0));
}
