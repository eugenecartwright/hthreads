/* C - program of block cipher IDEA */

#include <stdio.h>
#include <hthread.h>
#include <xcache_l.h>
#include "time_lib.h"

// The base addresses of the hardware thread we are creating
#define HWTI_BASEADDR0               (0xB0000000)
#define HWTI_BASEADDR1               (0xB0000100)
#define HWTI_BASEADDR2               (0xB0000200)
#define HWTI_BASEADDR3               (0xB0000300)
#define HWTI_BASEADDR4               (0xB0000400)
#define HWTI_BASEADDR5               (0xB0000500)
#define HWTI_BASEADDR6               (0xB0000600)
#define HWTI_BASEADDR7               (0xB0000700)
#define HWTI_BASEADDR8               (0xB0000800)
#define HWTI_BASEADDR9               (0xB0000900)

#define MSG_LENGTH      ((4*6)*32)
#define C_BLOCK_SIZE    (4) // Don't change
#define PER_LINE        (10)
#define NUM_THREADS     (3)
#define USE_MB_THREAD
//#define MY_DEBUG

#define NUM_CPUS        (10)
unsigned int base_array[NUM_CPUS] = {HWTI_BASEADDR0, HWTI_BASEADDR1, HWTI_BASEADDR2, HWTI_BASEADDR3, HWTI_BASEADDR4, HWTI_BASEADDR5, HWTI_BASEADDR6, HWTI_BASEADDR7, HWTI_BASEADDR8, HWTI_BASEADDR9};


#define maxim 	65537
#define fuyi	65536
#define one 	65535
#define round	8	

void cip(unsigned IN[5],unsigned OUT[5], unsigned Z[7][10]);
void cipher_all(unsigned int initial, unsigned int final, unsigned * in, unsigned * out, unsigned key[7][10]);
void key(short unsigned uskey[9], unsigned Z[7][10]);
void de_key(unsigned Z[7][10], unsigned DK[7][10]);
unsigned inv(unsigned xin);
unsigned mul(unsigned a, unsigned b);

typedef struct
{
    unsigned int initial;
    unsigned int final;
    unsigned int *input;
    unsigned int *output;
    unsigned int (* key)[10];
} targ_t;

void * cipher_thread (void * arg)
{
    // Unpack thread argument
    targ_t * targ = (targ_t *)arg;
    unsigned int *IN = targ->input;
    unsigned int *OUT = targ->output;
    unsigned int (* Z)[10] = targ->key;

    // Perform cipher
//    printf("From %d to %d\n",targ->initial,targ->final);
    cipher_all(targ->initial,targ->final,IN,OUT,Z);

    return (void*)0;
}

int lcm (int a, int b)
{
    int n;
    for (n = 1;;n++)
    {
            if (n%a == 0 && n%b == 0)
                return n;
    }
}

int run_tests() 
{
	int i,j;
	unsigned Z[7][10], DK[7][10], XX[MSG_LENGTH], TT[MSG_LENGTH], YY[MSG_LENGTH];
	short unsigned uskey[9];

    extern unsigned int cipher_handle_offset;
    extern unsigned char intermediate[];
    unsigned int cipher_handle = (cipher_handle_offset) + (unsigned int)(&intermediate);

    // Thread attribute structures
    Huint           sta[NUM_THREADS];
    void*           retval[NUM_THREADS];
    hthread_t       tid[NUM_THREADS];
    hthread_attr_t  attr[NUM_THREADS];
    targ_t thread_arg[NUM_THREADS];

    // Timer variables
    xps_timer_t timer;
    int time_create, time_start, time_stop;

    // Setup Cache
    XCache_DisableDCache();
    XCache_EnableICache(0xc0000801);

    // Create timer
    xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);

#ifdef USE_MB_THREAD
    printf("Using %d heterogeneous threads\n",NUM_THREADS);
#else
    printf("Using %d native threads\n",NUM_THREADS);
#endif

    for(i=1;i<=8;i++) uskey[i]=i;
	key(uskey,Z);	/* generate encryption subkeys Z[i][r] */

#ifdef MY_DEBUG
    printf("\nencryption keys\t  Z1\t  Z2\t  Z3\t  Z4\t  Z5\t  Z6");
	for(j=1;j<=9;j++) { printf("\n %3d-th round",j);
		if(j==9) for(i=1;i<=4;i++) printf("\t%6d",Z[i][j]);
			else for(i=1;i<=6;i++) printf("\t%6d",Z[i][j]);
		}
