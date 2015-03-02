#include <hthread.h>
#include <sysace/sysace.h>
#include <sysace/cf.h>
#include <sysace/cfg.h>
#include <fs/fat16/fat16.h>
#include <stdio.h>
#include <string.h>
#include <sleep.h>

const char* fat16_state( fat16_prt_t *part )
{
    switch( part->state )
    {
    case FAT16_PART_STATE_INACTIVE:     return "Inactive";
    case FAT16_PART_STATE_ACTIVE:       return "Active";
    default:                            return "Unknown";
    }
}

const char* fat16_type( fat16_prt_t *part )
{
    return fat16_part_typestr( part->type );
}

const char* fat16_sectors( fat16_prt_t *part )
{
    static char buffer[512];
    Hubyte  sh;
    Hubyte  eh;
    Hushort ss;
    Hushort es;

    sh = part->start_head;
    ss = part->start_sector;
    eh = part->end_head;
    es = part->end_sector;

    snprintf( buffer, 512, "(%d,%d) - (%d,%d)", sh, ss, eh, es );
    return buffer;
}

const char* fat16_size( fat16_prt_t *part )
{
    static char buffer[512];
    const char *units;
    Huint size;

    size = part->size * 512;

    units = "B";
    //if( size > 1024*1024*1024 )     { size /= 1024*1024*1024; units = "GB"; }
    //if( size > 1024*1024 )          { size /= 1024*1024; units = "MB"; }
    //if( size > 1024 )               { size /= 1024; units = "KB"; }

    snprintf( buffer, 512, "%u %s", size, units );
    return buffer;
}

const char* fat16_offset( fat16_prt_t *part )
{
    static char buffer[512];
    const char *units;
    Huint size;

    size = part->offset * 512;

    units = "B";
    //if( size > 1024*1024*1024 )     { size /= 1024*1024*1024; units = "GB"; }
    //if( size > 1024*1024 )          { size /= 1024*1024; units = "MB"; }
    //if( size > 1024 )               { size /= 1024; units = "KB"; }

    snprintf( buffer, 512, "%u %s", size, units );
    return buffer;
}

const char *fat16_boots_name( fat16_bts_t *boot )
{
    static char str[9];

    str[0] = boot->name[0];
    str[1] = boot->name[1];
    str[2] = boot->name[2];
    str[3] = boot->name[3];
    str[4] = boot->name[4];
    str[5] = boot->name[5];
    str[6] = boot->name[6];
    str[7] = boot->name[7];
    str[8] = 0;

    return str;
}

const char *fat16_boots_label( fat16_bts_t *boot )
{
    static char str[12];

    str[0] = boot->label[0];
    str[1] = boot->label[1];
    str[2] = boot->label[2];
    str[3] = boot->label[3];
    str[4] = boot->label[4];
    str[5] = boot->label[5];
    str[6] = boot->label[6];
    str[7] = boot->label[7];
    str[8] = boot->label[8];
    str[9] = boot->label[9];
    str[10] = boot->label[10];
    str[11] = 0;

    return str;
}

const char *fat16_boots_type( fat16_bts_t *boot )
{
    static char str[9];

    str[0] = boot->type[0];
    str[1] = boot->type[1];
    str[2] = boot->type[2];
    str[3] = boot->type[3];
    str[4] = boot->type[4];
    str[5] = boot->type[5];
    str[6] = boot->type[6];
    str[7] = boot->type[7];
    str[8] = 0;

    return str;
}
