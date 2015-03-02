#include "proc_hthread.h"

/** \brief  Initialize the attributes for a mutex attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function initializes the mutex attribute object attr and fills it
  * with the default values of blocking operation on mutex number 0. This 
  * function must be called on every mutex attribute object before it is
  * used.
  *
  * \param attr     This parameter is the mutex attribute object which 
  *                 is going to be initialized. This parameter should be
  *                 a pointer to a valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The mutex attribute object was successfully initalizes
  *                     and has been filled with the default values.
  *                 - HTHREAD_FAILURE\n
  *                     The mutex attribute object was not initialized properly
  *                     and should not be used in any other mutex operations.
  */
int hthread_mutexattr_init( hthread_mutexattr_t *attr )
{
    attr->num   = 0;
    attr->type  = HTHREAD_MUTEX_DEFAULT;

    return SUCCESS;
}

/** \brief  Destroy a mutex attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function destroys a mutex attribute object. This object cannot be
  * reused again until it has been reinitialized. In the current implementation
  * this function does nothing.
  *
  * \param attr     This parameter is the mutex attribute object which is
  *                 going to be destroyed. This parameter should be a
  *                 pointer to a valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The mutex attribute object was destroyed successfull.
  *                 - HTHREAD_FAILURE\n
  *                     A failure was encountered during the destruction of
  *                     the mutex attribute object.
  */
int hthread_mutexattr_destroy( hthread_mutexattr_t *attr )
{
    return SUCCESS;
}

/** \brief  Set the mutex number for the mutex attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function sets the mutex number for the mutex attribute object. The
  * mutex number identifies a specific mutex to use during the locking and
  * unlocking operations.
  *
  * The mutex number is an unsigned int in the range 0 to 511. Two or more threads
  * can synchronize on the same mutex by using the same mutex number. This
  * is especially useful when interacting with hardware threads.
  *
  * \param attr     This parameter is the mutex attribute object which is
  *                 having it's mutex number set. This parameter should be a
  *                 pointer to a valid memory location.
  * \param num      This parameter identifies the mutex number of assigned
  *                 to the given mutex attribute object. This number should
  *                 be in the range 0 to 511.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The mutex number for the mutex attribute object was
  *                     successfully set.
  *                 - HTHREAD_FAILURE\n
  *                     The nutex number of the mutex attribute object was not
  *                     set because the number was not in the range 0 to 511.
  */
int hthread_mutexattr_setnum( hthread_mutexattr_t *attr, unsigned int num )
{
    if( num > HT_SEM_MAXNUM ) return EINVAL;
    
    attr->num = num;
    return SUCCESS;
}

/** \brief  Retrieve the mutex number for the given mutex attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function returns the mutex number for the given mutex attribute
  * object. The return value is in the range 0 to 511.
  *
  * \param attr     This parameter is the mutex attribute object from which
  *                 the mutex number is be requested. This parameter should be
  *                 a pointer to a valid memory location.
  * \return         The return value is an integer in the range 0 to 511 and
  *                 identifies the mutex number used by the given mutex
  *                 attribute object.
  */
int hthread_mutexattr_getnum( hthread_mutexattr_t *attr, unsigned int *num )
{
    *num = attr->num;
    return SUCCESS;
}

