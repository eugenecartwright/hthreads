/** \file       htconsts.h
  * \brief      Declaration of constant values used by hthreads.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  *	This file contains the declarations of constant values used by the
  * hthreads implementation. Any constant value used by the implementation
  * should be declared in this file.
  */

#ifndef _PROC_HW_THREAD_CONSTS_H_
#define _PROC_HW_THREAD_CONSTS_H_

#define HT_SEM_MAXNUM 32

/** \brief  A generic success value.
  *
  * Many functions in the Hybrid Threads library return success vs. failure.
  * This value is returned for success.
  */
#define SUCCESS				    (0)

/** \brief  A generic failure value.
  *
  * Many functions in the Hybrid Threads library return success vs. failure.
  * This value is returned for failure.
  */
#define FAILURE				    (-1)

// FIXME: Move to right location
#define HT_ALREADY_EXITED           0x001

#define SCHED_OTHER             0
#define SCHED_FIFO              1
#define SCHED_RR                2

#define HTHREAD_STACK_MIN       128
#define HTHREAD_SCHEDPARAM_MAX  128
#define HTHREAD_STACK_RESERVE   64

#if 1
/** \brief  An error status indicating that the resources neccessary to
  *         perform some function were not available.
  *
  * This return value indicates that some function could not be performed
  * because the resources necessary to perform that function were not
  * available to the system at the time. Attempting to execute the function
  * again could yield a successful result.
  */
#define EAGAIN                  (-1)

/** \brief  An error status indicating that the parameter to some function
  *         was invalid.
  *
  * This return value indicates that some function could not be performed
  * because some parameter that was provided to the function was invalid.
  */
#define EINVAL                  (-2)

/** \brief  An error status indicating that no thread id could be found for
  *         the thread id that was supplied to some function.
  *
  * This return value indicates that some function could not be performed
  * because a thread id was provided to the function and that thread id could
  * not be found by the system.
  */
#define ESRCH                   (-3)

/** \brief  An error status indicating that a deadlock was detected and so
  *         the requested function was not performed.
  *
  * This return value indicates that some function could not be performed
  * because performing the requested function would result in a deadlock.
  */
#define EDEADLK                 (-4)

/** \brief  An error status indicating that a function could not be performed
  *         because there was not enough memory to support the function.
  *
  * This return value indicates that some function could not be performed
  * because the amount of free memory left in the system is less than the
  * amount of free memory that the function requires.
  */
#define ENOMEM                  (-5)

/** \brief  An error status indicating that a function could not be performed
  *         either because that function is not supported or because some
  *         combination of parameters passed to that function are not
  *         supported.
  *
  * This return value indicates that some function was not performed because
  * it is not supported. This could happen either because the function is
  * not supported at all or because some combinations of parameters passed to
  * the function are not supported.
  */
#define ENOTSUP                 (-6)
    
/** \brief  An error status indicating that a function could not be performed
  *         because the calling thread does not have the required permissions
  *         to execute that function.
  *
  * This return value indicates that some function was not performed because
  * the calling thread lacked the required permissions to execute the
  * function.
  */
#define EPERM                   (-7)

/** \brief  An error status indicating that a function could not be performed
  *         because the resources required were already in use.
  *
  * This return value indicates that some function was not performed because
  * the resources required to perform the operation were already in use by
  * another thread. Attempting to perform the function at a later time may
  * be successful.
  */
#define EBUSY                   (-8)

/** \brief  An error status indicating that a function did not complete
  *         successfully because the operation timed out.
  *
  * This return value indicates that some function could not be completed
  * successfully because the operation timed out before the operation could
  * be completed.
  */
#define ETIMEDOUT               (-9)

/** \brief  An error status indicating that a function could not be performed
  *         because there was an I/O error.
  *
  * This return value indicates that some function was not performed because
  * there was an I/O error.
  */
#define EIO                     (-10)
#endif

#endif

