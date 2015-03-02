/********************************IDEA.C*******************************/
/* idea.c - C source code for IDEA block cipher. IDEA (International Data
 * Encryption Algorithm), formerly known as IPES (Improved Proposed Encryption
 * Standard). Algorithm developed by Xuejia Lai and James L. Massey, of ETH
 * Zurich. This implementation modified and derived from original C code
 * developed by Xuejia Lai. Zero-based indexing added, names changed from IPES
 * to IDEA. CFB functions added. Random number routines added. Optimized for
 * speed 21 Oct 92 by Colin Plumb <colin@nsq.gts.org>. This code assumes that
 * each pair of 8-bit bytes comprising a 16-bit word in the key and in the
 * cipher block are externally represented with the Most Significant Byte
 * (MSB) first, regardless of internal native byte order of the target CPU.  */

#include <hthread.h>
#include <stdio.h>
#include "idea.h"

#define USEHWT 0
#define HWTI_ZERO_BASEADDR (void *)(0x63000000)
#define HWTI_ONE_BASEADDR (void *)(0x63010000)
#define LOG_SERIAL 1
#include <log/log.h>
log_t log;

#define LENGTH      900             /* Number of 4 16bit words to encrypt */
#define ROUNDS      8               /* Don't change this value, should be 8 */
#define KEYLEN      (6*ROUNDS+4)    /* length of key schedule */

typedef word16 IDEAkey[KEYLEN];

#ifdef IDEA32/* Use >16-bit temporaries */
#define low16(x) ((x) & 0xFFFF)
typedef unsigned int uint16;        /* at LEAST 16 bits, maybe more */
#else
#define low16(x) (x)                /* this is only ever applied to uint16's */
typedef word16 uint16;
#endif

#ifdef _GNUC_
/* __const__ simply means there are no side effects for this function,
 * which is useful info for the gcc optimizer */
#define CONST __const__
#else
#define CONST
#endif

static void en_key_idea(word16 userkey[8], IDEAkey Z);
static void de_key_idea(IDEAkey Z, IDEAkey DK);
#ifdef THREAD
struct cipher {
	word16 * in;
	word16 * out;
	int count;
	word16 * Z;
};

static void * cipher_idea(void *);
#else
static void * cipher_idea(word16 * in, word16 * out, int count, CONST IDEAkey Z);
#endif

void readHWTStatus( void* baseAddr) {
	printf( "Thread %x\n", baseAddr );
    printf( "  HWT Thread ID %x \n", read_reg(baseAddr) );
    printf( "  HWT Status  %x \n", read_reg(baseAddr + 0x00000008) );
    printf( "  HWT Command %x \n", read_reg(baseAddr + 0x0000000C) );
    printf( "  HWT Argument %x \n", read_reg(baseAddr + 0x00000010) );
    printf( "  HWT Result %x \n", read_reg(baseAddr + 0x00000014) );
    printf( "  HWT Timer %d \n", read_reg(baseAddr + 0x00000004) );
    //printf( "  HWT Debug User %x \n", read_reg(baseAddr + 0x0000001C) );
    //printf( "  HWT Reg Master Read %x \n", read_reg(baseAddr + 0x00000020) );
    //printf( "  HWT Reg Master Write %x \n", read_reg(baseAddr + 0x00000024) );
    //printf( "  HWT Stack Pointer %x \n", read_reg(baseAddr + 0x00000028) );
    //printf( "  HWT Frame Pointer %x \n", read_reg(baseAddr + 0x0000002C) );
    //printf( "  HWT Heap Pointer %x \n", read_reg(baseAddr + 0x00000030) );
    //printf( "  HWT RPC Numbers %x \n", read_reg(baseAddr + 0x00000048) );
    //printf( "  HWT RPC Struct %x \n", read_reg(baseAddr + 0x0000004C) );
}


/* Multiplication, modulo (2**16)+1. Note that this code is structured like
 * this on the assumption that untaken branches are cheaper than taken
 * branches, and the compiler doesn't schedule branches. */
