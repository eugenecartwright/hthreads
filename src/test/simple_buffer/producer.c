#include <buffer.h>
#include <producer.h>

void* producer( void *arg )
{
    int i;
    producer_t *pro;

    // Get a pointer to the consumer structure
    pro = (producer_t*)arg;

    // Consume the required number of elements
    for( i = 0; i < pro->num; i++ )
    {
        buffer_write( pro->buffer, 1 );
    }

    // Exit the thread
    return NULL;
}
