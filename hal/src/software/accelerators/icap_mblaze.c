#include <icap.h>
#include <dma/dma.h>
#include <hwti/hwti.h>
#include "pvr.h"


#ifdef ICAP
Hint perform_PR(Huint mb, Huint accelerator_type) {

   int SW_TRIGGER, STATUS;
   switch (mb)
   {
      case MB0 : SW_TRIGGER =MB_0_SW_TRIGGER; STATUS=MB_0_STATUS;   break;
      case MB1 : SW_TRIGGER =MB_1_SW_TRIGGER; STATUS=MB_1_STATUS;   break;
      case MB2 : SW_TRIGGER =MB_2_SW_TRIGGER; STATUS=MB_2_STATUS;   break;
      case MB3 : SW_TRIGGER =MB_3_SW_TRIGGER; STATUS=MB_3_STATUS;   break;
      case MB4 : SW_TRIGGER =MB_4_SW_TRIGGER; STATUS=MB_4_STATUS;   break;
      case MB5 : SW_TRIGGER =MB_5_SW_TRIGGER; STATUS=MB_5_STATUS;   break;
      case MB6 : SW_TRIGGER =MB_6_SW_TRIGGER; STATUS=MB_6_STATUS;   break;
      case MB7 : SW_TRIGGER =MB_7_SW_TRIGGER; STATUS=MB_7_STATUS;   break;
      case MB8 : SW_TRIGGER =MB_8_SW_TRIGGER; STATUS=MB_8_STATUS;   break;
      case MB9 : SW_TRIGGER =MB_9_SW_TRIGGER; STATUS=MB_9_STATUS;   break;
      case MB10 : SW_TRIGGER =MB_10_SW_TRIGGER; STATUS=MB_10_STATUS;   break;
      case MB11 : SW_TRIGGER =MB_11_SW_TRIGGER; STATUS=MB_11_STATUS;   break;
      case MB12 : SW_TRIGGER =MB_12_SW_TRIGGER; STATUS=MB_12_STATUS;   break;
      case MB13 : SW_TRIGGER =MB_13_SW_TRIGGER; STATUS=MB_13_STATUS;   break;
      case MB14 : SW_TRIGGER =MB_14_SW_TRIGGER; STATUS=MB_14_STATUS;   break;
      case MB15 : SW_TRIGGER =MB_15_SW_TRIGGER; STATUS=MB_15_STATUS;   break;
   }
   int Status=Xil_In32(SW_TRIGGER);
   // is there anything pending for this socket??
   if(!(Status&0x8000)) Xil_Out32(SW_TRIGGER,accelerator_type);
     
   while  ((Xil_In32(STATUS)&0x07) != 7);        

   return SUCCESS;

}

#endif
