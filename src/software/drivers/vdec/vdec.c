#include <vdec/vdec.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <config.h>
#include <xio.h>
#include <xi2c_l.h>
#include <sleep.h>

//Read: 0x41, Write: 0x40
#define DECODER     0x20
#define NORESET     1
#define IICRESET    3
#define DECRESET    0

const vdec_program_t SVIDEO_PROGRAM = { 17, {
    { 0x00, 0x06 }, { 0x15, 0x00 }, { 0x27, 0x58 }, { 0x3a, 0x12 },
    { 0x50, 0x04 }, { 0x0e, 0x80 }, { 0x50, 0x20 }, { 0x52, 0x18 },
    { 0x58, 0xed }, { 0x77, 0xc5 }, { 0x7c, 0x93 }, { 0x7d, 0x00 },
    { 0xd0, 0x48 }, { 0xd5, 0xa0 }, { 0xd7, 0xea }, { 0xe4, 0x3e },
    { 0xea, 0x0f }, { 0x0e, 0x00 }}}; 

const vdec_program_t COMPOSITE_PROGRAM = { 18, {
    { 0x00, 0x04 }, { 0x15, 0x00 }, { 0x17, 0x41 }, { 0x27, 0x58 },
    { 0x3a, 0x16 }, { 0x50, 0x04 }, { 0x0e, 0x80 }, { 0x50, 0x20 },
    { 0x52, 0x18 }, { 0x58, 0xed }, { 0x77, 0xc5 }, { 0x7c, 0x93 },
    { 0x7d, 0x00 }, { 0xd0, 0x48 }, { 0xd5, 0xa0 }, { 0xd7, 0xea },
    { 0xe4, 0x3e }, { 0xea, 0x0f }, { 0x0e, 0x00 }}};

const vdec_program_t COMPONENT_PROGRAM = { 13, {
    { 0x00, 0x0a }, { 0x27, 0xd8 }, { 0x50, 0x04 }, { 0x0e, 0x80 },
    { 0x52, 0x18 }, { 0x58, 0xed }, { 0x77, 0xc5 }, { 0x7c, 0x93 },
    { 0x7d, 0x00 }, { 0xd0, 0x48 }, { 0xd5, 0xa0 }, { 0xe4, 0x3e },
    { 0x0e, 0x00 }}};

Hint vdec_create( vdec_t *vdec, vdec_config_t *config )
{
    Hubyte strt;
    Hubyte recv;
    Hint   valu;

    // Store the base address of the I2C
    vdec->base = config->base;

    // Setup the addresses for the line 1 ready GPIO
    vdec->ready   = (Huint*)(config->ready);
    vdec->control = (Huint*)(config->ready + 1);

    // Setup the addresses for the video data buffers
    vdec->data[0] = (Huint*)(config->data[0]);
    vdec->data[1] = (Huint*)(config->data[1]);

    // Setup all GPIOs to be inputs
    *vdec->control = 0xFFFFFFFF;

    // Turn off the reset signal to the video decoder
    XI2c_mWriteReg( vdec->base, IIC_GPO, NORESET );

    // Initialize the video decoder board
    printf( "Detecting Video Decoder...\r" );
    XI2c_mWriteReg( vdec->base, IIC_GPO, IICRESET );
    XI2c_mWriteReg( vdec->base, IIC_GPO, NORESET ); 

    strt = 0;
    valu = XI2c_RSRecv( vdec->base, DECODER, strt, &recv, 1);
    if( valu != 1 )
    {
        printf( "Detecting Video Decoder...none found\n" );
        return EINVAL;
    }
    else
    {
        printf( "Detecting Video Decoder...found\n" );
        return SUCCESS;
    }
}

Hint vdec_destroy( vdec_t *vdec )
{
    // Return Successfully
    return SUCCESS;
}

Hint vdec_reset( vdec_t *vdec )
{
    // Send the reset to the video decoder
    XI2c_mWriteReg( vdec->base, IIC_GPO, DECRESET );
    usleep( 10 );

    // Turn the reset signal back off
    XI2c_mWriteReg( vdec->base, IIC_GPO, NORESET );
    usleep( 10 );

    // Return Successfully
    return SUCCESS;
}

Hint vdec_program( vdec_t *vdec, const vdec_program_t *program )
{
    Huint   i;
    Huint   num;
    Xuint8 send_data[2] = {0};

    // Download the configuration data to the VDEC
    for( i = 0; i < program->size; i++ )
    {
        XI2c_mWriteReg( vdec->base, IIC_GPO, IICRESET );
        XI2c_mWriteReg( vdec->base, IIC_GPO, NORESET );

        send_data[0] = program->data[i].addr;
        send_data[1] = program->data[i].val;
        num = XI2c_Send( vdec->base,DECODER, send_data,2);
        if( num != 2 )
        {
            printf( "Could not send data\n" );
            return EBADE;
        }
    }

    // Return Successfully
    return SUCCESS;
}

Hint vdec_select_composite( vdec_t *vdec )
{
    return vdec_program( vdec, &COMPOSITE_PROGRAM );
}

Hint vdec_select_svideo( vdec_t *vdec )
{
    return vdec_program( vdec, &SVIDEO_PROGRAM );
}

Hint vdec_select_component( vdec_t *vdec )
{
    return vdec_program( vdec, &COMPONENT_PROGRAM );
}
