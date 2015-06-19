

void resetgen ( volatile int *cmd, volatile int *resp, int rst  ) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis port=cmd
#pragma HLS INTERFACE axis port=resp

	int i;
	rst =1;
	i= *cmd;
	rst =0;
	*resp = i;
	rst =1;
	
}