/** \brief  Set the type of mutex that the mutex attribute object identifies.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function sets the mutex type for the given mutex attribute object.
  * Currently two mutex types are supported:
  *     - HTHREAD_MUTEX_BLOCK_NP: Blocking Mutexes\n
  *         When ::hthread_mutex_lock is called the mutex will attempt to 
  *         acquire a lock on the mutex. If the lock is granted then
  *         ::hthread_mutex_lock will return immediately. If the lock is owned
  *         by another thread then the thread requesting the lock will put
  *         to sleep.
  *         When the owner of the mutex releases the mutex a single thread
  *         will wake up and be granted the mutex lock. The lock is granted in
  *         FIFO order. Once a sleeping thread has been granted the
  *         lock it will return from the ::hthread_mutex_lock call.
  *     - HTHREAD_MUTEX_SPIN_NP: Busy Wait Mutexes\n
  *         When ::hthread_mutex_lock is called the mutex will attempt to 
  *         acquire a lock on the mutex. If the lock is granted then
  *         ::hthread_mutex_lock will return immediately. If the lock is owned
  *         by another thread it will continue to attempt locking the mutex.
  *         When the thread has successfully locked the mutex the
  *         ::hthread_mutex_lock function will return.
  *         When the owner of the mutex releases the mutex all threads
  *         which are attempting to lock the mutex will compete for the
  *         lock. The "fastest" thread to the mutex will be granted the lock.
  *
  * \param attr     This parameter is the mutex attribute object which is
  *                 having it's type set. This parameter should be a
  *                 pointer to a valid memory location.
  * \param type     This parameter indicates the type which is being assigned
  *                 to the given mutex attribute object. This should be either
  *                 HTHREAD_MUTEX_BLOCK_NP or HTHREAD_MUTEX_SPIN_NP.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The type of the mutex was successfully set.
  *                 - HTHREAD_FAILURE\n
  *                     The type of the mutex was not set because the
  *                     mutex kind was not valid.
  */
int hthread_mutexattr_settype( hthread_mutexattr_t *attr, unsigned int type )
{
    switch( type )
    {
    case HTHREAD_MUTEX_FAST_NP:
    case HTHREAD_MUTEX_RECURSIVE_NP:
    case HTHREAD_MUTEX_ERRORCHECK_NP:
        attr->type = type;
        return SUCCESS;

    default:
        return EINVAL;
    }
}

/** \brief Retrieve the mutex type.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function returns the type. See the documentation for the function
  * ::hthread_mutexattr_settype for more information on the supported mutex
  * tyeps.
  *
  * \param attr     This parameter is the mutex attribute object from which
  *                 the type is being retrieved. This parameter should be a
  *                 pointer to a valid memory location.
  * \return         An integer value indicating the type of the mutex.
  */
int hthread_mutexattr_gettype( hthread_mutexattr_t *attr, int *kind )
{
    *kind = attr->type;
    return SUCCESS;
}

/** \brief  
  */
int hthread_mutexattr_setpshared( hthread_mutexattr_t *attr, int pshared )
{
    return ENOTSUP;
}

/** \brief  
  */
int hthread_mutexattr_getpshared( hthread_mutexattr_t *attr, int *pshared )
{
    return ENOTSUP;
}

/** \brief  
  */
int hthread_mutexattr_setprotocol( hthread_mutexattr_t *attr, int protocol )
{
    return ENOTSUP;
}

/** \brief  
  */
int hthread_mutexattr_getprotocol( hthread_mutexattr_t *attr, int *protocol )
{
    return ENOTSUP;
}

/** \brief  
  */
int hthread_mutexattr_setprioceiling( hthread_mutexattr_t *attr, int ceil )
{
    return ENOTSUP;
}

/** \brief  
  */
int hthread_mutexattr_getprioceiling( hthread_mutexattr_t *attr, int *ceil )
{
    return ENOTSUP;
}

/** \brief  Initialize a mutex object given a mutex attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will initialize a mutex object given a mutex attribute
  * object. If the mutex attribute object is NULL then the default values
  * for the mutex will be used.
  *
  * This function must be called before any other mutex functions may be
  * used on the mutex object.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be initialized. This parameter should be a pointer to a
  *                 valid memory location.
  * \param attr     This parameter is the mutex attribute object which
  *                 contains the attributes to use with the given mutex
  *                 object.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The mutex object was successfully initialized.
  *                 - HTHREAD_FAILURE\n
  *                     The mutex object was not initialized and should not
  *                     be used in any other mutex operations.
  */
int hthread_mutex_init(hthread_mutex_t *mutex, const hthread_mutexattr_t *attr)
{
    if( attr == NULL )
    {
        mutex->num  = 0;
        mutex->type = HTHREAD_MUTEX_DEFAULT;
    }
    else
    {
        mutex->num  = attr->num;
        mutex->type = attr->type;
    }

    _mutex_setkind( mutex->num, mutex->type );
    return SUCCESS;
}