#ifdef SMALL_CACHE
CONST static uint16 mul(register uint16 a, register uint16 b)
{
       register word32 p;
       if (a)
       {     if (b)
             {      p = (word32)a * b;
                    b = low16(p);
                    a = p>>16;
                    return b - a + (b < a);
             }
             else
             {      return 1-a;
             }
       }
       else
       {     return 1-b;
       }
}        /* mul */
#endif /* SMALL_CACHE */
/* Compute multiplicative inverse of x, modulo (2**16)+1, using Euclid's GCD
 * algorithm. It is unrolled twice to avoid swapping the meaning of the
 * registers each iteration; some subtracts of t have been changed to adds.  */
CONST static uint16 inv(uint16 x)
{
       uint16 t0, t1;
       uint16 q, y;
       if (x <= 1)
             return x;    /* 0 and 1 are self-inverse */
       t1 = 0x10001 / x;  /* Since x >= 2, this fits into 16 bits */
       y = 0x10001 % x;
       if (y == 1)
             return low16(1-t1);
       t0 = 1;
       do
       {     q = x / y;
             x = x % y;
             t0 += q * t1;
             if (x == 1)
                    return t0;
             q = y / x;
             y = y % x;
             t1 += q * t0;
       } while (y != 1);
       return low16(1-t1);
} /* inv */
/*     Compute IDEA encryption subkeys Z */
static void en_key_idea(word16 *userkey, word16 *Z)
{
       int i,j;
       /* shifts */
       for (j=0; j<8; j++)
             Z[j] = *userkey++;
       for (i=0; j<KEYLEN; j++)
       {     i++;
             Z[i+7] = Z[i & 7] << 9 | Z[(i+1) & 7] >> 7;
             Z += i & 8;
             i &= 7;
       }
}        /* en_key_idea */
/*     Compute IDEA decryption subkeys DK from encryption subkeys Z */
/* Note: these buffers *may* overlap! */
static void de_key_idea(IDEAkey Z, IDEAkey DK)
{
       int j;
       uint16 t1, t2, t3;
       IDEAkey T;
       word16 *p = T + KEYLEN;
       t1 = inv(*Z++);
       t2 = -*Z++;
       t3 = -*Z++;
       *--p = inv(*Z++);
       *--p = t3;
       *--p = t2;
       *--p = t1;
       for (j = 1; j < ROUNDS; j++)
       {
             t1 = *Z++;
             *--p = *Z++;
             *--p = t1;
             t1 = inv(*Z++);
             t2 = -*Z++;
             t3 = -*Z++;
             *--p = inv(*Z++);
             *--p = t2;
             *--p = t3;
             *--p = t1;
       }
       t1 = *Z++;
       *--p = *Z++;
       *--p = t1;
       t1 = inv(*Z++);
       t2 = -*Z++;
       t3 = -*Z++;
       *--p = inv(*Z++);
       *--p = t3;
       *--p = t2;
       *--p = t1;
/* Copy and destroy temp copy */
       for (j = 0, p = T; j < KEYLEN; j++)
       {
             *DK++ = *p;
             *p++ = 0;
       }
} /* de_key_idea */
/* MUL(x,y) computes x = x*y, modulo 0x10001. Requires two temps, t16 and t32.
 * x must me a side-effect-free lvalue. y may be anything, but unlike x, must
 * be strictly 16 bits even if low16() is #defined. All of these are
 * equivalent; see which is faster on your machine.  */
#ifdef SMALL_CACHE
#define MUL(x,y) (x = mul(low16(x),y))
#else
#ifdef AVOID_JUMPS
#define MUL(x,y) (x = low16(x-1), t16 = low16((y)-1), \
             t32 = (word32)x*t16+x+t16+1, x = low16(t32), \
             t16 = t32>>16, x = x-t16+(x<t16) )
#else
#define MUL(x,y) ((t16 = (y)) ? (x=low16(x)) ? \
        t32 = (word32)x*t16, x = low16(t32), t16 = t32>>16, \
        x = x-t16+(x<t16) : \
        (x = 1-t16) : (x = 1-x))
