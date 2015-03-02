#ifndef _IMAGE_COLOR_GRAY_H_
#define _IMAGE_COLOR_GRAY_H_

typedef uint8 color_gray_t;

#define gray_red(c)             c
#define gray_green(c)           c
#define gray_blue(c)            c
#define gray_alpha(c)           255

#define gray_make(r,g,b,a)      ((r+g+b)/3)
#define gray_equal(c1,c2)       ((c1) == (c2))

#define gray_add(c1,c2)         ({                                  \
    color_gray_t    res;                                            \
    if( (int)c1 + (int)c2 > 255 )   res = 255;                      \
    else                            res = ((c1) + (c2));            \
    res;                                                            \
})

#define gray_sub(c1,c2)         ({                                  \
    color_gray_t    res;                                            \
    if( (int)c1 - (int)c2 < 0 )     res = 0;                        \
    else                            res = ((c1) - (c2));            \
    res;                                                            \
})

#define gray_mul(c1,c2)         ({                                  \
    color_gray_t    res;                                            \
    if( (int)c1*(int)c2 > 255 )     res = 255;                      \
    else                            res = ((c1) * (c2));            \
    res;                                                            \
})

#define gray_div(c1,c2)         ({                                  \
    color_gray_t    res;                                            \
    if( c2 == 0 )                   res = 255;                      \
    else                            res = ((c1) / (c2));            \
    res;                                                            \
})

#define gray_blend(c1,c2)         (((c1)+(c2))/2)

#define gray_cmp(c1,c2)         ({                                  \
        (c1 == c2) ? 0 : (c1 < c2) ? -1 : 1;                        \
})

#endif
