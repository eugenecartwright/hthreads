#include <dev/block.h>
#include <stdlib.h>
#include <string.h>
#include <debug.h>

Hint bdev_create( bdev_t *dev )
{
    // Setup the device structure
    dev->head    = NULL;
    dev->tail    = NULL;
    dev->devices = 0;

    // Return successfully
    return SUCCESS;
}

Hint bdev_destroy( bdev_t *dev )
{
    // Cleanup the device structure
    dev->head    = NULL;
    dev->tail    = NULL;
    dev->devices = 0;

    // Return successfully
    return SUCCESS;
}

Hint bdev_insert( bdev_t *dev, bdev_info_t *info )
{
    bdev_node_t *curr;

    // Allocate a new node for the device
    curr = (bdev_node_t*)malloc( sizeof(bdev_node_t) );
    if( curr == NULL )  return -ENOMEM;
    
    // Setup the new device node
    curr->prev = dev->tail;
    curr->next = NULL;
    curr->info = info;

    // Add  the new node to the list
    dev->tail->next = curr;
    dev->devices++;

    // Return successfully
    return SUCCESS;
}

Hint bdev_remove( bdev_t *dev, bdev_info_t *info )
{
    bdev_node_t *curr;

    // Loop through all of the devices
    for( curr = dev->head; curr != NULL; curr = curr->next )
    {
        // Remove the device if we have found the correct one
        if( curr->info == info )
        {
            // Remove the device from the device list
            curr->prev->next = curr->next;
            curr->next->prev = curr->prev;       
            dev->devices--;

            // Free the memory allocated for the device
            free( curr );

            // Return successfully
            return SUCCESS;
        }
    }

    // Return an error
    return -ENOENT;
}

bdev_info_t* bdev_find( bdev_t *dev, const char *name )
{
    bdev_node_t *curr;

    // Loop through all of the devices
    for( curr = dev->head; curr != NULL; curr = curr->next )
    {
        if( strcmp( name, curr->info->name ) == 0 )     return curr->info;
    }

    // Return an error
    return NULL;
}
