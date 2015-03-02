#include <hthread.h>
#include <xexception_l.h>
#include <xintc_l.h>
#include <time/time.h>
#include <pic/pic.h>

#define DELTA       (1 *    5000 - 1)
#define DELTA2      (10 * 100000 - 1)

void setup_timer( void )
{
    XExc_mDisableExceptions(XEXC_NON_CRITICAL);
    
    timer_set_delta( 0,  DELTA2 );
    timer_set_data(  0, 0xCAFEBABE );
    
    timer_set_command( 0,   HT_TIMER_CMD_PERIODIC   |
                            HT_TIMER_CMD_ENABLE     |
                            HT_TIMER_CMD_LOAD       |
                            HT_TIMER_CMD_RUN        );

    XExc_mEnableExceptions(XEXC_NON_CRITICAL);
}

void setup_pic( void )
{
    Hint intrstatus;

    XIntc_mMasterEnable( NONCRIT_PIC_BASEADDR );
    XIntc_mEnableIntr( NONCRIT_PIC_BASEADDR, 0xFFFFFFFF );

    intrstatus = spic_enabled();
    printf( "INTR Global Enable =  %x\n", intrstatus);
    intrstatus = spic_menable();
    printf( "Setting INTR Global Enable =  %x\n", intrstatus);
    intrstatus = spic_enabled();
    printf( "INTR Global Enable =  %x\n", intrstatus);
    intrstatus = spic_pending();
    printf( "INTR pending =  %x\n", intrstatus);
    intrstatus = spic_intrena();
    printf( "INTR Interrupts Enabled =  %x\n", intrstatus);    
}

void* child( void *arg )
{
    Hint res;
    Hint iid;
    Hint intrstatus;

    iid = (int)arg;
    while( 1 )
    {
        // Show that we are waiting for the interrupt
        printf( "Waiting for Interrupt: %d\n", iid );

        // Associate with an interrupt
        res = hthread_intrassoc( 1 );
        if( res < 0 )   printf( "Error During Association: %d\n", iid );

        intrstatus = spic_pending();
        printf( "INTR pending =  %x\n", intrstatus);

        // Show that we received the interrupt
        printf( "Interrupt Received: %d\n", iid );
    }

    return NULL;
}

int main( int argc, char *argv[] )
{
    Hint        i;
    hthread_t   tid[32];

    setup_pic();
    setup_timer();
    for( i = 0; i < 2; i++ )   hthread_create( &tid[i], NULL, child, (void*)i );

    while( 1 ) { write_reg(0x73000040, 0xCAFEBABE); hthread_yield(); }
    for( i = 0; i < 2; i++ )   hthread_join( tid[i], NULL );

    return 0;
}