/** \brief  Destroy a mutex object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will destroy a mutex object. This function must be called
  * once the mutex is no longer in used.
  *
  * NOTE: This function should not be called with a with a mutex object
  * which is locked by the calling thread.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be destroyed. This parameter should be a pointer to a
  *                 valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                 - HTHREAD_FAILURE\n
  */
int hthread_mutex_destroy( hthread_mutex_t *mutex )
{
    return SUCCESS;
}

/** \brief 
  */
int hthread_mutex_setprioceiling( hthread_mutex_t *mutex, int ceil )
{
    return ENOTSUP;
}

/** \brief  
  */
int hthread_mutex_getprioceiling( hthread_mutex_t *mutex, int *ceil )
{
    return ENOTSUP;
}


/** \brief  Attempt to lock a mutex.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will attempt to lock a mutex. This function will not 
  * return until the calling thread has been granted the lock. See the
  * documentation of ::hthread_mutexattr_settype for more information on
  * how this function works for each of the mutex types.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be locked. This parameter should be a pointer to a
  *                 valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The calling thread has been granted the mutex.
  *                 - HTHREAD_FAILURE\n
  *                     The calling thread has not been granted the mutex
  *                     and some error has occurred. This usually means
  *                     that the mutex object has was given as a parameter
  *                     was not valid.
  */
int hthread_mutex_lock( hthread_mutex_t *mutex )
{
    unsigned int cur;
    int sta;

    proc_interface_t iface;
    int hwti_base;

    // Form proc_interface_t from PVR register
    getpvr(1,hwti_base);
    initialize_interface(&iface, (int*)hwti_base);

    // Get current thread ID
    cur = *(iface.tid_reg);

    // Acquire mutex
    sta = _mutex_acquire( cur, mutex->num );

    if( sta == HT_MUTEX_BLOCK )
    {
        // Block until go command comes in
        wait_for_go_command(&iface);
        return SUCCESS;
    }

    if( sta == SUCCESS ) return SUCCESS;
    else                 return FAILURE;

}

/** \brief  Release a previously acquired lock.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will release a previously locked mutex. This function
  * should only be called by the owner of the lock.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be unlocked. This parameter should be a pointer to a
  *                 valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The lock was successfully released.
  *                 - HTHREAD_FAILURE\n
  *                     The lock was not releases. This indicates that either
  *                     the mutex object is invalid or that this function
  *                     was called by a thread that did not own then mutex. 
  */
int hthread_mutex_unlock( hthread_mutex_t *mutex )
{
    unsigned int cur;

    proc_interface_t iface;
    int hwti_base;

    // Get current thread ID
    cur = hthread_self();

    // Release mutex
    _mutex_release( cur, mutex->num );

    return SUCCESS;
}

/** \brief  Attempt to acquire a mutex but return an error condition if the
  *         mutex could not be acquired.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will attempt to acquire a mutex. If the mutex is already
  * held by another thread then the function will return with a failure
  * instead of blocking until the mutex can be acquired.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be acquired. This parameter should be a pointer to a
  *                 valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The mutex was successfully acquired.
  *                 - HTHREAD_BUSY\n
  *                     The mutex has already been locked by another thread. 
  *                 - HTHREAD_FAILURE\n
  *                     The lock was not acquired. This indicates that either
  *                     the mutex object is invalid or that some unknown
  *                     error has occurred.
  */
int hthread_mutex_trylock( hthread_mutex_t *mutex )
{
    unsigned int cur;
    int sta;

    // Get TID
    cur = hthread_self();

    // Try to acquire mutex
    sta = _mutex_tryacquire( cur, mutex->num );

    if( sta != SUCCESS )    return EBUSY;
    else                    return SUCCESS;
}

/** \brief  Retrieve the number of the mutex being used.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will retrieve the number of the mutex given to it.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be examined. This parameter should be a pointer to a
  *                 valid memory location.
  * \return         This function returns the mutex number of the given
  *                 mutex.
  */
int hthread_mutex_getnum( hthread_mutex_t *mutex )
{
    return mutex->num;
}