#endif
#endif
/* IDEA encryption/decryption algorithm . In/out can be the same buffer */
#ifdef THREAD
static void * cipher_idea(void * arg)
#else
static void * cipher_idea(word16 * in, word16 * out, int count, register CONST IDEAkey Z)
#endif
{
       register uint16 x1, x2, x3, x4, t1, t2;
       register uint16 t16;
       register word32 t32;
       int r = ROUNDS;
       word16 * origZ;
       
#ifdef THREAD
       word16 *in, *out;
       int count;
       word16 * Z;
       struct cipher * data;
       data = (struct cipher *) arg;
       in = data->in;
       out = data->out;
       count = data->count;
       Z = data->Z;
#endif

       origZ = Z;
    while( count > 0 ) {
       Z = origZ;
       r = ROUNDS;
       count--;
       x1 = *in++;  x2 = *in++;
       x3 = *in++;  x4 = *in++;
       do
       {
             //printf( "Round %d\n", r );
             MUL(x1,*Z++);
             x2 += *Z++;
             //printf( " A  x1 %4x, x2 %4x, x3 %4x, x4 %4x, t1 %4x, t2 %4x\n", x1, x2, x3, x4, t1, t2 );
             x3 += *Z++;
             MUL(x4, *Z++);
             //printf( " B  x1 %4x, x2 %4x, x3 %4x, x4 %4x, t1 %4x, t2 %4x\n", x1, x2, x3, x4, t1, t2 );
             t2 = x1^x3;
             MUL(t2, *Z++);
             t1 = t2 + (x2^x4);
             MUL(t1, *Z++);
             //printf( " C  x1 %4x, x2 %4x, x3 %4x, x4 %4x, t1 %4x, t2 %4x\n", x1, x2, x3, x4, t1, t2 );
             t2 = t1+t2;
             x1 ^= t1;
             x4 ^= t2;
             t2 ^= x2;
             x2 = x3^t1;
             x3 = t2;
             //printf( " D  x1 %4x, x2 %4x, x3 %4x, x4 %4x, t1 %4x, t2 %4x\n", x1, x2, x3, x4, t1, t2 );
       } while (--r);
       MUL(x1, *Z++);
       *out++ = x1;
       *out++ = x3 + *Z++;
       *out++ = x2 + *Z++;
       MUL(x4, *Z);
       *out++ = x4;
       //printf( " E  x1 %4x, x2 %4x, x3 %4x, x4 %4x, t1 %4x, t2 %4x\n\n", x1, x2, x3, x4, t1, t2 );
    }
    
    return NULL;
} /* cipher_idea */
/*-------------------------------------------------------------*/

/* Number of Kbytes of test data to encrypt. Defaults to 1 MByte. */
#ifndef KBYTES
#define KBYTES 1024
#endif

