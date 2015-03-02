/*

   Processor-Based HW Thread Mutex Library

   */

#ifndef MUTEX_H
#define MUTEX_H

#include "proc_hw_const.h"
#include "rops.h"

// *******************************************
// Synch Manager Functions
// *******************************************
#define SYNCH_BASEADDR (0x13000000)

#define KIND_BITS           2
#define COUNT_BITS          8
#define COMMAND_BITS        3
#define THREAD_BITS         8
#define MUTEX_BITS          6

#define HT_MUTEX_LOCK       0
#define HT_MUTEX_UNLOCK     1
#define HT_MUTEX_TRY        2
#define HT_MUTEX_OWNER      3
#define HT_MUTEX_KIND       4
#define HT_MUTEX_COUNT      5

#define HT_MUTEX_MID_SHIFT  2
#define HT_MUTEX_MID_MASK   ((1 << MUTEX_BITS) - 1)
#define HT_MUTEX_TID_SHIFT  (MUTEX_BITS + HT_MUTEX_MID_SHIFT)
#define HT_MUTEX_TID_MASK   ((1 << THREAD_BITS) - 1)
#define HT_MUTEX_CMD_SHIFT  (THREAD_BITS + HT_MUTEX_TID_SHIFT)
#define HT_MUTEX_CMD_MASK   ((1 << COMMAND_BITS) - 1)

#define MT_MUTEX_SUCCESS    0x00000000
#define HT_MUTEX_ERROR      0x80000000
#define HT_MUTEX_BLOCK      0x40000000

//#define HT_MUTEX_CNT_SHIFT  (32 - COUNT_BITS)
//#define HT_MUTEX_CNT_MASK   ((1 << COUNT_BITS) - 1)
//#define HT_MUTEX_KND_SHIFT  (32 - KIND_BITS)
//#define HT_MUTEX_KND_MASK   ((1 << KIND_BITS) - 1)
//#define HT_MUTEX_OWN_SHIFT  (32 - THREAD_BITS)
//#define HT_MUTEX_OWN_MASK   ((1 << THREAD_BITS) - 1)
#define HT_MUTEX_CNT_SHIFT  0
#define HT_MUTEX_CNT_MASK   0x000000FF
#define HT_MUTEX_KND_SHIFT  0
#define HT_MUTEX_KND_MASK   0x00000003
#define HT_MUTEX_OWN_SHIFT  0
#define HT_MUTEX_OWN_MASK   0x000000FF


#define mutex_cmd(c,t,m)    ((SYNCH_BASEADDR)                             |\
                             ((c&HT_MUTEX_CMD_MASK)<<HT_MUTEX_CMD_SHIFT)  |\
                             ((t&HT_MUTEX_TID_MASK)<<HT_MUTEX_TID_SHIFT)  |\
                             ((m&HT_MUTEX_MID_MASK)<<HT_MUTEX_MID_SHIFT))

#define mutex_kind(sta)     (((sta)>>HT_MUTEX_KND_SHIFT)&HT_MUTEX_KND_MASK)
#define mutex_count(sta)    (((sta)>>HT_MUTEX_CNT_SHIFT)&HT_MUTEX_CNT_MASK)
#define mutex_owner(sta)    (((sta)>>HT_MUTEX_OWN_SHIFT)&HT_MUTEX_OWN_MASK)
#define mutex_error(sta)    ((sta) != 0)

// Mutex type attributes
#define HTHREAD_MUTEX_FAST_NP                   0
#define HTHREAD_MUTEX_RECURSIVE_NP              1
#define HTHREAD_MUTEX_ERRORCHECK_NP             2
#define HTHREAD_MUTEX_DEFAULT                   HTHREAD_MUTEX_FAST_NP

// Mutex initializer
#define HTHREAD_MUTEX_INITIALIZER               {}
#define HTHREAD_RECURSIE_MUTEX_INITIALIZER_NP   {}
#define HTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP {}

