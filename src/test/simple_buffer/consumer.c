#include <buffer.h>
#include <consumer.h>

void* consumer( void *arg )
{
    int i;
    consumer_t *con;

    // Get a pointer to the consumer structure
    con = (consumer_t*)arg;

    // Consume the required number of elements
    for( i = 0; i < con->num; i++ )
    {
        buffer_read( con->buffer );
    }

    // Exit the thread
    return NULL;
}