int main(void) {
    int i, k;
    IDEAkey Z, DK;
    word16 XX[LENGTH], YY[LENGTH], XX2[LENGTH], YY2[LENGTH];
    word16 userkey[8];
#ifdef THREAD
    struct cipher arguments, arguments2;
    hthread_t thread, thread2;
    hthread_attr_t attr, attr2;
#endif

	//Generate a make believe key
	for(i=0; i<8; i++)
             userkey[i] = i+1;
    // Compute encryption subkeys from user key...
    en_key_idea(userkey,Z);
    // Compute decryption subkeys from encryption subkeys...
    de_key_idea(Z,DK);
       
	//Generate data to encrypt
	for (k=0; k<LENGTH; k++) XX[k] = k;
	for (k=0; k<LENGTH; k++) XX2[k] = k;
	for (k=0; k<LENGTH; k++) YY[k] = 0;
	for (k=0; k<LENGTH; k++) YY2[k] = 0;
	
	memcpy( (void *) 0x63001000, (void *) &Z[0], 104 );
	memcpy( (void *) 0x63011000, (void *) &Z[0], 104 );
	
	memcpy( (void *) 0x63002000, (void *) &XX[0], LENGTH * 2);
	memcpy( (void *) 0x63012000, (void *) &XX2[0], LENGTH * 2);

	log_create( &log, 1024 );
	
#ifdef THREAD
	arguments.in = &XX[0];
	arguments.out = &YY[0];
	arguments.count = LENGTH / 4;
	arguments.Z = &Z[0];

	arguments2.in = &XX2[0];
	arguments2.out = &YY2[0];
	arguments2.count = LENGTH / 4;
	arguments2.Z = &Z[0];
	
	//printf( "argument %x\n", &arguments );
	//printf( "in %x\n", arguments.in );
	//printf( "out %x\n", arguments.out );
	//printf( "count %x\n", arguments.count );
	//printf( "Z %x\n", arguments.Z );
	
	printf( "Starting ...\n" );

	hthread_attr_init( &attr );
	hthread_attr_init( &attr2 );
	if ( USEHWT >= 1) hthread_attr_sethardware( &attr, HWTI_ZERO_BASEADDR );
	if ( USEHWT >= 2) hthread_attr_sethardware( &attr2, HWTI_ONE_BASEADDR );
	log_time( &log );
	hthread_create( &thread, &attr, cipher_idea, &arguments );
	//hthread_create( &thread2, &attr2, cipher_idea, &arguments2 );

    //while ( 8 != read_reg(HWTI_ZERO_BASEADDR + 0x00000008) ) hthread_yield();
    //while ( 8 != read_reg(HWTI_ONE_BASEADDR + 0x00000008) ) hthread_yield();
	//readHWTStatus( HWTI_ZERO_BASEADDR );
	//printf( "%x %x %x %x\n", YY[0], YY[1], YY[2], YY[3] );
	//printf( "%x %x %x %x\n", YY[4], YY[5], YY[6], YY[7] );
	//printf( "%x %x %x %x\n", YY[8], YY[9], YY[10], YY[11] );
	//printf( "%x %x %x %x\n", YY[12], YY[13], YY[14], YY[15] );

	hthread_join( thread, NULL );
	//hthread_join( thread2, NULL );
	log_time( &log );

	//readHWTStatus( HWTI_ZERO_BASEADDR );
	//readHWTStatus( HWTI_ONE_BASEADDR );
	
#else
	log_time( &log );
	cipher_idea(XX,YY,LENGTH/4,Z);
	cipher_idea(XX2,YY2,LENGTH/4,Z);
	log_time( &log );
#endif

	printf( "Length %d\n", LENGTH );
	//printf( "%x %x %x %x\n", YY[0], YY[1], YY[2], YY[3] );
	//printf( "%x %x %x %x\n", YY[4], YY[5], YY[6], YY[7] );
	//printf( "%x %x %x %x\n", YY[8], YY[9], YY[10], YY[11] );
	//printf( "%x %x %x %x\n", YY[12], YY[13], YY[14], YY[15] );

	//printf( "%x %x %x %x\n", YY2[0], YY2[1], YY2[2], YY2[3] );
	//printf( "%x %x %x %x\n", YY2[4], YY2[5], YY2[6], YY2[7] );
	//printf( "%x %x %x %x\n", YY2[8], YY2[9], YY2[10], YY2[11] );
	//printf( "%x %x %x %x\n", YY2[12], YY2[13], YY2[14], YY2[15] );
	
	log_close_ascii( &log );
	return 0;
}

/*************************************************************************/
/* xorbuf - change buffer via xor with random mask block. Used for Cipher
 * Feedback (CFB) or Cipher Block Chaining (CBC) modes of encryption. Can be
 *  applied for any block encryption algorithm, with any block size, such as
 * the DES or the IDEA cipher.  */
static void xorbuf(register byteptr buf, register byteptr mask,
       register int count)
/*     count must be > 0 */
{
       if (count)
             do
                    *buf++ ^= *mask++;
             while (--count);
}      /* xorbuf */
/* cfbshift - shift bytes into IV for CFB input. Used only for Cipher Feedback
 * (CFB) mode of encryption. Can be applied for any block encryption algorithm
 * with any block size, such as the DES or the IDEA cipher.  */
static void cfbshift(register byteptr iv, register byteptr buf,
             register int count, int blocksize)
