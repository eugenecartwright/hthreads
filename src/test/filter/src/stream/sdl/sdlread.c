#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>
#include <arch/htime.h>
#include <SDL.h>

int sdlquit = 0;
int read_nonblock( int fd, void *buffer, size_t nbytes )
{ 
    int i;
    int ret;
    char *buf;
    SDL_Event evt;

    buf = (char*)buffer;
    for( i = 0; i < nbytes; i++, buf++ )
    {
        ret = SDL_PollEvent( &evt );
        if( ret == 0 ) return i;

        switch( evt.type )
        {
        case SDL_QUIT:
            sdlquit = 1;
            break;

        case SDL_KEYDOWN:
            if ( (evt.key.keysym.unicode & 0xFF80) == 0 )
            {
                *buf = evt.key.keysym.unicode & 0x7F;
            }
            break;
        }
    }

    return i;
}
