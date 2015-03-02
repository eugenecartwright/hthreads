#include <ps2/keyboard.h>
#include <ps2/keycodes.h>
#include <stdlib.h>

static Hubyte keycode[256]  = {
/*0x00          0x01            0x02            0x03*/
KEYCODE_NULL,   KEYCODE_F9,     KEYCODE_NULL,   KEYCODE_F5,
KEYCODE_F3,     KEYCODE_F1,     KEYCODE_F2,     KEYCODE_F12,
KEYCODE_NULL,   KEYCODE_F10,    KEYCODE_F8,     KEYCODE_F6,
KEYCODE_F4,     KEYCODE_TAB,    KEYCODE_TILDE,  KEYCODE_NULL,

/*0x10          0x11            0x12            0x13*/
KEYCODE_NULL,   KEYCODE_ALT,    KEYCODE_SHIFT,  KEYCODE_NULL,
KEYCODE_CTRL,   KEYCODE_Q,      KEYCODE_1,      KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_Z,      KEYCODE_S,
KEYCODE_A,      KEYCODE_W,      KEYCODE_2,      KEYCODE_WIN,

/*0x20          0x21            0x22            0x23*/
KEYCODE_NULL,   KEYCODE_C,      KEYCODE_X,      KEYCODE_D,
KEYCODE_E,      KEYCODE_4,      KEYCODE_3,      KEYCODE_WIN,
KEYCODE_NULL,   KEYCODE_SPACE,  KEYCODE_V,      KEYCODE_F,
KEYCODE_T,      KEYCODE_R,      KEYCODE_5,      KEYCODE_MENU,

/*0x30          0x31            0x32            0x33*/
KEYCODE_NULL,   KEYCODE_N,      KEYCODE_B,      KEYCODE_H,
KEYCODE_G,      KEYCODE_Y,      KEYCODE_6,      KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_M,      KEYCODE_J,
KEYCODE_U,      KEYCODE_7,      KEYCODE_8,      KEYCODE_NULL,

/*0x40          0x41            0x42            0x43*/
KEYCODE_NULL,   KEYCODE_COMMA,  KEYCODE_K,      KEYCODE_I,
KEYCODE_O,      KEYCODE_0,      KEYCODE_9,      KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_PERIOD, KEYCODE_FSLASH, KEYCODE_L,
KEYCODE_SEMI,   KEYCODE_P,      KEYCODE_MINUS,  KEYCODE_NULL,

/*0x50          0x51            0x52            0x53*/
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_QUOTE,  KEYCODE_NULL,
KEYCODE_LBRACE, KEYCODE_PLUS,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_CAPS,   KEYCODE_SHIFT,  KEYCODE_ENTER,  KEYCODE_RBRACE,
KEYCODE_NULL,   KEYCODE_BSLASH, KEYCODE_NULL,   KEYCODE_NULL,

/*0x60          0x61            0x62            0x63*/
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_BS,     KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_END,    KEYCODE_NULL,   KEYCODE_LEFT,
KEYCODE_HOME,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,

/*0x70          0x71            0x72            0x73*/
KEYCODE_INSERT, KEYCODE_DELETE, KEYCODE_DOWN,   KEYCODE_PAD5,
KEYCODE_RIGHT,  KEYCODE_UP,     KEYCODE_ESC,    KEYCODE_NUMLOCK,
KEYCODE_F11,    KEYCODE_PADPLS, KEYCODE_PGDOWN, KEYCODE_PADMINUS,
KEYCODE_PRINT,  KEYCODE_PGUP,   KEYCODE_SCROLL, KEYCODE_NULL,

/*0x80          0x81            0x82            0x83*/
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_F7,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,

/*0x90          0x91            0x92            0x93*/
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,

/*0xA0          0xA1            0xA2            0xA3*/
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,

/*0xB0          0xB1            0xB2            0xB3*/
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,

/*0xC0          0xC1            0xC2            0xC3*/
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,

/*0xD0          0xD1            0xD2            0xD3*/
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,

/*0xE0          0xE1            0xE2            0xE3*/
KEYCODE_NULL,   KEYCODE_PAUSE,  KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,

/*0xF0          0xF1            0xF2            0xF3*/
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,   KEYCODE_NULL,
};

