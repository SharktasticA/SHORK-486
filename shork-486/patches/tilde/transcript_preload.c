/*
    ######################################################
    ## Hand-written libltdl preload table for Tilde.    ##
    ## Since fully-static musl binaries cannot "dlopen" ##
    ## libtranscript's *.ltc codec plugins at runtime,  ##
    ## this table statically registers to ones SHORK    ##
    ## 486's Tilde build needs so libltdl can resolve   ##
    ## them from memory instead.                        ##
    ######################################################
    ## Licence: GNU GENERAL PUBLIC LICENSE Version 3    ##
    ######################################################
    ## Kali (links.sharktastica.co.uk)                  ##
    ######################################################
*/



#include <ltdl.h>



extern int transcript_get_iface_ascii(void);
extern int transcript_get_iface_iso885921999(void);
extern int transcript_get_iface_iso8859131998(void);
extern int transcript_get_iface_iso8859151999(void);
extern int transcript_get_iface_iso88591(void);
extern int transcript_get_iface_utf8(void);
extern void *transcript_get_table_iso885921999(void);
extern void *transcript_get_table_iso8859131998(void);
extern void *transcript_get_table_iso8859151999(void);
extern void *transcript_open_ascii(void);
extern void *transcript_open_iso88591(void);
extern void *transcript_open_utf8(void);

#define ASCII_ENTRIES \
    { "transcript_get_iface_ascii", (lt_ptr)transcript_get_iface_ascii }, \
    { "transcript_open_ascii", (lt_ptr)transcript_open_ascii },
#define ISO88591_ENTRIES \
    { "transcript_get_iface_iso88591", (lt_ptr)transcript_get_iface_iso88591 }, \
    { "transcript_open_iso88591", (lt_ptr)transcript_open_iso88591 },
#define LAT15_ENTRIES \
    { "transcript_get_iface_iso8859151999", (lt_ptr)transcript_get_iface_iso8859151999 }, \
    { "transcript_get_table_iso8859151999", (lt_ptr)transcript_get_table_iso8859151999 },
#define LAT2_ENTRIES \
    { "transcript_get_iface_iso885921999", (lt_ptr)transcript_get_iface_iso885921999 }, \
    { "transcript_get_table_iso885921999", (lt_ptr)transcript_get_table_iso885921999 },
#define LAT7_ENTRIES \
    { "transcript_get_iface_iso8859131998", (lt_ptr)transcript_get_iface_iso8859131998 }, \
    { "transcript_get_table_iso8859131998", (lt_ptr)transcript_get_table_iso8859131998 },
#define UTF8_ENTRIES \
    { "transcript_get_iface_utf8", (lt_ptr)transcript_get_iface_utf8 }, \
    { "transcript_open_utf8", (lt_ptr)transcript_open_utf8 },

const lt_dlsymlist lt_preloaded_symbols[] = {
    { "@PROGRAM@", (lt_ptr)0 },
    { "/usr/lib/transcript1/ascii.ltc", (lt_ptr)0 }, ASCII_ENTRIES
    { "/usr/lib/transcript1/iso88591.ltc", (lt_ptr)0 }, ISO88591_ENTRIES
    { "/usr/lib/transcript1/iso8859131998.ltc", (lt_ptr)0 }, LAT7_ENTRIES
    { "/usr/lib/transcript1/iso8859151999.ltc", (lt_ptr)0 }, LAT15_ENTRIES
    { "/usr/lib/transcript1/iso885921999.ltc", (lt_ptr)0 }, LAT2_ENTRIES
    { "/usr/lib/transcript1/utf8.ltc", (lt_ptr)0 }, UTF8_ENTRIES
    { (const char *)0, (lt_ptr)0 }
};
