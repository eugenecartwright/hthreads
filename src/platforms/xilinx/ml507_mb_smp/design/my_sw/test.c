#include <pvr.h>

int main()
{
	int id;
	
	getpvr(1,id);
	
	while(1)
	{
		xil_printf("%d\r\n",id);
	}
	return 0;
}