static Hubyte ascii[256]  = {
/* 0x00 */  '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
/* 0x08 */  '\x00', '\x00', '\x00', '\x00', '\x00',   '\t',    '`', '\x00',
/* 0x10 */  '\x00', '\x00', '\x00', '\x00', '\x00',    'q',    '1', '\x00',
/* 0x18 */  '\x00', '\x00',    'z',    's',    'a',    'w',    '2', '\x00',
/* 0x20 */  '\x00',    'c',    'x',    'd',    'e',    '4',    '3', '\x00',
/* 0x28 */  '\x00',    ' ',    'v',    'f',    't',    'r',    '5', '\x00',
/* 0x30 */  '\x00',    'n',    'b',    'h',    'g',    'y',    '6', '\x00',
/* 0x38 */  '\x00', '\x00',    'm',    'j',    'u',    '7',    '8', '\x00',
/* 0x40 */  '\x00',    ',',    'k',    'i',    'o',    '0',    '9', '\x00',
/* 0x48 */  '\x00',    '.',    '/',    'l',    ';',    'p',    '-', '\x00',
/* 0x50 */  '\x00', '\x00',   '\'', '\x00',    '[',    '=', '\x00', '\x00',
/* 0x58 */  '\x00', '\x00',   '\r',    ']', '\x00',   '\\', '\x00', '\x00',
/* 0x60 */  '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x08', '\x00',
/* 0x68 */  '\x00', '\x03', '\x00', '\x00', '\x02', '\x00', '\x00', '\x00',
/* 0x70 */  '\x00', '\x7f', '\x00', '\x00', '\x00', '\x00', '\x1B', '\x00',
/* 0x78 */  '\x00',    '+', '\x00',    '-',    '*', '\x00', '\x00', '\x00',

/* 0x80 */  '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x00',
/* 0x88 */  '\x00', '\x00', '\x00', '\x00', '\x00',   '\t',    '~', '\x00',
/* 0x90 */  '\x00', '\x00', '\x00', '\x00', '\x00',    'Q',    '!', '\x00',
/* 0x98 */  '\x00', '\x00',    'Z',    'S',    'A',    'W',    '@', '\x00',
/* 0xA0 */  '\x00',    'C',    'X',    'D',    'E',    '$',    '#', '\x00',
/* 0xA8 */  '\x00',    ' ',    'V',    'F',    'T',    'R',    '%', '\x00',
/* 0xB0 */  '\x00',    'N',    'B',    'H',    'G',    'Y',    '^', '\x00',
/* 0xB8 */  '\x00', '\x00',    'M',    'J',    'U',    '&',    '*', '\x00',
/* 0xC0 */  '\x00',    '<',    'K',    'I',    'O',    ')',    '(', '\x00',
/* 0xC8 */  '\x00',    '>',    '?',    'L',    ':',    'P',    '_', '\x00',
/* 0xD0 */  '\x00', '\x00',    '"', '\x00',    '{',    '+', '\x00', '\x00',
/* 0xD8 */  '\x00', '\x00',   '\r',    '}', '\x00',    '|', '\x00', '\x00',
/* 0xE0 */  '\x00', '\x00', '\x00', '\x00', '\x00', '\x00', '\x08', '\x00',
/* 0xE8 */  '\x00', '\x03', '\x00', '\x00', '\x02', '\x00', '\x00', '\x00',
/* 0xF0 */  '\x00', '\x7f', '\x00', '\x00', '\x00', '\x00', '\x1B', '\x00',
/* 0xF8 */  '\x00',    '+', '\x00',    '-',    '*', '\x00', '\x00', '\x00',
};

Hint keyboard_create( keyboard_t *keyboard, ps2_t *ps2 )
{
    keyboard->ps2       = ps2;
    keyboard->leds      = 0;
    keyboard->shift     = Hfalse;
    keyboard->ctrl      = Hfalse;
    keyboard->alt       = Hfalse;
    keyboard->caps      = Hfalse;
    keyboard->num       = Hfalse;
    keyboard->scroll    = Hfalse;
    keyboard->size      = 0;

    keyboard_reset( keyboard );
    keyboard_enablenum( keyboard );
    return SUCCESS;
}

