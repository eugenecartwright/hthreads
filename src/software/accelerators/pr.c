#include <pr.h>
#include <dma/dma.h>
#include <hwti/hwti.h>
#include "pvr.h"

#ifdef PR

Hint perform_PR(Huint mb, Huint accelerator_type) {
   
   Huint SW_TRIGGER, STATUS;
   volatile Huint *trigger, *status;
   switch (mb)
   {
      case 0  : SW_TRIGGER = MB_0_SW_TRIGGER;   STATUS=MB_0_STATUS;  break;
      case 1  : SW_TRIGGER = MB_1_SW_TRIGGER;   STATUS=MB_1_STATUS;  break;
      case 2  : SW_TRIGGER = MB_2_SW_TRIGGER;   STATUS=MB_2_STATUS;  break;
      case 3  : SW_TRIGGER = MB_3_SW_TRIGGER;   STATUS=MB_3_STATUS;  break;
      case 4  : SW_TRIGGER = MB_4_SW_TRIGGER;   STATUS=MB_4_STATUS;  break;
      case 5  : SW_TRIGGER = MB_5_SW_TRIGGER;   STATUS=MB_5_STATUS;  break;
      case 6  : SW_TRIGGER = MB_6_SW_TRIGGER;   STATUS=MB_6_STATUS;  break;
      case 7  : SW_TRIGGER = MB_7_SW_TRIGGER;   STATUS=MB_7_STATUS;  break;
      case 8  : SW_TRIGGER = MB_8_SW_TRIGGER;   STATUS=MB_8_STATUS;  break;
      case 9  : SW_TRIGGER = MB_9_SW_TRIGGER;   STATUS=MB_9_STATUS;  break;
      case 10 : SW_TRIGGER = MB_10_SW_TRIGGER;  STATUS=MB_10_STATUS; break;
      case 11 : SW_TRIGGER = MB_11_SW_TRIGGER;  STATUS=MB_11_STATUS; break;
      case 12 : SW_TRIGGER = MB_12_SW_TRIGGER;  STATUS=MB_12_STATUS; break;
      case 13 : SW_TRIGGER = MB_13_SW_TRIGGER;  STATUS=MB_13_STATUS; break;
      case 14 : SW_TRIGGER = MB_14_SW_TRIGGER;  STATUS=MB_14_STATUS; break;
      case 15 : SW_TRIGGER = MB_15_SW_TRIGGER;  STATUS=MB_15_STATUS; break;
      default : return FAILURE;
   }

   trigger = (volatile Huint *) SW_TRIGGER;
   status  = (volatile Huint *) STATUS;

   // is there anything pending for this socket??
   if(!(*trigger & 0x8000)) 
      *trigger = accelerator_type;
  
   Huint ReadStatus = 0;
   do {
      ReadStatus = *status;
      // Checking if error bits == 0
      if ((ReadStatus & 0x78) != 0) {
         return FAILURE;
      }
   } while((ReadStatus & 0x07) != 7);
   
   // always update last_accelerator field
   extern Huint hwti_array[];
   Huint vhwti_base = hwti_array[mb];
   _hwti_set_last_accelerator(vhwti_base, accelerator_type);

   // TODO: Does not update slave table for host.

   return SUCCESS;

}

#endif
