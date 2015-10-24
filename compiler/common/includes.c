
// ---------------------------------------------------------------- //
//                          Header Files                            //
// ---------------------------------------------------------------- //
// Include hthread.h in case user includes this file before hthread.h
#include <hthread.h>
#include <config.h>
#include <hwti/hwti.h>
#include <mutex/hardware.h>

// For accessing the threads structure
#include <sys/core.h>
#include <dma/dma.h>
#include <accelerator.h>
#ifdef PR
#include <pr.h>
#include <bitstream.h>
#endif
