#include <hthread.h>
#include <profile/storage/average.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

Hint hprofile_average_create(hprofile_average_t *avg,hprofile_average_info_t *i)
{
    // Store the info into the average profile
    avg->average = i->average;
    avg->output  = i->output;

    // Allocate space for the information
    avg->info    = malloc( i->size );
    if( avg->info == NULL ) return ENOMEM;

    // Copy over the initial data from the information
    memcpy( avg->info, i->init, i->size );

    // Initialize the number of samples taken
    avg->samples = 0;

    // Return successfully
    return SUCCESS;
}

Hint hprofile_average_capture( hprofile_average_t *avg, void *sample )
{
    Hint ret;

    // Delegate to the data interpreter's average function
    ret = avg->average( avg->info, sample, avg->samples+1 );
    if( ret == SUCCESS )    avg->samples++;

    // Return the status indicator
    return ret;
}

Hint hprofile_average_flush( hprofile_average_t *avg, hprofile_output_t *out )
{
    // Output the column headers
    out->olabel( "Samples" ); out->ocolumn();
    out->olabel( "Mean" ); out->ocolumn();
    out->olabel( "Standard Deviation" ); out->orow();

    // Delegate to the data interpreter's output function
    avg->output( avg->info, avg->samples, out );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_average_close( hprofile_average_t *avg )
{
    // Free the allocated information structure
    free( avg->info );

    // Return successfully
    return SUCCESS;
}
