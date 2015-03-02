
int main() {

	int a = 1;
	volatile int * b = (volatile int *) (0xB0001000);
	//Microblaze 0 code!
	while (1) {
		*b = 'A';
      a++;
      //xil_printf("0x%08x = %d\r\n", b, *b);
		//*c = 11;
	}

	return 0;
}
