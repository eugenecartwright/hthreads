#include <dev/char.h>
#include <stdlib.h>
#include <string.h>
#include <debug.h>

Hint cdev_create( cdev_t *dev )
{
    // Setup the device structure
    dev->head    = NULL;
    dev->tail    = NULL;
    dev->devices = 0;

    // Return successfully
    return SUCCESS;
}

Hint cdev_destroy( cdev_t *dev )
{
    // Cleanup the device structure
    dev->head    = NULL;
    dev->tail    = NULL;
    dev->devices = 0;

    // Return successfully
    return SUCCESS;
}

Hint cdev_insert( cdev_t *dev, cdev_info_t *info )
{
    cdev_node_t *curr;

    // Allocate a new node for the device
    curr = (cdev_node_t*)malloc( sizeof(cdev_node_t) );
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

Hint cdev_remove( cdev_t *dev, cdev_info_t *info )
{
    cdev_node_t *curr;

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

cdev_info_t* cdev_find( cdev_t *dev, const char *name )
{
    cdev_node_t *curr;

    // Loop through all of the devices
    for( curr = dev->head; curr != NULL; curr = curr->next )
    {
        if( strcmp( name, curr->info->name ) == 0 )     return curr->info;
    }

    // Return an error
    return NULL;
}
