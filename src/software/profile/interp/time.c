#include <hthread.h>
#include <profile/interp/time.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/*****************************************************************************
 * Support for storing time data values in the averaging store.
 ****************************************************************************/
Hint hprofile_interp_time_avg_average(void *info, void* data, Hulong samples)
{
    Htime sample;
    Hdouble delta;
    hprofile_time_avg *avg;

    // Get the profile information
    avg = (hprofile_time_avg*)info;

    // Determine if this is the finish time or start time. If this is the
    // start time then just record the current time and exit. If this is
    // the finish time then grab the value and continue.
    if( data == NULL )      {hthread_time_get(&avg->time); return EINVAL;}
    else                    {sample = *((Htime*)data);}

    // Calculate the time difference
    hthread_time_diff( sample, sample, avg->time );
    
    // Get the time in nanoseconds
    Hdouble ns = hthread_time_nsec( sample );

    // Calculate the new average
    // See: http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
    delta = ns - avg->mean;
    avg->mean += delta/samples;
    avg->variance += delta*(ns - avg->mean);

    // Return successfully
    return SUCCESS;
}

Hint hprofile_interp_time_avg_output( void *info, Hulong samples, hprofile_output_t *out )
{
    hprofile_time_avg *avg;

    // Get the profile information
    avg = (hprofile_time_avg*)info;

    // Flush out the profile information
    out->oulong( samples ); out->ocolumn();
    out->odouble( avg->mean ); out->ocolumn();
    out->odouble( sqrt(avg->mean/(samples-1)) ); out->orow();

    // Return successfully
    return SUCCESS;
}

/*****************************************************************************
 * Support for storing time data values in the histogramming store.
 ****************************************************************************/
Hint hprofile_interp_time_hist_histogram(void *info, void *data, Hint bins)
{
    Hint    bin;
    Hdouble bwidth;
    Hdouble ns;
    Htime   sample;
    hprofile_time_hist *hist;

    // Get the histogram data from the info
    hist = (hprofile_time_hist*)info;

    // Get the sample from the input data
    if( data == NULL )      {hthread_time_get(&hist->time); return -EINVAL;}
    else                    {sample = *((Htime*)data);}

    // Calculate the time difference
    hthread_time_diff( sample, sample, hist->time );

    // Get the time in nanoseconds
    ns = hthread_time_nsec( sample );

    // Capture the minimum and maximum values
    if( ns < hist->smin )   hist->smin = ns;
    if( ns > hist->smax )   hist->smax = ns;

    // Calculate the width of the bins
    bwidth = (Hdouble)(hist->max - hist->min) / (Hdouble)bins;

    // Calculate the bin to place the sample into
    bin = (Hulong)floor((ns-hist->min) / bwidth) + 1;

    // Cap the bin to remain in the buffer
    if( bin < 0 )             bin = 0;
    else if( bin > bins+1 )   bin = bins+1;

    // Return the bin to place the data into
    return bin;
}

Hint hprofile_interp_time_hist_output(void *info, Hint bin, Hint bins, Hulong val, hprofile_output_t *out )
{
    Hdouble low;
    Hdouble high;
    hprofile_time_hist *hist;

    // Get the histogram data from the info
    hist = (hprofile_time_hist*)info;

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
 * Support for storing time data values in the buffering store.
 ****************************************************************************/
Hint hprofile_interp_time_buff_buffer( void *info, Hubyte *data, Hulong bytes, void *d, Hulong samples )
{
    Htime sample;
    Hdouble *ddata;
    Hdouble ns;
    hprofile_time_buff *buff;

    // Get the buffer data from the info
    buff = (hprofile_time_buff*)info;

    // Check if there is enough space in the buffer
    if( bytes < sizeof(Htime) )   return -ENOMEM;

    // Get the sample from the input data
    if( data == NULL )      {hthread_time_get( &buff->time ); return EINVAL;}
    else                    {sample = *((Htime*)d);}

    // Calculate the time difference
    hthread_time_diff( sample, sample, buff->time );

    // Get the time in nanoseconds
    ns = hthread_time_nsec( sample );
    
    // Determine if this is the minimum of maximum sample
    if( ns < buff->min )    buff->min = ns;
    if( ns > buff->max )    buff->max = ns;

    // Get a pointer to the data buffer
    ddata = (Hdouble*)data;

    // Store the data into the buffer
    *ddata = ns;

    // Return the number of bytes consumed
    return sizeof(Hdouble);
}

Hint hprofile_interp_time_buff_output( void *info, void *data, Hulong samples, hprofile_output_t *out )
{
    Hulong  i;
    Hdouble *ddata;
    hprofile_time_buff *buff;

    // Get the buffer data from the info
    buff = (hprofile_time_buff*)info;

    // Get a pointer to the data buffer
    ddata = (Hdouble*)data;

    // Output the histogram data
    out->olabel( "Samples" );
    out->oulong( samples );

    // Quit if there is nothing in the buffer
    if( samples <= 0 )  return SUCCESS;

    out->olabel( "Minimum Value" );
    out->oulong( buff->min );

    out->olabel( "Maximum Value" );
    out->oulong( buff->max );

    // Output the buffer
    out->olabel( "Data" );

    // Output the values
    out->odouble( ddata[0] );
    for( i = 1; i < samples; i++ )  { out->orow(); out->odouble(ddata[i]); }

    // Return successfully
    return SUCCESS;
}

