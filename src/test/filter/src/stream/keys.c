#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>
#include <math.h>

extern stream_t streams[];
int laplace3_run = 0;
int laplace5_run = 0;
int sharpen_run = 0;
int sharpen_val = 1;
int sobel_run = 0;
int gray_run = 0;
int blur_run = 0;
int pixelate_run = 0;
int emboss_run = 0;
int histogram_run = 0;
int intensity_waveform_run = 0;
int uv_mapping_run = 0;
int hough_run = 0;

int hw_not_sw = 0;
int low_line = 20;
int high_line = 40;
int frame_limit_run = 0;
int invert_run = 0;
int dct_run = 0;
int idct_run = 0;
int rotate_run = 0;
int histogram_eq_run = 0;
int median_run = 0;
int contrast_run = 0;
int median_win = 3;
int thresh_run = 0;
int thresh_val = 128;

int angle = 0;
//float sang = 0;
//float cang = 1;

int fps = 30;

extern int read_nonblock( int fd, void *buffer, size_t nbytes );
void process_keys()
{
    int tst;
    char inp;

    tst = read_nonblock( 0, &inp, 1 );
    if( tst == 0 || inp == 0 ) return;

    switch( inp )
    {
    case 'l':   laplace3_run = !laplace3_run; break;
    case 'd':   dct_run = !dct_run; break;
    case 'x':   idct_run = !idct_run; break;
    case 'r':   rotate_run = !rotate_run; break;
    case '5':   laplace5_run = !laplace5_run; break;
    case 'z':   sharpen_run = !sharpen_run; break;
    case 's':   sobel_run = !sobel_run; break;
    case 'b':   blur_run = !blur_run; break;
    case 'p':   pixelate_run = !pixelate_run; break;
    case 'e':   emboss_run = !emboss_run; break;
    case 'h':   histogram_run = !histogram_run; break;
    case 'q':   histogram_eq_run = !histogram_eq_run; break;
    case '!':   hw_not_sw = !hw_not_sw; break;
    case 'n':   invert_run = !invert_run; break;
    case 'i':   intensity_waveform_run = !intensity_waveform_run; break;
    case 'u':   uv_mapping_run = !uv_mapping_run; break;
    case 'o':   hough_run = !hough_run; break;
    case 'f':   frame_limit_run = !frame_limit_run; break;
    case 'm':   median_run = !median_run; break;
    case 't':   thresh_run = !thresh_run; break;
    case 'g':   gray_run = !gray_run; break;
    case 'c':   contrast_run = !contrast_run; break;
    case '[':   median_win -= 2; if( median_win < 3 ) median_win = 3; break;
    case ']':   median_win += 2; if( median_win > 9 ) median_win = 9; break;
    case ',':   low_line++; high_line--; break;
    case '.':   low_line--; high_line++; break;
    case '-':   low_line--; high_line--; break;
    case '=':   low_line++; high_line++; break;
    case '0':   thresh_val++; if( thresh_val > 255 ) thresh_val = 255; break;
    case '9':   thresh_val--; if( thresh_val < 0 ) thresh_val = 0; break;
    case '1':   sharpen_val--; if( sharpen_val < 1 ) sharpen_val = 1; break;
    case '2':   sharpen_val++; if( sharpen_val > 255 ) sharpen_val = 255; break;
    case ')':   angle--;  if (angle < 0) angle = 0; /*sang = sin( M_PI/180.0 * angle ); cang = cos( M_PI/180.0 * angle );*/ break;
    case '(':   angle++;  if (angle > 360) angle = 0;/* sang = sin( M_PI/180.0 * angle ); cang = cos( M_PI/180.0 * angle );*/ break;
    case ';':   fps--; break;
    case '\'':  fps++; break;

    case 27:   
        rotate_run = 0;
        histogram_run = 0;
        intensity_waveform_run = 0;
        laplace3_run = 0;
        laplace5_run = 0;
        frame_limit_run = 0;
        sharpen_run = 0;
        sobel_run = 0;
        blur_run = 0;
        pixelate_run = 0;
        gray_run = 0;
        median_run = 0;
        contrast_run = 0;
        invert_run = 0;
        dct_run = 0;
        idct_run = 0;
        histogram_eq_run = 0;
        uv_mapping_run = 0;
        hough_run = 0;
        emboss_run = 0;
        low_line = 20;
        high_line = 40;
        thresh_val = 128;
        thresh_run = 0;
        fps = 30;
        angle = 45;
        hw_not_sw = 0;
        break;

    case '\\':
        stream_show( streams );
        break;

    case 8:     
    case 127:
        printf("Filter                  Key      Enabled \n");
        printf("-------------------------------------------------------\n");
        printf("laplace 3x3             l        %d\n",laplace3_run);
        printf("laplace 5x5             5        %d\n",laplace5_run);
        printf("sharpen                 z        %d\n",sharpen_run);
        printf("invert                  n        %d\n",invert_run);
        printf("sobel                   s        %d\n",sobel_run);
        printf("blur                    b        %d\n",blur_run);
        printf("pixelate                p        %d\n",pixelate_run);
        printf("emboss                  e        %d\n",emboss_run);
        printf("gray scale              g        %d\n",gray_run);
        printf("median                  m        %d\n",median_run);
        printf("contrast                c        %d\n",contrast_run);
        printf("histogram               h        %d\n",histogram_run);
        printf("histogram_eq            q        %d\n",histogram_eq_run);
        printf("rotate                  r        %d\n",rotate_run);
        printf("DCT                     d        %d\n",dct_run);
        printf("IDCT                    x        %d\n",idct_run);
        printf("threshold               t        %d\n",thresh_run);
        printf("intensity waveform      i        %d\n",intensity_waveform_run);
        printf("uv mapping              u        %d\n",uv_mapping_run);
        printf("hough                   o        %d\n",hough_run);
        printf("frame rate limit        f        %d\n",frame_limit_run);
        printf("frame rate decrease     ;        %d\n",fps);
        printf("frame rate increase     '        %d\n",fps);
        printf("median window decrease  [        %d\n",median_win);
        printf("median window increase  ]        %d\n",median_win);
        printf("threshold decrease      9        %d\n",thresh_val);
        printf("threshold increase      0        %d\n",thresh_val);
        printf("sharpen decrease        1        %d\n",sharpen_val);
        printf("sharpen increase        2        %d\n",sharpen_val);
        printf("angle decrease          )        %d\n",angle);
        printf("angle increase          (        %d\n",angle);
        printf("HW(1) or SW(0)          !        %d\n",hw_not_sw);
        break;

    //default:    printf( "Unknown Key: %d (%c)\n", inp, inp );
    }
}

