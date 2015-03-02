#include <sysace/sysace.h>
#include <sysace/block.h>
#include <sysace/cfg.h>
#include <sysace/cf.h>
#include <debug.h>
#include <stdlib.h>
#include <string.h>

Hint sysace_block_create( block_t *block, sysace_config_t *config, Huint lines, Huint depth )
{
    Hint            res;
    sysace_block_t  *ace;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, block == NULL, "NULL block pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, config == NULL, "NULL config pointer\n" );

    // Allocate a sysace structure for the block device
    ace = (sysace_block_t*)malloc( sizeof(sysace_block_t) );
    if( ace == NULL )
    {
        TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "malloc error\n" );
        TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
        return ENOMEM;
    }

    // Initialize the cache settings
    ace->hit    = 0;
    ace->miss   = 0;
    ace->lines  = 0;
    ace->depth  = 0;
    ace->cache  = NULL;
    ace->info   = NULL;
    sysace_block_cachesize( ace, lines, depth );

    // Create the sysace device
    res = sysace_create( &ace->ace, config );
    if( res != SUCCESS )
    {
        TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "create error (%d)\n", res );
        TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
        return res;
    }
    
    // Setup the block device structure
    block->read  = sysace_block_read;
    block->write = sysace_block_write;
    block->data  = ace;
    
    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint sysace_block_destroy( block_t *block )
{
    sysace_block_t  *ace;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, block == NULL, "NULL block pointer\n" );

    // Cast the block structure to a sysace block structure
    ace = (sysace_block_t*)block->data;

    // Set the cache size to 0 x 0 to free the cache data
    sysace_block_cachesize( ace, 0, 0 );
    
    // Destroy the old ace controller
    sysace_destroy( &ace->ace );

    // Free the resources used
    free( block->data );
    block->data  = NULL;
    block->read  = NULL;
    block->write = NULL;
    
    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint sysace_block_read( block_t *block, Huint start, Huint num, Hubyte *buffer )
{
    Hint line;
    Hint offset;
    Huint i;
    sysace_block_t  *ace;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, block == NULL, "NULL block pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, buffer == NULL, "NULL buffer pointer\n" );

    // Cast the block structure to a sysace block structure
    ace = (sysace_block_t*)block->data;

    // Read in all of the requested blocks
    for( i = start; i < start+num; i++ )
    {
        // Determine if the current block number is in the cache
        line = sysace_block_cachefind( ace, i );

        // If the block didn't exist in the cache then read the block in
        if( line < 0 )  line = sysace_block_cacheread( ace, i );

        // If the block still doesn't exist then there was an error
        if( line < 0 )
        {
            TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "cache line error (%d)\n", line );
            TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
            return line;
        }

        // Calculate the offset into the cache line
        offset = i % ace->lines;

        // Copy the block over to the buffer
        memcpy( buffer, &ace->cache[SYSACE_DATA_SECTOR*(line*ace->lines+offset)], SYSACE_DATA_SECTOR );
        buffer += SYSACE_DATA_SECTOR;

        // Touch this cache line
        sysace_block_cachetouch( ace, line );
    }

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint sysace_block_write( block_t *block, Huint start, Huint num, Hubyte *buffer )
{
    Hint i;
    Hint line;
    Hint offset;
    sysace_block_t  *ace;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, block == NULL, "NULL block pointer\n" );
    TRACE_PRINTF( TRACE_FATAL, buffer == NULL, "NULL buffer pointer\n" );

    // Cast the block structure to a sysace block structure
    ace = (sysace_block_t*)block->data;

    // Write out all of the requested blocks
    for( i = start; i < start+num; i++ )
    {
        // Determine if the current block number is in the cache
        line = sysace_block_cachefind( ace, i );

        // If the block didn't exist in the cache then read the block in
        if( line < 0 )  line = sysace_block_cacheread( ace, i );

        // If the block still doesn't exist then there was an error
        if( line < 0 )
        {
            TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "cache line error (%d)\n", line );
            TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
            return line;
        }

        // Calculate the offset into the cache line
        offset = i % ace->lines;

        // Copy the buffer into the block
        memcpy( &ace->cache[SYSACE_DATA_SECTOR*(line*ace->lines+offset)], buffer, SYSACE_DATA_SECTOR );
        buffer += SYSACE_DATA_SECTOR;

        // Touch this cache line
        sysace_block_cachetouch( ace, line );
        ace->info[line].dirty = 1;
    }

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint sysace_block_cachefind( sysace_block_t *ace, Huint block )
{
    Huint i;
    Hint  diff;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, ace == NULL, "NULL ace block\n" );

    // Loop through all of the cache lines
    for( i = 0; i < ace->depth; i++ )
    {
        // Determine if the requested block exists in this line
        diff = block - ace->info[i].sector;
        if( diff >= 0 && diff < ace->lines && !ace->info[i].cold )
        {
            TRACE_PRINTF( TRACE_INFO, SYSACE_DEBUG, "cache hit (%d=>%d)\n", block, i );
            TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );
            ace->hit++;
            return i;
        }
    }

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_INFO, SYSACE_DEBUG, "cache miss\n" );
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with failure\n" );

    // Return that the block was not in the cache
    ace->miss++;
    return -1;
}