/** \internal
  * \brief  An identifier which marks the highest mutex type value.
  *
  * This definition provides an upper bound for the mutex type. When
  * the function ::hthread_mutexattr_settype is call it will check that the
  * mutex type is an integer between 0 and the value defined here.
  */
#define HTHREAD_MUTEX_MAX_NP    2

/** \brief The mutex object structure.
  *
  * This structure represents a mutex object which can be used in the
  * hthread_mutex_lock and hthread_mutex_unlock functions. However,
  * the mutex must be initialized with a call to the function
  * hthread_mutex_init before either locking or unlocking the mutex.
  *
  * Typically, to create and use a mutex the following process will be taken:
  *     - A mutex attribute object is created and setup
  *         -# A new ::hthread_mutexattr_t structure is allocated.
  *         -# The mutex attribute object is initialized with a call to the
  *             function ::hthread_mutexattr_init.
  *         -# The mutex type is set by calling the function
  *             ::hthread_mutexattr_settype with the desired mutex kind.
  *         -# The mutex number is set by calling the function
  *             ::hthread_mutexattr_setnum with the desired mutex number.
  *     - A mutex object is created and setup
  *         -# A new ::hthread_mutex_t structure is allocated.
  *         -# The mutex object is initialized with a call to the function
  *             ::hthread_mutex_init using the mutex attribute object
  *             allocated and setup previously.
  *         -# The mutex object is used in calls to ::hthread_mutex_lock and
  *             ::hthread_mutex_unlock.
  *     - The mutex attribute object and mutex object are cleaned up
  *         -# The mutex attribute object is destroyed with a call to the
  *             function ::hthread_mutexattr_destroy. This step can be done
  *             any time so long as the mutex attribute object
  *             will not be used in any other calls to hthread_mutex_init.
  *         -# The mutex object is destroyed with a call to the function
  *             ::hthread_mutex_destroy.
  */
typedef struct
{
    /** \internal
      * \brief  The mutex number which is used during the locking and
      *         unlocking process.
      *
      * This structure member keeps track of the mutex number which is used
      * during the locking and unlocking process. The default value for the
      * mutex number is 0 (meaning mutex 0 is locked and unlocked by default)
      * but can be set by the user program using the function
      * ::hthread_mutexattr_setnum.
      */
    unsigned int   num;

    /** \internal
      * \brief  The mutex type which is used during the locking and
      *         unlocking process.
      *
      * This structure member identifies which mutex type is used during the
      * locking and unlocking process. The default type is
      * HTHREAD_MUTEX_BLOCK_NP which means the blocking mutexes are used
      * be default. The type can be set using the function
      * ::hthread_mutexattr_settype.
      */
    unsigned int   type;
} hthread_mutex_t;

/** \brief The mutex attribute object structure.
  *
  * This structure represents a mutex attribute object which is used when
  * calling the function hthread_mutex_init. A call to the function
  * hthread_mutexattr_init must be done before the mutex attribute object
  * is used in any other function.
  *
  * Typically, to create and use a mutex the following process will be taken:
  *     - A mutex attribute object is created and setup
  *         -# A new ::hthread_mutexattr_t structure is allocated.
  *         -# The mutex attribute object is initialized with a call to the
  *             function ::hthread_mutexattr_init.
  *         -# The mutex type is set by calling the function
  *             ::hthread_mutexattr_settype with the desired mutex kind.
  *         -# The mutex number is set by calling the function
  *             ::hthread_mutexattr_setnum with the desired mutex number.
  *     - A mutex object is created and setup
  *         -# A new ::hthread_mutex_t structure is allocated.
  *         -# The mutex object is initialized with a call to the function
  *             ::hthread_mutex_init using the mutex attribute object
  *             allocated and setup previously.
  *         -# The mutex object is used in calls to ::hthread_mutex_lock and
  *             ::hthread_mutex_unlock.
  *     - The mutex attribute object and mutex object are cleaned up
  *         -# The mutex attribute object is destroyed with a call to the
  *             function ::hthread_mutexattr_destroy. This step can be done
  *             any time so long as the mutex attribute object
  *             will not be used in any other calls to hthread_mutex_init.
  *         -# The mutex object is destroyed with a call to the function
  *             ::hthread_mutex_destroy.
  */
