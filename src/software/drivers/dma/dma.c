#include <dma/dma.h>
#include <stdlib.h>
#include <debug.h>

Hint dma_create( dma_t *dma, dma_config_t *config )
{
    dma->reset       = (Huint*)(config->base + DMA_RESET);
    dma->control     = (Huint*)(config->base + DMA_CONTROL);
    dma->source      = (Huint*)(config->base + DMA_SOURCE);
    dma->destination = (Huint*)(config->base + DMA_DESTINATION);
    dma->length      = (Huint*)(config->base + DMA_LENGTH);
    dma->status      = (Huint*)(config->base + DMA_STATUS);
    dma->isr         = (Huint*)(config->base + DMA_INTERRUPT_STATUS);
    dma->ier         = (Huint*)(config->base + DMA_INTERRUPT_ENABLE);
    dma->intr        = 0;

    dma_reset(dma);
    return SUCCESS;
}

Hint dma_destroy( dma_t *dma )
{
    dma->reset       = (Huint*)NULL;
    dma->control     = (Huint*)NULL;
    dma->source      = (Huint*)NULL;
    dma->destination = (Huint*)NULL;
    dma->length      = (Huint*)NULL;
    dma->status      = (Huint*)NULL;
    dma->isr         = (Huint*)NULL;
    dma->ier         = (Huint*)NULL;

    return SUCCESS;
}

void dma_reset( dma_t *dma )
{
    *dma->reset = DMA_RESET_DATA;
}

Huint dma_getid( dma_t *dma )
{
    return *dma->reset;
}

Hbool dma_getbusy( dma_t *dma )
{
    return (*dma->status & DMA_STATUS_BUSY);
}

Hbool dma_geterror( dma_t *dma )
{
    return (*dma->status & DMA_STATUS_ERROR);
}

Hbool dma_gettimeout( dma_t *dma )
{
    return (*dma->status & DMA_STATUS_TIMEOUT);
}

Hbool dma_getdone( dma_t *dma )
{
    return (*dma->isr & DMA_ISR_DONE);
}

Hbool dma_getfailed( dma_t *dma )
{
    return (*dma->isr & DMA_ISR_ERROR);
}

void dma_enabledone( dma_t *dma )
{
    dma->intr |= DMA_IER_DONE;
    *dma->ier = dma->intr;
}

void dma_disabledone( dma_t *dma )
{
    dma->intr &= ~DMA_IER_DONE;
    *dma->ier = dma->intr;
}

void dma_cleardone( dma_t *dma )
{
    *dma->isr = DMA_IER_DONE;
}

void dma_enablefailed( dma_t *dma )
{
    dma->intr |= DMA_IER_ERROR;
    *dma->ier = dma->intr;
}

void dma_disablefailed( dma_t *dma )
{
    dma->intr &= ~DMA_IER_ERROR;
    *dma->ier = dma->intr;
}

void dma_clearfailed( dma_t *dma )
{
    *dma->isr = DMA_IER_ERROR;
}

void* dma_malloc( Huint size )
{
    Huint   alloc;
    Huint   buffer;
    Hubyte  *off;

    // Allocate the buffer, we include extra space in case we need to align the memory
    alloc = (Huint)malloc( size+4 );

    // Align the buffer to a 4-byte boundary
    buffer = alloc + 4 - (alloc % 4);

    // Store the offset in the previous byte
    off = (Hubyte*)(buffer-1);
    *off = 4 - alloc % 4;
    
    return (void*)buffer;
}

void dma_free( void *mem )
{
    Huint   alloc;
    Huint   buffer;
    Hubyte  *off;

    // Cast the pointer to an integer
    buffer = (Huint)mem;

    // Get the offset that was used during alignment
    off = (Hubyte*)(buffer-1);

    // Retreive the orignally allocated buffer
    alloc = buffer - *off;

    // Free the original buffer
    free( (void*)alloc );
}

Hint dma_transfer( dma_t *dma, void *src, void *dst, Huint len, Huint cs, Hbool si, Hbool di )
{
    Huint   cmd;
    
    if( cs != DMA_SIZE_BYTE && cs != DMA_SIZE_HALFWORD && cs != DMA_SIZE_WORD )
    {
        //TRACE_PRINTF( TRACE_ERR, TRACE_DMA, "DMA: (ERROR=Chunk Size Invalid) (CS=%u)\n", cs );
        return FAILURE;
    }

    // For the command to send to the DMA control register
    cmd = cs;
    if( si )    cmd |= DMA_SOURCE_INC;
    if( di )    cmd |= DMA_DESTINATION_INC;

    // Wait for the dma controller to not be busy
    while( dma_getbusy(dma) );

    // Send the dma transfer commands
    *dma->control       = cmd;
    *dma->source        = (Huint)src;
    *dma->destination   = (Huint)dst;
    *dma->length        = len;

    return SUCCESS;
}
