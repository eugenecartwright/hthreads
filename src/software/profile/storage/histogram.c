#include <hthread.h>
#include <profile/storage/histogram.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <float.h>

Hint hprofile_histg_create( hprofile_hist_t *hist, hprofile_hist_info_t *info )
{
    Hulong i;

    // Allocate memory for all of the bins (two extra for under/over-flow)
    hist->data = (Hulong*)malloc( (info->bins+2)*sizeof(Hulong) );
    if( hist->data == NULL )    return ENOMEM;
    
    // Initialize all of the data bins
    for( i = 0; i < info->bins+2; i++ )   hist->data[i] = 0;

    // Initialize the rest of the structure
    hist->histogram = info->histogram;
    hist->output    = info->output;
    hist->bins      = info->bins;
    hist->samples   = 0;

    // Allocate space for the information
    hist->info = malloc( info->size );
    if( hist->info == NULL )    { free(hist->data); return ENOMEM; }

    // Copy the initialization data into the information structure
    memcpy( hist->info, info->init, info->size );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_histg_capture( hprofile_hist_t *hist, void* sample )
{
    Hint bin;

    // Delegate the the data interpreter's histogramming function
    bin = hist->histogram( hist->info, sample, hist->bins );
    if( bin < 0 )    return -bin;

    // Increment the number of samples taken
    hist->samples++;

    // Place the sample into the correct bin (skipping underflow bin)
    hist->data[bin]++;

    // Return successfully
    return SUCCESS;
}

Hint hprofile_histg_flush( hprofile_hist_t *hist, hprofile_output_t *out )
{
    Hulong  i;

    // Delegate the the data interpreter's output function

    // Print out the column headers
    out->olabel( "Low" ); out->ocolumn();
    out->olabel( "High" ); out->ocolumn();
    out->olabel( "Value" ); out->orow();

    // Print out all of the data bins
    for( i = 0; i < hist->bins+2; i++ )
    {
        hist->output( hist->info, i-1, hist->bins, hist->data[i], out );
    }

    // Return successfully
    return SUCCESS;
}

Hint hprofile_histg_close( hprofile_hist_t *hist )
{
    // Free the data bins
    free( hist->data );

    // Return successfully
    return SUCCESS;
}
