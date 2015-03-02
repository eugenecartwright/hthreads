#include <hthread.h>
#include <profile/interp/double.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/*****************************************************************************
 * Support for storing double data values in the averaging store.
 ****************************************************************************/
Hint hprofile_interp_double_avg_average(void *info, void* data, Hulong samples)
{
    Hdouble sample;
    Hdouble delta;
    hprofile_double_avg *avg;

    // Get the profile information
    avg = (hprofile_double_avg*)info;

    // Get the sample from the data
    sample = *((Hdouble*)data);

    // Calculate the new average
    // See: http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
    delta = sample - avg->mean;
    avg->mean += delta/samples;
    avg->variance += delta*(sample - avg->mean);

    // Return successfully
    return SUCCESS;
}

Hint hprofile_interp_double_avg_output( void *info, Hulong samples, hprofile_output_t *out )
{
    hprofile_double_avg *avg;

    // Get the profile information
    avg = (hprofile_double_avg*)info;

    // Flush out the profile information
    out->oulong( samples ); out->ocolumn();
    out->odouble( avg->mean ); out->ocolumn();
    out->odouble( sqrt(avg->mean/(samples-1)) ); out->orow();

    // Return successfully
    return SUCCESS;
}

/*****************************************************************************
 * Support for storing double data values in the histogramming store.
 ****************************************************************************/
Hint hprofile_interp_double_hist_histogram(void *info, void *data, Hint bins)
{
    Hint    bin;
    Hdouble bwidth;
    Hdouble sample;
    hprofile_double_hist *hist;

    // Get the histogram data from the info
    hist = (hprofile_double_hist*)info;

    // Get the sample from the input data
    sample = *((Hdouble*)data);

    // Capture the minimum and maximum values
    if( sample < hist->smin )   hist->smin = sample;
    if( sample > hist->smax )   hist->smax = sample;

    // Calculate the width of the bins
    bwidth = (hist->max - hist->min) / bins;

    // Calculate the bin to place the sample into
    bin = (Hulong)floor((sample-hist->min) / bwidth) + 1;

    // Cap the bin to remain in the buffer
    if( bin < 0 )             bin = 0;
    else if( bin > bins+1 )   bin = bins+1;

    // Return the bin to place the data into
    return bin;
}

Hint hprofile_interp_double_hist_output( void *info, Hint bin, Hint bins, Hulong val, hprofile_output_t *out )
{
    Hdouble low;
    Hdouble high;
    hprofile_double_hist *hist;

    // Get the histogram data from the info
    hist = (hprofile_double_hist*)info;

    // Output the underflow bucket
    if( bin < 0 )
    {
        out->ocolumn();
        out->olabel( "< " ); out->odouble( hist->min ); out->ocolumn();
        out->oulong( val ); out->orow();
        return SUCCESS;
    }

    // Output the overflow bucket
    if( bin >= bins )
    { 
        out->ocolumn();
        out->olabel( "> " ); out->odouble( hist->max ); out->ocolumn();
        out->oulong( val ); out->orow();
        return SUCCESS;
    }

    // Calculate the lower and upper bounds for this bin
    low  = (Hdouble)((hist->max - hist->min) * bin / bins) + hist->min; 
    high = low + (Hdouble)(hist->max-hist->min) / bins;

    // Output the data
    out->odouble( low ); out->ocolumn();
    out->odouble( high ); out->ocolumn();
    out->oulong( val ); out->orow();

    // Return successfully
    return SUCCESS;
}

/*****************************************************************************
 * Support for storing double data values in the buffering store.
 ****************************************************************************/
Hint hprofile_interp_double_buff_buffer( void *info, Hubyte *data, Hulong bytes, void *d, Hulong samples )
{
    Hdouble sample;
    Hdouble *ddata;
    hprofile_double_buff *buff;

    // Get the buffer data from the info
    buff = (hprofile_double_buff*)info;

    // Check if there is enough space in the buffer
    if( bytes < sizeof(Hdouble) )   return -ENOMEM;

    // Get the sample from the data
    sample = *((Hdouble*)d);

    // Determine if this is the minimum of maximum sample
    if( sample < buff->min )    buff->min = sample;
    if( sample > buff->max )    buff->max = sample;

    // Get a pointer to the data buffer
    ddata = (Hdouble*)data;

    // Store the data into the buffer
    *ddata = sample;

    // Return the number of bytes consumed
    return sizeof(Hdouble);
}

Hint hprofile_interp_double_buff_output( void *info, void *data, Hulong samples, hprofile_output_t *out )
{
    Hulong  i;
    Hdouble *ddata;
    hprofile_double_buff *buff;

    // Get the buffer data from the info
    buff = (hprofile_double_buff*)info;

    // Get a pointer to the data buffer
    ddata = (Hdouble*)data;

    // Output the histogram data
    out->olabel( "Samples" );
    out->oulong( samples );

    // Quit if there is nothing in the buffer
    if( samples <= 0 )  return SUCCESS;

    out->olabel( "Minimum Value" );
    out->odouble( buff->min );

    out->olabel( "Maximum Value" );
    out->odouble( buff->max );

    // Output the buffer
    out->olabel( "Data" );

    // Output the values
    out->odouble( ddata[0] );
    for( i = 1; i < samples; i++ )  { out->orow(); out->odouble(ddata[i]); }

    // Return successfully
    return SUCCESS;
}

