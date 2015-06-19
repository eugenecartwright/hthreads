#include <vector.h>
#include <htconst.h>

Hint vector(void * a_ptr, void * b_ptr, void * c_ptr, Huint size, Huint op_code) {

    Huint * a = (Huint *) a_ptr;
    Huint * b = (Huint *) b_ptr;
    Huint * c = (Huint *) c_ptr;
    Huint i = 0;
    for (i = 0; i < size; i++) {
        c[i] = a[i] + b[i];
    }

    return SUCCESS;
}

Hint vector_add(void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {
    
    return (vector(a_ptr, b_ptr, c_ptr, size, 0));

}
Hint vector_multiply(void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {

    return (vector(a_ptr, b_ptr, c_ptr, size, 1));

}

Hint vector_innerProduct(void * a_ptr, void * b_ptr, void * c_ptr, Huint size) {

    return (vector(a_ptr, b_ptr, c_ptr, size, 2));

}