Hint sysace_block_cacheread( sysace_block_t *ace, Huint block )
{
    Huint line;
    Huint sector;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, ace == NULL, "NULL ace block\n" );

    // Get the best cache line to read data into
    line = sysace_block_cachereplace( ace );

    // Get the sector to start transfer from
    sector = block - (block % ace->lines);

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting\n" );

    // Read the blocks into the cache
    return sysace_block_cacheload( ace, line, sector );
}

Hint sysace_block_cacheload( sysace_block_t *ace, Huint line, Huint sector )
{
    Hint    res;
    Huint   size;
    
    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, ace == NULL, "NULL ace block\n" );
    TRACE_PRINTF( TRACE_FATAL, line >= ace->depth, "cache line out of bounds (%d)\n", line );

    // Attempt to lock the sysace controller
    res = sysace_lock( &ace->ace );
    if( res < 0 )
    {
        TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "couldn't get lock (%d)\n", res );
        TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
        return res;
    }

    // Wait for the device to be ready
    res = sysace_cf_ready( &ace->ace );
    if( res < 0 )
    {
        TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "couldn't wait for ready (%d)\n", res );
        TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
        return res;
    }

    // Read the cache line from the device
    size = sysace_cf_readsector( &ace->ace, sector, ace->lines, (Hubyte*)&ace->cache[SYSACE_DATA_SECTOR*line*ace->lines] );
    if( size < ace->lines*SYSACE_DATA_SECTOR )
    {
        TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "cache block not transfered (%d of %d)\n", size, ace->lines*SYSACE_DATA_SECTOR );
        TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
        return EIO;
    }
    
    // Unlock  the sysace controller
    sysace_unlock( &ace->ace );

    // Store the information for the newly loaded sector
    ace->info[line].sector = sector;
    ace->info[line].cold   = 0;
    ace->info[line].dirty  = 0;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );

    // Return successfully
    return line;
}

Hint sysace_block_cachestore( sysace_block_t *ace, Huint line )
{
    Hint    res;
    Huint   size;
    
    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, ace == NULL, "NULL ace block\n" );
    TRACE_PRINTF( TRACE_FATAL, line >= ace->depth, "cache line out of bounds (%d)\n", line );

    // Attempt to lock the sysace controller
    res = sysace_lock( &ace->ace );
    if( res < 0 )
    {
        TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "couldn't get lock (%d)\n", res );
        TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
        return res;
    }

    // Wait for the device to be ready
    res = sysace_cf_ready( &ace->ace );
    if( res < 0 )
    {
        TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "couldn't wait for ready (%d)\n", res );
        TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
        return res;
    }

    // Store the cache line back to the device
    size = sysace_cf_writesector( &ace->ace, ace->info[line].sector, ace->lines, &ace->cache[line*SYSACE_DATA_SECTOR*ace->lines] );
    if( size < ace->lines*SYSACE_DATA_SECTOR )
    {
        TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "cache block not transfered (%d of %d)\n", size, ace->lines*SYSACE_DATA_SECTOR );
        TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
        return EIO;
    }
    
    // Unlock  the sysace controller
    sysace_unlock( &ace->ace );

    // Update cache information
    ace->info[line].dirty  = 0;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Huint sysace_block_cachetouch( sysace_block_t *ace, Huint line )
{
    Hint  i;
    Huint lru;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, ace == NULL, "NULL ace block\n" );
    TRACE_PRINTF( TRACE_FATAL, line >= ace->depth, "cache line out of bounds (%d)\n", line );

    // Get the old lru of the line
    lru = ace->info[line].lru;
    if( lru == 0 )
    {
        TRACE_PRINTF( TRACE_INFO, SYSACE_DEBUG, "block %d already lru\n", line );
        TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );
        return lru;
    }

    // Increment all items below this one
    for( i = 0; i < ace->depth; i++ )
    {
        if( ace->info[i].lru <= lru && ace->info[i].lru != 0xFFFFFFFF )
        {
            ace->info[i].lru++;
        }
    }

    // Reset the LRU data of the line
    ace->info[line].lru    = 0;
    ace->info[line].second = 0;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );

    // Return the old lru
    return lru;
}

