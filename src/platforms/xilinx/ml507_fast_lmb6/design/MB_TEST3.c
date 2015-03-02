
int main() {

	int a = 1;
	volatile char * b = (volatile char *) (0xB000100C);
	//Microblaze 3 code!
	while (1) {
		*b = 'D';
      a++;
      //xil_printf("0x%08x = %d\r\n", b, *b);
		//*c = 11;
	}

	return 0;
}
