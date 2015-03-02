/* idea.h - header file for idea.c */

#include "usuals.h"  /* typedefs for byte, word16, boolean, etc. */
#define IDEAKEYSIZE 16
#define IDEABLOCKSIZE 8
void initcfb_idea(word16 iv0[4], byte key[16], boolean decryp);
void ideacfb(byteptr buf, int count);
void close_idea(void);
void init_idearand(byte key[16], byte seed[8], word32 tstamp);
byte idearand(void);
void close_idearand(void);

/* prototypes for passwd.c */
/* GetHashedPassPhrase -get pass phrase from user, hashes it to an IDEA key. */
int GetHashedPassPhrase(char *keystring, char *hash, boolean noecho);

/* hashpass - Hash pass phrase down to 128 bits (16 bytes). */
void hashpass (char *keystring, int keylen, byte *hash);
