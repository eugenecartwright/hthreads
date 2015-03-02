/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Kansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

/** \file       netif.h
  * \brief      Header file for the ethlite lwip network interface.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads ethlite network interface.
  */
#ifndef _HYBRID_THREADS_DRIVER_ETHLITE_NETIF_H_
#define _HYBRID_THREADS_DRIVER_ETHLITE_NETIF_H_

#include <ethlite/ethlite.h>
#include <lwip/api.h>
#include <lwip/raw.h>
#include <lwip/mem.h>
#include <lwip/netif.h>
#include <lwip/stats.h>
#include <netif/etharp.h>

#if LINK_STATS
#define RECV_INC()      (lwip_stats.link.recv++)
#define SEND_INC()      (lwip_stats.link.xmit++)
#define MEMERR_INC()    (lwip_stats.link.memerr++)
#define DROP_INC()      (lwip_stats.link.drop++)
#else
#define RECV_INC()
#define SEND_INC()
#define MEMERR_INC()
#define DROP_INC()
#endif

#if ETH_PAD_SIZE
#define ADD_SIZE(p)         ((p) += (ETH_PAD_SIZE))
#define DROP_SIZE(p)        pbuf_header((p), (-ETH_PAD_SIZE));
#define RECLAIM_SIZE(p)     pbuf_header((p), (ETH_PAD_SIZE));
#else
#define ADD_SIZE(p)
#define DROP_SIZE(p)
#define RECLAIM_SIZE(p)
#endif

#define ETHLITE_NETIF_NAME0     'H'
#define ETHLITE_NETIF_NAME1     'T'

typedef struct
{
    ethlite_t   eth;
    Huint       *txbuffer;
    Huint       *rxbuffer;
} ethlite_netif_t;

err_t        ethlite_netif_llinit( struct netif* );
struct pbuf* ethlite_netif_llinput( struct netif* );
err_t        ethlite_netif_lloutput( struct netif*, struct pbuf* );

err_t ethlite_netif_init( struct netif* );
void  ethlite_netif_input( struct netif* );
err_t ethlite_netif_output( struct netif*, struct pbuf*, struct ip_addr* );


#endif
