void sw_bubblesort( int * a , int start, int end )
{
    int i,temp,j,bound = end;
    for(  i = start ; i < end  ; i++ )
    {
        for ( j = start ; j < bound ; j++ )
        {
            if ( a[j] > a[j + 1] )
            {
                temp = a[j];
                a[j] = a[j + 1];
                a[j + 1] = temp;

            }
        }
        bound = j-1;
    }
}


void bubblesort (volatile int *cmd, volatile int *resp, int a[4096], int b[4096], int result[4096]  ) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis port=cmd
#pragma HLS INTERFACE axis port=resp
#pragma HLS INTERFACE bram depth=1024 port=a
#pragma HLS INTERFACE bram depth=1024 port=b
#pragma HLS INTERFACE bram depth=1024 port=result

#pragma HLS RESOURCE variable=a core=RAM_1P_BRAM
#pragma HLS RESOURCE variable=b core=RAM_1P_BRAM
#pragma HLS RESOURCE variable=result core=RAM_1P_BRAM

   int start,end;
   // Accumulate each channel
   For_Loop: while (1) 
   {
      end= *cmd;
      start = *cmd;
      sw_bubblesort (result, start,end);
      *resp= 1; //means I am done.
   }


  
}





