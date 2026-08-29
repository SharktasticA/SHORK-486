#!/bin/bash

######################################################
## Clones the Linux kernel and applies all the      ##
## current SHORK-made patches to it, the commits    ##
## it, to provide a clean stage for me to           ##
## experiment with a new patch with.                ##
######################################################
## Kali (links.sharktastica.co.uk)                  ##
######################################################



PATCHES_DIR=$(pwd)

if [[ -d tmp/linux ]]; then
    cd tmp/linux
    git reset --hard v7.2
    git clean -fdx
else
    mkdir -p tmp
    cd tmp
    git clone --depth=1 --branch v7.2 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
    cd linux
fi

echo -e "${GREEN}Applying 7.2.x_restore-387-586-elan-gx1-rdc321x-umc-winchip...${RESET}"
patch -p1 < "${PATCHES_DIR}/linux/7.2.x/7.2.x_restore-387-586-elan-gx1-rdc321x-umc-winchip.patch"

echo -e "${GREEN}Applying 7.1.x_restore-M486-M486SX-ELAN patch...${RESET}"
patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-M486-M486SX-ELAN.patch"

echo -e "${GREEN}Applying 7.1.x_restore-pcmcia-hosts patch...${RESET}"
patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-pcmcia-hosts.patch"

echo -e "${GREEN}Applying 7.1.x_restore-no-pci-devices patch...${RESET}"
patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-no-pci-devices.patch"

echo -e "${GREEN}Applying 7.1.x_restore-pc110pad patch...${RESET}"
patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-pc110pad.patch"

echo -e "${GREEN}Applying 7.2.x_restore-isa-pcmcia-net patch...${RESET}"
patch -p1 < "${PATCHES_DIR}/linux/7.2.x/7.2.x_restore-isa-pcmcia-net.patch"

echo -e "${GREEN}Applying 7.2.x_restore-arcnet-isa-pcmcia patch...${RESET}"
patch -p1 < "${PATCHES_DIR}/linux/7.2.x/7.2.x_restore-arcnet-isa-pcmcia.patch"

git add .
git commit -m "---"
