/*****************************************************************************
 * Type Definitions
 *****************************************************************************/
#ifndef _ALGORITHM_UTIL_TYPES_H_
#define _ALGORITHM_UTIL_TYPES_H_

// Utility Functions
#define min(x,y)        ((x) < (y) ? (x) : (y))
#define max(x,y)        ((x) > (y) ? (x) : (y))

#define swap(x,y)       ({  \
    typeof(y)   _z;         \
                            \
    _z = (x);               \
    (x) = (y);              \
    (y) = _z;               \
})

// Integer Data Ranges
#define INT8_MIN        (-128)
#define INT16_MIN       (-32767-1)
#define INT32_MIN       (-2147483647-1)
#define INT64_MIN       (-(9223372036854775807LL)-1)
#define INT8_MAX        (127)
#define INT16_MAX       (32767)
#define INT32_MAX       (2147483647)
#define INT64_MAX       (9223372036854775807LL)

// Unsigned Integer Data Ranges
#define UINT8_MAX       (255)
#define UINT16_MAX      (65535)
#define UINT32_MAX      (4294967295U)
#define UINT64_MAX      (18446744073709551615ULL)

// Floating Point Data Ranges
#define REAL32_MIN      (1.17549435e-38F)
#define REAL32_MAX      (3.40282347e+38F)
#define REAL64_MIN      (2.2250738585072014e-308)
#define REAL64_MAX      (1.7976931348623157e+308)

// Signed Integer Types
typedef char                int8;
typedef short               int16;
typedef int                 int32;
typedef long long           int64;

// Unsigned Integer Types
typedef unsigned char       uint8;
typedef unsigned short      uint16;
typedef unsigned int        uint32;
typedef unsigned long long  uint64;

// Floating Point Types
typedef float               real32;
typedef double              real64;
typedef long double         real128;

// Boolean Type
typedef enum { false=0, true=1 } boolean;

#endif
