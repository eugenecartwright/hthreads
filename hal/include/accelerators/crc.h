#ifndef _CRC_H_
#define _CRC_H_

#include <accelerator.h>
#include "fsl.h"
#include "pvr.h"
#include <hwti/hwti.h>
#include <arch/htime.h>
#include <httype.h>

Hint poly_crc (void * list_ptr, Huint size);
Hint sw_crc(void * list_ptr, Huint size);
Hint gen_crc( Hint input);

#endif
