#ifndef TCB_H
#define TCB_H

#include "common/types.h"
#include "common/export_buffer.h"
#include "common/import_buffer.h"


/* only the TCB struct (at bottom) is of interest */


typedef struct {
  byte* base_addr;
} TCB_Virtualization;



typedef struct {
  flag done_interpreting;
  flag start_exporting;
  flag done_exporting;
} TCB_CommunicationsControl;

typedef struct {
  ExportBuffer* export_buffer_addr;
  ImportBuffer* import_buffer_addr;
  word return_value;  
} TCB_CommunicationsData;

typedef struct {
  TCB_CommunicationsControl control;
  TCB_CommunicationsData data;
} TCB_Communication;


typedef struct {
  TID_t tid;
  TCB_Virtualization virtualization;
  TCB_Communication communication;
} TCB;

#endif

