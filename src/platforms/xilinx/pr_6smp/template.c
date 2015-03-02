// Compilation Key: 00110000110001800 6 64 65536 9600 hwti_mblaze_6smp

#define NUM_TRIALS          (1)
#define DEBUG_DISPATCH

#ifndef HETERO_COMPILATION
#include "Program_Name_prog.h"
#endif

#ifdef HETERO_COMPILATION
int main() { return 0; }
#else
int main(){
    printf("HOST: START\n");
    // insert code here...

    printf("END\n");
    return 0;
}
#endif

