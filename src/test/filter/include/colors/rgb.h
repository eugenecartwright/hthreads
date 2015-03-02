#ifndef _IMAGE_COLOR_RGB_H_
#define _IMAGE_COLOR_RGB_H_

struct __color_rgb_t
{
    uint8   r;
    uint8   g;
    uint8   b;
} __attribute__((__packed__));;

typedef struct __color_rgb_t  color_rgb_t;

#define rgb_red(c)             ((c).r)
#define rgb_green(c)           ((c).g)
#define rgb_blue(c)            ((c).b)
#define rgb_alpha(c)           255

#define rgb_make(_r,_g,_b,_a)  ({       \
        color_rgb_t c;                  \
        c.r = _r;                       \
        c.g = _g;                       \
        c.b = _b;                       \
        c;                              \
})

#define rgb_equal(c1,c2)        ({                  \
        (c1).r==(c2).r &&                           \
        (c1).g==(c2).g &&                           \
        (c1).b==(c2).b;                             \
})

#define rgb_add(c1,c2)         ({                                   \
    color_rgb_t    res;                                             \
    if( (int)(c1).r + (int)(c2).r > 255 )   res.r = 255;            \
    else                            res.r = ((c1).r + (c2).r);      \
    if( (int)(c1).g + (int)(c2).g > 255 )   res.g = 255;            \
    else                            res.r = ((c1).g + (c2).g);      \
    if( (int)(c1).b + (int)(c2).b > 255 )   res.b = 255;            \
    else                            res.r = ((c1).b + (c2).b);      \
    res;                                                            \
})

#define rgb_sub(c1,c2)         ({                                   \
    color_rgb_t    res;                                             \
    if( (int)(c1).r - (int)(c2).r < 0 )     res.r = 0;              \
    else                            res.r = ((c1).r - (c2).r);      \
    if( (int)(c1).g - (int)(c2).g < 0 )     res.g = 0;              \
    else                            res.g = ((c1).g - (c2).g);      \
    if( (int)(c1).b - (int)(c2).b < 0 )     res.b = 0;              \
    else                            res.b = ((c1).b - (c2).b);      \
    res;                                                            \
})

#define rgb_mul(c1,c2)         ({                                   \
    color_rgb_t    res;                                             \
    if( (int)(c1).r*(int)(c2).r > 255 )     res.r = 255;            \
    else                            res.r = ((c1).r * (c2).r);      \
    if( (int)(c1).g*(int)(c2).g > 255 )     res.g = 255;            \
    else                            res.g = ((c1).g * (c2).g);      \
    if( (int)(c1).b*(int)(c2).b > 255 )     res.b = 255;            \
    else                            res.g = ((c1).b * (c2).b);      \
    res;                                                            \
})

#define rgb_div(c1,c2)         ({                                   \
    color_rgb_t    res;                                             \
    if( (c2).r == 0 )               res.r = 255;                    \
    else                            res.r = ((c1).r / (c2).r);      \
    if( (c2).g == 0 )               res.g = 255;                    \
    else                            res.g = ((c1).g / (c2).g);      \
    if( (c2).b == 0 )               res.b = 255;                    \
    else                            res.b = ((c1).b / (c2).b);      \
    res;                                                            \
})

#define rgb_blend(c1,c2)        ({                                  \
    color_rgb_t    res;                                             \
    res.r = ((c1).r + (c2).r) / 2;                                  \
    res.g = ((c1).g + (c2).g) / 2;                                  \
    res.b = ((c1).b + (c2).b) / 2;                                  \
    res;                                                            \
})

#define rgb_cmp(c1,c2)          ({                                  \
        uint32 lc;                                                  \
        uint32 rc;                                                  \
        lc = (c1).r*(c1).r + (c1).g*(c1).g + (c1).b*(c1).b;         \
        rc = (c2).r*(c2).r + (c2).g*(c2).g + (c2).b*(c2).b;         \
        (lc == rc) ? 0 : (lc < rc) ? -1 : 1;                        \
})

#endif
