#ifndef __ARCH_SYS_ARCH_H__
#define __ARCH_SYS_ARCH_H__

#include <sys/types.h>
#include <semaphore.h>

#define SYS_MBOX_NULL NULL
#define SYS_SEM_NULL  NULL

typedef sem_t *sys_sem_t;

struct sys_mbox_s;
typedef struct sys_mbox_s *sys_mbox_t;

struct sys_thread;
typedef struct sys_thread *sys_thread_t;

/* typedef int sys_prot_t; */

#endif /* __ARCH_SYS_ARCH_H__ */

