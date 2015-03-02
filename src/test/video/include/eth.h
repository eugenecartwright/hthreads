#ifndef _VIDEO_ETH_H_
#define _VIDEO_ETH_H_

#include <hthread.h>
#include <xemac.h>
#include <time.h>

#define MILLISECOND     (CLOCKS_PER_SEC/1000)

typedef XEmac eth_t;
typedef XEmac_Config eth_config_t;

extern Hint eth_init( eth_t*, eth_config_t* );
extern Hint eth_destroy( eth_t* );

extern Hint eth_recv( eth_t*, void*, Huint* );
extern Hint eth_send( eth_t*, void*, Huint );

#endif