#endif

    de_key(Z,DK);	/* compute decryption subkeys DK[i][r] */
	
#ifdef MY_DEBUG
	printf("\n\ndecryption keys\t  DK1\t  DK2\t  DK3\t  DK4\t  DK5\t  DK6");

	for(j=1;j<=9;j++) { printf("\n %3d-th round",j);
		if(j==9) for(i=1;i<=4;i++) printf("\t%6d",DK[i][j]);
			else for(i=1;i<=6;i++) printf("\t%6d",DK[i][j]);
	}
#endif

#ifdef MY_DEBUG
    printf("\nPlaintext X =\n");
    for(x=1;x<=MSG_LENGTH;x++)
    {
        XX[x]=x-1;
        printf("%6u,",XX[x]);
        if (x%PER_LINE == 0)
            printf("\n");
    }
    printf("\n");
#endif

    // Setup arguments and attributes
    unsigned int width = MSG_LENGTH/NUM_THREADS;
    unsigned int num_blocks = width/C_BLOCK_SIZE;
    printf("Blocks per thread = %d\n",num_blocks);
    int final = -1;
    for (j = 0; j < NUM_THREADS; j++)
    {
        // Initialize arguments
        thread_arg[j].initial = final + 1;

        final = final + (num_blocks*C_BLOCK_SIZE);
        if (final > MSG_LENGTH)
            final = MSG_LENGTH;

        thread_arg[j].final = final;
        thread_arg[j].input = XX;
        thread_arg[j].output = YY;
        thread_arg[j].key = Z;

        // Initialize the attributes for the threads
        hthread_attr_init( &attr[j] );
        hthread_attr_sethardware( &attr[j], (void*)base_array[j] );
    }

    // Create worker threads
    time_create = xps_timer_read_counter(&timer);
    for (j = 0; j < NUM_THREADS; j++)
    {
#ifdef USE_MB_THREAD
        sta[j] = hthread_create( &tid[j], &attr[j], (void*)cipher_handle, (void*)(&thread_arg[j]) );
#else
        sta[j] = hthread_create( &tid[j], NULL, cipher_thread, (void*)(&thread_arg[j]) );
#endif
        //cip(XX,YY,Z);
    }

    // Allow created threads to begin running and start timer
    time_start = xps_timer_read_counter(&timer);

    // Wait for threads to finish
    for (j = 0; j < NUM_THREADS; j++) {
        hthread_join(tid[j],&retval[j]);
    }

    // Grab stop time
    time_stop = xps_timer_read_counter(&timer);

#ifdef MY_DEBUB
    printf("Ciphertext Y =\n");
    for(x=1;x<=MSG_LENGTH;x++)
    {
        printf("%6u,",YY[x]);
        if (x%PER_LINE == 0)
            printf("\n");
    }
    printf("\n");
#endif

    cipher_all(0,MSG_LENGTH,YY,TT,DK);
	//cip(YY,TT,DK);	/* decipher YY to TT with key DK */

#ifdef MY_DEBUG
    printf("Result TT =\n");
    for(x=1;x<=MSG_LENGTH;x++)
    {
        printf("%6u,",TT[x]);
        if (x%PER_LINE == 0)
            printf("\n");
    }
    printf("\n");
#endif
    // Print out status
    for (j = 0; j < NUM_THREADS; j++) {
       printf("TID[%d] = 0x%08x, status = 0x%08x, retval = 0x%08x\n",j,tid[j],sta[j],(unsigned int)retval[j]);
    }
    printf("*********************************\n");
    printf("Create time  = %u\n",time_create);
    printf("Start time   = %u\n",time_start);
    printf("Stop time    = %u\n",time_stop);
    printf("*********************************\n");
    printf("Creation time (|Start - Create|) = %u\n",time_start - time_create);
    printf("Compute time  (|Stop - Start|)   = %u\n",time_stop - time_start);
    printf("*********************************\n");
    printf("Total  (|Create - Start|)   = %u\n",time_stop - time_create);
    return 0;
}

	/* encrypt algorithm */
void cipher_all(unsigned int initial, unsigned int final, unsigned * in, unsigned * out, unsigned key[7][10])
{
    int i = 0;
    for (i = initial; i < final; i+=C_BLOCK_SIZE)
    {
        // Cipher each block
        cip(&in[i], &out[i], key);
    }
}

