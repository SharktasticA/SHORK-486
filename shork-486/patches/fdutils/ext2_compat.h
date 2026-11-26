/*
    ######################################################
    ## Allows fdutils' fdmount to be compiled without   ##
    ## needing e2fsprogs or kernel ext2 headers to      ##
    ## provide ext2_super_block.                        ##
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

#ifndef FDUTILS_EXT2_COMPAT_H
#define FDUTILS_EXT2_COMPAT_H

#include <stdint.h>

#ifndef EXT2_SUPER_MAGIC
#define EXT2_SUPER_MAGIC 0xEF53
#endif

struct ext2_super_block {
    uint32_t s_inodes_count;
    uint32_t s_blocks_count;
    uint32_t s_r_blocks_count;
    uint32_t s_free_blocks_count;
    uint32_t s_free_inodes_count;
    uint32_t s_first_data_block;
    uint32_t s_log_block_size;
    uint32_t s_log_frag_size;
    uint32_t s_blocks_per_group;
    uint32_t s_frags_per_group;
    uint32_t s_inodes_per_group;
    uint32_t s_mtime;
    uint32_t s_wtime;
    uint16_t s_mnt_count;
    int16_t  s_max_mnt_count;
    uint16_t s_magic;
    // Remaining fields are unused by fdmount...
};

#endif
