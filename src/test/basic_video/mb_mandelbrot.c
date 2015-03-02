//
// This application utilizes microblaze processors to calculate the 
// mandelbrot series.
// It displays the output using vga
// Author: Andres Baez
// Date: Fall 2010
//

#include <stdio.h>
#include <hthread.h>
#include <vga_lib.h>
#include <arch/arch.h>

// Define the vga output size
#define DISPLAY_COLUMNS  640
#define DISPLAY_ROWS     480

#define int32 int
#define MAX_VALUE 256

#define WORKER_THREADS 2



 //////////////
// STRUCTURES //
 //////////////

typedef struct {
    float real;
    float imag;
} complex_t;


// Thread argument structure
typedef struct {
    hthread_mutex_t *output_mutex;
    framebuffer_t *dst_image;

    vga_t *vga;
} targ_t;


// Processing threads's arguments
typedef struct {
    targ_t *img;

    int x_start;
    int x_end;
    int y_start;
    int y_end;
} args_t;

 ////////////////////////
// FUNCTION DEFINITIONS //
 ////////////////////////

void *input_thread(void *arg);
void *output_thread(void *arg);
void *process_thread(void *arg);
int calc_pixel(complex_t c, int x, int y, framebuffer_t *dst);

// Extra functions
void usleep(int delay);
int32 framebuffer_invert(framebuffer_t *dst, framebuffer_t *src);
void draw_colors(framebuffer_t *dst, framebuffer_t *src, vga_t *vga);

void exit(int n) {
    printf("EXIT! (%d)\n",n);
    while(1);
}



 ////////
// MAIN //
 ////////