Hint sysace_block_cachereplace( sysace_block_t *ace )
{
    Huint   i;
    Huint   best;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, ace == NULL, "NULL ace block\n" );

    // Initialize the best selection
    best = 0;
    
    // Loop through all of the cache lines
    for( i = 0; i < ace->depth; i++ )
    {
        if( ace->info[i].cold )
        {
            TRACE_PRINTF( TRACE_INFO, SYSACE_DEBUG, "cold block found (%d)\n", i );
            TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );
            return i;
        }

        if( ace->info[i].lru > ace->info[best].lru ) { best = i; }
    }

    // If the block is dirty and hasn't had a second chance then give it another chance
    if( ace->info[best].dirty && !ace->info[best].second )
    {
        ace->info[best].second = 1;
        TRACE_PRINTF( TRACE_INFO, SYSACE_DEBUG, "giving second chance (%d)\n", best );
        TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );
        return sysace_block_cachereplace(ace);
    }

    // Write the block back if we need to
    if( ace->info[best].dirty )
    {
        TRACE_PRINTF( TRACE_INFO, SYSACE_DEBUG, "cache block write back (%d)\n", best );
        sysace_block_cachestore( ace, best );
    }

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_INFO, SYSACE_DEBUG, "selecting %d for replacement\n", best );
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );

    // Return the best line to replace
    return best;
}

Hint sysace_block_cacheflush( sysace_block_t *ace )
{
    Hint i;
    Hint res;

    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, ace == NULL, "NULL sysace block\n" );

    // Initialize the cache
    for( i = 0; i < ace->depth; i++ )
    {
        if( ace->info[i].dirty )
        {
            res = sysace_block_cachestore( ace, i );
            if( res < 0 )
            {
                TRACE_PRINTF(TRACE_ERR, SYSACE_DEBUG, "cache block write back\n");
                TRACE_PRINTF(TRACE_FINE, SYSACE_DEBUG, "exiting with error (%d)\n", res);
                return res;
            }
        }

        ace->info[i].cold      = 1;
        ace->info[i].lru       = 0xFFFFFFFF;
        ace->info[i].sector    = 0;
        ace->info[i].dirty     = 0;
        ace->info[i].second    = 0;
    }

    // Reset the cache statistics
    ace->hit  = 0;
    ace->miss = 0;
    
    // Print out trace information if configured
    TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

Hint sysace_block_cachesize( sysace_block_t *ace, Huint lines, Huint depth )
{
    Hint i;

    // Flush the cache first
    if( ace->cache != NULL )        sysace_block_cacheflush( ace );

    // Free the existing data
    if( ace->cache != NULL )        free( ace->cache );
    if( ace->info != NULL )         free( ace->info );

    // Setup the new geometry
    ace->lines  = lines;
    ace->depth = depth;

    if( lines > 0 && depth > 0 )
    {
        // Allocate the new cache
        ace->cache = (Hubyte*)malloc( lines*depth*SYSACE_DATA_SECTOR*sizeof(Hubyte) );
        if( ace->cache == NULL )
        {
            TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "malloc error\n" );
            TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
            return ENOMEM;
        }

        // Allocate the information cache
        ace->info = (sysace_block_cache_t*)malloc( depth*sizeof(sysace_block_cache_t) );
        if( ace->info == NULL )
        {
            free( ace->cache );
            ace->cache = NULL;

            TRACE_PRINTF( TRACE_ERR, SYSACE_DEBUG, "malloc error\n" );
            TRACE_PRINTF( TRACE_FINE, SYSACE_DEBUG, "exiting with error\n" );
            return ENOMEM;
        }

        // Initialize the cache
        for( i = 0; i < ace->depth; i++ )
        {
            ace->info[i].cold      = 1;
            ace->info[i].lru       = 0xFFFFFFFF;
            ace->info[i].sector    = 0;
            ace->info[i].dirty     = 0;
            ace->info[i].second    = 0;
        }
    }

    // Return successfully
    return SUCCESS;
}