/* iv is initialization vector. buf is buffer pointer. count is number of bytes
 * to shift in...must be > 0. blocksize is 8 bytes for DES or IDEA ciphers. */
{
       int retained;
       if (count)
       {
             retained = blocksize-count;   /* number bytes in iv to retain */
         /* left-shift retained bytes of IV over by count bytes to make room */
             while (retained--)
             {
                    *iv = *(iv+count);
                    iv++;
             }
             /* now copy count bytes from buf to shifted tail of IV */
             do     *iv++ = *buf++;
             while (--count);
       }
}      /* cfbshift */
/* Key schedules for IDEA encryption and decryption */
static IDEAkey Z, DK;
static word16 *iv_idea;        /* pointer to IV for CFB or CBC */
static boolean cfb_dc_idea;    /* TRUE iff CFB decrypting */
/* initkey_idea initializes IDEA for ECB mode operations */
void initkey_idea(byte key[16], boolean decryp)
{
       word16 userkey[8]; /* IDEA key is 16 bytes long */
       int i;
       /* Assume each pair of bytes comprising a word is ordered MSB-first. */
       for (i=0; i<8; i++)
       {
             userkey[i] = (key[0]<<8) + key[1];
             key++; key++;
       }
       en_key_idea(userkey,Z);
       if (decryp)
       {
             de_key_idea(Z,Z);   /* compute inverse key schedule DK */
       }
       for (i=0; i<8; i++)/* Erase dangerous traces */
             userkey[i] = 0;
} /* initkey_idea */
/* Run a 64-bit block thru IDEA in ECB (Electronic Code Book) mode, using the
 * currently selected key schedule. */
void idea_ecb(word16 *inbuf, word16 *outbuf)
{
       /* Assume each pair of bytes comprising a word is ordered MSB-first. */
#ifndef HIGHFIRST   /* If this is a least-significant-byte-first CPU */
       word16 x;
       /* Invert the byte order for each 16-bit word for internal use. */
       x = inbuf[0]; outbuf[0] = x >> 8 | x << 8;
       x = inbuf[1]; outbuf[1] = x >> 8 | x << 8;
       x = inbuf[2]; outbuf[2] = x >> 8 | x << 8;
       x = inbuf[3]; outbuf[3] = x >> 8 | x << 8;
#ifndef THREAD
       cipher_idea(outbuf, outbuf, 1, Z);
#endif
       x = outbuf[0]; outbuf[0] = x >> 8 | x << 8;
       x = outbuf[1]; outbuf[1] = x >> 8 | x << 8;
       x = outbuf[2]; outbuf[2] = x >> 8 | x << 8;
       x = outbuf[3]; outbuf[3] = x >> 8 | x << 8;
#else  /* HIGHFIRST */
       /* Byte order for internal and external representations is the same. */
       cipher_idea(inbuf, outbuf, Z);
#endif /* HIGHFIRST */
} /* idea_ecb */
/* initcfb - Initializes IDEA key schedule tables via key; initializes Cipher
 * Feedback mode IV. References context variables cfb_dc_idea and iv_idea.  */
void initcfb_idea(word16 iv0[4], byte key[16], boolean decryp)
/* iv0 is copied to global iv_idea, buffer will be destroyed by ideacfb. key is
 * pointer to key buffer. decryp is TRUE if decrypting, FALSE if encrypting. */
{
       iv_idea = iv0;
       cfb_dc_idea = decryp;
       initkey_idea(key,FALSE);
} /* initcfb_idea */
/* ideacfb - encipher a buffer with IDEA enciphering algorithm, using Cipher
 *  Feedback (CFB) mode. Assumes initcfb_idea has already been called.
 * References context variables cfb_dc_idea and iv_idea.  */
