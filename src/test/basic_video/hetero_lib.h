//#define USE_MB_THREAD

// The base addresses of the hardware thread we are creating
#define HWTI_BASEADDR0               (0xB0000000)
#define HWTI_BASEADDR1               (0xB0000100)
#define HWTI_BASEADDR2               (0xB0000200)
#define HWTI_BASEADDR3               (0xB0000300)
#define HWTI_BASEADDR4               (0xB0000400)
#define HWTI_BASEADDR5               (0xB0000500)
#define HWTI_BASEADDR6               (0xB0000600)
#define HWTI_BASEADDR7               (0xB0000700)
#define HWTI_BASEADDR8               (0xB0000800)
#define HWTI_BASEADDR9               (0xB0000900)

// Array of base addresses
#define NUM_CPUS        (10)
unsigned int base_array[NUM_CPUS] = {HWTI_BASEADDR0, HWTI_BASEADDR1, HWTI_BASEADDR2, HWTI_BASEADDR3, HWTI_BASEADDR4, HWTI_BASEADDR5, HWTI_BASEADDR6, HWTI_BASEADDR7, HWTI_BASEADDR8, HWTI_BASEADDR9};

// Heterogeneous sanity check.( FIXME: Put a num hetero CPU def inside of the config.h file for each platform, that way this number will be set automatically)
#define NUM_HETERO_CPUS (6)
int num_hetero_threads_sanity_check(int num_threads)
{
    if (num_threads > NUM_HETERO_CPUS)
    {
        printf("HETEROGENEOUS SANITY CHECK - There are only %d heterogeneous processors!\n",NUM_HETERO_CPUS);
        printf("  but the program is trying to simultaneously create %d hetero. threads!\n",num_threads);
        return -999;
    }
    else
    {
        return 0;
    }
}
