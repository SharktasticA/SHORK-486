/*
    ######################################################
    ## Minimal replacements for util-linux's mtab       ##
    ## locking, as required by fdmount.                 ##
    ######################################################
    ## This patch is a derivative work of fdutils. It   ##
    ## is licensed separately under the terms of the    ##
    ## GNU GPLv2 licence, and is distributed as part of ##
    ## the SHORK project. See the accompanying COPYING  ##
    ## file in this directory for details.              ##
    ######################################################
    ## Kali (links.sharktastica.co.uk)                  ##
    ######################################################
*/

#include <fcntl.h>
#include <sys/file.h>
#include <unistd.h>

static int mtab_lock_fd = -1;

void lock_mtab(void)
{
    mtab_lock_fd = open("/etc/mtab~", O_RDWR | O_CREAT, 0644);
    if (mtab_lock_fd >= 0)
        flock(mtab_lock_fd, LOCK_EX);
}

void unlock_mtab(void)
{
    if (mtab_lock_fd >= 0) {
        flock(mtab_lock_fd, LOCK_UN);
        close(mtab_lock_fd);
        mtab_lock_fd = -1;
    }
}
