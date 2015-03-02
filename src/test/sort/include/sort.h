#ifndef _SORT_SORTER_H_
#define _SORT_SORTER_H_

#define ENDLINE     15

typedef struct
{
    Huint   size;
    Huint   *data;
} sort_t;

extern Hint sort_init( void );
extern Hint sort_finish( void );
extern Hint sort_setup( sort_t*, Huint );
extern Hint sort_destroy( sort_t* );
extern Hint sort_copy( sort_t*, sort_t*, Huint, Huint );
extern Hint sort_fill( sort_t*, Huint min, Huint max );
extern Hint sort_show( sort_t* );
extern Hint sort_verify( sort_t* );
extern void sort_merge( sort_t *sort, sort_t *left, sort_t *right );
extern void sort_recursive( sort_t *sort );
extern void sort_direct( sort_t *sort );
extern void* sort_thread( void *arg );
extern void sort_setcutoff( Huint cutoff );
extern Huint sort_getcutoff( void );

#endif
