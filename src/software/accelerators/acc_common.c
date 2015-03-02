#include <accelerator.h>

// -------------------------------------------------------------- //
//             Get's index size for given data size               //
// -------------------------------------------------------------- //
Huint get_index(Huint size) 
{
    
    if (size > ((BRAM_SIZE + (BRAM_SIZE/2)) / 2)) {
        return NUM_OF_SIZES-1;
    } 
    if (size > ((BRAM_SIZE/2 + (BRAM_SIZE/4)) / 2)) {
        return NUM_OF_SIZES-2;
    } 
    if (size > ((BRAM_SIZE/4 + (BRAM_SIZE/8)) / 2)) {
        return NUM_OF_SIZES-3;
    } 
    if (size > ((BRAM_SIZE/8 + (BRAM_SIZE/16)) / 2)) {
        return NUM_OF_SIZES-4;
    } 
    if (size > ((BRAM_SIZE/16 + (BRAM_SIZE/32)) / 2)) {
        return NUM_OF_SIZES-5;
    } 
    if (size > ((BRAM_SIZE/32 + (BRAM_SIZE/64)) / 2)) {
        return NUM_OF_SIZES-6;
    } 
    return NUM_OF_SIZES-7;
}
