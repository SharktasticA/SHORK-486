/*
    ######################################################
    ## fp_mode_shim.c                                   ##
    ######################################################
    ## musl fenv.h-backed  __fe_getround and            ##
    ## __fe_raise_inexact for libsoftfp                 ##
    ######################################################
    ## Kali (links.sharktastica.co.uk)                  ##
    ######################################################
*/

#include <fenv.h>
int __fe_getround(void) { return fegetround(); }
void __fe_raise_inexact(void) { feraiseexcept(FE_INEXACT); }