void ideacfb(byteptr buf, int count)
/* buf is input, output buffer, may be more than 1 block. count is byte count
 * is byte count of buffer.  May be > IDEABLOCKSIZE. */
{
    int chunksize;                /* smaller of count, IDEABLOCKSIZE */
    word16 temp[IDEABLOCKSIZE/2];

       while ((chunksize = min(count,IDEABLOCKSIZE)) > 0)
       {
             idea_ecb(iv_idea,temp);  /* encrypt iv_idea, making temp. */
             if (cfb_dc_idea)/* buf is ciphertext */
                    /* shift in ciphertext to IV... */
                    cfbshift((byte *)iv_idea,buf,chunksize,IDEABLOCKSIZE);
             /* convert buf via xor */
             xorbuf(buf,(byte *)temp,chunksize);/* buf has enciphered output */
             if (!cfb_dc_idea)/* buf was plaintext, is now ciphertext */
                    /* shift in ciphertext to IV... */
                    cfbshift((byte *)iv_idea,buf,chunksize,IDEABLOCKSIZE);
             count -= chunksize;
             buf += chunksize;
       }
} /* ideacfb */
/* close_idea function erases all the key schedule information when we are
 * done with a set of operations for a particular IDEA key context. This is to
 * prevent any sensitive data from being left around in memory. */
void close_idea(void)     /* erase current key schedule tables */
{
       short i;
       for (i = 0; i < KEYLEN; i++)
             Z[i] = 0;
}      /* close_idea() */
/********************************************************************/
/* These buffers are used by init_idearand, idearand, and close_idearand. */
static word16 dtbuf_idea[4] = {0};     /* buffer for enciphered timestamp */
static word16 randseed_idea[4] = {0};  /* seed for IDEA random # generator */
static word16 randbuf_idea[4] = {0};   /* buffer for IDEA random # generator */
static byte randbuf_idea_counter = 0;  /* random bytes left in randbuf_idea */
/* init_idearand - initialize idearand, IDEA random number generator. Used for
 *  generating cryptographically strong random numbers. Much of design comes
 * from Appendix C of ANSI X9.17. key is pointer to IDEA key buffer. seed is
 * pointer to random number seed buffer. tstamp is a 32-bit timestamp */
void init_idearand(byte key[16], byte seed[8], word32 tstamp)
{
       int i;
       initkey_idea(key, FALSE);      /* initialize IDEA */
       for (i=0; i<4; i++)            /* capture timestamp material */
       {     dtbuf_idea[i] = tstamp;  /* get bottom word */
             tstamp = tstamp >> 16;   /* drop bottom word */
             /* tstamp has only 4 bytes-- last 4 bytes will always be 0 */
       }
       /* Start with enciphered timestamp: */
       idea_ecb(dtbuf_idea,dtbuf_idea);
       /* initialize seed material */
       for (i=0; i<8; i++)
             ((byte *)randseed_idea)[i] = seed[i];
       randbuf_idea_counter = 0; /* # of random bytes left in randbuf_idea */
} /* init_idearand */
/* idearand - IDEA pseudo-random number generator. Used for generating
 * cryptographically strong random numbers. Much of design comes from Appendix
 * C of ANSI X9.17.  */
byte idearand(void)
{
       int i;
       if (randbuf_idea_counter==0)         /* if random buffer is spent...*/
       {     /* Combine enciphered timestamp with seed material: */
             for (i=0; i<4; i++)
                    randseed_idea[i] ^= dtbuf_idea[i];
             idea_ecb(randseed_idea,randbuf_idea);   /* fill new block */
             /* Compute new seed vector: */
             for (i=0; i<4; i++)
                    randseed_idea[i] = randbuf_idea[i] ^ dtbuf_idea[i];
             idea_ecb(randseed_idea,randseed_idea);    /* fill new seed */
             randbuf_idea_counter = 8;   /* reset counter for full buffer */
       }
       /* Take a byte from randbuf_idea: */
       return(((byte *)randbuf_idea)[--randbuf_idea_counter]);
} /* idearand */
void close_idearand(void)
{      /* Erase random IDEA buffers and wipe out IDEA key info */
       int i;
       for (i=0; i<4; i++)
       {     randbuf_idea[i] = 0;
             randseed_idea[i] = 0;
             dtbuf_idea[i] = 0;
       }
       close_idea();/* erase current key schedule tables */
}      /* close_idearand */
/* end of idea.c */
