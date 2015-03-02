#ifndef _CRC_H_
#define _CRC_H_

#include <httype.h>

extern Hint crc(void * list_ptr, Huint size, Huint * done);
extern Hint sw_crc(void * list_ptr, Huint size);
extern Hint gen_crc( Hint input);
extern void pipeline_crc(Hint x, Hint * start, Hint n);


#endif
