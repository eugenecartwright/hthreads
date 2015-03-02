#include <sysace/sysace.h>
#include <sysace/cfg.h>
#include <sysace/cf.h>
#include <stdio.h>
#include <sleep.h>

Hint sysace_create( sysace_t *ace, sysace_config_t *config )
{
    Hint res;

    // Setup pointers to all of the registers
    ace->mode[0]    = (Hushort*)(config->base + SYSACE_BUS_MODE);
    ace->mode[1]    = (Hushort*)(config->base + SYSACE_BUS_MODE + 2);

    ace->control[0] = (Hushort*)(config->base + SYSACE_CONTROL);
    ace->control[1] = (Hushort*)(config->base + SYSACE_CONTROL + 2);

    ace->status[0]  = (Hushort*)(config->base + SYSACE_STATUS);
    ace->status[1]  = (Hushort*)(config->base + SYSACE_STATUS + 2);
    
    ace->error[0]   = (Hushort*)(config->base + SYSACE_ERROR);
    ace->error[1]   = (Hushort*)(config->base + SYSACE_ERROR + 2);
    
    ace->count[0]   = (Hushort*)(config->base + SYSACE_SECTOR);
    ace->version[0] = (Hushort*)(config->base + SYSACE_VERSION);
    ace->fat[0]     = (Hushort*)(config->base + SYSACE_FAT_STATUS);
    ace->data[0]    = (Hushort*)(config->base + SYSACE_DATA);

    ace->clba[0]    = (Hushort*)(config->base + SYSACE_CONFIG_LBA);
    ace->clba[1]    = (Hushort*)(config->base + SYSACE_CONFIG_LBA + 2);

    ace->mlba[0]    = (Hushort*)(config->base + SYSACE_MPU_LBA);
    ace->mlba[1]    = (Hushort*)(config->base + SYSACE_MPU_LBA + 2);

    // Put the device into 16-bit bus mode
    res = sysace_busmode( ace, SYSACE_BUSMODE_16BIT );
    if( res != SUCCESS )    return res;
    
    // Disable interrupts
    res = sysace_disable( ace, SYSACE_CONTROL_IMASK | SYSACE_CONTROL_RESETI );
    if( res != SUCCESS )    return res;

    // Reset the configuration controller
    res = sysace_cfg_reset( ace );
    if( res != SUCCESS )    return res;

    // Flush any remaining data out of the data buffer
    sysace_flushbuffer( ace );

    // Return successfully
    return SUCCESS;
}

Hint sysace_destroy( sysace_t *ace )
{
    // Destroy pointers to all of the registers
    ace->mode[0]    = NULL;
    ace->mode[1]    = NULL;

    ace->control[0] = NULL;
    ace->control[1] = NULL;

    ace->status[0]  = NULL;
    ace->status[1]  = NULL;

    ace->error[0]   = NULL;
    ace->error[1]   = NULL;

    ace->count[0]   = NULL;
    ace->version[0] = NULL;
    ace->fat[0]     = NULL;
    ace->data[0]    = NULL;

    ace->clba[0]    = NULL;
    ace->clba[1]    = NULL;

    ace->mlba[0]    = NULL;
    ace->mlba[1]    = NULL;

    // Return successfully
    return SUCCESS;
}

Hushort sysace_version( sysace_t *ace )
{
    return sysace_getversion(ace);
}

Hint sysace_lock( sysace_t *ace )
{
    // Send the lock request
    sysace_orcontrol(ace, SYSACE_CONTROL_RLOCK);
    
    // Wait for the lock
    while( !(sysace_getstatus(ace) & SYSACE_STATUS_MLOCK) );

    // Return successfully
    return SUCCESS;
}

Hint sysace_unlock( sysace_t *ace )
{
    // Deassrt the lock request
    sysace_andcontrol( ace, ~SYSACE_CONTROL_RLOCK );
    
    // Return successfully
    return SUCCESS;
}

Hint sysace_busmode( sysace_t *ace, Hushort mode )
{
    sysace_setmode(ace,mode);

    // Return successfully
    return SUCCESS;
}

Hint sysace_enable( sysace_t *ace, Huint intr)
{
    // Set the appropriate bits in the control register
    sysace_orcontrol(ace, (intr & SYSACE_CONTROL_IMASK));

    // Return successfully
    return SUCCESS;
}