void cip(unsigned IN[5],unsigned OUT[5],unsigned Z[7][10]) 
{
	unsigned r,x1,x2,x3,x4,kk,t1,t2,a;
	x1=IN[1]; x2=IN[2]; x3=IN[3]; x4=IN[4];
	for(r=1;r<=8;r++) 			/* the round function */
	{
			/* the group operation on 64-bits block */
	x1 = mul(x1,Z[1][r]);		x4 = mul(x4,Z[4][r]);
	x2 = (x2 + Z[2][r]) & one;	x3 = (x3 + Z[3][r]) & one;
			/* the function of the MA structure */
	kk = mul(Z[5][r],(x1^x3));
	t1 = mul(Z[6][r],(kk+(x2^x4)) & one);
	t2 = (kk+t1) & one;
			/* the involutary permutation PI */
	x1 = x1^t1;		x4=x4^t2;
	a  = x2^t2;		x2=x3^t1;	x3=a;

	//printf("\n\t%1u-th rnd %6u\t%6u\t%6u\t%6u",r,x1,x2,x3,x4);
	}

		/* the output transformation */
	OUT[1] = mul(x1,Z[1][round+1]);
	OUT[4] = mul(x4,Z[4][round+1]);
	OUT[2] = (x3+Z[2][round+1]) & one;
	OUT[3] = (x2+Z[3][round+1]) & one;
}

	/* multiplication using the Low-High algorithm */

unsigned mul(unsigned a,unsigned b) 
{
	long int p;
	long unsigned q;
		if(a==0) p=maxim-b;
		else
		if(b==0) p=maxim-a;
		else {
		q=(unsigned long)a*(unsigned long)b;
		p=(q & one) - (q>>16); 
		if(p<=0) p=p+maxim;
		}
	return (unsigned)(p&one);
}

	/* compute inverse of xin by Euclidean gcd alg. */

unsigned inv(unsigned xin)
{
	long n1,n2,q,r,b1,b2,t;
	if(xin==0) b2=0;
	else
	{ n1=maxim; n2=xin; b2=1; b1=0;
		do { r = (n1 % n2); q = (n1-r)/n2;
			 if(r==0) { if(b2<0) b2=maxim+b2; }
			 else { n1=n2; n2=r; t=b2; b2=b1-q*b2; b1=t; }
		   } while (r!=0);
	}
	return (unsigned)b2;
}

	/* generate encryption subkeys Z's */

void key(short unsigned uskey[9], unsigned Z[7][10]) 
{
	short unsigned S[54];
	int i,j,r;
	for(i=1;i<9;i++) S[i-1]=uskey[i];
		/* shifts */
	for(i=8;i<54;i++)
		{
			if((i+2)%8 == 0)			/* for S[14],S[22],... */
				S[i] = ((S[i-7]<<9) ^ (S[i-14]>>7)) & one;
			else if((i+1)%8==0)			/* for S[15],S[23],... */
				S[i] = ((S[i-15]<<9) ^ (S[i-14]>>7)) & one;
			else
				S[i] = ((S[i-7]<<9) ^ (S[i-6]>>7)) & one;
		}

	/* get subkeys */

	for(r=1;r<=round+1;r++) 
	 for(j=1;j<7;j++)
		Z[j][r]=S[6*(r-1)+j-1];
}

	/* compute decryption subkeys DK's */

void de_key(unsigned Z[7][10],unsigned DK[7][10])
{
	int j;
	for(j=1;j<=round+1;j++)
	{
		DK[1][round-j+2] = inv(Z[1][j]);
		DK[4][round-j+2] = inv(Z[4][j]);
	
		if (j==1 || j==round+1) {
			DK[2][round-j+2] = (fuyi-Z[2][j]) & one;
			DK[3][round-j+2] = (fuyi-Z[3][j]) & one;
		} else {
			DK[2][round-j+2] = (fuyi-Z[3][j]) & one;
			DK[3][round-j+2] = (fuyi-Z[2][j]) & one;
		}
	}

	for(j=1;j<=round+1;j++)
	{ DK[5][round+1-j]=Z[5][j];
	  DK[6][round+1-j]=Z[6][j];
	}
}


int main()
{
    int x;
    for (x = 0; x < 4; x++)
    {
        run_tests();
    }
    return 0;
}
