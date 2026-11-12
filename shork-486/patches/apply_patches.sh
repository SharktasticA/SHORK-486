#!/bin/bash

######################################################
## Clones the Linux kernel and applies all the      ##
## current SHORK-made patches to it, the commits    ##
## it, to provide a clean stage for me to           ##
## experiment with a new patch with.                ##
######################################################
## Kali (links.sharktastica.co.uk)                  ##
######################################################



set -e

PATCHES_DIR=$(pwd)

if [[ -d tmp/linux ]]; then
    cd tmp/linux
    git reset --hard v7.4-rc2
    git clean -fdx
else
    mkdir -p tmp
    cd tmp
    git clone --depth=1 --branch v7.4-rc2 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
    cd linux
fi

clear

patch -p1 < "${PATCHES_DIR}/linux/7.3.x/7.3.x_restore-387-586-elan-gx1-rdc321x-umc-winchip.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-M486-M486SX-ELAN.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-pcmcia-hosts.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-no-pci-devices.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-pc110pad.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.2.x/7.2.x_restore-isa-pcmcia-net.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.2.x/7.2.x_restore-arcnet-isa-pcmcia.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.2.x/7.2.x_restore-pcmcia-bt.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.2.x/7.2.x_restore-mdacon.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.2.x/7.2.x_restore-hgafb.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.3.x/7.3.x_restore-doubletalk-pc.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.3.x/7.3.x_restore-xircom-cardbus.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.4.x/7.4.x_fix-387-fpu-clone-sigfpe.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.4.x/7.4.x_restore-fpu-emu-hooks.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.4.x/7.4.x_restore-cr4-read-fault-handler.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.0.x/7.0.x_force-486-fpu-check.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.0.x/7.0.x_unsupported-486-586-msgs.patch"
patch -p1 < "${PATCHES_DIR}/linux/7.0.x/7.0.x_vga16fb-force-ega-fix.patch"

git add .
git commit -m "---"
