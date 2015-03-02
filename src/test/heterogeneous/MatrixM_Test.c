// ##############################################################################
// Created by Sen Ma
// ##############################################################################
#include <stdlib.h>
#include <stdio.h>
#include <hthread.h>
//#include <arch/htime.h>
#include <math.h>
//#include "hetero_time_lib.h"
//#define DEBUG_DISPATCH

#define Test_Type			int

hthread_attr_t create_attr()
{
	hthread_attr_t attr;
	hthread_attr_init(&attr);
	hthread_attr_setdetachstate(&attr, HTHREAD_CREATE_JOINABLE);
	return attr;
}

typedef struct
{
	int 	   W;
	Test_Type *A;
	Test_Type *B;
	Test_Type *C;
}
Thread_Arg_MM;

typedef struct
{
	Test_Type	 *A0[5];
	Test_Type	 *B0[5];
	Test_Type	 *C1[5];
	Test_Type	 *C2[5];
}
MM_ABC_Arg;

void * matrixMul_Test(void * arg)
{
	int i,j,k;
	Thread_Arg_MM* p = (Thread_Arg_MM*) arg;
	for (i=0; i<p->W; i++)
	{
		for (j=0; j<p->W; j++)
		{
			Test_Type value = 0;
			for(k=0; k<p->W; k++)
			{
				value += p->A[i * p->W + k] * p->B[k * p->W + j];
			}
			p->C[i * p->W + j] = value;
		}
	}
	return (void *) 0;
}

void * matrixMul_thread(void * arg)
{
	int i,j,k;
	Thread_Arg_MM* p = (Thread_Arg_MM*) arg;
	for (i=0; i<p->W; i++)
	{
		for (j=0; j<p->W; j++)
		{
			Test_Type value = 0;
			for(k=0; k<p->W; k++)
			{
				value += p->A[i * p->W + k] * p->B[k * p->W + j];
			}
			p->C[i * p->W + j] = value;
		}
	}
	return (void *) 0;
}

#ifndef HETERO_COMPILATION
#include "MatrixM_Test_prog.h"
char FN[] = "MatrixM_Test.c";

#endif
#ifdef HETERO_COMPILATION
int main()
{
	return 0;
}
#else
int main(int argc, char** argv)
{
	//printf("\r\nBegin -> %s\r\n", FN);
	int CPUs = NUM_AVAILABLE_HETERO_CPUS;
	//printf("Number Available CPUs : %d\r\n",CPUs);
	int					i_CPUs;
	int					i_MM;
	int					i;
	int					j;
	int					size = 0;
	int					flag = 0;
	Thread_Arg_MM		*arg_Test=NULL;
	Thread_Arg_MM		*arg=NULL;
	hthread_t			*threads=NULL;
	hthread_attr_t		*attr=NULL;
	/////////////////////////////////////////////////////
	threads 	 = (hthread_t *)     malloc (CPUs * sizeof(hthread_t));
	if (threads == NULL) {printf("3\r\nEND\r\n"); exit(0);}
	attr		 = (hthread_attr_t*) malloc (CPUs * sizeof(hthread_attr_t));
	if (attr == NULL) {printf("3\r\nEND\r\n"); exit(0);}
	attr[i_CPUs] = create_attr();

	for (i_MM=5; i_MM<=5; i_MM++)
	{
		size=1<<i_MM;
		//printf("Size:\t%d x %d\t\t\r\n", size, size);

		arg_Test	= (Thread_Arg_MM*)malloc(CPUs * sizeof(Thread_Arg_MM));
		arg	  		= (Thread_Arg_MM*)malloc(CPUs * sizeof(Thread_Arg_MM));

		for (i_CPUs=0; i_CPUs<CPUs; i_CPUs++)
		{
			(arg_Test+i_CPUs)->W	= 1<<i_MM;
			(arg_Test+i_CPUs)->A	= (int *)malloc(sizeof(int)*size*size);
			if ((arg_Test+i_CPUs)->A == NULL) {printf("2\r\nEND\r\n"); exit(0);}
			(arg_Test+i_CPUs)->B	= (int *)malloc(sizeof(int)*size*size);
			if ((arg_Test+i_CPUs)->B == NULL) {printf("2\r\nEND\r\n"); exit(0);}
			(arg_Test+i_CPUs)->C	= (int *)malloc(sizeof(int)*size*size);
			if ((arg_Test+i_CPUs)->C == NULL) {printf("2\r\nEND\r\n"); exit(0);}

			(arg+i_CPUs)->W			= 1<<i_MM;
			(arg+i_CPUs)->A			= (int *)malloc(sizeof(int)*size*size);
			if ((arg+i_CPUs)->A == NULL) {printf("2\r\nEND\r\n"); exit(0);}
			(arg+i_CPUs)->B			= (int *)malloc(sizeof(int)*size*size);
			if ((arg+i_CPUs)->B == NULL) {printf("2\r\nEND\r\n"); exit(0);}
			(arg+i_CPUs)->C			= (int *)malloc(sizeof(int)*size*size);
			if ((arg+i_CPUs)->C == NULL) {printf("2\r\nEND\r\n"); exit(0);}

			for (i=1; i<=size*size; i++)
			{
				(arg_Test+i_CPUs)->A[i-1]	= (Test_Type)(rand() % 5);//(Test_Type)i;
				(arg_Test+i_CPUs)->B[i-1]	= (Test_Type)(rand() % 5);//(Test_Type)(size*size-i+1);
				(arg_Test+i_CPUs)->C[i-1]	= (Test_Type)0;

				(arg+i_CPUs)->A[i-1]		= (arg_Test+i_CPUs)->A[i-1];
				(arg+i_CPUs)->B[i-1]		= (arg_Test+i_CPUs)->B[i-1];
				(arg+i_CPUs)->C[i-1]		= (Test_Type)0;
			}
		}
		for (i_CPUs=0; i_CPUs<CPUs; i_CPUs++) matrixMul_Test((void *)(arg_Test+i_CPUs));


		for (i_CPUs=0; i_CPUs<CPUs; i_CPUs++)
		{
			microblaze_create((threads+i_CPUs),(attr+i_CPUs), matrixMul_thread_FUNC_ID, (void *)(arg+i_CPUs), i_CPUs);
		}

		for (i_CPUs=0; i_CPUs<CPUs; i_CPUs++)
		{
			hthread_join(*(threads+i_CPUs), NULL);
		}

		for (i_CPUs=0; i_CPUs<CPUs; i_CPUs++)
		{
			flag = 0;
			//printf("Running on %d CPU\t\t", i_CPUs);
			for(i = 0; i < size*size; i++)
			{
				if ((arg_Test+i_CPUs)->C[i] != (arg+i_CPUs)->C[i])
				{
					flag=1;
					break;
				}
			}
			if (flag == 0) continue;//printf("Passed\r\n");
			else {printf("4\r\nEND\r\n"); exit(0);}//printf("Failed\r\n");
		}
		//free(arg_Test->A);
		//free(arg_Test->B);
		//free(arg_Test->C);
		//free(arg->A);
		//free(arg->B);
		//free(arg->C);
		//free(arg_Test);
		//free(arg);
	}
	free(threads);
	free(attr);
	printf("0\r\nEND\r\n");
	//printf("Done -> %s\r\n", FN);
	//printf("==================================\r\n");
	return 0;
}
#endif
