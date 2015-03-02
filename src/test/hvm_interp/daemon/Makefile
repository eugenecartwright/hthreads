HTHREAD_INC = /build/jstevens/hthreads/trunk/include
#GCC = gcc -I../ -I$(HTHREAD_INC) -I$(HTHREAD_INC)/hthread -Wall
GCC = gcc -I../ -Wall


daemon.o: daemon.c
	$(GCC) -c daemon.c

clean:
	rm -f *.o
