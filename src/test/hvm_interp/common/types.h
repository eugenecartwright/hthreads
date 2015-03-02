#ifndef TYPES_H
#define TYPES_H

/* basic types */
typedef unsigned char byte;
typedef int word;

typedef unsigned long int ByteCount; /* this needs to match malloc signature */
typedef unsigned int TID_t;

/* flags */
typedef unsigned char flag;
#define ISSET(x) (0 != x)
#define SET(x) (x = 1)
#define UNSET(x) (x = 0)


#endif

