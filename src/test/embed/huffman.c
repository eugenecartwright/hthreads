/*   
 * Huffman Encoding
 *
 * Original software source code written by John Gauch as part of the KUIM
 * library. Source code modified to work with hthreads.
 */

#include <hthread.h>
#include <stdlib.h>
#include <xcache_l.h>
#include "time_lib.h"

// The base addresses of the hardware thread we are creating
#define HWTI_BASEADDR0               (0xB0000000)
#define HWTI_BASEADDR1               (0xB0000100)
#define HWTI_BASEADDR2               (0xB0000200)
#define NUM_CPUS        (3)
unsigned int base_array[NUM_CPUS] = {HWTI_BASEADDR0, HWTI_BASEADDR1, HWTI_BASEADDR2};

#define LENGTH 100
#define USE_HARDWARE 1

#define MAX_SIZE 1024
struct HuffmanCode {
   int Prob[MAX_SIZE];
   int Parent[MAX_SIZE];
   int Zero[MAX_SIZE];
   int One[MAX_SIZE];
   int Bit[MAX_SIZE];
   int Count;
};

struct HuffmanStructure {
	int * inputData;
	int * outputData;
	int count;
	struct HuffmanCode code;
    xps_timer_t * timer;
    int elapsed_time;
};

//------------------------------------------------------------
// Calculate min/max pixel values in image.
//------------------------------------------------------------
void MinMax(int * data, int length, int *min, int *max)
{
   int index;
   
   // Calculate current min and max
   *min = (int) data[0];
   *max = (int) data[0];
   for (index = 0; index < length; index++)
   {
      if (data[index] < *min)
         *min = data[index];
      else if (data[index] > *max)
         *max = data[index];
   }
}

//------------------------------------------------------------
// Calculate histogram for image.
//------------------------------------------------------------
void Histogram(int * data, int length, int * histo, int min, int max)
{
   // Initialize histogram array
   int index;
   int range = max - min + 1;
   for (index = 0; index < range; index++)
      histo[index] = 0;

   // Calculate intensity histogram
   for (index = 0; index < length; index++)
      if ((data[index] >= min) && (data[index] <= max))
         histo[data[index] - min]++;
}

//----------------------------------------------------------
// Purpose:  Build the Huffman code tree for encode/decode.
// Input:    HuffmanCode structure with Prob initialized.
// Output:   An initialized HuffmanCode structure.
// Author:   John Gauch
//----------------------------------------------------------
void build_huffman_code(struct HuffmanCode * code) 
{
   // Initialize binary tree
   int Index, Loop, MinPos;
   for (Index = 0; Index < MAX_SIZE; Index++) 
   {
      code->Parent[Index] = -1;
      code->Zero[Index] = -1;
      code->One[Index] = -1;
      code->Bit[Index] = 0;
   }

   // Merge leaf nodes in tree to build Huffman code
   for (Loop = 0; Loop < code->Count - 1; Loop++) 
   {
      // Find first leaf node
      for (Index = 0; code->Parent[Index] != -1; Index++);
      MinPos = Index;

      // Find lowest probability symbol
      for (Index = 0; Index < code->Count + Loop; Index++)
         if ((code->Prob[Index] < code->Prob[MinPos]) &&
             (code->Parent[Index] == -1))
            MinPos = Index;

      // Update binary tree links
      code->Prob[code->Count + Loop] = code->Prob[MinPos];
      code->Zero[code->Count + Loop] = MinPos;
      code->Parent[MinPos] = code->Count + Loop;
      code->Bit[MinPos] = 0;

      // Find next leaf node
      for (Index = 0; code->Parent[Index] != -1; Index++);
      MinPos = Index;

      // Find next lowest probability symbol
      for (Index = 0; Index < code->Count + Loop; Index++)
         if ((code->Prob[Index] < code->Prob[MinPos]) &&
             (code->Parent[Index] == -1))
            MinPos = Index;

      // Update binary tree links
      code->Prob[code->Count + Loop] += code->Prob[MinPos];
      code->One[code->Count + Loop] = MinPos;
      code->Parent[MinPos] = code->Count + Loop;
      code->Bit[MinPos] = 1;
   }
}

//----------------------------------------------------------
// Purpose:  Print the Huffman code tree for dedbugging.
// Input:    An initialized HuffmanCode structure.
// Output:   none.
// Author:   John Gauch
//----------------------------------------------------------
void print_huffman_code(struct HuffmanCode code)
{
   // Print Huffman codes
   int Index;
   for (Index = 0; Index < code.Count; Index++)
   {
      // Build Huffman code
      int Len = 0;
      int Pos = Index;
      int Code[MAX_SIZE];
      while (code.Parent[Pos] >= 0)
      {
         Code[Len++] = code.Bit[Pos];
         Pos = code.Parent[Pos];
      }

      // Print Huffman code
      printf("Value %d Prob %d Code ", Index, code.Prob[Index]);
      while (Len > 0)
         printf("%d", Code[--Len]);
      printf("\n");
   }
}

