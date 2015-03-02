.phony: clean

GCC = gcc -g -I..

interpreter: isa.h interpreter.h interpreter.o main.o
	$(GCC) interpreter.o main.o \
	   -l pthread \
	   -o interpreter

interpreter.o: isa.h interpreter.h interpreter.c
	$(GCC) -c interpreter.c

main.o: isa.h interpreter.h main.c
	$(GCC) -c main.c

clean:
	-\rm -f *.o
	-\rm -f interpreter