int main(void) {
    int i=0;

    printf("~~~ VGA Mandelbrot ~~~\n");
    // Setup Cache PPC Only
    //XCache_DisableDCache();
    //XCache_EnableICache(0xc0000801);

    // Declare the threads
    hthread_t tid[WORKER_THREADS];
    hthread_t tid0, tid1;

    hthread_mutex_t mutex; // Declare the mutex

    args_t *targ; // thread argument
    targ_t iarg; // Image data argument

    vga_t vga; // Declare vga type
    pixel_t *image; // Declare pixel type

    // Initialize the video device
    printf("Setting up TFT...\n");
    vgaoutput_init(&vga);

    // Initialize the mutex
    printf("Setting up synchronization...\n");
    hthread_mutex_init(&mutex, NULL);

    // Allocating framebuffers
    printf("Allocating framebuffers...\n");
    iarg.dst_image = malloc(sizeof(framebuffer_t));

    // Allocate memory for the image to display
    printf("Allocating memory for the image...\n");
    image = (pixel_t *)malloc((DISPLAY_COLUMNS*DISPLAY_ROWS) * sizeof(pixel_t));
    if (image == NULL) {
        printf("ERROR - Unable to allocate memory for the image!\n");
        exit(1);
    }

    // Setup thread arguments
    printf("Setting up thread arguments...\n");
    iarg.output_mutex = &mutex;
    iarg.dst_image->width = DISPLAY_COLUMNS;
    iarg.dst_image->height = DISPLAY_ROWS;
    iarg.dst_image->im_ptr = (pixel_t *)image;
    iarg.vga = &vga;

    printf("    Allocating memory for the worker thread arguments...\n");
    targ = (args_t *)malloc(WORKER_THREADS * sizeof(args_t));
    if (targ == NULL) {
        printf("Unable to allocate memory!\n");
        exit(1);
    }

    // Initialize the address of the image for all thread arguments
    for (i=0; i < WORKER_THREADS; i++) {
        targ[i].img = &iarg;
    }

    // Initialize the background color
    printf("Initializing the background screen color to: [20, 100, 150]\n");
    for (i=0; i < DISPLAY_COLUMNS*DISPLAY_ROWS; i++) {
        pixel_t pix;

        pix.r = 20; 
        pix.g = 100;
        pix.b = 150;

        image[i] = pix;
    }

    int min_num_rows = targ[0].img->dst_image->height / (int)WORKER_THREADS;
    printf("\nThere will be %d worker threads.\n", WORKER_THREADS);
    printf("Each thread will process %d rows...\n\n", min_num_rows);

    //printf("Setting up thread attributes...\n");
    //hthread_attr_t attr[WORKER_THREADS];
    //for (i=0; i < WORKER_THREADS; i++) {
    //    //hthread_attr_init(&attr[i]);
    //}

    // Pre-lock mutex
    hthread_mutex_lock(&mutex);

    // Create threads
    unsigned int status;

    printf("Creating threads...\n");
    printf("    Creating input thread...\n");
    status = hthread_create(&tid0, NULL, input_thread, (void *)targ);
    if (status != SUCCESS) {
        printf("ERROR - Unable to create thread: (STA=0x%8.8x)\n", status);
        exit(1);
    }
    printf("    -> Thread Created.\n");

    // Allow input thread to pre-lock mutex
    hthread_yield();

    int start_num = 0;

    for (i=0; i < WORKER_THREADS; i++) {
        // Initialize the thread arguments
        targ[i].x_start = start_num;
        targ[i].x_end = start_num + (min_num_rows - 1);
        targ[i].y_start = 0;
        targ[i].y_end = targ[i].img->dst_image->width-1;

        printf("    Creating process thread %d...\n", i);
        printf("        -> x: %d - %d, y: %d - %d\n", targ[i].x_start,
                                                      targ[i].x_end,
                                                      targ[i].y_start,
                                                      targ[i].y_end);
        status = hthread_create(&tid[i], NULL, process_thread, (void *)&targ[i]);
        if (status != SUCCESS) {
            printf("ERROR - Unable to create thread (STA=0x%8.8x)\n", status);
            exit(1);
        }

        start_num += min_num_rows;
        printf("    -> Process thread %d created.\n", i);
    }

    printf("    Creating output thread...\n");
    status = hthread_create(&tid1, NULL, output_thread, (void *)targ);
    if (status != SUCCESS) {
        printf("ERROR - Unable to create thread: (STA=0x%8.8x)\n", status);
        exit(1);
    }
    printf("    -> Output thread created.\n");

    // Release mutex, allowing all threads to process data
    hthread_mutex_unlock(&mutex);

    // Wait for threads to complete
    printf("Waiting for threads to complete...\n");
    hthread_join(tid0, NULL);
    for (i=0; i < WORKER_THREADS; i++) {
        printf("Joining process thread %d\n", i);
        hthread_join(tid[i], NULL);
    }
    hthread_join(tid1, NULL);

    //draw_colors(dst_image, dst_image, &vga);

    printf("-- DONE --\n");
    return 0;
}



 ///////////////////
// FUNCTION BODIES //
 ///////////////////


void draw_colors(framebuffer_t *dst, framebuffer_t *src, vga_t *vga) {
    if ((dst->width != src->width) || (dst->height != src->height)) {
        printf("Error, dimensions don't match!\n");
    }

    vgaoutput_show_frame(vga, src);
}


void *process_thread(void *arg) {
    args_t *targ = (args_t *)arg;
    framebuffer_t *dst = targ->img->dst_image;
    complex_t c;

    int y=0, x=0;

    //hthread_mutex_lock(targ->img->output_mutex);
    while (1) {
        //printf("PROCESS THREAD:\n");
        //hthread_mutex_unlock(targ->img->output_mutex);
        for (y=targ->y_start; y < targ->y_end; y++) {
            c.real = y/((double)dst->width) * 4.0 - 2.0;
            for (x=targ->x_start; x < targ->x_end; x++) {
                c.imag = x/((double)dst->height) * 4.0 - 2.0;

                hthread_mutex_lock(targ->img->output_mutex);
                printf("Coord(%d, %d) P#%d\n", x,y, _get_procid());
                //framebuffer_invert(targ->img->dst_image, targ->img->dst_image);
                calc_pixel(c, x, y, dst);
                //vgaoutput_show_frame(targ->img->vga, targ->img->dst_image);
                hthread_mutex_unlock(targ->img->output_mutex);
                hthread_yield();
            }
        }
    }

    return (void *)99;
}



