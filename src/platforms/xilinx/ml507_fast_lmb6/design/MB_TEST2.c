
int main() {

	int a = 1;
	volatile char * b = (volatile char *) (0xB0001008);
	//Microblaze 2 code!
	while (1) {
		*b = 'C';
      a++;
      //xil_printf("0x%08x = %d\r\n", b, *b);
		//*c = 11;
	}

	return 0;
}