Hint sysace_disable( sysace_t *ace, Huint intr )
{
    // Clear the appropriate bits in the control register
    sysace_andcontrol(ace, ~(intr & SYSACE_CONTROL_IMASK));

    // Return successfully
    return SUCCESS;
}

Huint sysace_readbuffer( sysace_t *ace, Hubyte *buffer, Huint size )
{
    Huint   i;
    Huint   j;
    Huint   num;
    Huint   read;
    Hushort data;

    // Calculate the number of full buffer transfers
    num = size / SYSACE_DATA_BUFFER;

    // Initialize the number of bytes read
    read = 0;
    
    // Perform all of the full buffer transfers
    for( i = 0; i < num; i++ )
    {
        // Wait the the data buffer to be ready
        while(!(sysace_getstatus(ace) & SYSACE_STATUS_DREADY) ); //&& !sysace_geterror(ace));

        // Read the entire buffer out of the controller
        for( j = 0; j < SYSACE_DATA_BUFFER; j += 2 )
        {
            // Stop performing the read if an error occurred
            //if( sysace_geterror(ace) != 0 )  return read;

            // Read data out of the controller
            data = sysace_getdata(ace);

            // Store the data into the buffer
            *buffer++ = (Hubyte)data;
            *buffer++ = (Hubyte)(data >> 8);

            // Increment the number of bytes read
            read      += 2;
        }

        // Delay for a small amount of time for the controller
        DELAY_CTRL(ace);
    }

    // Perform any remaining reads
    if( read < size )
    {
        // Wait the the data buffer to be ready
        while(!(sysace_getstatus(ace) & SYSACE_STATUS_DREADY) && !sysace_geterror(ace));

        // Read the entire buffer out of the controller
        for( j = 0; j < SYSACE_DATA_BUFFER; j++ )
        {
            // Stop performing the read if an error occurred
            if( sysace_geterror(ace) != 0 )  return read;

            // Read data out of the controller
            data = sysace_getdata(ace);

            // Store the data into the buffer
            if( read < size )   { *buffer++ = (Hubyte)data; read++; }
            if( read < size )   { *buffer++ = (Hubyte)(data >> 8); read++; }
        }
    }

    // Return successfully
    return read;
}

Huint sysace_writebuffer( sysace_t *ace, Hubyte *buffer, Huint size)
{
    Huint   i;
    Huint   j;
    Huint   num;
    Hushort data;
    Huint   written;

    // Calculate the number of full buffer transfers
    num = size / SYSACE_DATA_BUFFER;

    // Initialize the number of bytes read
    written = 0;
    
    // Perform all of the full buffer transfers
    for( i = 0; i < num; i++ )
    {
        // Wait the the data buffer to be ready
        while(!(sysace_getstatus(ace) & SYSACE_STATUS_DREADY) && !sysace_geterror(ace));

        // Write an entire buffer out to the controller
        for( j = 0; j < SYSACE_DATA_BUFFER; j += 2 )
        {
            // Stop performing the read if an error occurred
            if( sysace_geterror(ace) != 0 )  return written;

            // Read data out of the buffer
            data  = (Hushort)(*buffer++);
            data |= (((Hushort)(*buffer++)) << 8);

            // Write data to the contoller
            sysace_setdata(ace,data);

            // Increment the number of bytes read
            written      += 2;
        }
    }

    // Perform any remaining writes
    if( written < size )
    {
        // Wait the the data buffer to be ready
        while(!(sysace_getstatus(ace) & SYSACE_STATUS_DREADY) && !sysace_geterror(ace));

        // Read the entire buffer out
        for( j = 0; j < SYSACE_DATA_BUFFER; j++ )
        {
            // Stop performing the read if an error occurred
            if( sysace_geterror(ace) != 0 )  return written;

            // Read data out of the buffer
            data = 0;
            if( written < size )    { data = (Hushort)(*buffer++); written++; }
            if( written < size )    { data |= (((Hushort)(*buffer++)) << 8); written++; }

            // Write data to the contoller
            sysace_setdata(ace,data);
        }
    }

    // Return successfully
    return written;
}

Huint sysace_flushbuffer( sysace_t *ace )
{
    Huint num;
    Huint done;
    Hushort data;

    num = 0;
    done = 0;
    while( done < 100 )
    {
        while( sysace_getstatus(ace) & SYSACE_STATUS_DREADY )
        {
            done = 0;

            data = sysace_getdata(ace);
            num++;
        }
        
        done++;
        usleep( 50 );
    }

    return num;
}

