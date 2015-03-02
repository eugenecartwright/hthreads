


/*

This main() is the command-line front-end to the interpreter.

*/







#include <stdlib.h>
#include <stdio.h>

#include "common/types.h"
//#include <interpreter/interpreter.h>
#include <interpreter.h>

#define READ_BINARY "rb"
#define STACK_BYTE_COUNT 0x000100000






ByteCount nbytes_in_file(FILE* handle) {
  fpos_t original_pos;
  ByteCount size = 0;

  if ( fgetpos(handle, & original_pos) ) { perror("File access failed"); exit(-1); }
  
  if ( fseek(handle, 0, SEEK_END) ) {perror("File access failed");  exit(-1); }
  else {
    size = (ByteCount) ftell(handle);
  }

  if ( fsetpos(handle, & original_pos) ) { perror("File access failed"); exit(-1); }

  return size;
}

ErrorCode load_and_interpret_image(char* image_filename) {
  /* open image file */
  FILE* handle = fopen(image_filename, READ_BINARY);
  if ( NULL == handle ) { perror("Error opening image file"); exit(-1); }


  byte* image = NULL;
  ByteCount nbytes = 0;
  { /* allocate memory for instructions */
    nbytes = nbytes_in_file(handle); /* all errors are perrors, so no checks */

    nbytes += STACK_BYTE_COUNT;

    if ( 0 == nbytes ) { puts("I pity the fool who uses an empty image"); exit(-1); }
    if ( 0 != nbytes % 4 ) { puts("I pity the fool who uses an image that isn't word-aligned (multiple of 4 bytes)"); exit(-1); }

    image = (byte*) malloc(nbytes);

    if ( NULL == image ) { perror("Could not allocate image"); exit(-1); }
  }


  byte* c = image;
  { /* read bytes into image memory */
    while ( !feof(handle) ) {
      char input = fgetc(handle);
      *c = (byte) input;
      ++c;
    }
  }


  /* sanity check */
  if ( (c - image - 1) != (nbytes - STACK_BYTE_COUNT) ) {
    puts("Error: the number of image bytes read is different than the byte size of the image file");
    exit(-1);
  }


  fclose(handle);

  { /* dump registers when the interpreter exits */
    TCB tcb;
    word * junk = (word*)10;

    tcb.virtualization.base_addr = image;

    ErrorCode status = interpreter( & tcb, junk );

    print_register_file(junk);

    printf("\nWordcode returns %i, 0x%08x.\n"
	   , (int) tcb.communication.data.return_value
	   , (int) tcb.communication.data.return_value
	   );


    return status;
  }
}




int help(char* program_name) {
  fputs("Usage: ", stdout);
  fputs(program_name, stdout);
  fputs(" <image>", stdout);
  fputs("\n", stdout);

  return -1;
}

int main(int argc, char** argv) {
  if ( argc != 2 ) { return help(argv[0]); }
  else { return load_and_interpret_image(argv[1]); }
}
