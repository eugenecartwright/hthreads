#include <pr.h>
#include <dma/dma.h>
#include <hwti/hwti.h>
#include "pvr.h"

#ifdef PR
Hint perform_PR(Huint mb, Huint accelerator_type) {
   
   volatile Huint * SWtrigger = (volatile Huint *) SW_triggers[mb];
   volatile Hint * StatusReg    = (volatile Hint *) MB_status[mb];

   // is there anything pending for this socket??
   if(!(*SWtrigger&0x8000)) 
      *SWtrigger = accelerator_type;

   while  ((*StatusReg & 0x07) != 7);        

   return SUCCESS;

}

#endif
