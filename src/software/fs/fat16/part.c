/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Arkansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/
#include <fs/fat16/fat16.h>
#include <hendian.h>
#include <debug.h>

// A table of file system types
static const char *PART_TYPES[256] = {
/* 0x00 */    NULL,
/* 0x01 */    "DOS FAT12",
/* 0x02 */    "XENIX root",
/* 0x03 */    "XENIX /usr",
/* 0x04 */    "DOS 3.0+ FAT16",
/* 0x05 */    "DOS 3.3+ Extended",
/* 0x06 */    "DOS 3.31+ FAT16",
/* 0x07 */    "HPFS / NTFS / Advanced Unix / QNX2.x (pre-1988)",
/* 0x08 */    "OS/2 / AIX BOOT / SplitDrive / Commodore DOS / DELL /  QNX ('qny')",
/* 0x09 */    "AIX DATA / Coherent FS / QNZ ('qnz')",
/* 0x0A */    "OS/2 Boot Managear / Coherent Swap / OPUS",
/* 0x0B */    "WIN95 FAT32",
/* 0x0C */    "WIN95 FAT32, LBA-mapped",
/* 0x0D */    NULL,
/* 0x0E */    "WIN95 FAT16, LBA-mapped",
/* 0x0F */    "WIN95 Extended, LBA-mapped",
/* 0x10 */    "OPUS (?)",
/* 0x11 */    "DOS FAT12 Hidden",
/* 0x12 */    "Compaq Diagnostics",
/* 0x13 */    NULL,
/* 0x14 */    "DOS 3.0+ FAT16 Hidden / AST DOS",
/* 0x15 */    NULL,
/* 0x16 */    "DOS 3.31+ FAT16 Hidden",
/* 0x17 */    "HPFS Hidden",
/* 0x18 */    "AST SmartSleep",
/* 0x19 */    NULL,
/* 0x1A */    NULL,
/* 0x1B */    "WIN95 FAT32 Hidden",
/* 0x1C */    "WIN95 FAT32 Hidden, LBA-mapped",
/* 0x1D */    NULL,
/* 0x1E */    "WIN95 FAT16 Hidden, LBA-mapped",
/* 0x1F */    NULL,
/* 0x20 */    NULL,
/* 0x21 */    "Reserved",
/* 0x22 */    NULL,
/* 0x23 */    "Reserved",
/* 0x24 */    "NEC DOS 3.x",
/* 0x25 */    NULL,
/* 0x26 */    "Reserved",
/* 0x27 */    NULL,
/* 0x28 */    NULL,
/* 0x29 */    NULL,
/* 0x2A */    "AtheOS FS",
/* 0x2B */    "SyllableSecure",
/* 0x2C */    NULL,
/* 0x2D */    NULL,
/* 0x2E */    NULL,
/* 0x2F */    NULL,
/* 0x30 */    NULL,
/* 0x31 */    "Reserved",
/* 0x32 */    "NOS",
/* 0x33 */    "Reserved",
/* 0x34 */    "Reserved",
/* 0x35 */    "JFS on OS/2 / JFS on eCS",
/* 0x36 */    "Reserved",
/* 0x37 */    NULL,
/* 0x38 */    "THEOS 2GB",
/* 0x39 */    "Plan 9 / THEOS Spanned",
/* 0x3A */    "THEOS 4GB",
/* 0x3B */    "THEOS Extended",
/* 0x3C */    "PartitionMagic Recovery",
/* 0x3D */    "NetWare Hidden",
/* 0x3E */    NULL,
/* 0x3F */    NULL,
/* 0x40 */    "Venix 80286",
/* 0x41 */    "Linux / MINIX / RISC Boot / PPC PReP Boot",
/* 0x42 */    "Linux Swap / SFS / Windows 2000 Marker",
/* 0x43 */    "Linux Native",
/* 0x44 */    "GoBack",
/* 0x45 */    "Boot-US / Priam / EUMEL",
/* 0x46 */    "EUMEL/Elan",
/* 0x47 */    "EUMEL/Elan",
/* 0x48 */    "EUMEL/Elan",
/* 0x49 */    NULL,
/* 0x4A */    "AdaOS Aquila / ALFS",
/* 0x4B */    NULL,
/* 0x4C */    "Oberon",
/* 0x4D */    "QNX4.x",
/* 0x4E */    "QNX4.x 2nd",
/* 0x4F */    "QNX4.x 3rd / Oberon",
/* 0x50 */    "Lynx RTOS / Oberon Native / OnTrack Disk Manager RO",
/* 0x51 */    "Novell / OnTrack Disk Manager RW",
/* 0x52 */    "CP/M / SysV/AT",
/* 0x53 */    "Disk Manager 6.0",
/* 0x54 */    "Disk Manager 6.0 DDO",
/* 0x55 */    "EZ-Drive",
/* 0x56 */    "Golden Bow VFeature / DM -> EZ-BIOS",
/* 0x57 */    "DrivePro / VNDI",
/* 0x58 */    NULL,
/* 0x59 */    NULL,
/* 0x5A */    NULL,
/* 0x5B */    NULL,
/* 0x5C */    "Priam EDisk",
/* 0x5D */    NULL,
/* 0x5E */    NULL,
/* 0x5F */    NULL,
/* 0x60 */    NULL,
/* 0x61 */    "SpeedStor",
/* 0x62 */    NULL,
/* 0x63 */    "Unix System V / Mach / GNU Hurd",
/* 0x64 */    "PC-ARMOUR Protected / Novell Netware 286",
/* 0x65 */    "Novell Netware",
/* 0x66 */    "Novell Netware SMS",
/* 0x67 */    "Novell",
/* 0x68 */    "Novell",
/* 0x69 */    "Novell Netware 5+ / Novell Netware NSS",
/* 0x6A */    NULL,
/* 0x6B */    NULL,
/* 0x6C */    NULL,
/* 0x6D */    NULL,
/* 0x6E */    NULL,
/* 0x6F */    NULL,
/* 0x70 */    "DiskSecure Multi-Boot",
/* 0x71 */    "Reserved",
/* 0x72 */    NULL,
/* 0x73 */    "Reserved",
/* 0x74 */    "Scramdisk",
/* 0x75 */    "IBM PC/IX",
/* 0x76 */    "Reserved",
/* 0x77 */    "M2FS/M2CS / VNDI",
/* 0x78 */    "XOSL FS",
/* 0x79 */    NULL,
/* 0x7A */    NULL,
/* 0x7B */    NULL,
/* 0x7C */    NULL,
/* 0x7D */    NULL,
/* 0x7E */    NULL,
/* 0x7F */    NULL,
/* 0x80 */    "MINIX until 1.4a",
/* 0x81 */    "MINIX since 1.4b, early Linux / Mitac Disk Manager",
/* 0x82 */    "Linux Swap / Solaris x86 / Prime",
/* 0x83 */    "Linux Native",
/* 0x84 */    "OS/2 Hidden / Hibernation",
/* 0x85 */    "Linux Extended",
/* 0x86 */    "Linux RAID Superblock / FAT16 Volume Set",
/* 0x87 */    "NTFS volume set",
/* 0x88 */    "Linux Plaintext",
/* 0x89 */    NULL,
/* 0x8A */    "Linux Kernel",
/* 0x8B */    "Fault Tolerant FAT32",
/* 0x8C */    "Fault Tolerant FAT32, INT 13h",
/* 0x8D */    "FDISK Hidden DOS FAT12",
/* 0x8E */    "Linux Logical Volume Manager",
/* 0x8F */    NULL,
/* 0x90 */    "FDISK Hidden DOS FAT16",
/* 0x91 */    "FDISK Hidden DOS Extended",
/* 0x92 */    "FDISK Hidden DOS Large FAT16",
/* 0x93 */    "Amoeba / Linux Native Hidden",
/* 0x94 */    "Amoeba Bad Block",
/* 0x95 */    "MIT EXOPC native partitions",
/* 0x96 */    NULL,
/* 0x97 */    "FDISK Hidden DOS FAT32",
/* 0x98 */    "FDISK Hidden DOS FAT32, LBA-mapped / Datalight ROM-DOS",
/* 0x99 */    "DCE376",
/* 0x9A */    "FDISK Hidden DOS FAT16, LBA-mapped",
/* 0x9B */    "FDISK Hidden DOS Extended, LBA-mapped",
/* 0x9C */    NULL,
/* 0x9D */    NULL,
/* 0x9E */    NULL,
/* 0x9F */    "BSD/OS",
/* 0xA0 */    "Laptop Hibernation",
/* 0xA1 */    "HP Volume Expansion / Laptop Hibernation",
/* 0xA2 */    NULL,
/* 0xA3 */    "HP Volume Expansion",
/* 0xA4 */    "HP Volume Expansion",
/* 0xA5 */    "BSD/386, 386BSD, NetBSD, FreeBSD",
/* 0xA6 */    "OpenBSD",
/* 0xA7 */    "NEXTSTEP",
/* 0xA8 */    "Mac OS-X",
/* 0xA9 */    "NetBSD",
/* 0xAA */    "Olivetti Fat 12 1.44Mb Service Partition",
/* 0xAB */    "Mac OS-X Boot / GO!",
/* 0xAC */    NULL,
/* 0xAD */    NULL,
/* 0xAE */    "ShagOS",
/* 0xAF */    "ShagOS Swap",
/* 0xB0 */    "BootStar Dummy",
/* 0xB1 */    "HP Volume Expansion",
/* 0xB2 */    NULL,
/* 0xB3 */    "HP Volume Expansion",
/* 0xB4 */    "HP Volume Expansion",
/* 0xB5 */    NULL,
/* 0xB6 */    "HP Volume Expansion",
/* 0xB7 */    "BSDI BSD/386",
/* 0xB8 */    "BSDI BSD/386 Swap",
/* 0xB9 */    NULL,
/* 0xBA */    NULL,
/* 0xBB */    "Boot Wizard Hidden",
/* 0xBC */    NULL,
/* 0xBD */    NULL,
/* 0xBE */    "Solaris 8 Boot",
/* 0xBF */    "New Solaris x86",
/* 0xC0 */    "CTOS / REAL/32 Secure / NTFT / DRDOS",
/* 0xC1 */    "DRDOS Secured",
/* 0xC2 */    "Linux Hidden",
/* 0xC3 */    "Linux Swap Hidden",
/* 0xC4 */    "DRDOS/secured",
/* 0xC5 */    "DRDOS/secured",
/* 0xC6 */    "DRDOS/secured / Windows NT Corrupted FAT16",
/* 0xC7 */    "Syrinx Boot / Windows NT Corrupted NTFS",
/* 0xC8 */    "Reserved",
/* 0xC9 */    "Reserved",
/* 0xCA */    "Reserved",
/* 0xCB */    "DRDOS/secured FAT32",
/* 0xCC */    "DRDOS/secured FAT32, LBA-mapped",
/* 0xCD */    "CTOS Memdump",
/* 0xCE */    "DRDOS/secured FAT16, LBA-mapped",
/* 0xCF */    NULL,
/* 0xD0 */    "REAL/32 Secured / Multiuser DOS Secured",
/* 0xD1 */    "Old Multiuser DOS secured FAT12",
/* 0xD2 */    NULL,
/* 0xD3 */    NULL,
/* 0xD4 */    "Old Multiuser DOS secured FAT16 <32M",
/* 0xD5 */    "Old Multiuser DOS secured extended partition",
/* 0xD6 */    "Old Multiuser DOS secured FAT16 >=32M",
/* 0xD7 */    NULL,
/* 0xD8 */    "CP/M-86",
/* 0xD9 */    NULL,
/* 0xDA */    "Non-FS Data / Powercopy Backup",
/* 0xDB */    "CP/M / Concurrent DOS / CTOS / KDG SCPU",
/* 0xDC */    NULL,
/* 0xDD */    "CTOS Memdump Hidden",
/* 0xDE */    "Dell PowerEdge Server Utilities",
/* 0xDF */    "DG/UX Virtual Disk Manager / BootIt EMBRM",
/* 0xE0 */    "Reserved by STMicroelectronics for a filesystem called ST AVFS.",
/* 0xE1 */    "DOS access or SpeedStor 12-bit FAT extended partition",
/* 0xE2 */    NULL,
/* 0xE3 */    "DOS R/O or SpeedStor",
/* 0xE4 */    "SpeedStor 16-bit FAT extended partition < 1024 cyl.",
/* 0xE5 */    "Tandy DOS with logical sectored FAT  (According to Powerquest.)",
/* 0xE6 */    "Storage Dimensions",
/* 0xE7 */    NULL,
/* 0xE8 */    NULL,
/* 0xE9 */    NULL,
/* 0xEA */    NULL,
/* 0xEB */    "BeOS BFS",
/* 0xEC */    "SkyFS",
/* 0xED */    NULL,
/* 0xEE */    "EFI Header",
/* 0xEF */    "EFI",
/* 0xF0 */    "Linux/PA-RISC",
/* 0xF1 */    "SpeedStor",
/* 0xF2 */    "DOS 3.3+ Secondary",
/* 0xF3 */    "SpeedStor",
/* 0xF4 */    "SpeedStor Large / Prologue Single-Volume",
/* 0xF5 */    "Prologue Multi-Volume",
/* 0xF6 */    "SpeedStor",
/* 0xF7 */    NULL,
/* 0xF8 */    NULL,
/* 0xF9 */    "pCache"
/* 0xFA */    "Bochs",
/* 0xFB */    "VMware File System partition",
/* 0xFC */    "VMware Swap partition",
/* 0xFD */    "Linux RAID Persistent Superblock",
/* 0xFE */    "SpeedStor / LANstep / IBM PS/2 IML / Windows NT Hidden / Linux LVM",
/* 0xFF */    "Xenix Bad Block Table"
};

Hint fat16_part_readconvert( fat16_prt_t *part )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );
    TRACE_PRINTF( TRACE_FATAL, part == NULL, "NULL partition\n" );

    part->start_sector = little_to_bigs( part->start_sector );
    part->end_sector   = little_to_bigs( part->end_sector );
    part->offset       = little_to_bigl( part->offset );
    part->size         = little_to_bigl( part->size );

    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );

    // Return successfully
    return SUCCESS;
}

const char* fat16_part_typestr( Hubyte type )
{
    // Print out a trace message if configured
    TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "entering\n" );

    if( PART_TYPES[type] == NULL )
    {
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );
        return "Unknown";
    }
    else
    {
        TRACE_PRINTF( TRACE_FINE, FAT16_DEBUG, "exiting with success\n" );
        return PART_TYPES[type];
    }
}
