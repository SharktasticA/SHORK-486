#include "config.h"
#include "libshork.h"

const char *libshorkMessage(void)
{
#ifdef SHORK_GREETING
    return SHORK_GREETING;
#else
    return "Hello (config.h problem)";
#endif
}
