#include <sysace/sysace.h>
#include <sysace/cfg.h>
#include <sleep.h>

Hint sysace_cfg_reset( sysace_t *ace )
{
    // Assert the reset bit in the control register
    sysace_orcontrol(ace, SYSACE_CONTROL_RESET);

    // Sleep for a short period of time
    usleep( 50 );

    // Deassert the reset bit in the control register
    sysace_andcontrol(ace, ~SYSACE_CONTROL_RESET);

    // Flush the buffer
    sysace_flushbuffer( ace );

    // Return successfully
    return SUCCESS;
}

Hint sysace_cfg_addr( sysace_t *ace, Huint addr )
{
    Huint ctrl;

    // Get the old configuration
    ctrl = sysace_getcontrol(ace);

    // Clear the address bits from the control register
    ctrl &= ~SYSACE_CONTROL_ADDR;
    
    // Set the address bits in the control register
    ctrl |= ((addr<<SYSACE_CONTROL_ASHIFT) & SYSACE_CONTROL_ADDR);

    // Set the force address bit in the control register
    ctrl |= SYSACE_CONTROL_FADDR;
        
    // Set  the control bits to the new value
    sysace_setcontrol(ace,ctrl);

    // Return successfully
    return SUCCESS;
}

Hint sysace_cfg_mode( sysace_t *ace, Hbool immed, Hbool start )
{
    Huint ctrl;

    // Get the old configuration
    ctrl = sysace_getcontrol(ace);

    // Set the immediate mode bit in the control register
    if( immed ) ctrl |= SYSACE_CONTROL_MODE;
    else        ctrl &= ~SYSACE_CONTROL_MODE;

    // Set the start bit in to control register
    if( start ) ctrl |= SYSACE_CONTROL_START;
    else        ctrl &= ~SYSACE_CONTROL_START;

    // Set the force mode bit in the control regsiter
    ctrl |= SYSACE_CONTROL_FMODE;

    // Set the new mode in the control register
    sysace_setcontrol(ace,ctrl);

    // Return successfully
    return SUCCESS;
}

Hint sysace_cfg_select( sysace_t *ace, Hbool sel )
{
    Huint ctrl;

    // Get the old configuration
    ctrl = sysace_getcontrol(ace);

    // Set the select bit in the control register
    if( sel )   ctrl |= SYSACE_CONTROL_SELECT;
    else        ctrl &= ~SYSACE_CONTROL_SELECT;

    // Set the new mode in the control register
    sysace_setcontrol(ace,ctrl);

    // Return successfully
    return SUCCESS;
}

Hint sysace_cfg_prog( sysace_t *ace, Hubyte *buffer, Huint size )
{
    Huint ctrl;
    Huint num;
    
    // If the device is not locked return an error
    if( !(sysace_getstatus(ace) & SYSACE_STATUS_MLOCK) )  return EDEADLK;

    // Get the old configuration
    ctrl = sysace_getcontrol(ace);

    // Use the MPU to perform configuration
    sysace_cfg_select( ace, Htrue );

    // Set the mode to start configuration only when the start bit is active
    sysace_cfg_mode( ace, Hfalse, Htrue );

    // Reset the controller (it will start the configuration process)
    sysace_cfg_reset( ace );

    // Send the configuration data to the controller (skipping the first sector)
    num = sysace_writebuffer( ace, buffer+SYSACE_DATA_SECTOR, size-SYSACE_DATA_SECTOR );
    
    // Restore the old configuration
    sysace_setcontrol(ace,ctrl);

    // Determine if there was an error sending the data
    if( num != size )   return EIO;

    // Return successfully
    return SUCCESS;
}

Huint sysace_cfg_sector( sysace_t *ace )
{
    return sysace_getclba(ace);
}