//----------------------------------------------------------
// Purpose:  Encode image data using Huffman code.
// Input:    An initialized HuffmanCode structure
//           Data array containing pixels.
//           Count of data values to decode.
// Output:   Binary file with Huffman coded data.
// Author:   John Gauch
//----------------------------------------------------------
void * encode_data(void * arg)
{
   int Buffer = 0;
   int BufLen = 0;
   int outputIndex = 0;
   int Index, Len, Pos, Code[MAX_SIZE];
   
   struct HuffmanStructure * huffman = (struct HuffmanStructure *) arg;

   int time_start, time_stop;

   //log_time( &log );
   time_start = xps_timer_read_counter(huffman->timer);

   // Encode specified number of data values
   for (Index = 0; Index < huffman->count; Index++)
   {
      // Build up the Huffman code
      Len = 0;
      Pos = huffman->inputData[Index];
      while ((Pos < MAX_SIZE) && (huffman->code.Parent[Pos] >= 0))
      {
         Code[Len++] = huffman->code.Bit[Pos];
         Pos = huffman->code.Parent[Pos];
      }

      //for( i=0; i<Len; i++ ) printf( "%x", Code[i] );
      // Write Huffman code one bit at a time
      while (Len > 0)
      {
         Buffer = (Buffer << 1) | Code[--Len];
         BufLen++;

         // Flush buffer when full
         if (BufLen == 32)
         {
            //fwrite(&Buffer, 1, sizeof(int), Fd);
            huffman->outputData[outputIndex] = Buffer;
            outputIndex++;
            Buffer = 0;
            BufLen = 0;
         }
      }
      //printf( "\n" );
   }

   // Flush last buffer
   if (BufLen != 0)
   {
      Buffer = Buffer << (32 - BufLen);
      //fwrite(&Buffer, 1, sizeof(int), Fd);
      huffman->outputData[outputIndex] = Buffer;
   }
   
   //log_time( &log );
   time_stop = xps_timer_read_counter(huffman->timer);
   huffman->elapsed_time = time_stop - time_start;
   return NULL;
}

//------------------------------------------------------------
// Perform Huffman encoding of image.
//------------------------------------------------------------
void HuffEncode(int * inputData, int * outputData, int length, xps_timer_t * timer)
{
   int Min, Max, Range, Index, *Histo;
   struct HuffmanCode code;
   struct HuffmanStructure huffman;
   hthread_t thread;
   hthread_attr_t attr;
   
   // Calculate pixel probablities
   MinMax(inputData, length, &Min, &Max);
   Range = Max - Min + 1;
   for (Index = 0; Index < length; Index++) {
      inputData[Index] -= Min;
	  outputData[Index] = 0;
   }
   Histo = (int *) malloc( Range * sizeof(int) );
   Histogram(inputData, length, Histo, 0, Range - 1);

   // Initialize Huffman code structure
   code.Count = Range;
   for (Index = 0; Index < Range; Index++)
      code.Prob[Index] = Histo[Index];

   build_huffman_code(&code);
   free( Histo );
   //print_huffman_code(code);

   // Perform Huffman encode
   //FILE *Fd = fopen(filename, "w");
   //fwrite(&Xdim, 1, sizeof(short), Fd);
   //fwrite(&Ydim, 1, sizeof(short), Fd);
   //fwrite(&Zdim, 1, sizeof(short), Fd);
   //fwrite(&Min, 1, sizeof(short), Fd);
   //fwrite(&Max, 1, sizeof(short), Fd);
   //fwrite(&code.Count, 1, sizeof(int), Fd);
   //fwrite(&code.Prob, code.Count, sizeof(int), Fd);
   //encode_data(code, Data1D, NumPixels, Fd);
   //fclose(Fd);
   huffman.inputData = inputData;
   huffman.outputData = outputData;
   huffman.count = length;
   huffman.code = code;
   huffman.timer = timer;
   huffman.elapsed_time = -999;

   extern unsigned int encode_data_handle_offset;
   extern unsigned char intermediate[];
   unsigned int encode_data_handle = (encode_data_handle_offset) + (unsigned int)(&intermediate);
   
   hthread_attr_init( &attr );
   if ( USE_HARDWARE ){
       hthread_attr_sethardware( &attr, (void*)base_array[0] );
       hthread_create( &thread, &attr, (void*)encode_data_handle, &huffman );
   }
   else
   {
       hthread_create( &thread, &attr, encode_data, &huffman );
   }
   
   hthread_join( thread, NULL );

   printf("Elapsed Time = %d\n",huffman.elapsed_time);
}

int main() {
	int i, *inputData, *outputData;
	int length = LENGTH;

    // Timer variables
    xps_timer_t timer;

    // Setup Cache
    XCache_DisableDCache();
    XCache_EnableICache(0xc0000801);

    // Create timer
    xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);
	
	inputData = malloc( length * sizeof( int ) );
	outputData = malloc( length * sizeof( int ) );
	
	//Create data to compress;
	for( i=0; i<length; i++ ) inputData[i] = i % 256;
	
	//log_create( &log, 1024 );
	HuffEncode( inputData, outputData, length, &timer);
	
	for( i=0; i<10; i++ ) printf( "input  %x\n", inputData[i] );
	for( i=0; i<10; i++ ) printf( "output  %x\n", outputData[i] );
	
	printf( "Size %d Hardware %d\n", LENGTH, USE_HARDWARE );
	//log_close_ascii( &log );

	return 0;
}