typedef struct
{
    /** \internal
      * \brief  The mutex number which is used during the locking and
      *         unlocking process.
      *
      * This structure member keeps track of the mutex number which is used
      * during the locking and unlocking process. The default value for the
      * mutex number is 0 (meaning mutex 0 is locked and unlocked by default)
      * but can be set by the user program using the function
      * ::hthread_mutexattr_setnum.
      */
    unsigned int   num;

    /** \internal
      * \brief  The mutex type which is used during the locking and
      *         unlocking process.
      *
      * This structure member identifies which mutex type is used during the
      * locking and unlocking process. The default type is
      * HTHREAD_MUTEX_BLOCK_NP which means the blocking mutexes are used
      * be default. The type can be set using the function
      * ::hthread_mutexattr_settype.
      */
    unsigned int   type;
} hthread_mutexattr_t;

int hthread_mutexattr_init( hthread_mutexattr_t* );
int hthread_mutexattr_destroy( hthread_mutexattr_t* );
int hthread_mutexattr_setnum( hthread_mutexattr_t*, unsigned int );
int hthread_mutexattr_getnum( hthread_mutexattr_t*, unsigned int* );
int hthread_mutexattr_settype( hthread_mutexattr_t*, unsigned int );
int hthread_mutexattr_gettype( hthread_mutexattr_t*, int* );

int hthread_mutex_init( hthread_mutex_t*, const hthread_mutexattr_t* );
int hthread_mutex_lock( hthread_mutex_t* );
int hthread_mutex_trylock( hthread_mutex_t* );
int hthread_mutex_unlock( hthread_mutex_t* );
int hthread_mutex_destroy( hthread_mutex_t*);
int hthread_mutex_getnum( hthread_mutex_t* );


static inline int _mutex_acquire( unsigned int tid, unsigned int mid )
{
    unsigned int cmd;
    unsigned int sta;

    cmd = mutex_cmd( HT_MUTEX_LOCK, tid, mid );
    sta = read_reg( cmd );

    return sta;
}

static inline int _mutex_tryacquire( unsigned int tid, unsigned int mid )
{
    unsigned int cmd;
    unsigned int sta;

    cmd = mutex_cmd( HT_MUTEX_TRY, tid, mid );
    sta = read_reg( cmd );

    if( mutex_error(sta) )  return FAILURE;
    else                    return SUCCESS;
}

static inline void _mutex_release( unsigned int tid, unsigned int mid )
{
    unsigned int cmd;
    unsigned int sta;

    cmd = mutex_cmd( HT_MUTEX_UNLOCK, tid, mid );
    sta = read_reg( cmd );

}

static inline unsigned int _mutex_owner( unsigned int mid )
{
    unsigned int cmd;
    unsigned int sta;

    cmd = mutex_cmd( HT_MUTEX_OWNER, 0, mid );
    sta = read_reg( cmd );

    return mutex_owner(sta);
}

static inline unsigned int _mutex_count( unsigned int mid )
{
    unsigned int cmd;
    unsigned int sta;

    cmd = mutex_cmd( HT_MUTEX_COUNT, 0, mid );
    sta = read_reg( cmd );

    return mutex_count(sta);
}

static inline unsigned int _mutex_kind( unsigned int mid )
{
    unsigned int cmd;
    unsigned int sta;

    cmd = mutex_cmd( HT_MUTEX_KIND, 0, mid );
    sta = read_reg( cmd );

    return mutex_kind(sta);
}

static inline void _mutex_setkind( unsigned int mid, unsigned int kind )
{
    unsigned int cmd;

    cmd = mutex_cmd( HT_MUTEX_KIND, 0, mid );
    write_reg( cmd, kind );
}


#endif /* MUTEX_H */