Hint keyboard_destroy( keyboard_t *keyboard )
{
    keyboard->ps2   = NULL;
    keyboard->shift = Hfalse;
    keyboard->ctrl  = Hfalse;
    keyboard->alt   = Hfalse;
    return SUCCESS;
}

Hint keyboard_reset( keyboard_t *keyboard )
{
    Hubyte ack;

    ps2_sendbyte( keyboard->ps2, KEYBOARD_CMD_RESET );

    ack = ps2_recvbyte( keyboard->ps2 );
    if( ack != 0xFA )   { return FAILURE; }

    ack = ps2_recvbyte( keyboard->ps2 );
    if( ack != 0xAA )   { return FAILURE; }
    
    return SUCCESS;
}

Huint keyboard_getkey( keyboard_t *keyboard )
{
    return ps2_recvbyte( keyboard->ps2 );
}

Huint keyboard_getcode( keyboard_t *keyboard )
{
    Huint key;

    // Read the next byte from the ps2 device
    key = ps2_recvbyte( keyboard->ps2 );

    // Check the key that was pressed
    switch( key )
    {
    case KEY_EXTEND:
        key = ps2_recvbyte( keyboard->ps2 );
        break;

    case KEY_RELEASE:
        key = ps2_recvbyte( keyboard->ps2 );
        break;
    }

    return keycode[key];
}

Hubyte keyboard_getascii( keyboard_t *keyboard )
{
    Hint   i;
    Hbool  up;
    Hubyte key;

    if( keyboard->size > 0 )
    {
        key = keyboard->data[0];
        for( i = 1; i < keyboard->size; i++ )   keyboard->data[i-1] = keyboard->data[i];

        keyboard->size--;
        return key;
    }
    
    up = Hfalse;
    key = ps2_recvbyte( keyboard->ps2 );
    while( ascii[key] == '\x00' )
    {
        if( key == KEY_RELEASE )    { up = Htrue; key = ps2_recvbyte( keyboard->ps2 ); }
        else                        { up = Hfalse; }

        switch( keycode[key] )
        {
        case KEYCODE_SHIFT:
            keyboard->shift = !up;
            break;

        case KEYCODE_CTRL:
            keyboard->ctrl = !up;
            break;

        case KEYCODE_ALT:
            keyboard->alt = !up;
            break;

        case KEYCODE_NUMLOCK:
            keyboard->scroll = !up;
            if( !up )   keyboard_togglenum( keyboard );
            break;

        case KEYCODE_SCROLL:
            if( !up )   keyboard_togglescroll( keyboard );
            break;

        case KEYCODE_CAPS:
            if( !up )   keyboard_togglecaps( keyboard );
            break;
        }

        key = ps2_recvbyte( keyboard->ps2 );
    }

    switch( keycode[key] )
    {
    case KEYCODE_ENTER:  keyboard->data[keyboard->size++] = '\n'; break;
    case KEYCODE_BS:     keyboard->data[keyboard->size++] = ' ';
                         keyboard->data[keyboard->size++] = '\x08'; break;
    }

    if( keyboard->shift || keyboard->caps ) return ascii[key + 128];
    else                                    return ascii[key];
}

void keyboard_enablecaps( keyboard_t *keyboard )
{
    Hubyte ack;

    keyboard->caps = Htrue;
    keyboard->leds |= KEYBOARD_LED_CAPS;
    ps2_sendbyte( keyboard->ps2, KEYBOARD_CMD_SETLED );
    ack = ps2_recvbyte( keyboard->ps2 );

    ps2_sendbyte( keyboard->ps2, keyboard->leds );
    ack = ps2_recvbyte( keyboard->ps2 );
}

void keyboard_disablecaps( keyboard_t *keyboard )
{
    Hubyte ack;

    keyboard->caps = Hfalse;
    keyboard->leds &= ~KEYBOARD_LED_CAPS;
    ps2_sendbyte( keyboard->ps2, KEYBOARD_CMD_SETLED );
    ack = ps2_recvbyte( keyboard->ps2 );

    ps2_sendbyte( keyboard->ps2, keyboard->leds );
    ack = ps2_recvbyte( keyboard->ps2 );
}

