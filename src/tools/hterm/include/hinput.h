#ifndef _HINPUT_H_
#define _HINPUT_H_

#include <sys/select.h>
#ifndef FD_COPY
#define FD_COPY(s,d)    memcpy((d),(s),(sizeof(fd_set)))
#endif

typedef int (*callback)( int, void* );

typedef struct
{
    int         fd;
    int         del;
    void        *data;
    callback    call;
} hinput_call_t;

typedef struct
{
    int     nfds;
    fd_set  readfds;
    fd_set  writefds;
    fd_set  exceptfds;

    fd_set  rfds;
    fd_set  wfds;
    fd_set  efds;

    hinput_call_t   *readcall;
    hinput_call_t   *writecall;
    hinput_call_t   *exceptcall;

    int             readsize;
    int             writesize;
    int             exceptsize;
} hinput_t;

extern void hinput_create( hinput_t* );
extern void hinput_destroy( hinput_t* );

extern int hinput_read( hinput_t*, int, callback, void* );
extern int hinput_write( hinput_t*, int, callback, void* );
extern int hinput_except( hinput_t*, int, callback, void* );
extern void hinput_delread( hinput_t*, int );
extern void hinput_delwrite( hinput_t*, int );
extern void hinput_delexcept( hinput_t*, int );

extern int hinput_nonblocking( int fd );
extern int  hinput_select( hinput_t*, struct timeval* );

extern int  hinput_readset( hinput_t*, int );
extern int  hinput_writeset( hinput_t*, int );
extern int  hinput_exceptset( hinput_t*, int );
extern int  hinput_listener( hinput_t*, int, callback, void* );
extern int  hinput_serial( hinput_t*, const char*,int, callback, void* );

#endif
