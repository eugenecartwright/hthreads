#ifndef _TCPIP_CALLBACKS_H_
#define _TCPIP_CALLBACKS_H_

#include <tcpip.h>

extern err_t tcpip_connected( void*, struct tcp_pcb*, err_t );
extern err_t tcpip_accept( void*, struct tcp_pcb*, err_t );
extern err_t tcpip_sent( void*, struct tcp_pcb*, u16_t len );
extern err_t tcpip_recv( void*, struct tcp_pcb*, struct pbuf*, err_t );
extern err_t tcpip_poll( void*, struct tcp_pcb* );
extern void tcpip_err( void*, err_t err );
extern struct tcp_pcb* tcpip_up( void*, struct netif* );
extern void tcpip_running( struct tcp_pcb* );

#endif