void keyboard_togglecaps( keyboard_t *keyboard )
{
    if( keyboard->leds & KEYBOARD_LED_CAPS )    keyboard_disablecaps( keyboard );
    else                                        keyboard_enablecaps( keyboard );
}

void keyboard_enablenum( keyboard_t *keyboard )
{
    Hubyte ack;

    keyboard->num  = Htrue;
    keyboard->leds |= KEYBOARD_LED_NUM;
    ps2_sendbyte( keyboard->ps2, KEYBOARD_CMD_SETLED );
    ack = ps2_recvbyte( keyboard->ps2 );

    ps2_sendbyte( keyboard->ps2, keyboard->leds );
    ack = ps2_recvbyte( keyboard->ps2 );
}

void keyboard_disablenum( keyboard_t *keyboard )
{
    Hubyte ack;

    keyboard->num  = Hfalse;
    keyboard->leds &= ~KEYBOARD_LED_NUM;
    ps2_sendbyte( keyboard->ps2, KEYBOARD_CMD_SETLED );
    ack = ps2_recvbyte( keyboard->ps2 );

    ps2_sendbyte( keyboard->ps2, keyboard->leds );
    ack = ps2_recvbyte( keyboard->ps2 );
}

void keyboard_togglenum( keyboard_t *keyboard )
{
    if( keyboard->leds & KEYBOARD_LED_NUM )     keyboard_disablenum( keyboard );
    else                                        keyboard_enablenum( keyboard );
}

void keyboard_enablescroll( keyboard_t *keyboard )
{
    Hubyte ack;

    keyboard->scroll = Htrue;
    keyboard->leds |= KEYBOARD_LED_SCROLL;
    ps2_sendbyte( keyboard->ps2, KEYBOARD_CMD_SETLED );
    ack = ps2_recvbyte( keyboard->ps2 );

    ps2_sendbyte( keyboard->ps2, keyboard->leds );
    ack = ps2_recvbyte( keyboard->ps2 );
}

void keyboard_disablescroll( keyboard_t *keyboard )
{
    Hubyte ack;

    keyboard->scroll = Hfalse;
    keyboard->leds &= ~KEYBOARD_LED_SCROLL;
    ps2_sendbyte( keyboard->ps2, KEYBOARD_CMD_SETLED );
    ack = ps2_recvbyte( keyboard->ps2 );

    ps2_sendbyte( keyboard->ps2, keyboard->leds );
    ack = ps2_recvbyte( keyboard->ps2 );
}

void keyboard_togglescroll( keyboard_t *keyboard )
{
    if( keyboard->leds & KEYBOARD_LED_SCROLL )  keyboard_disablescroll( keyboard );
    else                                        keyboard_enablescroll( keyboard );
}

void keyboard_setdelay( keyboard_t *keyboard, Hubyte delay )
{
    Hubyte ack;

    keyboard->delay = delay;
    ps2_sendbyte( keyboard->ps2, KEYBOARD_CMD_SETRATE );
    ack = ps2_recvbyte( keyboard->ps2 );

    ps2_sendbyte( keyboard->ps2, keyboard->delay|keyboard->rate );
    ack = ps2_recvbyte( keyboard->ps2 );
}

Hubyte keyboard_getdelay( keyboard_t *keyboard )
{
    return keyboard->delay;
}

void keyboard_setrate( keyboard_t *keyboard, Hubyte rate )
{
    Hubyte ack;

    keyboard->rate = rate;
    ps2_sendbyte( keyboard->ps2, 0xF3 );
    ack = ps2_recvbyte( keyboard->ps2 );

    ps2_sendbyte( keyboard->ps2, keyboard->delay|keyboard->rate );
    ack = ps2_recvbyte( keyboard->ps2 );
}

Hubyte keyboard_getrate( keyboard_t *keyboard )
{
    return keyboard->rate;
}

void keyboard_disable( keyboard_t *keyboard )
{
    Hubyte ack;
    ps2_sendbyte( keyboard->ps2, KEYBOARD_CMD_DISABLE );
    ack = ps2_recvbyte( keyboard->ps2 );
}

void keyboard_enable( keyboard_t *keyboard )
{
    Hubyte ack;
    ps2_sendbyte( keyboard->ps2, KEYBOARD_CMD_ENABLE );
    ack = ps2_recvbyte( keyboard->ps2 );
}
