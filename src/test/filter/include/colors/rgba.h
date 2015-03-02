#ifndef _IMAGE_COLOR_RGBA_H_
#define _IMAGE_COLOR_RGBA_H_

typedef uint32 color_rgba_t;
typedef union
{
    color_rgba_t    color;
    struct { uint8 r; uint8 g; uint8 b; uint8 a; };
} __rgba_helper;

#define rgba_red(c)            ((c) >>  0 & 0xFF)
#define rgba_green(c)          ((c) >>  8 & 0xFF)
#define rgba_blue(c)           ((c) >> 16 & 0xFF) 
#define rgba_alpha(c)          ((c) >> 24 & 0xFF)

#define rgba_make(r,g,b,a)     ((((r)&0xFF)<< 0)   |   \
                                (((g)&0xFF)<< 8)   |   \
                                (((b)&0xFF)<<16)   |   \
                                (((a)&0xFF)<<24))

#define rgba_equal(c1,c2)       ((c1) == (c2))

#define rgba_add(_c1,_c2)       ({                                  \
    __rgba_helper    res;                                           \
    __rgba_helper    c1;                                            \
    __rgba_helper    c2;                                            \
    c1.color = _c1;                                                 \
    c2.color = _c2;                                                 \
    if( (int)(c1).r + (int)(c2).r > 255 )   res.r = 255;            \
    else                            res.r = ((c1).r + (c2).r);      \
    if( (int)(c1).g + (int)(c2).g > 255 )   res.g = 255;            \
    else                            res.r = ((c1).g + (c2).g);      \
    if( (int)(c1).b + (int)(c2).b > 255 )   res.b = 255;            \
    else                            res.r = ((c1).b + (c2).b);      \
    if( (int)(c1).a + (int)(c2).a > 255 )   res.a = 255;            \
    else                            res.a = ((c1).a + (c2).a);      \
    res.color;                                                      \
})

#define rgba_sub(_c1,_c2)       ({                                  \
    __rgba_helper    res;                                           \
    __rgba_helper    c1;                                            \
    __rgba_helper    c2;                                            \
    c1.color = _c1;                                                 \
    c2.color = _c2;                                                 \
    if( (int)(c1).r - (int)(c2).r < 0 )     res.r = 0;              \
    else                            res.r = ((c1).r - (c2).r);      \
    if( (int)(c1).g - (int)(c2).g < 0 )     res.g = 0;              \
    else                            res.g = ((c1).g - (c2).g);      \
    if( (int)(c1).b - (int)(c2).b < 0 )     res.b = 0;              \
    else                            res.b = ((c1).b - (c2).b);      \
    if( (int)(c1).a - (int)(c2).a < 0 )     res.a = 0;              \
    else                            res.a = ((c1).a - (c2).a);      \
    res.color;                                                      \
})

#define rgba_mul(_c1,_c2)       ({                                  \
    __rgba_helper    res;                                           \
    __rgba_helper    c1;                                            \
    __rgba_helper    c2;                                            \
    c1.color = _c1;                                                 \
    c2.color = _c2;                                                 \
    if( (int)(c1).r*(int)(c2).r > 255 )     res.r = 255;            \
    else                            res.r = ((c1).r * (c2).r);      \
    if( (int)(c1).g*(int)(c2).g > 255 )     res.g = 255;            \
    else                            res.g = ((c1).g * (c2).g);      \
    if( (int)(c1).b*(int)(c2).b > 255 )     res.b = 255;            \
    else                            res.g = ((c1).b * (c2).b);      \
    if( (int)(c1).a*(int)(c2).a > 255 )     res.a = 255;            \
    else                            res.a = ((c1).a * (c2).a);      \
    res.color;                                                      \
})

#define rgba_div(_c1,_c2)       ({                                  \
    __rgba_helper    res;                                           \
    __rgba_helper    c1;                                            \
    __rgba_helper    c2;                                            \
    c1.color = _c1;                                                 \
    c2.color = _c2;                                                 \
    if( (c2).r == 0 )               res.r = 255;                    \
    else                            res.r = ((c1).r / (c2).r);      \
    if( (c2).g == 0 )               res.g = 255;                    \
    else                            res.g = ((c1).g / (c2).g);      \
    if( (c2).b == 0 )               res.b = 255;                    \
    else                            res.b = ((c1).b / (c2).b);      \
    if( (c2).a == 0 )               res.a = 255;                    \
    else                            res.a = ((c1).a / (c2).a);      \
    res.color;                                                      \
})

#define rgba_blend(_c1,_c2)      ({                                 \
    __rgba_helper    res;                                           \
    __rgba_helper    c1;                                            \
    __rgba_helper    c2;                                            \
    c1.color = _c1;                                                 \
    c2.color = _c2;                                                 \
    res.r = (((c1).r*(255-(c2).a)) + ((c2).r*(c2).a)) / 255;        \
    res.g = (((c1).g*(255-(c2).a)) + ((c2).g*(c2).a)) / 255;        \
    res.b = (((c1).b*(255-(c2).a)) + ((c2).b*(c2).a)) / 255;        \
    res.a = (c2).a;                                                 \
    res.color;                                                      \
})

#define rgba_cmp(_c1,_c2)       ({                                  \
    uint32 lc;                                                      \
    uint32 rc;                                                      \
    __rgba_helper    c1;                                            \
    __rgba_helper    c2;                                            \
    c1.color = _c1;                                                 \
    c2.color = _c2;                                                 \
    lc = (c1).r*(c1).r + (c1).g*(c1).g + (c1).b*(c1).b;             \
    rc = (c2).r*(c2).r + (c2).g*(c2).g + (c2).b*(c2).b;             \
    (lc == rc) ? 0 : (lc < rc) ? -1 : 1;                            \
})

#endif