void *output_thread(void *arg) {
    args_t *targ = (args_t *)arg;
    
    while (1) {
        hthread_mutex_lock(targ->img->output_mutex);
        //printf("OUTPUT THREAD\n");
        vgaoutput_show_frame(targ->img->vga, targ->img->dst_image);
        hthread_mutex_unlock(targ->img->output_mutex);
        hthread_yield();
    }

    return (void *)99;
}


void *input_thread(void *arg) {
    args_t *targ = (args_t *)arg;
    int count=0;

    while (1) {
        hthread_mutex_lock(targ->img->output_mutex);
        // Do nothing
        printf("INPUT THREAD, frame %d...\n", count++);
        //vgaoutput_show_frame(targ->img->vga, targ->img->dst_image);
        hthread_mutex_unlock(targ->img->output_mutex);
        hthread_yield();
        usleep(200);
    }

    return (void *)99;
}



int calc_pixel(complex_t c, int x, int y, framebuffer_t *dst) {
    int count=0, max_iter=0;
    float temp=0.0, lengthsq=0.0;

    complex_t z;

    max_iter = 200;
    z.real = 0.0;
    z.imag = 0.0;

    do {
        temp = z.real * z.real - z.imag * z.imag + c.real;
        z.imag = 2.0*z.real * z.imag + c.imag;
        z.real = temp;

        lengthsq = z.real * z.real + z.imag * z.imag;
        count++;
    } while ((lengthsq < 4.0) && (count < max_iter));

    if (count == max_iter) {
        framebuffer_set(dst, x, y, color_make(0, 0, 0, 255));
    }
    if (count > max_iter/25) {
        if (count < max_iter/7) {
            framebuffer_set(dst, x, y, color_make(200, 200, 200, 255));
        }
        else if (count < max_iter/6) {
            framebuffer_set(dst, x, y, color_make(15, 150, 150, 255));
        }
        else if (count < max_iter/5) {
            framebuffer_set(dst, x, y, color_make(100, 10, 100, 255));
        }
        else if (count < max_iter/4) {
            framebuffer_set(dst, x, y, color_make(5, 50, 50, 255));
        }
        else if (count < max_iter/3) {
            framebuffer_set(dst, x, y, color_make(25, 25, 2, 255));
        }
        else if (count < max_iter/2) {
            framebuffer_set(dst, x, y, color_make(10, 1, 10, 255));
        }
        else {
            framebuffer_set(dst, x, y, color_make(5, 5, 5, 255));
        }
    }
    else {
        framebuffer_set(dst, x, y, color_make(255, 255, 255, 255));
    }

    return count;
}



int32 framebuffer_invert(framebuffer_t *dst, framebuffer_t *src) {
    int32   x;
    int32   y;
    int32   r_inv;
    int32   g_inv;
    int32   b_inv;
    pixel_t t;

    if (dst->width != src->width)      return EINVAL;
    if (dst->height != src->height)    return EINVAL;

    // Invert image pixel by pixel
    for(y = 0; y < src->height; y++) {
        for(x = 0; x < src->width; x++) {
            // Grab a pixel and invert it
            t = framebuffer_get(src, x, y);
            r_inv = MAX_VALUE - color_red(t);
            g_inv = MAX_VALUE - color_green(t);
            b_inv = MAX_VALUE - color_blue(t);

            if( r_inv < 0 )         r_inv = 0;
            else if( r_inv > 255 )  r_inv = 255;

            if( g_inv < 0 )         g_inv = 0;
            else if( g_inv > 255 )  g_inv = 255;

            if( b_inv < 0 )         b_inv = 0;
            else if( b_inv > 255 )  b_inv = 255;

            // Write out inverted pixel
            framebuffer_set(dst, x, y, color_make(r_inv,g_inv,b_inv,255));
        }
    }

    return 0;
}


void usleep(int delay) {
    int x = delay;
    int y = 0;
    for (y = 0; y < delay; y++) {
        x = y + delay * x / (x + 3);
    } 
}


