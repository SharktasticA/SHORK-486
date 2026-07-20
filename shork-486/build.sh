#!/bin/bash

######################################################
## SHORK 486 build script                           ##
######################################################
## Kali (links.sharktastica.co.uk)                  ##
######################################################



START_TIME=$(date +%s)



set -e



# The highest working directory
CURR_DIR=$(pwd)



# TUI colour palette
RED='\033[0;31m'
LIGHT_RED='\033[0;91m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'



# A general confirmation prompt
confirm()
{
    while true; do
        read -p "$(echo -e ${YELLOW}Do you want to $1? [Yy/Nn]: ${RESET})" yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            *) echo -e "${RED}Please answer [Y/y] or [N/n]. Try again.${RESET}" ;;
        esac
    done
}



echo -e "${BLUE}========================"
echo -e "${BLUE}== SHORK build script =="
echo -e "${BLUE}========================${RESET}"



######################################################
## Global variables                                 ##
######################################################

# General global vars
BUILD_TYPE="default"
BOOTLDR_USED=""
DEFAULT_TARGET_DISK=80
DEFAULT_TARGET_SWAP=8
DISK_CYLINDERS=0
DISK_HEADS=16
DISK_SECTORS_TRACK=63
DONT_DEL_ROOT=false
DOTENV_USED=false
EST_MIN_RAM="16MiB"
EXCLUDED_BB_CMDS=()
EXCLUDED_FEATURES=""
INCLUDED_BB_CMDS=()
INCLUDED_FEATURES=""
MINIMAL_TARGET_DISK=8
ROOT_PART_SIZE=0
TOTAL_DISK_SIZE=0
USED_PARAMS=""
USED_WM="TWM"

# Branding
ARCH="$(cat ${CURR_DIR}/branding/ARCH | tr -d '\n')"
DIST="SHORK 486"
VER="$(cat ${CURR_DIR}/branding/VER | tr -d '\n')"
ID="shork-486"
URL="$(cat ${CURR_DIR}/branding/URL | tr -d '\n')"
HOSTNAME="$shork-486"

# Common compiler/compiler-related locations
CROSS="${ARCH}-linux-musl-cross"
PREFIX="${CURR_DIR}/build/${CROSS}"
AR="${PREFIX}/bin/${ARCH}-linux-musl-ar"
CC="${PREFIX}/bin/${ARCH}-linux-musl-gcc"
CC_STATIC="${CURR_DIR}/compilation/${ARCH}-linux-musl-gcc-static"
CXX="${PREFIX}/bin/${ARCH}-linux-musl-g++"
CXX_STATIC="${CURR_DIR}/compilation/${ARCH}-linux-musl-gxx-static"
DESTDIR="${CURR_DIR}/build/root"
HOST="${ARCH}-linux-musl"
LD="${PREFIX}/bin/${ARCH}-linux-musl-ld"
RANLIB="${PREFIX}/bin/${ARCH}-linux-musl-ranlib"
STRIP="${PREFIX}/bin/${ARCH}-linux-musl-strip"
SYSROOT="${PREFIX}/${ARCH}-linux-musl"

# Other common locations
CONFIGS_DIR="${CURR_DIR}/configs"
PATCHES_DIR="${CURR_DIR}/patches"

# Target software/feature versions
LINUX_STABLE_SRC="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
LINUX_TORVALDS_SRC="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
LINUX_VER="7.1.4"

BUSYBOX_SRC="https://busybox.net/downloads"
BUSYBOX_VER="1.38.0"

SHORKFETCH_SRC="https://github.com/SharktasticA/shorkfetch.git"
SHORKFETCH_VER="0.4.4"
SHORKMINES_SRC="https://github.com/SharktasticA/shorkmines.git"
SHORKMINES_VER=""

C3270_SRC="https://github.com/pmattes/x3270.git"
C3270_VER="4.5ga5"
CSCOPE_SRC="https://git.code.sf.net/p/cscope/cscope cscope-cscope"
CSCOPE_VER="15.9"
CTAGS_SRC="https://github.com/universal-ctags/ctags.git"
CTAGS_VER="p6.2.20260705.0"
CURL_SRC="https://curl.se/download"
CURL_VER="8.21.0"
DIALOG_SRC="https://invisible-mirror.net/archives/dialog"
DIALOG_VER="1.3-20260107"
DROPBEAR_SRC="https://github.com/mkj/dropbear.git"
DROPBEAR_VER="2026.92"
FILE_SRC="https://github.com/file/file.git"
FILE_VER="5_48"
GCC_SRC="https://more.musl.cc/11/i686-linux-musl"
GIT_SRC="https://github.com/git/git.git"
GIT_VER="2.55.0"
HTOP_SRC="https://github.com/htop-dev/htop.git"
HTOP_VER="3.5.1"
HWINFO_SRC="https://github.com/opensuse/hwinfo.git"
HWINFO_VER="25.4"
INDENT_SRC="https://ftp.gnu.org/gnu/indent"
INDENT_VER="2.2.13"
JOE_SRC="https://github.com/joe-editor/joe"
JOE_VER="4.8"
LIBAO_SRC="https://github.com/xiph/libao.git"
LIBAO_VER="1.2.2"
LIBEVENT_SRC="https://github.com/libevent/libevent.git"
LIBEVENT_VER="release-2.1.13-stable"
LIBID3TAG_SRC="https://github.com/markjeee/libid3tag.git"
LIBID3TAG_VER="7929736a334804dc5670b203c9129cac2708d31c"
LIBMAD_SRC="https://github.com/markjeee/libmad.git"
LIBMAD_VER="c2f96fa4166446ac99449bdf6905f4218fb7d6b5"
LIBT3_SRC="https://os.ghalkes.nl/dist"
LIBT3CONFIG_VER="1.0.0"
LIBT3HIGHLIGHT_VER="0.5.0"
LIBT3KEY_VER="0.2.11"
LIBT3WIDGET_VER="1.2.2"
LIBT3WINDOW_VER="0.4.2"
LIBTRANSCRIPT_VER="0.3.4"
LIBUNISTRING_SRC="https://ftp.gnu.org/gnu/libunistring"
LIBUNISTRING_VER="1.4.2"
LIBXLSXWRITER_SRC="https://github.com/jmcnamara/libxlsxwriter.git"
LIBXLSXWRITER_VER="1.2.4"
LIBXML2_SRC="https://github.com/gnome/libxml2.git"
LIBXML2_VER="2.15.3"
LIBZIP_SRC="https://github.com/nih-at/libzip.git"
LIBZIP_VER="1.11.4"
LYNX_SRC="https://github.com/ThomasDickey/lynx-snapshots.git"
LYNX_VER="2-9-3a"
MAKE_SRC="https://ftp.gnu.org/gnu/make"
MAKE_VER="4.4.1"
MG_SRC="https://github.com/troglobit/mg.git"
MG_VER="4.0"
MICROPYTHON_SRC="https://github.com/micropython/micropython.git"
MICROPYTHON_VER="1.28.0"
MPG321_SRC="https://github.com/GiterMirror/mpg321.git"
MPG321_VER="a41a9397d10576d3aee39c2ed7628a78c285714d"
MT_ST_SRC="https://github.com/iustin/mt-st.git"
MT_ST_VER="1.8"
MUSL_SRC="https://musl.libc.org/releases"
MUSL_VER="1.2.6"
NANO_SRC="https://www.nano-editor.org/dist"
NANO_DIST="v9"
NANO_VER="9.1"
NASM_SRC="https://github.com/netwide-assembler/nasm.git"
NASM_VER="3.02"
NCURSES_SRC="https://github.com/mirror/ncurses.git"
NCURSES_VER="6.4"
NEDIT_SRC="https://git.code.sf.net/p/nedit/git"
NEDIT_VER="NEDIT-CLASSIC-END"
OPENSSL_SRC="https://github.com/openssl/openssl.git"
OPENSSL_VER="3.6.3"
PCRE2_SRC="https://github.com/PCRE2Project/pcre2/releases/download"
PCRE2_VER="10.47"
SC_IM_SRC="https://github.com/andmarti1424/sc-im.git"
SC_IM_VER="0.8.5"
STRACE_SRC="https://github.com/strace/strace.git"
STRACE_VER="7.1"
TCC_SRC="https://github.com/Tiny-C-Compiler/tinycc-mirror-repository.git"
TCC_VER="e5eedc0"
TILDE_VER="1.1.3"
TMUX_SRC="https://github.com/tmux/tmux.git"
TMUX_VER="3.7b"
TN5250_SRC="https://github.com/tn5250/tn5250.git"
TN5250_VER="0.18.0"
TNFTP_SRC="https://ftp.netbsd.org/pub/NetBSD/misc/tnftp"
TNFTP_VER="20260211"
TWM_SRC="https://gitlab.freedesktop.org/xorg/app/twm.git"
TWM_VER="1.0.13.1"
UTIL_LINUX_SRC="https://github.com/util-linux/util-linux.git"
UTIL_LINUX_VER="2.42.2"
VIM_SRC="https://github.com/vim/vim.git"
VIM_VER="9.2.0785"
X86EMU_SRC="https://github.com/wfeldt/libx86emu.git"
X86EMU_VER="3.7"
ZLIB_SRC="https://github.com/madler/zlib.git"
ZLIB_VER="1.3.2"

# MBR binary
MBR_BIN=""

# Build parameters/arguments
ALWAYS_BUILD=false
FIX_EXTLINUX=false
IS_ARCH=false
IS_DEBIAN=false
IS_FEDORA=false
PHYSICAL_ALIGN=0x2000
PHYSICAL_START=""
ROOT_PASSWD=""
SCANCODE_SET=-1
SERIAL_CON_PORT="ttyS0"
SET_KEYMAP=""
SHORKUTILS_RECLONE=false
SKIP_BB=false
SKIP_KRN=false
TARGET_DISK=$DEFAULT_TARGET_DISK
TARGET_SWAP=$DEFAULT_TARGET_SWAP
TINY_KRN=false

ENABLE_CDROM=true
ENABLE_FB=true
ENABLE_HIGHMEM=false
ENABLE_MENU=true
ENABLE_NO_VDS032=true
ENABLE_MULTIUSER_KRN=false
ENABLE_MULTIUSER_REAL=false
ENABLE_NET_BASE=false
ENABLE_NET_ETH=false
ENABLE_NET_PCMCIA=false
ENABLE_PCMCIA=true
ENABLE_SATA=false
ENABLE_SCSI_EXP=true
ENABLE_SERIAL_CON=false
ENABLE_SMP=false
ENABLE_SOUND=false
ENABLE_TASKSTATS=false
ENABLE_USB=false
ENABLE_ZSWAP=true

INCLUDE_C3270=false
INCLUDE_CON_FONTS=true
INCLUDE_CSCOPE=false
INCLUDE_CTAGS=false
INCLUDE_DIALOG=true
INCLUDE_DROPBEAR=true
INCLUDE_FILE=true
INCLUDE_GCC=false
INCLUDE_GIT=true
INCLUDE_GUI=false
INCLUDE_HTOP=true
INCLUDE_HWINFO=false
INCLUDE_INDENT=false
INCLUDE_JOE=false
INCLUDE_KEYMAPS=true
INCLUDE_LYNX=true
INCLUDE_MAKE=false
INCLUDE_MG=true
INCLUDE_MICROPYTHON=true
INCLUDE_MPG321=false
INCLUDE_MT_ST=true
INCLUDE_NANO=true
INCLUDE_NASM=false
INCLUDE_PCI_IDS=true
INCLUDE_SC_IM=true
INCLUDE_SHORKSTALL=false
INCLUDE_SHORKTAINMENT=true
INCLUDE_STRACE=true
INCLUDE_TESTS=false
INCLUDE_TCC=true
INCLUDE_TILDE=false
INCLUDE_TMUX=true
INCLUDE_TN5250=false
INCLUDE_TNFTP=true
INCLUDE_UTIL_LINUX=true
INCLUDE_VIM=false

USE_GRUB=false

while [ $# -gt 0 ]; do
    USED_PARAMS+="\n $1"
    case "$1" in
        --always-build)
            ALWAYS_BUILD=true
            ;;
        --enable-tests)
            INCLUDE_TESTS=true
            ;;
        --is-arch)
            IS_ARCH=true
            IS_DEBIAN=false
            IS_FEDORA=false
            ;;
        --is-debian)
            IS_ARCH=false
            IS_DEBIAN=true
            IS_FEDORA=false
            ;;
        --is-fedora)
            IS_ARCH=false
            IS_DEBIAN=false
            IS_FEDORA=true
            ;;
        --shorkutils-reclone)
            SHORKUTILS_RECLONE=true
            ;;
        --skip-busybox)
            SKIP_BB=true
            DONT_DEL_ROOT=true
            ;;
        --skip-kernel)
            SKIP_KRN=true
            DONT_DEL_ROOT=true
            ;;
        --tiny)
            TINY_KRN=true
            ;;
    esac
    shift
done

# Import build configuration if config.sh was used
if [[ -f .env ]]; then
    DOTENV_USED=true
    source .env
fi

# If in Docker, make sure that the target distro is Debian
if [ -n "$IN_DOCKER" ] && [ "$IS_DEBIAN" = false ]; then
    IS_ARCH=false
    IS_DEBIAN=true
    IS_FEDORA=false
fi



######################################################
## Overrides                                        ##
######################################################

# Overrides to ensure the correct estimated RAM requirement is shown in the after-build report
if [ "$ID" == "shork-486" ]; then
    if [ "$BUILD_TYPE" = "custom" ]; then
        echo -e "${GREEN}Noting minimum RAM requirement for a SHORK 486 custom build...${RESET}"
        if [ "$INCLUDE_GCC" = true ]; then
            EST_MIN_RAM="24MiB + 8MiB swap/16MiB + 16MiB swap"
        elif [ "$INCLUDE_GUI" = true ] || [ "$ENABLE_HIGHMEM" = true ] || [ "$ENABLE_SATA" = true ]; then
            EST_MIN_RAM="24MiB/16MiB + 8MiB swap"
        elif [ "$ENABLE_NET_ETH" = true ]; then
            EST_MIN_RAM="16MiB"
        else
            EST_MIN_RAM="12MiB"
        fi
    elif [ "$BUILD_TYPE" = "maximal" ]; then
        echo -e "${GREEN}Noting minimum RAM requirement for a SHORK 486 maximal build...${RESET}"
        EST_MIN_RAM="32MiB/24MiB + 8MiB swap"
    elif [ "$BUILD_TYPE" = "plus" ]; then
        echo -e "${GREEN}Noting minimum RAM requirement for a SHORK 486 plus build...${RESET}"
        EST_MIN_RAM="24MiB + 8MiB swap/16MiB + 16MiB swap"
    elif [ "$BUILD_TYPE" = "offline" ]; then
        echo -e "${GREEN}Noting minimum RAM requirement for a SHORK 486 offline build...${RESET}"
        EST_MIN_RAM="12MiB"
    elif [ "$BUILD_TYPE" = "minimal" ]; then
        echo -e "${GREEN}Noting minimum RAM requirement for a SHORK 486 minimal build...${RESET}"
        EST_MIN_RAM="8MiB"
    fi
elif [ "$ID" == "shork-disc" ]; then
    echo -e "${GREEN}Noting minimum RAM requirement for a SHORK DISC build...${RESET}"
    EST_MIN_RAM="8MiB"
elif [ "$ID" == "shork-diskette" ]; then
    echo -e "${GREEN}Noting minimum RAM requirement for a SHORK DISKETTE build...${RESET}"
    EST_MIN_RAM="16MiB"
fi

# Override to ensure the USED_WM is empty when the "use GUI" parameter is not used
if ! $INCLUDE_GUI; then
    USED_WM=""
else
    # If USED_WM is empty but GUI is desired, ensure the default WM (TWM) is set
    if [[ $USED_WM == "" ]]; then
        USED_WM="TWM"
    fi
fi

# Networking-related overrides
if [ "$ENABLE_NET_ETH" = true ]; then
    # Ensure PCMCIA networking support is enabled if general PCMCIA support is also enabled
    if [ "$ENABLE_PCMCIA" = true ]; then
        ENABLE_NET_PCMCIA=true
    fi
else
    # If networking support is disabled, make sure networking-based programs and features are also disabled
    ENABLE_NET_PCMCIA=false
    INCLUDE_DROPBEAR=false
    INCLUDE_GIT=false
    INCLUDE_TNFTP=false
fi

# Ensure MULTIUSER_KRN is enabled with MULTIUSER_REAL
if [ "$ENABLE_MULTIUSER_REAL" = true ]; then
    ENABLE_MULTIUSER_KRN=true
fi

# Ensure USE_GRUB is disabled with FIX_EXTLINUX
if [ "$FIX_EXTLINUX" = true ]; then
    USE_GRUB=false
fi

# Ensure MULTIUSER_KRN and TASKSTATS are enabled with HTOP
if [ "$INCLUDE_HTOP" = true ]; then
    ENABLE_MULTIUSER_KRN=true
    ENABLE_TASKSTATS=true
fi

# Ensure NET_BASE is enabled with HTOP, TMUX or NET_ETH
if [ "$INCLUDE_HTOP" = true ] || [ "$INCLUDE_TMUX" = true ] || [ "$ENABLE_NET_ETH" = true ]; then
    ENABLE_NET_BASE=true
fi

# Ensure SOUND is enabled with MPG321
if [ "$INCLUDE_MPG321" = true ]; then
    ENABLE_SOUND=true
fi

# Ensure SCSI_EXT is enabled with MT_ST
if [ "$INCLUDE_MT_ST" = true ]; then
    ENABLE_SCSI_EXP=true
fi



######################################################
## Input validation & parameter conflict checks     ##
######################################################

# Convert physical start MiB to hex
if [ -n "$PHYSICAL_START" ]; then
    if [[ "$PHYSICAL_START" != 0x* ]]; then
        BYTES=$(echo "$PHYSICAL_START * 1048576" | bc)
        BYTES=${BYTES%.*}
    else
        BYTES=$((PHYSICAL_START))
    fi
    CLEAN_ALIGN=${PHYSICAL_ALIGN#0x}
    ALIGN_DEC=$((16#$CLEAN_ALIGN))
    PHYSICAL_START=$(((BYTES + ALIGN_DEC - 1) / ALIGN_DEC * ALIGN_DEC))
    PHYSICAL_START=$(printf "0x%X" "$PHYSICAL_START")
fi

# Target disk integer check
if [ -n "$TARGET_DISK" ] && [ "$TARGET_DISK" -ne 0 ]; then
    TARGET_DISK="$(echo "$TARGET_DISK" | tr -d '[:space:]')"
    if ! [[ "$TARGET_DISK" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}ERROR: the target disk value must be an integer (whole number)${RESET}"
        exit 1
    fi
    TARGET_DISK=$((TARGET_DISK))
else
    TARGET_DISK=$DEFAULT_TARGET_DISK
fi

# Target swap integer and range check
if [ -n "$TARGET_SWAP" ] || [ "$TARGET_SWAP" -ne 0 ]; then
    TARGET_SWAP="$(echo "$TARGET_SWAP" | tr -d '[:space:]')"
    if ! [[ "$TARGET_SWAP" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}ERROR: the target swap value must be an integer (whole number)${RESET}"
        exit 1
    fi
    if [ "$TARGET_SWAP" -lt 0 ]; then
        echo -e "${RED}ERROR: the target swap value must more than 0${RESET}"
        exit 1
    fi
    TARGET_SWAP=$((TARGET_SWAP))
else
    TARGET_SWAP=$DEFAULT_TARGET_SWAP
fi

# Set keymap existence check
if [ -n "$SET_KEYMAP" ]; then
    if [ ! -f "$CURR_DIR/sysfiles/keymaps/$SET_KEYMAP.kmap.bin" ]; then
        echo -e "${RED}ERROR: the set keymap value does not match a known included keymap${RESET}"
        exit 1
    fi
fi



# Check what other prerequisites we need
NEED_CURL=false
NEED_OPENSSL=false
NEED_LIBAO=false
NEED_LIBEVENT=false
NEED_LIBID3TAG=false
NEED_LIBMAD=false
NEED_LIBUUID=false
NEED_LIBXLSXWRITER=false
NEED_LIBXML2=false
NEED_LIBZIP=false
NEED_X86EMU=false
NEED_ZLIB=false

if $ENABLE_FB; then
    NEED_X86EMU=true
fi

if $INCLUDE_CTAGS; then
    NEED_LIBXML2=true
fi

if $INCLUDE_GIT; then
    NEED_CURL=true
    NEED_OPENSSL=true
    NEED_ZLIB=true
fi

if $INCLUDE_HWINFO; then
    NEED_LIBUUID=true
    NEED_X86EMU=true
fi

if $INCLUDE_LYNX; then
    NEED_OPENSSL=true
fi

if $INCLUDE_MPG321; then
    NEED_ZLIB=true
    NEED_LIBID3TAG=true
    NEED_LIBMAD=true
    NEED_LIBAO=true
fi

if $INCLUDE_SC_IM; then
    NEED_LIBXLSXWRITER=true
    NEED_LIBXML2=true
    NEED_LIBZIP=true
fi

if $INCLUDE_TMUX; then
    NEED_LIBEVENT=true
fi

if [ -n "$USED_WM" ]; then
    NEED_ZLIB=true
fi



# Use commit ID-based versioning is VER is not numeric 
if [[ ! "$VER" =~ [0-9] ]]; then
    if [ -n "$IN_DOCKER" ]; then
        git config --global --add safe.directory "/var/shork-486"
    fi
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        COMMIT=$(git rev-parse --short=7 HEAD)
        VER="$VER $COMMIT"
    fi
fi



######################################################
## House keeping                                    ##
######################################################

# Deletes build directory
delete_root_dir()
{
    if [ -n "$CURR_DIR" ] && [ -d $DESTDIR ]; then
        echo -e "${GREEN}Deleting existing ${DIST} root directory to ensure fresh changes can be made...${RESET}"
        sudo rm -rf $DESTDIR
    fi
}

# Fixes directory and file permissions after root build
fix_perms()
{
    echo -e "${GREEN}Tidying up and fixing directory and file permissions...${RESET}"

    HOST_GID=${HOST_GID:-1000}
    HOST_UID=${HOST_UID:-1000}

    sudo chown -R "$HOST_UID:$HOST_GID" $CURR_DIR/build || true
    sudo chmod 755 $CURR_DIR/build || true

    sudo chown -R "$HOST_UID:$HOST_GID" $CURR_DIR/images || true
    sudo chmod 755 $CURR_DIR/images || true

    for f in "$CURR_DIR/images/"*; do
        [ -f "$f" ] || continue
        sudo chown "$HOST_UID:$HOST_GID" "$f"
        sudo chmod 644 "$f"
    done

    sudo chown -R "$HOST_UID:$HOST_GID" $CURR_DIR/__pycache__ || true
    sudo chmod 755 $CURR_DIR/__pycache__ || true
}

# Cleans up any stale mounts and block-device mappings left by image builds
clean_stale_mounts()
{
    echo -e "${GREEN}Cleaning up any stale mounts and block-device mappings left by image builds...${RESET}"
    sudo umount -lf /mnt/$ID 2>/dev/null || true
    sudo losetup -a | grep $ID | cut -d: -f1 | xargs -r sudo losetup -d || true
    sudo dmsetup remove_all 2>/dev/null || true
}



######################################################
## Copy functions                                   ##
######################################################

# Copies a config file to a destination and makes sure any @CC@, @CC_STATIC@,
# @AR@ or @STRIP@ placeholders are replaced
copy_config()
{
    # Input parameters
    SRC="$1"
    DST="$2"

    # Ensure source exists
    [ -f "$SRC" ] || return 1

    # Copy file
    sudo cp "$SRC" "$DST"

    # Replace all placeholders with their respective values
    sudo sed -i -e "s|@CC@|$CC|g" -e "s|@CC_STATIC@|$CC_STATIC|g" -e "s|@AR@|$AR|g" -e "s|@STRIP@|$STRIP|g" "$DST"
}

# Copies a sysfile to a destination and makes sure any @DIST@, @VER@, @ID@,
# @HOSTNAME@ or @URL@ placeholders are replaced
copy_sysfile()
{
    # Input parameters
    SRC="$1"
    DST="$2"

    # Ensure source exists
    [ -f "$SRC" ] || return 1

    # Copy file
    sudo cp "$SRC" "$DST"

    # Replace all placeholders with their respective values
    sudo sed -i -e "s|@DIST@|$DIST|g" -e "s|@VER@|$VER|g" -e "s|@ID@|$ID|g" -e "s|@HOSTNAME@|$HOSTNAME|g" -e "s|@URL@|$URL|g" "$DST"
}



######################################################
## Host environment prerequisites                   ##
######################################################

install_arch_prerequisites()
{
    echo -e "${GREEN}Installing prerequisite packages for an Arch-based system...${RESET}"

    PACKAGES="autoconf bc base-devel bison bzip2 ca-certificates cdrtools cpio dosfstools e2fsprogs flex gettext git libtool make multipath-tools ncurses pciutils python qemu-img systemd texinfo util-linux wget xz"

    if $INCLUDE_GUI; then
        PACKAGES+=" fontconfig gperf unzip xorg-bdftopcf xorg-font-util xorg-mkfontscale"
    fi

    if $INCLUDE_MICROPYTHON; then
        PACKAGES+=" libffi"
    fi

    if $INCLUDE_SC_IM; then
        PACKAGES+=" cmake"
    fi

    if $INCLUDE_TMUX; then
        PACKAGES+=" pkgconf"
    fi

    if $FIX_EXTLINUX; then
        PACKAGES+=" nasm"
    fi

    if $USE_GRUB; then
        PACKAGES+=" grub"
    else
        PACKAGES+=" syslinux"
    fi

    sudo pacman -Syu --noconfirm --needed $PACKAGES
}

install_debian_prerequisites()
{
    echo -e "${GREEN}Installing prerequisite packages for a Debian-based system...${RESET}"
    sudo dpkg --add-architecture i386
    sudo apt-get update

    PACKAGES="autopoint bc bison bzip2 e2fsprogs extlinux fdisk flex genisoimage git kpartx libtool libtool-bin make pkg-config python3 python-is-python3 qemu-utils wget xz-utils"

    if $INCLUDE_GUI; then
        PACKAGES+=" fontconfig gettext gperf unzip xfonts-utils"
    fi

    if $INCLUDE_GIT; then
        PACKAGES+=" autoconf"
    fi

    if $INCLUDE_MICROPYTHON; then
        PACKAGES+=" libffi-dev"
    fi

    if $INCLUDE_NANO; then
        PACKAGES+=" texinfo"
    fi

    if $INCLUDE_PCI_IDS; then
        PACKAGES+=" pciutils"
    fi

    if $INCLUDE_SC_IM; then
        PACKAGES+=" cmake"
    fi

    if $FIX_EXTLINUX; then
        PACKAGES+=" nasm uuid-dev"
    fi

    if $USE_GRUB; then
        PACKAGES+=" grub-common grub-pc"
    else
        PACKAGES+=" isolinux syslinux"
    fi

    sudo apt-get install -y $PACKAGES

    export PATH="$PATH:/usr/sbin:/sbin"
}

install_fedora_prerequisites()
{
    echo -e "${GREEN}Installing prerequisite packages for a Fedora-based system...${RESET}"
    sudo dnf -y update

    PACKAGES="autoconf automake bison dialog docbook2pdf docbook2X flex gcc genisoimage gettext git libtool make patch perl python3 qemu-img"

    if $INCLUDE_GUI; then
        PACKAGES+=" bdftopcf fontconfig gperf mkfontscale xorg-x11-font-utils"
    fi

    if $INCLUDE_MICROPYTHON; then
        PACKAGES+=" libffi-devel"
    fi

    if $INCLUDE_NANO; then
        PACKAGES+=" texinfo"
    fi

    if $INCLUDE_PCI_IDS; then
        PACKAGES+=" pciutils"
    fi

    if $INCLUDE_SC_IM; then
        PACKAGES+=" byacc cmake"
    fi

    if $FIX_EXTLINUX; then
        PACKAGES+=" libuuid-devel nasm"
    fi

    if $USE_GRUB; then
        PACKAGES+=" grub2-common grub2-pc"
    else
        PACKAGES+=" syslinux-extlinux syslinux-nonlinux"
    fi

    sudo dnf install -y $PACKAGES || true
}

# Installs needed packages to host computer
get_prerequisites()
{
    if [ -z "$IN_DOCKER" ]; then
        if $IS_ARCH; then
            install_arch_prerequisites
        elif $IS_DEBIAN; then
            install_debian_prerequisites
        elif $IS_FEDORA; then
            install_fedora_prerequisites
        else
            echo -e "${YELLOW}Select host Linux distribution:${RESET}"
            select host in "Arch based" "Debian based" "Fedora based"; do
                case $host in
                    "Arch based")
                        install_arch_prerequisites
                        break ;;
                    "Debian based")
                        install_debian_prerequisites
                        break ;;
                    "Fedora based")
                        install_fedora_prerequisites
                        break ;;
                    *)
                esac
            done
        fi
    else
        # Skip if inside Docker as Dockerfile already installs prerequisites
        echo -e "${LIGHT_RED}Running inside Docker, skipping installing prerequisite packages...${RESET}"
    fi
}



######################################################
## Compiled software toolchains & prerequisites     ##
######################################################

# Download and extract the required GCC+musl cross-compiler
get_musl_cross()
{
    cd "$CURR_DIR/build"

    echo -e "${GREEN}Downloading ${CROSS}...${RESET}"
    [ -f "${CROSS}.tgz" ] || wget "https://musl.cc/${CROSS}.tgz"
    [ -d "${CROSS}" ] || tar xvf "${CROSS}.tgz"
}

# Download and compile ncurses (required for c3270, htop, Lynx, nano, sc-im, tic,
# tmux, tn5250 and util-linux)
get_ncurses()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "${PREFIX}/lib/libncursesw.a" ]; then
        echo -e "${LIGHT_RED}ncurses already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d ncurses ]; then
        echo -e "${YELLOW}ncurses source already present, resetting...${RESET}"
        git config --global --add safe.directory $CURR_DIR/build/ncurses
        cd ncurses
        git reset --hard
    else
        echo -e "${GREEN}Downloading ncurses...${RESET}"
        git clone --branch v${NCURSES_VER} $NCURSES_SRC
        cd ncurses
    fi

    # Compile and install
    echo -e "${GREEN}Compiling ncurses...${RESET}"
    ./configure \
        --host=${HOST} \
        --build=$(./config.guess) \
        --prefix="${PREFIX}" \
        --with-normal \
        --without-shared \
        --without-debug \
        --without-cxx \
        --enable-widec \
        CC="${CC_STATIC}" \
        CFLAGS="-fPIC" \
        CPPFLAGS="-D_XOPEN_SOURCE=600"
    make -j$(nproc)
    make install

    ln -sf "${PREFIX}/include/ncursesw/curses.h" "${PREFIX}/include/curses.h"
    ln -sf "${PREFIX}/include/ncursesw/ncurses.h" "${PREFIX}/include/ncurses.h"
    ln -sf "${PREFIX}/include/ncursesw/panel.h" "${PREFIX}/include/panel.h"
    ln -sf "${PREFIX}/include/ncursesw/menu.h" "${PREFIX}/include/menu.h"
    ln -sf "${PREFIX}/include/ncursesw/form.h" "${PREFIX}/include/form.h"
    ln -sf "${PREFIX}/include/ncursesw/term.h" "${PREFIX}/include/term.h"

    ln -sf "${PREFIX}/lib/libncursesw.a" "${PREFIX}/lib/libncurses.a"
    ln -sf "${PREFIX}/lib/libncursesw.a" "${PREFIX}/lib/libtinfo.a"
    ln -sf "${PREFIX}/lib/libncursesw.a" "${PREFIX}/lib/libcurses.a"
}

# Download and compile tic (required for shorkset)
get_tic()
{
    cd "$CURR_DIR/build/ncurses"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/tic" ]; then
        echo -e "${LIGHT_RED}tic already compiled, skipping...${RESET}"
        return
    fi

    # Compile and install
    echo -e "${GREEN}Compiling tic...${RESET}"
    ./configure \
        --host="${HOST}" \
        --prefix=/usr \
        --with-normal \
        --without-shared \
        --without-debug \
        --without-cxx \
        --enable-widec \
        CC="${CC}" \
        CFLAGS="-Os -static"
    make -C progs tic -j$(nproc)
    sudo install -D progs/tic "$DESTDIR/usr/bin/tic"
}

# Download and compile curl (required for Git/HTTPS remote)
get_curl()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$SYSROOT/lib/libcurl.a" ]; then
        echo -e "${LIGHT_RED}curl already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading curl...${RESET}"
    
    CURL="curl-${CURL_VER}"
    CURL_ARC="${CURL}.tar.xz"
    CURL_URI="${CURL_SRC}/${CURL_ARC}"

    # Download source
    [ -f $CURL_ARC ] || wget $CURL_URI

    # Extract source
    if [ -d $CURL ]; then
        echo -e "${YELLOW}curl's source archive is already present, re-extracting before proceeding...${RESET}"
        sudo rm -rf $CURL
    fi
    tar xf $CURL_ARC
    cd $CURL

    # Compile and install
    echo -e "${GREEN}Compiling curl...${RESET}"
    CPPFLAGS="-I$SYSROOT/include" \
    LDFLAGS="-L$SYSROOT/lib -static" \
    LIBS="-lssl -lcrypto -lpthread -ldl -latomic" \
    CC="${CC}" \
    CFLAGS="-Os -march=${ARCH} -static" \
    ./configure --build="$(gcc -dumpmachine)" --host="${HOST}" --prefix="$SYSROOT" --with-openssl="$SYSROOT" --without-libpsl --disable-shared
    make -j$(nproc)
    make install
}

# Download and compile libao (required for mpg321) 
get_libao()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$SYSROOT/usr/lib/libao.a" ]; then
        echo -e "${LIGHT_RED}libao already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d libao ]; then
        echo -e "${YELLOW}libao source already present, resetting...${RESET}"
        cd libao
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading libao...${RESET}"
        git clone $LIBAO_SRC
        cd libao
        git checkout $LIBAO_VER
    fi

    # Compile and install
    echo -e "${GREEN}Compiling libao...${RESET}"
    ./autogen.sh
    ./configure \
        --host=$HOST \
        --build=x86_64-linux-gnu \
        --prefix=/usr \
        --disable-shared \
        --enable-static \
        --disable-alsa \
        --disable-esd \
        --disable-arts \
        --disable-pulse \
        AR=$AR \
        CC=$CC \
        RANLIB=$RANLIB \
        CPPFLAGS="-I$SYSROOT/usr/include" \
        CFLAGS="-fPIC" \
        LDFLAGS="-L$SYSROOT/usr/lib"
    make -j$(nproc)
    make DESTDIR=$SYSROOT install

    # FOLLOWING NO LONGER NEEDED SINCE MPG321 PATCHES OUT REAL LIBAO USAGE
    #sudo mkdir -p $DESTDIR/lib
    #sudo mkdir -p $DESTDIR/usr/lib/ao/plugins-4/
    #sudo cp $SYSROOT/lib/libc.so $DESTDIR/lib/
    #sudo cp $SYSROOT/usr/lib/libao.so* $DESTDIR/usr/lib/
    #sudo cp $SYSROOT/usr/lib/ao/plugins-4/liboss.so $DESTDIR/usr/lib/ao/plugins-4/
    #sudo ln -sf libc.so $DESTDIR/lib/ld-musl-i386.so.1
}

# Download and compile libevent (required for tmux)
get_libevent()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "${PREFIX}/lib/libevent.a" ]; then
        echo -e "${LIGHT_RED}libevent already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d libevent ]; then
        echo -e "${YELLOW}libevent source already present, resetting...${RESET}"
        cd libevent
        git reset --hard
    else
        echo -e "${GREEN}Downloading libevent...${RESET}"
        git clone --branch ${LIBEVENT_VER} $LIBEVENT_SRC
        cd libevent
    fi

    # Compile and install
    echo -e "${GREEN}Compiling libevent...${RESET}"
    ./autogen.sh
    ./configure --host=${HOST} --prefix="${PREFIX}" --disable-shared  --enable-static --disable-samples --disable-openssl CC="${CC}"
    make -j$(nproc)
    make install
}

# Download and compile libmad (required for mpg321) 
get_libmad()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$SYSROOT/usr/lib/libmad.a" ]; then
        echo -e "${LIGHT_RED}libmad already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d libmad ]; then
        echo -e "${YELLOW}libmad source already present, resetting...${RESET}"
        cd libmad
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading libmad...${RESET}"
        git clone $LIBMAD_SRC libmad
        cd libmad
        git checkout $LIBMAD_VER
    fi

    # Its config.sub is too old to recognise musl
    cp "${CURR_DIR}/compilation/config.guess" config.guess
    cp "${CURR_DIR}/compilation/config.sub" config.sub

    local CFLAGS="-static -O2 -march=i486 -mtune=i486 -fomit-frame-pointer -I$SYSROOT/usr/include"

    # Compile and install
    echo -e "${GREEN}Compiling libmad...${RESET}"
    ./configure \
        --host=$HOST \
        --prefix=/usr \
        --enable-static \
        --disable-shared \
        AR=$AR \
        CC=$CC_STATIC \
        RANLIB=$RANLIB \
        CFLAGS="${CFLAGS}" \
        LDFLAGS="-static -L$SYSROOT/usr/lib"
    make CFLAGS="${CFLAGS}" -j$(nproc)
    make DESTDIR=$SYSROOT install
}

# Download and compile util-linux for libuuid (required for hwinfo)
get_libuuid()
{
    mkdir -p "$CURR_DIR/build/libuuid"
    cd "$CURR_DIR/build/libuuid"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/lscpu" ] &&
       [ -f "$DESTDIR/usr/bin/partx" ] &&
       [ -f "$DESTDIR/usr/sbin/sfdisk" ] &&
       [ -f "$DESTDIR/usr/bin/whereis" ]; then
        echo -e "${LIGHT_RED}util-linux for libuuid already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d util-linux ]; then
        echo -e "${YELLOW}util-linux for libuuid source already present, resetting...${RESET}"
        cd util-linux
        git config --global --add safe.directory $CURR_DIR/build/libuuid/util-linux
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading util-linux for libuuid...${RESET}"
        git clone --depth=1 --branch v$UTIL_LINUX_VER $UTIL_LINUX_SRC
        cd util-linux
    fi

    # Compile and install
    echo -e "${GREEN}Compiling util-linux for libuuid...${RESET}"
    ./autogen.sh
    ./configure \
        --host=${HOST} \
        --prefix=/usr \
        --disable-all-programs \
        --enable-libuuid \
        CC="${CC_STATIC}" \
        CFLAGS="-Os -march=${ARCH} -I${PREFIX}/include" \
        CPPFLAGS="-I${PREFIX}/include" \
        LDFLAGS="-L${PREFIX}/lib -static" \
        PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig"
    make TINFO_LIBS="" -j$(nproc)
    make DESTDIR=$SYSROOT install
}

# Download and compile libid3tag (required for mpg321) 
get_libid3tag()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$SYSROOT/usr/lib/libid3tag.a" ]; then
        echo -e "${LIGHT_RED}libid3tag already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d libid3tag ]; then
        echo -e "${YELLOW}libid3tag source already present, resetting...${RESET}"
        cd libid3tag
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading libid3tag...${RESET}"
        git clone $LIBID3TAG_SRC libid3tag
        cd libid3tag
        git checkout $LIBID3TAG_VER
    fi

    # Its config.sub is too old to recognise musl
    cp "${CURR_DIR}/compilation/config.guess" config.guess
    cp "${CURR_DIR}/compilation/config.sub" config.sub

    # Compile and install
    echo -e "${GREEN}Compiling libid3tag...${RESET}"
    ./configure \
        --host=$HOST \
        --prefix=/usr \
        --enable-static \
        --disable-shared \
        AR=$AR \
        CC=$CC_STATIC \
        RANLIB=$RANLIB \
        CFLAGS="-static -I$SYSROOT/usr/include" \
        LDFLAGS="-static -L$SYSROOT/usr/lib"

    make -j$(nproc)
    make DESTDIR=$SYSROOT install
}

# Download and compile libxlsxwriter (required for sc-im)
get_libxlsxwriter()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "${PREFIX}/lib/libxlsxwriter.a" ]; then
        echo -e "${LIGHT_RED}libxlsxwriter already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d libxlsxwriter ]; then
        echo -e "${YELLOW}libxlsxwriter source already present, resetting...${RESET}"
        git config --global --add safe.directory "$CURR_DIR/build/libxlsxwriter"
        cd libxlsxwriter
        git reset --hard
    else
        echo -e "${GREEN}Downloading libxlsxwriter...${RESET}"
        git clone --branch v${LIBXLSXWRITER_VER} $LIBXLSXWRITER_SRC
        cd libxlsxwriter
    fi

    # Compile and install
    echo -e "${GREEN}Compiling libxlsxwriter...${RESET}"
    make \
        CC="$CC_STATIC" \
        AR="$AR" \
        RANLIB="$RANLIB" \
        CFLAGS="-static -O2 -I$PREFIX/include -I$SYSROOT/usr/include" \
        LDFLAGS="-static -L$PREFIX/lib -L$SYSROOT/usr/lib" \
        MINIZIP=1 \
        -j$(nproc)
    cp -r include/* "$PREFIX/include/"
    cp src/libxlsxwriter.a "$PREFIX/lib/"
}

# Download and compile libxml2 (required for ctags and sc-im)
get_libxml2()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "${PREFIX}/lib/libxml2.a" ]; then
        echo -e "${LIGHT_RED}libxml2 already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d libxml2 ]; then
        echo -e "${YELLOW}libxml2 source already present, resetting...${RESET}"
        cd libxml2
        git reset --hard
    else
        echo -e "${GREEN}Downloading libxml2...${RESET}"
        git clone --branch v${LIBXML2_VER} $LIBXML2_SRC
        cd libxml2
    fi

    # Compile and install
    echo -e "${GREEN}Compiling libxml2...${RESET}"
    ./autogen.sh
    ./configure \
        --host=${HOST} \
        --prefix="${PREFIX}" \
        --disable-shared \
        --enable-static \
        CC="${CC_STATIC}"
    make -j$(nproc)
    make install
}

# Download and compile libzip (required for sc-im)
get_libzip()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$PREFIX/lib/libzip.a" ]; then
        echo -e "${LIGHT_RED}libzip already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d libzip ]; then
        echo -e "${YELLOW}libzip source already present, resetting...${RESET}"
        cd libzip
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading libzip...${RESET}"
        git clone --branch v${LIBZIP_VER} $LIBZIP_SRC
        cd libzip
    fi

    # Compile and install
    echo -e "${GREEN}Compiling libzip...${RESET}"
    cmake -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        -DCMAKE_C_COMPILER="$CC_STATIC" \
        -DCMAKE_SYSTEM_NAME=Linux \
        -DCMAKE_SYSTEM_PROCESSOR=${ARCH} \
        -DBUILD_SHARED_LIBS=OFF \
        -DENABLE_GNUTLS=OFF \
        -DENABLE_MBEDTLS=OFF \
        -DENABLE_OPENSSL=OFF \
        -DENABLE_ZSTD=OFF \
        -DENABLE_BZIP2=OFF \
        -DENABLE_LZMA=OFF \
        -DZLIB_LIBRARY="$PREFIX/lib/libz.a" \
        -DZLIB_INCLUDE_DIR="$PREFIX/include" \
        -DBUILD_TOOLS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_DOC=OFF \
        -DBUILD_REGRESS=OFF \
        -DBUILD_FUZZERS=OFF
    make zip -j$(nproc)
    cp lib/libzip.a "${PREFIX}/lib/"
    cp zipconf.h "${PREFIX}/include/"
    cp lib/zip.h "${PREFIX}/include/"
}

# Download and compile OpenSSL (required for curl, Lynx, Git/HTTPS remote and
# tn5250)
get_openssl()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$SYSROOT/lib/libssl.a" ]; then
        echo -e "${LIGHT_RED}OpenSSL already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d openssl ]; then
        echo -e "${YELLOW}OpenSSL source already present, resetting...${RESET}"
        git config --global --add safe.directory $CURR_DIR/build/openssl
        cd openssl
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading OpenSSL...${RESET}"
        git clone --branch openssl-${OPENSSL_VER} $OPENSSL_SRC
        cd openssl
    fi

    # Compile and install
    echo -e "${GREEN}Compiling OpenSSL...${RESET}"
    ./Configure linux-generic32 no-shared no-tests no-dso no-engine \
        --prefix="$SYSROOT" --openssldir=/etc/ssl \
        CC="${CC} -latomic" \
        AR="${AR}" \
        RANLIB="${RANLIB}"
    make -j$(nproc)
    make install_sw
}

# Download and compile zlib (required for Git, libzip and TWM)
get_zlib()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$SYSROOT/usr/lib/libz.a" ]; then
        echo -e "${LIGHT_RED}zlib already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d zlib ]; then
        echo -e "${YELLOW}zlib source already present, resetting...${RESET}"
        git config --global --add safe.directory $CURR_DIR/build/zlib
        cd zlib
        git reset --hard
    else
        echo -e "${GREEN}Downloading zlib...${RESET}"
        git clone --branch v${ZLIB_VER} $ZLIB_SRC
        cd zlib
    fi

    echo -e "${GREEN}Compiling zlib...${RESET}"
    CC="$CC_STATIC" \
    CFLAGS="-Os -march=${ARCH} -static --sysroot=$SYSROOT" \
    ./configure  --static --prefix=/usr
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

# Download and compile x86emu (required for SHORKSET's VBE resolution detection)
get_x86emu()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$SYSROOT/usr/lib/libx86emu.a" ]; then
        echo -e "${LIGHT_RED}x86emu already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d libx86emu ]; then
        echo -e "${YELLOW}x86emu source already present, resetting...${RESET}"
        git config --global --add safe.directory $CURR_DIR/build/libx86emu
        cd libx86emu
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading x86emu...${RESET}"
        git clone --branch $X86EMU_VER $X86EMU_SRC
        cd libx86emu
    fi

    echo -e "${GREEN}Compiling x86emu...${RESET}"
    for f in *.c; do
        "$CC_STATIC" -c -Os -march=${ARCH} -static --sysroot=$SYSROOT -I include -o "${f%.c}.o" "$f"
    done
    "$AR" rcs libx86emu.a *.o
    "$RANLIB" libx86emu.a
    install -D -m644 libx86emu.a "$SYSROOT/usr/lib/libx86emu.a"
    install -D -m644 include/x86emu.h "$SYSROOT/usr/include/x86emu.h"
}

# Download and build our forked ISOLINUX/EXTLINUX/SYSLINUX (required if "Fix
# ISOLINUX/EXTLINUX/SYSLINUX" was used)
get_patched_xlinux()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$CURR_DIR/build/syslinux/bios/extlinux/extlinux" ]; then
        echo -e "${LIGHT_RED}ISOLINUX/EXTLINUX/SYSLINUX already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d syslinux ]; then
        echo -e "${YELLOW}ISOLINUX/EXTLINUX/SYSLINUX source already present, resetting...${RESET}"
        cd syslinux
        git reset --hard
        make clean || true
    else
        echo -e "${GREEN}Downloading ISOLINUX/EXTLINUX/SYSLINUX...${RESET}"
        git clone https://github.com/SharktasticA/syslinux.git
        cd syslinux
    fi

    # Patches for fixing "x.bin: too big (y > z)" issues
    sudo sed -i 's/\$maxsize = \$padsize = 440;/\$maxsize = \$padsize = 500;/' mbr/checksize.pl
    sudo sed -i 's/\$maxsize = \$padsize = 432;/\$maxsize = \$padsize = 500;/' mbr/checksize.pl
    sudo sed -i 's/\$maxsize = \$padsize = 439;/\$maxsize = \$padsize = 500;/' mbr/checksize.pl

    # Fedora 44+ seems to need this specific patch...
    if $IS_FEDORA; then
        sudo sed -i 's/-pie//g' core/Makefile
    fi

    # Compile and install
    echo -e "${GREEN}Compiling ISOLINUX/EXTLINUX/SYSLINUX...${RESET}"
    CFLAGS="-fcommon" sudo make bios
}



######################################################
## BusyBox & core utilities building                ##
######################################################

# Used to merge a BusyBox config fragment into .config
merge_busybox_frag()
{
    frag="$1"
    while IFS= read -r line; do
        case "$line" in
            CONFIG_*=y)
                # Replace "# ... is not set"
                name="${line%%=*}"
                sed -i "s/^# $name is not set/$name=y/" .config

                # If doesn't exist, let's append it
                if ! grep -q "^$name=" .config && ! grep -q "^# $name is not set" .config; then
                    echo "$name=y" >> .config
                fi
                ;;
        esac
    done < "$frag"
}

# Download and compile BusyBox
get_busybox()
{
    cd "$CURR_DIR/build"

    BUSYBOX="busybox-${BUSYBOX_VER}"
    BUSYBOX_ARC="${BUSYBOX}.tar.bz2"
    BUSYBOX_URI="${BUSYBOX_SRC}/${BUSYBOX_ARC}"

    # Download source
    echo -e "${GREEN}Downloading BusyBox...${RESET}"
    [ -f $BUSYBOX_ARC ] || wget $BUSYBOX_URI

    # Extract source
    if [ -d $BUSYBOX ]; then
        echo -e "${YELLOW}BusyBox's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $BUSYBOX
    fi
    tar -xjf $BUSYBOX_ARC
    cd $BUSYBOX

    # Patch to fix error with running menuconfig
    sed -i 's/main() {}/int main() {}/' scripts/kconfig/lxdialog/check-lxdialog.sh

    # Patch BusyBox's eject and volname to default to /dev/sr0 not /dev/cdrom
    sed -i 's|"/dev/cdrom"|"/dev/sr0"|' util-linux/eject.c
    sed -i 's|"/dev/cdrom"|"/dev/sr0"|' miscutils/volname.c

    # Patch login timeout to 0
    sed -i 's/getenv("LOGIN_TIMEOUT") ? : "60"/getenv("LOGIN_TIMEOUT") ? : "0"/' loginutils/login.c

    echo -e "${GREEN}Copying base ${DIST} BusyBox .config file...${RESET}"
    if [ "$ID" == "shork-486" ]; then
        cp $CONFIGS_DIR/busybox/busybox.config.base .config
    elif [ "$ID" == "shork-disc" ]; then
        cp $CONFIGS_DIR/busybox/busybox.config.base.disc .config
    elif [ "$ID" == "shork-diskette" ]; then
        cp $CONFIGS_DIR/busybox/busybox.config.base.diskette .config
    fi

    # Ensure BusyBox behaves with our toolchain
    sed -i "s|^CONFIG_CROSS_COMPILER_PREFIX=.*|CONFIG_CROSS_COMPILER_PREFIX=\"${PREFIX}/bin/${ARCH}-linux-musl-\"|" .config
    sed -i "s|^CONFIG_SYSROOT=.*|CONFIG_SYSROOT=\"${CURR_DIR}/build/${ARCH}-linux-musl-cross\"|" .config
    sed -i "s|^CONFIG_EXTRA_CFLAGS=.*|CONFIG_EXTRA_CFLAGS=\"-no-pie -fno-pie -march=i486 -mtune=i486 -I${PREFIX}/include\"|" .config
    sed -i "s|^CONFIG_EXTRA_LDFLAGS=.*|CONFIG_EXTRA_LDFLAGS=\"-no-pie -static -L${PREFIX}/lib\"|" .config

    # Patch in swap partition identification in lsblk implementation
    echo -e "${GREEN}Applying 1.38.0_lsblk_swap patch...${RESET}"
    patch -p1 < "${PATCHES_DIR}/busybox/1.38.0_lsblk_swap.patch"

    if $ENABLE_MULTIUSER_REAL; then
        echo -e "${GREEN}Enabling BusyBox's multi-user utilities...${RESET}"
        merge_busybox_frag "$CONFIGS_DIR/busybox/busybox.config.multiuser.frag"
        
        echo -e "${GREEN}Applying 1.37.0-1.38.0_musl_utmp patch...${RESET}"
        patch -p1 < "${PATCHES_DIR}/busybox/1.37.0-1.38.0_musl_utmp.patch"
    fi
    
    if $ENABLE_NET_ETH; then
        echo -e "${GREEN}Enabling BusyBox's networking utilities...${RESET}"
        merge_busybox_frag "$CONFIGS_DIR/busybox/busybox.config.net.frag"
    fi

    if $ENABLE_USB; then
        echo -e "${GREEN}Enabling BusyBox's USB-related utilities...${RESET}"
        merge_busybox_frag "$CONFIGS_DIR/busybox/busybox.config.usb.frag"
        yes | make oldconfig
    fi

    if $INCLUDE_GCC; then
        echo -e "${GREEN}Disabling BusyBox's ar and strings implementations in favour of GNU Bintuils'...${RESET}"
        sed -i 's/^CONFIG_AR=y$/# CONFIG_AR is not set/' .config
        sed -i 's/^CONFIG_FEATURE_AR_LONG_FILENAMES=y$/# CONFIG_FEATURE_AR_LONG_FILENAMES is not set/' .config
        sed -i 's/^CONFIG_FEATURE_AR_CREATE=y$/# CONFIG_FEATURE_AR_CREATE is not set/' .config
        sed -i 's/^CONFIG_STRINGS=y$/# CONFIG_STRINGS is not set/' .config
    fi

    # Compile and install
    echo -e "${GREEN}Compiling BusyBox...${RESET}"
    make ARCH=x86 -j$(nproc)
    make ARCH=x86 install

    echo -e "${GREEN}Installing BusyBox as the basis of our root file system...${RESET}"
    if [ -d $DESTDIR ]; then
        sudo rm -r $DESTDIR
    fi
    mv _install $DESTDIR
}

# Download and compile strace
get_strace()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/strace" ]; then
        echo -e "${LIGHT_RED}strace already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d strace ]; then
        echo -e "${YELLOW}strace source already present, resetting...${RESET}"
        cd strace
        git config --global --add safe.directory $CURR_DIR/build/strace
        git reset --hard
    else
        echo -e "${GREEN}Downloading strace...${RESET}"
        git clone --branch v$STRACE_VER $STRACE_SRC
        cd strace
    fi

    # Compile and install
    echo -e "${GREEN}Compiling strace...${RESET}"
    ./bootstrap
    ./configure --host=${HOST} --prefix=/usr --disable-shared --enable-static CC="${CC_STATIC}" CFLAGS="-Os -march=${ARCH}" LDFLAGS="-static"
    make -j$(nproc)
    make install DESTDIR="$DESTDIR"
}

# Download and compile util-linux (lscpu, partx, sfdisk and whereis)
get_util_linux()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/lscpu" ] &&
       [ -f "$DESTDIR/usr/bin/partx" ] &&
       [ -f "$DESTDIR/usr/sbin/sfdisk" ] &&
       [ -f "$DESTDIR/usr/bin/whereis" ]; then
        echo -e "${LIGHT_RED}lscpu, partx, sfdisk and whereis from util-linux already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d util-linux ]; then
        echo -e "${YELLOW}util-linux source already present, resetting...${RESET}"
        cd util-linux
        git config --global --add safe.directory $CURR_DIR/build/util-linux
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading util-linux...${RESET}"
        git clone --depth=1 --branch v$UTIL_LINUX_VER $UTIL_LINUX_SRC
        cd util-linux
    fi

    # Compile and install
    echo -e "${GREEN}Compiling util-linux for lscpu, partx, sfdisk and whereis...${RESET}"

    # In case "cannot find -ltinfo" error 
    export ac_cv_search_tigetstr='-lncursesw'
    export ac_cv_lib_tinfo_tigetstr='no'
    export LIBS="-lncursesw"

    ./autogen.sh
    ./configure \
        --host=${HOST} \
        --prefix=/usr \
        --disable-all-programs \
        --enable-fdisks \
        --enable-lsblk \
        --enable-partx \
        --enable-whereis \
        --enable-lscpu \
        --enable-libblkid \
        --enable-libfdisk \
        --enable-libmount \
        --enable-libsmartcols \
        --enable-libuuid \
        --disable-shared \
        --enable-static \
        --without-python \
        --without-tinfo \
        --disable-nls \
        --disable-widechar \
        CC="${CC_STATIC}" \
        CFLAGS="-Os -march=${ARCH} -I${PREFIX}/include" \
        CPPFLAGS="-I${PREFIX}/include" \
        LDFLAGS="-L${PREFIX}/lib -static" \
        PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig"

    # In case "cannot find -ltinfo" error 
    for mf in Makefile libfdisk/Makefile disk-utils/Makefile misc-utils/Makefile libmount/Makefile libsmartcols/Makefile libuuid/Makefile libblkid/Makefile
    do
        [ -f "$mf" ] || continue
        sed -i 's/-ltinfo//g' "$mf"
        sed -i 's/^TINFO_LIBS *=.*/TINFO_LIBS = /' "$mf"
    done
   
    make TINFO_LIBS="" -j$(nproc)

    for bin in lscpu partx whereis; do
        sudo install -D -m 755 "${bin}" "$DESTDIR/usr/bin/${bin}"
    done
    for bin in sfdisk; do
        sudo install -D -m 755 "${bin}" "$DESTDIR/usr/sbin/${bin}"
    done

    # Fix potential linking issues with ncurses
    unset LIBS
    unset CFLAGS
    unset CPPFLAGS
    unset LDFLAGS
}



######################################################
## Kernel building                                  ##
######################################################

download_kernel()
{
    cd "$CURR_DIR/build"
    echo -e "${GREEN}Downloading the Linux kernel...${RESET}"

    local LINUX_SRC="$LINUX_STABLE_SRC"
    if [[ "$LINUX_VER" == *-rc* ]]; then
        LINUX_SRC="$LINUX_TORVALDS_SRC"
    fi

    if [ ! -d "linux" ]; then
        git clone --depth=1 --branch "v$LINUX_VER" "$LINUX_SRC" || true
        cd "$CURR_DIR/build/linux"
        configure_kernel
    fi
}

configure_kernel()
{
    echo -e "${GREEN}Copying base ${DIST} kernel configuration file...${RESET}"

    if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
        if ! $TINY_KRN; then
            cp $CONFIGS_DIR/linux/linux.config.base .config
        else
            cp $CONFIGS_DIR/linux/linux.config.base.tiny .config
        fi
    elif [ "$ID" == "shork-diskette" ]; then
        cp $CONFIGS_DIR/linux/linux.config.base.diskette .config
    fi

    FRAGS=""

    if $ENABLE_CDROM; then
        echo -e "${GREEN}Enabling kernel-level CD-ROM & DVD-ROM support...${RESET}"
        if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
            FRAGS+="$CONFIGS_DIR/linux/linux.config.cdrom.frag "
        elif [ "$ID" == "shork-diskette" ]; then
            FRAGS+="$CONFIGS_DIR/linux/linux.config.cdrom.diskette.frag "
        fi
    fi
    
    if $ENABLE_FB; then
        echo -e "${GREEN}Enabling kernel-level framebuffer, VESA & enhanced VGA support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.fb.frag "
    fi

    if $INCLUDE_GUI; then
        echo -e "${GREEN}Enabling kernel-level event interface support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.x11.frag "
    fi

    if $ENABLE_HIGHMEM; then
        echo -e "${GREEN}Enabling kernel-level high memory support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.highmem.frag "
    fi

    if $ENABLE_MULTIUSER_KRN; then
        echo -e "${GREEN}Enabling kernel-level multi-user support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.multiuser.frag "
    fi

    if $ENABLE_PCMCIA; then
        echo -e "${GREEN}Enabling kernel-level PCMCIA support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.pcmcia.frag "
    fi

    if $ENABLE_NET_BASE; then
        echo -e "${GREEN}Enabling kernel-level networking support (base)...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.net.base.frag "
    fi

    if $ENABLE_NET_ETH; then
        echo -e "${GREEN}Enabling kernel-level networking support (ethernet)...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.net.eth.frag "
    fi

    if $ENABLE_NET_PCMCIA; then
        echo -e "${GREEN}Enabling kernel-level networking support (PCMCIA)...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.net.pcmcia.frag "
    fi

    if $ENABLE_SATA; then
        echo -e "${GREEN}Enabling kernel-level SATA support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.sata.frag "
    fi

    if $ENABLE_SCSI_EXP; then
        echo -e "${GREEN}Enabling kernel-level SCSI media changer & tape drive support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.scsi.exp.frag "
    fi

    if $ENABLE_SMP; then
        echo -e "${GREEN}Enabling kernel-level symmetric multiprocessing (SMP) support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.smp.frag "
    fi

    if $ENABLE_SOUND; then
        echo -e "${GREEN}Enabling kernel-level sound support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.sound.frag "
    fi

    if $ENABLE_TASKSTATS; then
        echo -e "${GREEN}Enabling kernel-level taskstats support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.taskstats.frag "
    fi

    if $ENABLE_USB; then
        echo -e "${GREEN}Enabling kernel-level USB & HID support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.usb.frag "
    fi

    if $ENABLE_ZSWAP; then
        echo -e "${GREEN}Enabling kernel-level zswap support...${RESET}"
        FRAGS+="$CONFIGS_DIR/linux/linux.config.zswap.frag "
    fi

    if [ -n "$PHYSICAL_START" ]; then
        echo -e "${GREEN}Setting custom Linux kernel physical address start...${RESET}"
        sed -i "s/CONFIG_PHYSICAL_START=0x100000/CONFIG_PHYSICAL_START=$PHYSICAL_START/" .config
    fi
    
    if [ -n "$FRAGS" ]; then
        ./scripts/kconfig/merge_config.sh -m .config $FRAGS
    fi
}

reset_kernel()
{
    cd "$CURR_DIR/build/linux"

    CURR_TAG=$(git describe --tags --exact-match 2>/dev/null || echo "")
    if [ -n "$CURR_TAG" ] && [ "$CURR_TAG" != "v${LINUX_VER}" ]; then
        echo -e "${GREEN}Switching kernel version from ${CURR_TAG} to v${LINUX_VER}...${RESET}"
        reclone_kernel
        return
    fi

    echo -e "${GREEN}Resetting and cleaning Linux kernel...${RESET}"
    git config --global --add safe.directory $CURR_DIR/build/linux || true
    git reset --hard || true
    git clean -fdx || true
    make clean
    git checkout "v${LINUX_VER}"

    configure_kernel
}

reclone_kernel()
{
    cd "$CURR_DIR/build"
    echo -e "${GREEN}Recloning Linux kernel...${RESET}"
    sudo rm -r linux
    download_kernel
}

compile_kernel()
{   
    cd "$CURR_DIR/build/linux/"

    # Remove "-dirty" suffix until I can clone the kernel to my own repo
    sudo sed -i "s/printf '%s' -dirty/printf '%s'/" scripts/setlocalversion

    # Apply our patches
    if [[ "$LINUX_VER" == 7.2* ]]; then
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
    elif [[ "$LINUX_VER" == 7.1* ]]; then
        echo -e "${GREEN}Applying 7.1.x_restore-M486-M486SX-ELAN patch...${RESET}"
        patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-M486-M486SX-ELAN.patch"

        echo -e "${GREEN}Applying 7.1.x_restore-pcmcia-hosts patch...${RESET}"
        patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-pcmcia-hosts.patch"

        echo -e "${GREEN}Applying 7.1.x_restore-no-pci-devices patch...${RESET}"
        patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-no-pci-devices.patch"

        echo -e "${GREEN}Applying 7.1.x_restore-pc110pad patch...${RESET}"
        patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-pc110pad.patch"

        echo -e "${GREEN}Applying 7.1.x_restore-isa-pcmcia-net patch...${RESET}"
        patch -p1 < "${PATCHES_DIR}/linux/7.1.x/7.1.x_restore-isa-pcmcia-net.patch"
    fi

    echo -e "${GREEN}Compiling Linux kernel...${RESET}"
    make ARCH=x86 olddefconfig
    make ARCH=x86 bzImage -j$(nproc)
    $STRIP vmlinux

    sudo mv arch/x86/boot/bzImage "$CURR_DIR/build" || true
}

# Download and compile Linux kernel
get_kernel()
{
    cd "$CURR_DIR/build"

    if $ALWAYS_BUILD; then
        if [ ! -d "linux" ]; then
            download_kernel
        else
            reset_kernel
        fi
    else
        if [ ! -d "linux" ]; then
            download_kernel
        else
            echo -e "${YELLOW}A Linux kernel has already been downloaded and potentially compiled. Select action:${RESET}"
            select action in "Proceed with current kernel" "Reset & clean" "Delete & reclone"; do
                case $action in
                    "Proceed with current kernel")
                        echo -e "${GREEN}Proceeding with the current kernel...${RESET}"
                        return
                        break ;;
                    "Reset & clean")
                        reset_kernel
                        break ;;
                    "Delete & reclone")
                        reclone_kernel
                        break ;;
                    *)
                esac
            done
        fi
    fi

    compile_kernel
}

# Download and compile v86d (needed for uvesafb, NOT PRESENTLY USED)
get_v86d()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/sbin/v86d" ]; then
        echo -e "${LIGHT_RED}v86d already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d v86d ]; then
        echo -e "${YELLOW}v86d source already present, resetting...${RESET}"
        cd v86d
        git reset --hard
    else
        echo -e "${GREEN}Downloading v86d...${RESET}"
        git clone https://salsa.debian.org/debian/v86d.git
        cd v86d
    fi

    # Compile and install
    echo -e "${GREEN}Compiling v86d...${RESET}"
    sudo cp $CONFIGS_DIR/v86d.config.h config.h
    make clean >/dev/null 2>&1
    make CC="$CC -m32 -static -no-pie" v86d
    install -Dm755 v86d "$DESTDIR/sbin/v86d"
    $STRIP "$DESTDIR/sbin/v86d"
}



######################################################
## X11/window manager building                      ##
######################################################

get_xorgproto()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/include/X11/Xproto.h" ]; then
        echo -e "${LIGHT_RED}xorgproto already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xorgproto...${RESET}"

    XORGPROTO="xorgproto-2025.1"
    XORGPROTO_ARC="${XORGPROTO}.tar.xz"
    XORGPROTO_URI="https://xorg.freedesktop.org/archive/individual/proto/${XORGPROTO_ARC}"

    # Download source
    [ -f $XORGPROTO_ARC ] || wget $XORGPROTO_URI

    # Extract source
    if [ -d $XORGPROTO ]; then
        echo -e "${YELLOW}xorgproto's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $XORGPROTO
    fi
    tar xf $XORGPROTO_ARC
    cd $XORGPROTO

    # Compile and install
    echo -e "${GREEN}Compiling xorgproto...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --enable-legacy --with-sysroot="$SYSROOT" CC="$CC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libxdmcp()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXdmcp.a" ]; then
        echo -e "${LIGHT_RED}libXdmcp already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXdmcp...${RESET}"
 
    LIBXDMCP="libXdmcp-1.1.5"
    LIBXDMCP_ARC="${LIBXDMCP}.tar.xz"
    LIBXDMCP_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXDMCP_ARC}"

    # Download source
    [ -f $LIBXDMCP_ARC ] || wget $LIBXDMCP_URI

    # Extract source
    if [ -d $LIBXDMCP ]; then
        echo -e "${YELLOW}libXdmcp's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBXDMCP
    fi
    tar xf $LIBXDMCP_ARC
    cd $LIBXDMCP

    # Compile and install
    echo -e "${GREEN}Compiling libXdmcp...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make install DESTDIR="$SYSROOT"
}

get_libxau()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXau.a" ]; then
        echo -e "${LIGHT_RED}libXau already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXau...${RESET}"

    LIBXAU="libXau-1.0.12"
    LIBXAU_ARC="${LIBXAU}.tar.xz"
    LIBXAU_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXAU_ARC}"

    # Download source
    [ -f $LIBXAU_ARC ] || wget $LIBXAU_URI

    # Extract source
    if [ -d $LIBXAU ]; then
        echo -e "${YELLOW}libXau's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBXAU
    fi
    tar xf $LIBXAU_ARC
    cd $LIBXAU

    # Compile and install
    echo -e "${GREEN}Compiling libXau...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make install DESTDIR="$SYSROOT"
}

get_xcbproto()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/share/xcb/xproto.xml" ]; then
        echo -e "${LIGHT_RED}xcb-proto already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xcb-proto...${RESET}"

    LIBXCBPROTO="xcb-proto-1.17.0"
    LIBXCBPROTO_ARC="${LIBXCBPROTO}.tar.xz"
    LIBXCBPROTO_URI="https://xorg.freedesktop.org/archive/individual/proto/${LIBXCBPROTO_ARC}"

    # Download source
    [ -f $LIBXCBPROTO_ARC ] || wget $LIBXCBPROTO_URI

    # Extract source
    if [ -d $LIBXCBPROTO ]; then
        echo -e "${YELLOW}xcb-proto's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBXCBPROTO
    fi
    tar xf $LIBXCBPROTO_ARC
    cd $LIBXCBPROTO

    # Compile and install
    echo -e "${GREEN}Compiling xcb-proto...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make install DESTDIR="$SYSROOT"
}

get_libxcb()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libxcb.a" ]; then
        echo -e "${LIGHT_RED}libxcb already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libxcb...${RESET}"

    LIBXCB="libxcb-1.17.0"
    LIBXCB_ARC="${LIBXCB}.tar.xz"
    LIBXCB_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXCB_ARC}"

    # Download source
    [ -f $LIBXCB_ARC ] || wget $LIBXCB_URI

    # Extract source
    if [ -d $LIBXCB ]; then
        echo -e "${YELLOW}libxcb's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBXCB
    fi
    tar xf $LIBXCB_ARC
    cd $LIBXCB

    # Compile and install
    echo -e "${GREEN}Compiling libxcb...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make install DESTDIR="$SYSROOT"
}

get_xtrans()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/include/X11/Xtrans/Xtrans.h" ]; then
        echo -e "${LIGHT_RED}xtrans already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xtrans...${RESET}"

    XTRANS="xtrans-1.6.0"
    XTRANS_ARC="${XTRANS}.tar.xz"
    XTRANS_URI="https://xorg.freedesktop.org/archive/individual/lib/${XTRANS_ARC}"

    # Download source
    [ -f $XTRANS_ARC ] || wget $XTRANS_URI

    # Extract source
    if [ -d $XTRANS ]; then
        echo -e "${YELLOW}xtrans' source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $XTRANS
    fi
    tar xf $XTRANS_ARC
    cd $XTRANS

    # Compile and install
    echo -e "${GREEN}Compiling xtrans...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libx11()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libX11.a" ]; then
        echo -e "${LIGHT_RED}libX11 already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libX11...${RESET}"

    LIBX11="libX11-1.8.12"
    LIBX11_ARC="${LIBX11}.tar.xz"
    LIBX11_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBX11_ARC}"

    # Download source
    [ -f $LIBX11_ARC ] || wget $LIBX11_URI

    # Extract source
    if [ -d $LIBX11 ]; then
        echo -e "${YELLOW}libX11's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBX11
    fi
    tar xf $LIBX11_ARC
    cd $LIBX11

    # Compile and install
    echo -e "${GREEN}Compiling libX11...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static --with-sysroot="$SYSROOT" CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make install DESTDIR="$SYSROOT"
}

get_libxext()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXext.a" ]; then
        echo -e "${LIGHT_RED}libXext already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXext...${RESET}"

    LIBXEXT="libXext-1.3.7"
    LIBXEXT_ARC="${LIBXEXT}.tar.xz"
    LIBXEXT_URI="https://xorg.freedesktop.org/archive/individual/lib//${LIBXEXT_ARC}"

    # Download source
    [ -f $LIBXEXT_ARC ] || wget $LIBXEXT_URI

    # Extract source
    if [ -d $LIBXEXT ]; then
        echo -e "${YELLOW}libXext's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $LIBXEXT
    fi
    tar xf $LIBXEXT_ARC
    cd $LIBXEXT

    # Compile and install
    echo -e "${GREEN}Compiling libXext...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libxfixes()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXfixes.a" ]; then
        echo -e "${LIGHT_RED}libXfixes already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXfixes...${RESET}"

    LIBXFIXES="libXfixes-6.0.2"
    LIBXFIXES_ARC="${LIBXFIXES}.tar.xz"
    LIBXFIXES_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXFIXES_ARC}"

    # Download source
    [ -f $LIBXFIXES_ARC ] || wget $LIBXFIXES_URI

    # Extract source
    if [ -d $LIBXFIXES ]; then
        echo -e "${YELLOW}libXfixes' source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $LIBXFIXES
    fi
    tar xf $LIBXFIXES_ARC
    cd $LIBXFIXES

    # Compile and install
    echo -e "${GREEN}Compiling libXfixes...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libxi()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXi.a" ]; then
        echo -e "${LIGHT_RED}libXi already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXi...${RESET}"

    LIBXI="libXi-1.8.2"
    LIBXI_ARC="${LIBXI}.tar.xz"
    LIBXI_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXI_ARC}"

    # Download source
    [ -f $LIBXI_ARC ] || wget $LIBXI_URI

    # Extract source
    if [ -d $LIBXI ]; then
        echo -e "${YELLOW}libXi's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $LIBXI
    fi
    tar xf $LIBXI_ARC
    cd $LIBXI

    # Compile and install
    echo -e "${GREEN}Compiling libXi...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libxtst()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXtst.a" ]; then
        echo -e "${LIGHT_RED}libXtst already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXtst...${RESET}"

    LIBXTST="libXtst-1.2.5"
    LIBXTST_ARC="${LIBXTST}.tar.xz"
    LIBXTST_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXTST_ARC}"

    # Download source
    [ -f $LIBXTST_ARC ] || wget $LIBXTST_URI

    # Extract source
    if [ -d $LIBXTST ]; then
        echo -e "${YELLOW}libXtst's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $LIBXTST
    fi
    tar xf $LIBXTST_ARC
    cd $LIBXTST

    # Compile and install
    echo -e "${GREEN}Compiling libXtst...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libice()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libICE.a" ]; then
        echo -e "${LIGHT_RED}libICE already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libICE...${RESET}"

    LIBICE="libICE-1.1.2"
    LIBICE_ARC="${LIBICE}.tar.xz"
    LIBICE_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBICE_ARC}"

    # Download source
    [ -f $LIBICE_ARC ] || wget $LIBICE_URI

    # Extract source
    if [ -d $LIBICE ]; then
        echo -e "${YELLOW}libICE's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $LIBICE
    fi
    tar xf $LIBICE_ARC
    cd $LIBICE

    # Compile and install
    echo -e "${GREEN}Compiling libICE...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libsm()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libSM.a" ]; then
        echo -e "${LIGHT_RED}libSM already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libSM...${RESET}"

    LIBSM="libSM-1.2.6"
    LIBSM_ARC="${LIBSM}.tar.xz"
    LIBSM_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBSM_ARC}"

    # Download source
    [ -f $LIBSM_ARC ] || wget $LIBSM_URI

    # Extract source
    if [ -d $LIBSM ]; then
        echo -e "${YELLOW}libSM's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $LIBSM
    fi
    tar xf $LIBSM_ARC
    cd $LIBSM

    # Compile and install
    echo -e "${GREEN}Compiling libSM...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libxt()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXt.a" ]; then
        echo -e "${LIGHT_RED}libXt already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXt...${RESET}"

    LIBXT="libXt-1.3.1"
    LIBXT_ARC="${LIBXT}.tar.xz"
    LIBXT_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXT_ARC}"

    # Download source
    [ -f $LIBXT_ARC ] || wget $LIBXT_URI

    # Extract source
    if [ -d $LIBXT ]; then
        echo -e "${YELLOW}libXt's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $LIBXT
    fi
    tar xf $LIBXT_ARC
    cd $LIBXT

    # Compile and install
    echo -e "${GREEN}Compiling libXt...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libpng()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libpng.a" ]; then
        echo -e "${LIGHT_RED}libpng already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libpng...${RESET}"

    LIBPNG_VER="1.6.54"
    LIBPNG="libpng-${LIBPNG_VER}"
    LIBPNG_ARC="${LIBPNG}.tar.xz"
    LIBPNG_URI="https://unlimited.dl.sourceforge.net/project/libpng/libpng16/1.6.54/${LIBPNG_ARC}"

    # Download source
    [ -f "$LIBPNG_ARC" ] || wget "$LIBPNG_URI"

    # Extract source
    if [ -d $LIBPNG ]; then
        echo -e "${YELLOW}libpng's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $LIBPNG
    fi
    tar xf $LIBPNG_ARC
    cd $LIBPNG

    # Compile and install
    echo -e "${GREEN}Compiling libpng...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libxpm()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXpm.a" ]; then
        echo -e "${LIGHT_RED}libXpm already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXpm...${RESET}"

    LIBXPM="libXpm-3.5.18"
    LIBXPM_ARC="${LIBXPM}.tar.xz"
    LIBXPM_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXPM_ARC}"

    # Download source
    [ -f $LIBXPM_ARC ] || wget $LIBXPM_URI

    # Extract source
    if [ -d $LIBXPM ]; then
        echo -e "${YELLOW}libXpm's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $LIBXPM
    fi
    tar xf $LIBXPM_ARC
    cd $LIBXPM

    # Compile and install
    echo -e "${GREEN}Compiling libXpm...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static --with-sysroot="$SYSROOT" CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP" LIBS="-lX11 -lxcb -lXau -lXdmcp -lSM -lICE"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libxmu()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXmu.a" ]; then
        echo -e "${LIGHT_RED}libXmu already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXmu...${RESET}"

    LIBXMU="libXmu-1.3.1"
    LIBXMU_ARC="${LIBXMU}.tar.xz"
    LIBXMU_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXMU_ARC}"

    # Download source
    [ -f $LIBXMU_ARC ] || wget $LIBXMU_URI

    # Extract source
    if [ -d $LIBXMU ]; then
        echo -e "${YELLOW}libXmu's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $LIBXMU
    fi
    tar xf $LIBXMU_ARC
    cd $LIBXMU

    # Compile and install
    echo -e "${GREEN}Compiling libXmu...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_utilmacros()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/share/pkgconfig/xorg-macros.pc" ]; then
        echo -e "${LIGHT_RED}util-macros already compiled, skipping...${RESET}"
        return
    fi

    UTILMACROS="util-macros-1.20.2"
    UTILMACROS_ARC="${UTILMACROS}.tar.xz"
    UTILMACROS_URI="https://xorg.freedesktop.org/archive/individual/util/${UTILMACROS_ARC}"

    echo -e "${GREEN}Downloading util-macros...${RESET}"

    # Download source
    [ -f $UTILMACROS_ARC ] || wget $UTILMACROS_URI

    # Extract source
    if [ -d $UTILMACROS ]; then
        echo -e "${YELLOW}util-macros' source archive is already present, re-extracting before proceeding...${RESET}"
        rm -rf $UTILMACROS
    fi
    tar xf $UTILMACROS_ARC
    cd $UTILMACROS

    # Compile and install
    echo -e "${GREEN}Compiling util-macros...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_freetype()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libfreetype.a" ]; then
        echo -e "${LIGHT_RED}freetype already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading freetype...${RESET}"

    FREETYPE="freetype-2.14.1"
    FREETYPE_ARC="${FREETYPE}.tar.xz"
    FREETYPE_URI="https://download.savannah.gnu.org/releases/freetype/${FREETYPE_ARC}"

    # Download source
    [ -f $FREETYPE_ARC ] || wget $FREETYPE_URI

    # Extract source
    if [ -d $FREETYPE ]; then
        echo -e "${YELLOW}freetype's source archive is already present, re-extracting before proceeding...${RESET}"
        sudo rm -r $FREETYPE
    fi
    tar xf $FREETYPE_ARC
    cd $FREETYPE

    # Compile and install
    echo -e "${GREEN}Compiling freetype...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libexpat()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libexpat.a" ]; then
        echo -e "${LIGHT_RED}libexpat already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libexpat...${RESET}"

    LIBEXPAT="expat-2.5.0"
    LIBEXPAT_ARC="${LIBEXPAT}.tar.xz"
    LIBEXPAT_URI="https://github.com/libexpat/libexpat/releases/download/R_2_5_0/${LIBEXPAT_ARC}"

    # Download source
    [ -f $LIBEXPAT_ARC ] || wget $LIBEXPAT_URI

    # Extract source
    if [ -d $LIBEXPAT ]; then
        echo -e "${YELLOW}libexpat's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBEXPAT
    fi
    tar xf $LIBEXPAT_ARC
    cd $LIBEXPAT

    # Compile and install
    echo -e "${GREEN}Compiling libexpat...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static --without-examples --without-tests CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_fontconfig()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete
    
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libfontconfig.a" ]; then
        echo -e "${LIGHT_RED}fontconfig already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading fontconfig...${RESET}"

    FONTCONFIG="fontconfig-2.16.0"
    FONTCONFIG_ARC="${FONTCONFIG}.tar.xz"
    FONTCONFIG_URI="https://www.freedesktop.org/software/fontconfig/release/${FONTCONFIG_ARC}"

    # Download source
    [ -f $FONTCONFIG_ARC ] || wget $FONTCONFIG_URI

    # Extract source
    if [ -d $FONTCONFIG ]; then
        echo -e "${YELLOW}fontconfig's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $FONTCONFIG
    fi
    tar xf $FONTCONFIG_ARC
    cd $FONTCONFIG

    # Compile and install
    echo -e "${GREEN}Compiling fontconfig...${RESET}"
    #./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP" LIBS="-lpng16 -lz -lm"
    ./configure \
        --host="$HOST" \
        --prefix=/usr \
        --disable-shared \
        --enable-static \
        --disable-docs \
        CC="$CC_STATIC" \
        AR="$AR" \
        RANLIB="$RANLIB" \
        STRIP="$STRIP" \
        LIBS="-lz -lm"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libxrender()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXrender.a" ]; then
        echo -e "${LIGHT_RED}libXrender already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXrender...${RESET}"

    LIBXRENDER="libXrender-0.9.12"
    LIBXRENDER_ARC="${LIBXRENDER}.tar.xz"
    LIBXRENDER_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXRENDER_ARC}"

    # Download source
    [ -f $LIBXRENDER_ARC ] || wget $LIBXRENDER_URI

    # Extract source
    if [ -d $LIBXRENDER ]; then
        echo -e "${YELLOW}libXrender's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBXRENDER
    fi
    tar xf $LIBXRENDER_ARC
    cd $LIBXRENDER

    # Compile and install
    echo -e "${GREEN}Compiling libXrender...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libxft()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXft.a" ]; then
        echo -e "${LIGHT_RED}libXft already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXft...${RESET}"

    LIBXFT="libXft-2.3.9"
    LIBXFT_ARC="${LIBXFT}.tar.xz"
    LIBXFT_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXFT_ARC}"

    # Download source
    [ -f $LIBXFT_ARC ] || wget $LIBXFT_URI

    # Extract source
    if [ -d $LIBXFT ]; then
        echo -e "${YELLOW}libXft's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBXFT
    fi
    tar xf $LIBXFT_ARC
    cd $LIBXFT

    # Compile and install
    echo -e "${GREEN}Compiling libXft...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libfontenc()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libfontenc.a" ]; then
        echo -e "${LIGHT_RED}libfontenc already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libfontenc...${RESET}"

    LIBFONTENC="libfontenc-1.1.8"
    LIBFONTENC_ARC="${LIBFONTENC}.tar.xz"
    LIBFONTENC_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBFONTENC_ARC}"

    # Download source
    [ -f $LIBFONTENC_ARC ] || wget $LIBFONTENC_URI

    # Extract source
    if [ -d $LIBFONTENC ]; then
        echo -e "${YELLOW}libfontenc's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBFONTENC
    fi
    tar xf $LIBFONTENC_ARC
    cd $LIBFONTENC

    # Compile and install
    echo -e "${GREEN}Compiling libfontenc...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make DESTDIR="$SYSROOT" install
}

get_libxfont()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXfont.a" ]; then
        echo -e "${LIGHT_RED}libXfont already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXfont...${RESET}"

    LIBXFONT="libXfont-1.5.4"
    LIBXFONT_ARC="${LIBXFONT}.tar.gz"
    LIBXFONT_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXFONT_ARC}"

    # Download source
    [ -f $LIBXFONT_ARC ] || wget $LIBXFONT_URI

    # Extract source
    if [ -d $LIBXFONT ]; then
        echo -e "${YELLOW}libXfont's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBXFONT
    fi
    tar xzf $LIBXFONT_ARC
    cd $LIBXFONT

    # Compile and install
    echo -e "${GREEN}Compiling libXfont...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make install DESTDIR="$SYSROOT"
}

get_fontutil()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/share/aclocal/fontutil.m4" ]; then
        echo -e "${LIGHT_RED}font-util already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading font-util...${RESET}"

    FONTUTIL="font-util-1.4.1"
    FONTUTIL_ARC="${FONTUTIL}.tar.xz"
    FONTUTIL_URI="https://xorg.freedesktop.org/archive/individual/font/${FONTUTIL_ARC}"

    # Download source
    [ -f $FONTUTIL_ARC ] || wget $FONTUTIL_URI

    # Extract source
    if [ -d $FONTUTIL ]; then
        echo -e "${YELLOW}font-util's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $FONTUTIL
    fi
    tar xf $FONTUTIL_ARC
    cd $FONTUTIL

    # Compile and install
    echo -e "${GREEN}Compiling font-util...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make install DESTDIR="$SYSROOT"
}

get_fonts()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    BIT_FONT_DIR=$DESTDIR/usr/lib/X11/fonts/misc
    OTF_FONT_DIR=$DESTDIR/usr/share/fonts/opentype

    if [ -f "$BIT_FONT_DIR/fonts.dir" ]; then
        echo -e "${LIGHT_RED}Fonts already installed, skipping...${RESET}"
        return
    fi



    echo -e "${GREEN}Downloading bitmap fonts...${RESET}"
    for FONT in font-misc-misc-1.1.3 font-cursor-misc-1.0.4; do
        echo -e "${GREEN}Building $FONT...${RESET}"
        ARC="${FONT}.tar.xz"
        URI="https://xorg.freedesktop.org/archive/individual/font/${ARC}"
        [ -f $ARC ] || wget $URI
        tar xf $ARC
        cd $FONT
        ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static --with-fontdir=/usr/lib/X11/fonts/misc
        make -j$(nproc)
        make install DESTDIR="$SYSROOT"
        cd ..
    done

    echo -e "${GREEN}Installing bitmap fonts...${RESET}"
    mkdir -p $BIT_FONT_DIR
    for f in 6x13.pcf.gz 7x14.pcf.gz 8x13.pcf.gz 9x15.pcf.gz cursor.pcf.gz; do
        if [ -f "$SYSROOT/usr/lib/X11/fonts/misc/$f" ]; then
            sudo cp $SYSROOT/usr/lib/X11/fonts/misc/$f $BIT_FONT_DIR
        fi
    done
    echo "fixed -misc-fixed-medium-r-normal--14-130-75-75-c-70-iso10646-1" | sudo tee "$BIT_FONT_DIR/fonts.alias" > /dev/null
    cd $DESTDIR/usr/lib/X11/fonts/misc
    rm -f fonts.dir fonts.scale
    mkfontscale .
    mkfontdir .



    cd "$CURR_DIR/build"

    echo -e "${GREEN}Downloading OTF/TTF fonts...${RESET}"
    IBMPM="ibm-plex-mono"
    IBMPM_ARC="${IBMPM}.zip"
    IBMPM_URI="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/${IBMPM_ARC}"

    mkdir -p "$OTF_FONT_DIR/$IBMPM"
    [ -f $IBMPM_ARC ] || wget $IBMPM_URI
    unzip -oj "$IBMPM_ARC" "ibm-plex-mono/fonts/complete/otf/IBMPlexMono-Regular.otf" -d $CURR_DIR/build/plex
    unzip -oj "$IBMPM_ARC" "ibm-plex-mono/LICENSE.txt" -d $CURR_DIR/build/plex
    cd plex
    sudo cp IBMPlexMono-Regular.otf $OTF_FONT_DIR/ibm-plex-mono



    sudo mkdir -p $DESTDIR/var/cache/fontconfig
    sudo chmod 777 $DESTDIR/var/cache/fontconfig
    sudo mkdir -p $DESTDIR/etc/fonts
    copy_sysfile $CURR_DIR/sysfiles/fonts.conf $DESTDIR/etc/fonts/fonts.conf
    sudo fc-cache -r "$DESTDIR/usr/share/fonts"
}

get_libxaw()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libXaw7.a" ]; then
        echo -e "${LIGHT_RED}libXaw already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libXaw...${RESET}"

    LIBXAW="libXaw-1.0.16"
    LIBXAW_ARC="${LIBXAW}.tar.xz"
    LIBXAW_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXAW_ARC}"

    # Download source
    [ -f $LIBXAW_ARC ] || wget $LIBXAW_URI

    # Extract source
    if [ -d $LIBXAW ]; then
        echo -e "${YELLOW}libXaw's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBXAW
    fi
    tar xf $LIBXAW_ARC
    cd $LIBXAW

    # Compile and install
    echo -e "${GREEN}Compiling libXaw...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make install DESTDIR="$SYSROOT"
}

get_libxkbfile()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/lib/libxkbfile.a" ]; then
        echo -e "${LIGHT_RED}libxkbfile already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading libxkbfile...${RESET}"

    LIBXKBFILE="libxkbfile-1.1.3"
    LIBXKBFILE_ARC="${LIBXKBFILE}.tar.xz"
    LIBXKBFILE_URI="https://xorg.freedesktop.org/archive/individual/lib/${LIBXKBFILE_ARC}"

    # Download source
    [ -f $LIBXKBFILE_ARC ] || wget $LIBXKBFILE_URI

    # Extract source
    if [ -d $LIBXKBFILE ]; then
        echo -e "${YELLOW}libxkbfile's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $LIBXKBFILE
    fi
    tar xf $LIBXKBFILE_ARC
    cd $LIBXKBFILE

    # Compile and install
    echo -e "${GREEN}Compiling libxkbfile...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make install DESTDIR="$SYSROOT"
}

get_xbitmaps()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/share/pkgconfig/xbitmaps.pc" ]; then
        echo -e "${LIGHT_RED}xbitmaps already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xbitmaps...${RESET}"

    XBITMAPS="xbitmaps-1.1.3"
    XBITMAPS_ARC="${XBITMAPS}.tar.xz"
    XBITMAPS_URI="https://xorg.freedesktop.org/archive/individual/data/${XBITMAPS_ARC}"

    # Download source
    [ -f $XBITMAPS_ARC ] || wget $XBITMAPS_URI

    # Extract source
    if [ -d $XBITMAPS ]; then
        echo -e "${YELLOW}xbitmaps' source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $XBITMAPS
    fi
    tar xf $XBITMAPS_ARC
    cd $XBITMAPS

    # Compile and install
    echo -e "${GREEN}Compiling xbitmaps...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
    make -j$(nproc)
    make install DESTDIR="$SYSROOT"

    # Also install bitmaps to root file system
    sudo mkdir -p $DESTDIR/usr/include/X11/bitmaps
    sudo cp $SYSROOT/usr/include/X11/bitmaps/* $DESTDIR/usr/include/X11/bitmaps
}

get_openmotif()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$SYSROOT/usr/include/Xm/Xm.h" ]; then
        echo -e "${LIGHT_RED}OpenMotif already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading OpenMotif...${RESET}"

    OPENMOTIF="motif-2.3.8"
    OPENMOTIF_ARC="${OPENMOTIF}.tar.gz"
    OPENMOTIF_URI="https://deac-fra.dl.sourceforge.net/project/motif/Motif%202.3.8%20Source%20Code/${OPENMOTIF_ARC}"

    # Download source
    [ -f $OPENMOTIF_ARC ] || wget $OPENMOTIF_URI

    # Extract source
    if [ -d $OPENMOTIF ]; then
        echo -e "${YELLOW}OpenMotif's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $OPENMOTIF
    fi
    tar xzf $OPENMOTIF_ARC
    cd $OPENMOTIF

    # Compile and install
    echo -e "${GREEN}Compiling OpenMotif...${RESET}"
    ./configure --host="$HOST" \
        --prefix=/usr \
        --with-x \
        --enable-static \
        --disable-shared \
        CC="$CC_STATIC" \
        AR="$AR" \
        RANLIB="$RANLIB" \
        STRIP="$STRIP" \
        CFLAGS="--sysroot=${SYSROOT} -O2 -march=${ARCH} -I${SYSROOT}/usr/include -Wno-error -Wno-maybe-uninitialized -Wno-array-bounds -Wno-int-in-bool-context"

    # Patch for "undefined reference to 'main'"
    sudo sed -i 's/^LEX =.*/LEX = flex/' tools/wml/Makefile
    echo "int main(int argc, char **argv) { return 0; }" | sudo tee -a tools/wml/wmluiltok.l

    make -j"$(nproc)" -C lib
    make -j"$(nproc)" -C include 
    make -C lib install DESTDIR="$SYSROOT"
    make -C include install DESTDIR="$SYSROOT"
}

get_xbiff()
{
    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/xbiff" ]; then
        echo -e "${LIGHT_RED}xbiff already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xbiff...${RESET}"

    XBIFF="xbiff-1.0.5"
    XBIFF_ARC="${XBIFF}.tar.gz"
    XBIFF_URI="https://xorg.freedesktop.org/archive/individual/app/${XBIFF_ARC}"

    # Download source
    [ -f $XBIFF_ARC ] || wget $XBIFF_URI

    # Extract source
    if [ -d $XBIFF ]; then
        echo -e "${YELLOW}xbiff's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $XBIFF
    fi
    tar xf $XBIFF_ARC
    cd $XBIFF

    # Compile and install
    echo -e "${GREEN}Compiling xbiff...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static --x-includes="$SYSROOT/usr/include" --x-libraries="$SYSROOT/usr/lib" CC="$CC_STATIC" LIBS="-lXaw7 -lXmu -lXpm -lXt -lSM -lICE -lXext -lX11 -lxcb -lXau -lXdmcp"
    make -j$(nproc)
    make DESTDIR="$DESTDIR" install
}

prepare_x11()
{
    export PKG_CONFIG_DIR=""
    export PKG_CONFIG_LIBDIR="$SYSROOT/usr/lib/pkgconfig:$SYSROOT/usr/share/pkgconfig"
    export PKG_CONFIG_SYSROOT_DIR="$SYSROOT"

    get_xorgproto
    get_libxdmcp
    get_libxau
    get_xcbproto
    get_libxcb
    get_xtrans
    get_libx11
    get_libxext
    get_libxfixes
    get_libxi
    get_libxtst
    get_libice
    get_libsm
    get_libxt
    get_libpng
    get_libxpm
    get_libxmu
    get_utilmacros
    get_freetype
    get_libexpat
    get_fontconfig
    get_libxrender
    get_libxft
    get_libfontenc
    get_libxfont
    get_fontutil
    get_fonts
    get_libxaw
    get_libxkbfile
    get_xbitmaps
    get_openmotif
    #get_xbiff
}

get_tinyx()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/Xfbdev" ]; then
        echo -e "${LIGHT_RED}TinyX already compiled, skipping...${RESET}"
        return
    fi

    # Prevent hard-coded paths poisoning the cross-compilation linker
    sudo find "$SYSROOT/usr/lib" -name "*.la" -delete

    # Download source
    if [ -d tinyx ]; then
        echo -e "${YELLOW}TinyX source already present, resetting...${RESET}"
        git config --global --add safe.directory "$CURR_DIR/build/tinyx"
        cd tinyx
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading TinyX...${RESET}"
        git clone https://github.com/tinycorelinux/tinyx.git
        cd tinyx
    fi

    export ACLOCAL_PATH="$SYSROOT/usr/share/aclocal"

    LINK_LIBS="-lXtst -lXi -lXext -lXfixes -lXfont -lfontenc -lX11 -lxcb -lXau -lXdmcp -lfreetype -lpng -lz -lm"

    # Compile and install
    echo -e "${GREEN}Compiling TinyX...${RESET}"
    ./autogen.sh
    ./configure \
        --host="${HOST}" \
        --prefix=/usr \
        --disable-shared \
        --enable-static \
        --with-sysroot="$SYSROOT" \
        --disable-xorg \
        --enable-kdrive \
        --enable-xfbdev \
        CC="${CC_STATIC}" \
        CPPFLAGS="-I$SYSROOT/usr/include -I$SYSROOT/usr/include/freetype2" \
        CFLAGS="-O2 -march=i486 -mtune=i486 -fomit-frame-pointer -ffast-math -mno-fancy-math-387 -pipe --sysroot=$SYSROOT" \
        LDFLAGS="-static -L$SYSROOT/usr/lib --sysroot=$SYSROOT" \
        LIBS="$LINK_LIBS" \XSERVERCFLAGS_CFLAGS="-I$SYSROOT/usr/include -I$SYSROOT/usr/include/freetype2" XSERVERLIBS_LIBS="$LINK_LIBS"
    make -j$(nproc)
    make DESTDIR=$DESTDIR install
}

get_twm()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/twm" ]; then
        echo -e "${LIGHT_RED}TWM already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d twm ]; then
        echo -e "${YELLOW}TWM source already present, resetting...${RESET}"
        git config --global --add safe.directory "$CURR_DIR/build/twm"
        cd twm
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading TWM...${RESET}"
        git clone --branch "twm-${TWM_VER}" $TWM_SRC
        cd twm
    fi

    export PKG_CONFIG_SYSROOT_DIR="$SYSROOT"
    export PKG_CONFIG_PATH="$SYSROOT/usr/lib/pkgconfig:$SYSROOT/usr/share/pkgconfig"
    export PKG_CONFIG="pkg-config --static"
    export ACLOCAL_PATH="$SYSROOT/usr/share/aclocal"

    # Patch to rename "TWM Icon Manager" to "Tasklist"
    #sudo sed -i 's/"%s Icon Manager"/"Tasklist"/' src/iconmgr.c

    # Compile and install
    echo -e "${GREEN}Compiling TWM...${RESET}"
    ./autogen.sh
    ./configure --host="$HOST" --prefix=/usr \
        CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP" \
        CFLAGS="-O2 -march=i486 -mtune=i486 -fomit-frame-pointer -ffast-math -pipe --sysroot=$SYSROOT" \
        CPPFLAGS="-I$SYSROOT/usr/include" \
        LDFLAGS="-static -L$SYSROOT/usr/lib --sysroot=$SYSROOT"
    make -j$(nproc)
    make DESTDIR="$DESTDIR" install
}

get_nedit()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/nedit" ]; then
        echo -e "${LIGHT_RED}NEdit already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d nedit-git ]; then
        echo -e "${YELLOW}NEdit source already present, resetting...${RESET}"
        git config --global --add safe.directory "$CURR_DIR/build/nedit-git"
        cd nedit-git
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading NEdit...${RESET}"
        git clone $NEDIT_SRC nedit-git
        cd nedit-git
        git checkout $NEDIT_VER
    fi

    sudo sed -i 's|-I../Microline||g' makefiles/Makefile.linux
    sudo sed -i 's|../Microline/XmL/libXmL.a||g' makefiles/Makefile.linux

    export CFLAGS="--sysroot=${SYSROOT} -O2 -march=${ARCH} -I${SYSROOT}/usr/include"
    export LDFLAGS="--sysroot=${SYSROOT} -L${SYSROOT}/usr/lib"

    # Compile and install
    echo -e "${GREEN}Compiling NEdit...${RESET}"

    sudo cp makefiles/Makefile.linux util/Makefile
    sudo cp makefiles/Makefile.linux source/Makefile
    cd util
    make CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"

    cd ../source
    make clean
    make CC="${CC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" PREFIX=/usr

    make install PREFIX=/usr
}

get_oneko()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/oneko" ]; then
        echo -e "${LIGHT_RED}oneko already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d oneko ]; then
        echo -e "${YELLOW}oneko source already present, resetting...${RESET}"
        git config --global --add safe.directory "$CURR_DIR/build/oneko"
        cd oneko
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading oneko...${RESET}"
        git clone https://github.com/tie/oneko.git
        cd oneko
    fi

    # Compile and install
    echo -e "${GREEN}Compiling oneko...${RESET}"
    "$CC_STATIC" -Wno-parentheses -std=c11 -pedantic -D_DEFAULT_SOURCE -I"$SYSROOT/usr/include" "$CURR_DIR/build/oneko/oneko.c" -L"$SYSROOT/usr/lib" -lX11 -lxcb -lXau -lXdmcp -lXext -lc -lm -o oneko
    sudo cp oneko $DESTDIR/usr/bin/
}

get_st()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/st" ]; then
        echo -e "${LIGHT_RED}st already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d st ]; then
        echo -e "${YELLOW}st source already present, resetting...${RESET}"
        git config --global --add safe.directory "$CURR_DIR/build/st"
        cd st
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading st...${RESET}"
        git clone git://git.suckless.org/st
        cd st
    fi

    # Patch to fix "select: function not implemented" error
    sudo sed -i 's/pselect(\(.*\), NULL)/select(\1)/' st.c
    sudo sed -i 's/pselect(\(.*\), NULL)/select(\1)/' x.c
    
    # Patch to fix st launching as "Untitled" in TWM
    sudo sed -i '/CWColormap, &xw\.attrs);/a XTextProperty prop; char *name = "Terminal"; XStringListToTextProperty(&name, 1, &prop); XSetWMName(xw.dpy, xw.win, &prop); XSetWMIconName(xw.dpy, xw.win, &prop);' x.c

    # Patch to make sure st uses our fixed font
    sudo sed -i 's/^static char \*font.*/static char *font = "fixed:pixelsize=14";/' config.def.h

    # Patch to change default TERM value
    sudo sed -i 's|st-256color|linux|g' config.def.h

    # Patch to disable cursor blinking
    sed -i 's/^static unsigned int blinktimeout = .*/static unsigned int blinktimeout = 0;/' config.def.h

    # Compile and install
    echo -e "${GREEN}Compiling st...${RESET}"
    make -j$(nproc) \
        CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP" \
        CFLAGS="-O2 -march=i486 -mtune=i486 -fomit-frame-pointer -ffast-math -pipe" \
        CPPFLAGS="-I$SYSROOT/usr/include -I$SYSROOT/usr/include/freetype2" \
        LDFLAGS="-static -L$SYSROOT/usr/lib --sysroot=$SYSROOT" \
        LIBS="-lXft -lfontconfig -lfreetype -lXrender -lX11 -lxcb -lXau -lXdmcp -lexpat -lpng -lz -lm"
    make DESTDIR="$DESTDIR" PREFIX=/usr install CC="$CC_STATIC" AR="$AR" RANLIB="$RANLIB" STRIP="$STRIP"
}

get_xcalc()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/xcalc" ]; then
        echo -e "${LIGHT_RED}xcalc already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xcalc...${RESET}"

    XCALC="xcalc-1.1.2"
    XCALC_ARC="${XCALC}.tar.gz"
    XCALC_URI="https://xorg.freedesktop.org/archive/individual/app/${XCALC_ARC}"

    # Download source
    [ -f $XCALC_ARC ] || wget $XCALC_URI

    # Extract source
    if [ -d $XCALC ]; then
        echo -e "${YELLOW}xcalc's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $XCALC
    fi
    tar xf $XCALC_ARC
    cd $XCALC

    # Compile and install
    echo -e "${GREEN}Compiling xcalc...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --x-includes="$SYSROOT/usr/include" --x-libraries="$SYSROOT/usr/lib" CC="$CC_STATIC" LIBS="-lXaw7 -lXmu -lXt -lXpm -lXft -lfontconfig -lfreetype -lpng -lexpat -lXrender -lXext -lxcb -lXau -lXdmcp -lSM -lICE -lX11 -lz"
    make -j$(nproc)
    make DESTDIR=$DESTDIR install
}

get_xclock()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/xclock" ]; then
        echo -e "${LIGHT_RED}xclock already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xclock...${RESET}"

    XCLOCK="xclock-1.1.1"
    XCLOCK_ARC="${XCLOCK}.tar.gz"
    XCLOCK_URI="https://xorg.freedesktop.org/archive/individual/app/${XCLOCK_ARC}"

    # Download source
    [ -f $XCLOCK_ARC ] || wget $XCLOCK_URI

    # Extract source
    if [ -d $XCLOCK ]; then
        echo -e "${YELLOW}xclock's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $XCLOCK
    fi
    tar xf $XCLOCK_ARC
    cd $XCLOCK

    # Compile and install
    echo -e "${GREEN}Compiling xclock...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --x-includes="$SYSROOT/usr/include" --x-libraries="$SYSROOT/usr/lib" CC="$CC_STATIC" LIBS="-lXaw7 -lXmu -lXt -lXpm -lXft -lfontconfig -lfreetype -lpng -lexpat -lXrender -lXext -lxcb -lXau -lXdmcp -lSM -lICE -lX11 -lz"
    make -j$(nproc)
    make DESTDIR="$DESTDIR" install
}

get_xedit()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/xedit" ]; then
        echo -e "${LIGHT_RED}xedit already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xedit...${RESET}"

    XEDIT="xedit-1.2.4"
    XEDIT_ARC="${XEDIT}.tar.gz"
    XEDIT_URI="https://xorg.freedesktop.org/archive/individual/app/${XEDIT_ARC}"

    # Download source
    [ -f $XEDIT_ARC ] || wget $XEDIT_URI

    # Extract source
    if [ -d $XEDIT ]; then
        echo -e "${YELLOW}xedit's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $XEDIT
    fi
    tar xf $XEDIT_ARC
    cd $XEDIT

    # Compile and install
    echo -e "${GREEN}Compiling xedit...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static --x-includes="$SYSROOT/usr/include" --x-libraries="$SYSROOT/usr/lib" CC="$CC_STATIC" LIBS="-lXaw7 -lXmu -lXt -lXpm -lXext -lSM -lICE -lX11 -lxcb -lXau -lXdmcp"
    make -j$(nproc)
    make DESTDIR="$DESTDIR" install
}

get_xeyes()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/xeyes" ]; then
        echo -e "${LIGHT_RED}xeyes already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xeyes...${RESET}"

    XEYES="xeyes-1.3.1"
    XEYES_ARC="${XEYES}.tar.gz"
    XEYES_URI="https://xorg.freedesktop.org/archive/individual/app/${XEYES_ARC}"

    # Download source
    [ -f $XEYES_ARC ] || wget $XEYES_URI

    # Extract source
    if [ -d $XEYES ]; then
        echo -e "${YELLOW}xeyes' source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $XEYES
    fi
    tar xf $XEYES_ARC
    cd $XEYES

    # Compile and install
    echo -e "${GREEN}Compiling xeyes...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --x-includes="$SYSROOT/usr/include" --x-libraries="$SYSROOT/usr/lib" CC="$CC_STATIC" LIBS="-lXaw7 -lXmu -lXpm -lXt -lSM -lICE -lXext -lX11 -lxcb -lXau -lXdmcp"
    make -j$(nproc)
    make DESTDIR="$DESTDIR" install
}

get_xli()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/xli" ]; then
        echo -e "${LIGHT_RED}xli already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d xli ]; then
        echo -e "${YELLOW}xli source already present, resetting...${RESET}"
        git config --global --add safe.directory "$CURR_DIR/build/xli"
        cd xli
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading xli...${RESET}"
        git clone https://github.com/openSUSE/xli.git
        cd xli
    fi

    # Patch to remove JPEG support
    sudo sed -i -e 's/jpeg\.c//g' -e 's/jpeg\.o//g' -e 's/rle\.c//g' -e 's/rle\.o//g' -e 's/rlelib\.c//g' -e 's/rlelib\.o//g' Makefile.std
    sudo sed -i '/jpegIdent/d' imagetypes.c
    sudo sed -i '/jpegLoad/d' imagetypes.c
    sudo sed -i '/rleIdent/d' imagetypes.c
    sudo sed -i '/rleLoad/d' imagetypes.c

    # Patch to add missing string.h headers in various files
    sudo sed -i '1i #include <string.h>' ddxli.c pcd.c png.c zoom.c

    # Patch to disable gamma correction logic
    sudo sed -i 's/make_gamma(/ \/\/ make_gamma(/g' bright.c send.c
    sudo sed -i 's/gammacorrect(/ \/\/ gammacorrect(/g' xli.c

    # Patch to add explicit linking of X11 components
    sudo sed -i -e 's/^LIBS=.*/LIBS= -lX11 -lXext -lxcb -lXau -lXdmcp -lpng -lz -lm/' Makefile.std
    sudo sed -i -e 's/^\t$(MAKE) all CC=/\t$(MAKE) CC=/' Makefile.std
  
    # Compile and install
    echo -e "${GREEN}Compiling xli...${RESET}"
    make -f Makefile.std all CC="${CC_STATIC}" CFLAGS="-I${PREFIX}/include -DSYSPATHFILE=\\\"/usr/lib/X11/Xli\\\" -DNO_JPEG" LDFLAGS="-L${PREFIX}/lib"
    install -Dm755 xli "$DESTDIR/usr/bin/xli"
}

get_xload()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/xload" ]; then
        echo -e "${LIGHT_RED}xload already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xload...${RESET}"

    XLOAD="xload-1.2.0"
    XLOAD_ARC="${XLOAD}.tar.gz"
    XLOAD_URI="https://xorg.freedesktop.org/archive/individual/app/${XLOAD_ARC}"

    # Download source
    [ -f $XLOAD_ARC ] || wget $XLOAD_URI

    # Extract source
    if [ -d $XLOAD ]; then
        echo -e "${YELLOW}xload's source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $XLOAD
    fi
    tar xf $XLOAD_ARC
    cd $XLOAD

    # Patch to avoid "setgid failed: function not implemented" error
    sudo sed -i '/^#if !defined(_WIN32) || defined(__CYGWIN__)/,/^#endif/d' xload.c

    # Compile and install
    echo -e "${GREEN}Compiling xload...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --disable-shared --enable-static --x-includes="$SYSROOT/usr/include" --x-libraries="$SYSROOT/usr/lib" CC="$CC_STATIC" LIBS="-lXaw7 -lXmu -lXpm -lXt -lSM -lICE -lXext -lX11 -lxcb -lXau -lXdmcp"
    make -j$(nproc)
    make DESTDIR="$DESTDIR" install
}

get_xset()
{
    cd "$CURR_DIR/build"

    # Skip if already built
    if [ -f "$DESTDIR/usr/bin/xset" ]; then
        echo -e "${LIGHT_RED}xset already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading xset...${RESET}"

    XSET="xset-1.2.5"
    XSET_ARC="${XSET}.tar.gz"
    XSET_URI="https://xorg.freedesktop.org/archive/individual/app/${XSET_ARC}"

    # Download source
    [ -f $XSET_ARC ] || wget $XSET_URI

    # Extract source
    if [ -d $XSET ]; then
        echo -e "${YELLOW}xset' source archive is already present, re-extracting before proceeding...${RESET}"
        rm -r $XSET
    fi
    tar xf $XSET_ARC
    cd $XSET

    # Compile and install
    echo -e "${GREEN}Compiling xset...${RESET}"
    ./configure --host="$HOST" --prefix=/usr --x-includes="$SYSROOT/usr/include" --x-libraries="$SYSROOT/usr/lib" CC="$CC_STATIC" LIBS="-lxcb -lXau -lXdmcp"
    make -j$(nproc)
    make DESTDIR="$DESTDIR" install
}



######################################################
## Console cosmetics                                ##
######################################################

# Download and install console fonts
get_console_fonts()
{
    cd $CURR_DIR/build

    echo -e "${GREEN}Installing console fonts...${RESET}"

    FONTS+=(
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat2-Fixed13.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat2-Fixed14.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat2-Fixed16.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat2-Fixed18.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat7-Fixed13.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat7-Fixed14.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat7-Fixed16.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat7-Fixed18.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat15-Fixed13.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat15-Fixed14.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat15-Fixed16.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat15-Fixed18.psf"

        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat2-Terminus14.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat2-Terminus16.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat7-Terminus14.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat7-Terminus16.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat15-Terminus14.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat15-Terminus16.psf"

        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat2-VGA8.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat2-VGA14.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat2-VGA16.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat7-VGA8.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat7-VGA14.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat7-VGA16.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat15-VGA8.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat15-VGA14.psf"
        "https://www.zap.org.au/projects/console-fonts-distributed/psftx-debian-13.4/Lat15-VGA16.psf"
    )

    mkdir -p $DESTDIR/usr/share/consolefonts
    for FONT in "${FONTS[@]}"; do
        BASE="$(basename "$FONT")"
        DEST="$DESTDIR/usr/share/consolefonts/$BASE"

        if [ -f "$DEST" ]; then
            echo -e "${LIGHT_RED}$BASE font already installed, skipping...${RESET}"
            continue
        fi
        sudo wget $FONT -O $DEST
    done

    # Download Terminus' licence file
    TERMINUS_MIRRORS=(
        "https://altushost-bul.dl.sourceforge.net/project/terminus-font/terminus-font-4.49"
        "https://altushost-swe.dl.sourceforge.net/project/terminus-font/terminus-font-4.49"
        "https://sf-eu-introserv-3.dl.sourceforge.net/project/terminus-font/terminus-font-4.49"
    )
    TERMINUS_ARC="terminus-font-4.49.1.tar.gz"

    if [ ! -f "$TERMINUS_ARC" ]; then
        for MIRROR in "${TERMINUS_MIRRORS[@]}"; do
            if wget --timeout=5 --tries=1 "$MIRROR/$TERMINUS_ARC"; then
                break
            fi
        done
    fi

    cd $DESTDIR
}



######################################################
## Bundled software building                        ##
######################################################

# Download a program from a Git repository and compile with configure
get_prog_git()
{
    cd "$CURR_DIR/build"

    local BIN_DIR="$1"
    local TEST_BIN="$2"
    local NAME="$3"
    local GIT_DIR="$4"
    local SRC="$5"
    local VER="$6"
    local PATCH_FILE="$7"
    local AUTOGEN=$8
    local AUTORECONF=$9
    local CONFIGURE_PREFIX="${10}" 
    local CONFIGURE="${11}"

    if [ -n "$CONFIGURE_PREFIX" ]; then
        CONFIGURE_PREFIX=("--prefix=${CONFIGURE_PREFIX}")
    fi

    local CONFIGURE_ARR=()
    eval "CONFIGURE_ARR=($CONFIGURE)"

    # Skip if already compiled
    if [ -f "$DESTDIR/$BIN_DIR/$TEST_BIN" ]; then
        echo -e "${LIGHT_RED}$NAME already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d $GIT_DIR ]; then
        echo -e "${YELLOW}$NAME source already present, resetting & cleaning...${RESET}"
        cd $GIT_DIR
        git config --global --add safe.directory "$CURR_DIR/build/$GIT_DIR"
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading $NAME...${RESET}"
        git clone --branch $VER $SRC
        cd $GIT_DIR
    fi

    if [ -n "$PATCH_FILE" ]; then
        patch -p1 < "${PATCHES_DIR}/${PATCH_FILE}"
    fi

    # Compile program
    echo -e "${GREEN}Compiling $NAME...${RESET}"
    if $AUTOGEN; then
        ./autogen.sh
    fi
    if $AUTORECONF; then
        autoreconf -fi
    fi
    if [ -x ./configure ] || [ -f ./configure ]; then
        ./configure \
            --host=${HOST} \
            "${CONFIGURE_PREFIX}" \
            "${CONFIGURE_ARR[@]}" \
            CC="${CC_STATIC}" \
            AR="${AR}" \
            RANLIB="${RANLIB}" \
            STRIP="${STRIP}" \
            CFLAGS="-Os -march=${ARCH} -mno-fancy-math-387 -ffunction-sections -fdata-sections -I${PREFIX}/include -I${PREFIX}/include/ncursesw" \
            CPPFLAGS="-I${SYSROOT}/include -I${PREFIX}/include -I${PREFIX}/include/ncursesw -DHAVE_FORKPTY" \
            LDFLAGS="-static -Wl,--gc-sections -s -L${PREFIX}/lib" \
            LIBEVENT_CFLAGS="-I${PREFIX}/include" \
            LIBEVENT_LIBS="-L${PREFIX}/lib -levent" \
            CURSES_CFLAGS="-I${PREFIX}/include/ncursesw -I${PREFIX}/include" \
            CURSES_LIBS="-L${PREFIX}/lib -lncursesw"
    fi
    make -j$(nproc)
    sudo make DESTDIR=$DESTDIR install
}

# Download a program from a tarball source and compile with configure
get_prog_tar()
{
    cd "$CURR_DIR/build"

    local BIN_DIR="$1"
    local TEST_BIN="$2"
    local NAME="$3"
    local SRC_DIR="$4"
    local ARC_EXT="$5"
    local SRC_URI="$6"
    local TAR_CMD="$7"
    local AUTOGEN=$8
    local AUTORECONF=$9
    local CONFIGURE_PREFIX="${10}" 
    local CONFIGURE="${11}"

    if [ -n "$CONFIGURE_PREFIX" ]; then
        CONFIGURE_PREFIX=("--prefix=${CONFIGURE_PREFIX}")
    fi

    local CONFIGURE_ARR=()
    eval "CONFIGURE_ARR=($CONFIGURE)"

    # Skip if already compiled
    if [ -f "$DESTDIR/$BIN_DIR/$TEST_BIN" ]; then
        echo -e "${LIGHT_RED}$NAME already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading $NAME...${RESET}"

    ARC="${SRC_DIR}.${ARC_EXT}"
    URI="${SRC_URI}/${ARC}"

    # Download source
    [ -f $ARC ] || wget $URI

    # Extract source
    if [ -d $SRC_DIR ]; then
        echo -e "${YELLOW}$NAME's source archive is already present, re-extracting before proceeding...${RESET}"
        sudo rm -rf $SRC_DIR
    fi
    tar $TAR_CMD $ARC
    cd $SRC_DIR

    # Compile program
    echo -e "${GREEN}Compiling $NAME...${RESET}"
    if $AUTOGEN; then
        ./autogen.sh
    fi
    if $AUTORECONF; then
        autoreconf -fi
    fi
    if [ -x ./configure ] || [ -f ./configure ]; then
        ./configure \
            --host=${HOST} \
            "${CONFIGURE_PREFIX}" \
            "${CONFIGURE_ARR[@]}" \
            CC="${CC_STATIC}" \
            AR="${AR}" \
            RANLIB="${RANLIB}" \
            STRIP="${STRIP}" \
            CFLAGS="-Os -march=${ARCH} -mno-fancy-math-387 -ffunction-sections -fdata-sections -I${PREFIX}/include -I${PREFIX}/include/ncursesw" \
            CPPFLAGS="-I${SYSROOT}/include -I${PREFIX}/include -I${PREFIX}/include/ncursesw -DHAVE_FORKPTY" \
            LDFLAGS="-static -Wl,--gc-sections -s -L${PREFIX}/lib" \
            LIBEVENT_CFLAGS="-I${PREFIX}/include" \
            LIBEVENT_LIBS="-L${PREFIX}/lib -levent" \
            CURSES_CFLAGS="-I${PREFIX}/include/ncursesw -I${PREFIX}/include" \
            CURSES_LIBS="-L${PREFIX}/lib -lncursesw"
    fi
    make -j$(nproc)
    sudo make DESTDIR=$DESTDIR install
}

# Download and compile Dropbear
get_dropbear()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/ssh" ]; then
        echo -e "${LIGHT_RED}Dropbear already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d dropbear ]; then
        echo -e "${YELLOW}Dropbear source already present, resetting...${RESET}"
        cd dropbear
        git config --global --add safe.directory "$CURR_DIR/build/dropbear"
        git reset --hard
    else
        echo -e "${GREEN}Downloading Dropbear...${RESET}"
        git clone --branch DROPBEAR_${DROPBEAR_VER} $DROPBEAR_SRC
        cd dropbear
    fi

    # Compile and install
    echo -e "${GREEN}Compiling Dropbear...${RESET}"
    unset LIBS
    ./configure --host=${HOST} --prefix=/usr --disable-zlib --disable-loginfunc --disable-syslog --disable-lastlog --disable-utmp --disable-utmpx --disable-wtmp --disable-wtmpx CC="${CC}" AR="${AR}" RANLIB="${RANLIB}" CFLAGS="-Os -march=${ARCH} -static" LDFLAGS="-static"
    make PROGRAMS="dbclient scp" -j$(nproc)
    sudo make DESTDIR=$DESTDIR install PROGRAMS="dbclient scp"
    sudo mv "$DESTDIR/usr/bin/dbclient" "$DESTDIR/usr/bin/ssh"
}

# Download and compile file
get_file()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/file" ]; then
        echo -e "${LIGHT_RED}file already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d file ]; then
        echo -e "${YELLOW}file source already present, resetting...${RESET}"
        cd file
        git config --global --add safe.directory $CURR_DIR/build/file
        git reset --hard
    else
        echo -e "${GREEN}Downloading file...${RESET}"
        git clone --branch "FILE$FILE_VER" $FILE_SRC
        cd file
    fi

    # Prune magic database of "non-essential" categories to save space
    CULL_LIST="acorn adi adventure algol68 amigaos apple aria asf bioinformatics blackberry c64 claris clojure console convex dolby epoc erlang forth frame freebsd games geo hp ispell lif mach macintosh map mathematica mercurial mips nasa netbsd netscape ole2compounddocs pc98 pdp scientific sniffer spectrum statistics sun sysex ti-8x tplink vacuum-cleaner wordpress xenix zyxel"
    for TO_CULL in $CULL_LIST; do
        if [ -f "$CURR_DIR/build/file/magic/Magdir/$TO_CULL" ]; then
            truncate -s 0 "$CURR_DIR/build/file/magic/Magdir/$TO_CULL"
        fi
    done

    # Compile and install
    echo -e "${GREEN}Compiling file...${RESET}"
    autoreconf -fiv
    ./configure \
        --host=${HOST} \
        --prefix=/usr \
        --disable-shared \
        --enable-static \
        CC="${CC_STATIC}" \
        AR="${AR}" \
        RANLIB="${RANLIB}" \
        CFLAGS="-Os -march=${ARCH} -D__NR_landlock_create_ruleset=444 -D__NR_landlock_add_rule=445 -D__NR_landlock_restrict_self=446" \
        LDFLAGS="-static"
    make -j$(nproc)
    sudo make DESTDIR=$DESTDIR install
}

# Download and extract GCC + musl
get_gcc()
{
    cd "$CURR_DIR/build"

    # Skip if already extracted
    if [ -d "$DESTDIR/opt/${ARCH}-linux-musl-native" ]; then
        echo -e "${LIGHT_RED}${ARCH}-linux-musl-native already extracted, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading ${ARCH}-linux-musl-native...${RESET}"

    DIR="${ARCH}-linux-musl-native"
    ARC="${DIR}.tgz"
    URI="${GCC_SRC}/${ARC}"

    # Download
    [ -f $ARC ] || wget $URI

    # Extract
    if [ -d "$DESTDIR/opt/$DIR" ]; then
        echo -e "${YELLOW}${ARCH}-linux-musl-native's archive is already present, re-extracting...${RESET}"
        sudo rm -rf "$DESTDIR/opt/$DIR"
    fi
    mkdir -p $DESTDIR/opt
    tar xzf $ARC -C $DESTDIR/opt

    # Symlink all shared libraries so they're discoverable without needing a
    # custom library path
    mkdir -p $DESTDIR/lib
    for f in $DESTDIR/opt/${ARCH}-linux-musl-native/lib/*.so*; do
        [ -e "$f" ] || continue
        target="${f#$DESTDIR}"
        ln -sf "$target" "$DESTDIR/lib/"
    done
    ln -sf /opt/i486-linux-musl-native/lib/libc.so "${DESTDIR}/lib/ld-musl-i386.so.1"
}

# Download and compile Git
get_git()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/git" ]; then
        echo -e "${LIGHT_RED}Git already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d git ]; then
        echo -e "${YELLOW}Git source already present, resetting...${RESET}"
        cd git
        git config --global --add safe.directory "$CURR_DIR/build/git"
        git reset --hard
    else
        echo -e "${GREEN}Downloading Git...${RESET}"
        git clone --branch "v${GIT_VER}" $GIT_SRC
        cd git
    fi

    # Compile and install
    echo -e "${GREEN}Compiling Git...${RESET}"
    make configure
    ./configure \
        --host=${HOST} \
        --prefix=/usr \
        CC="${CC}" \
        AR="${AR}" \
        RANLIB="${RANLIB}" \
        CFLAGS="-Os -march=${ARCH} -static -I${PREFIX}/include" \
        LDFLAGS="-static -L${PREFIX}/lib"
    sudo cp $CONFIGS_DIR/git.config.mak config.mak
    make NO_RUST=1 -j$(nproc)
    sudo make NO_RUST=1 DESTDIR=$DESTDIR install
}

# Download and compile htop
get_htop()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/htop" ]; then
        echo -e "${LIGHT_RED}htop already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d htop ]; then
        echo -e "${YELLOW}htop source already present, resetting...${RESET}"
        cd htop
        git config --global --add safe.directory "$CURR_DIR/build/htop"
        git reset --hard
    else
        echo -e "${GREEN}Downloading htop...${RESET}"
        git clone --branch "${HTOP_VER}" $HTOP_SRC
        cd htop
    fi

    # Compile and install
    echo -e "${GREEN}Compiling htop...${RESET}"
    ./autogen.sh
    ./configure --host=${HOST} --prefix=/usr CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" CFLAGS="-Os -march=${ARCH} -I${PREFIX}/include -I${PREFIX}/include/ncursesw" LDFLAGS="-static -L${PREFIX}/lib"
    make -j$(nproc)
    sudo cp htop $DESTDIR/usr/bin
}

# Download and compile hwinfo
get_hwinfo()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/hwinfo" ]; then
        echo -e "${LIGHT_RED}hwinfo already compiled, skipping...${RESET}"
        #return
    fi

    # Download source
    if [ -d hwinfo ]; then
        echo -e "${YELLOW}hwinfo source already present, resetting...${RESET}"
        cd hwinfo
        git config --global --add safe.directory "$CURR_DIR/build/hwinfo"
        git reset --hard
    else
        echo -e "${GREEN}Downloading hwinfo...${RESET}"
        git clone --branch "${HWINFO_VER}" $HWINFO_SRC
        cd hwinfo
    fi

    # Compile and install
    echo -e "${GREEN}Compiling hwinfo...${RESET}"
    make \
        CC="${CC_STATIC}" \
        AR="${AR}" \
        RANLIB="${RANLIB}" \
        STRIP="${STRIP}" \
        SYSROOT="${SYSROOT}" \
        ENABLE_ISDN=0 \
        ENABLE_HAL=1 \
        ENABLE_SYSFS=1 \
        ENABLE_UDEV=1 \
        ENABLE_X86EMU=1
        -j$(nproc)
    sudo make DESTDIR=$DESTDIR install
}

# Download and compile JOE
get_joe()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/joe" ]; then
        echo -e "${LIGHT_RED}Lynx already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d joe ]; then
        echo -e "${YELLOW}JOE source already present, resetting...${RESET}"
        cd joe
        git config --global --add safe.directory "$CURR_DIR/build/joe"
        git reset --hard
    else
        echo -e "${GREEN}Downloading JOE...${RESET}"
        git clone --branch "releases/joe-${JOE_VER}" $JOE_SRC
        cd joe
    fi

    # Use freopen instead of fclose on stdin since the latter is not compatible
    # with musl
    sed -i '/fclose(stdin);/!b;n;s/stdin = fopen/freopen/;s/);/, stdin);/' joe/main.c

    # Compile and install
    echo -e "${GREEN}Compiling JOE...${RESET}"
    autoreconf -fiv
    ./configure \
        --host=${HOST} \
        --prefix=/usr \
        --sysconfdir=/etc \
        CC="${CC_STATIC}"
    make -j$(nproc)
    sudo make DESTDIR=$DESTDIR install
}

# Download and compile lapifetch
get_lapifetch()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/local/bin/lapifetch" ]; then
        echo -e "${LIGHT_RED}lapifetch already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d lapifetch ]; then
        echo -e "${YELLOW}lapifetch source already present, resetting...${RESET}"
        cd lapifetch
        git config --global --add safe.directory "$CURR_DIR/build/lapifetch"
        git reset --hard
    else
        echo -e "${GREEN}Downloading lapifetch...${RESET}"
        git clone https://github.com/asunyan-dev/lapifetch.git
        cd lapifetch
    fi

    sed -i 's/^install: all$/install:/' Makefile
    sed -i '1s/^/DESTDIR =\n\n/' Makefile
    sed -i 's|cp $(TARGET) /usr/local/bin|cp $(TARGET) $(DESTDIR)/usr/local/bin|' Makefile
    sed -i 's|rm -f /usr/local/bin/$(TARGET)|rm -f $(DESTDIR)/usr/local/bin/$(TARGET)|' Makefile

    # Compile and install
    echo -e "${GREEN}Compiling lapifetch...${RESET}"
    make -j$(nproc) CXX="${CXX_STATIC}"
    sudo make DESTDIR=$DESTDIR install
}

# Download and compile Mg
get_mg()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/mg" ]; then
        echo -e "${LIGHT_RED}Mg already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d mg ]; then
        echo -e "${YELLOW}Mg source already present, resetting...${RESET}"
        cd mg
        git config --global --add safe.directory $CURR_DIR/build/mg
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading Mg...${RESET}"
        git clone --branch "v${MG_VER}" $MG_SRC
        cd mg
    fi

    # Patch to prevent "~" backup files from spawning after saving
    sudo sed -i 's/int	  	 nobackups = 0;/int	  	 nobackups = 1;/g' src/main.c

    # Remove tutorial hint as we will delete the docs later to save space
    sudo sed -i 's/| C-h t  tutorial//g' src/help.c

    # Compile and install
    echo -e "${GREEN}Compiling Mg...${RESET}"
    ./autogen.sh
    ./configure --host=${HOST} --prefix=/usr CC="${CC}" AR="${AR}" RANLIB="${RANLIB}" CFLAGS="-Os -march=${ARCH} -static"
    make -j$(nproc)
    sudo make DESTDIR=$DESTDIR install

    # Symlink emacs to mg
    ln -sf mg "$DESTDIR/usr/bin/emacs"
}

# Download and compile MicroPython
get_micropython()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/micropython" ]; then
        echo -e "${LIGHT_RED}MicroPython already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d micropython ]; then
        echo -e "${YELLOW}MicroPython source already present, resetting...${RESET}"
        cd micropython
        git config --global --add safe.directory $CURR_DIR/build/micropython
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading MicroPython...${RESET}"
        git clone --branch "v${MICROPYTHON_VER}" $MICROPYTHON_SRC
        cd micropython
    fi
    
    # Build prerequisites
    echo -e "${GREEN}Compiling mpy-cross...${RESET}"
    make -C mpy-cross

    # Compile and install
    echo -e "${GREEN}Compiling MicroPython...${RESET}"
    cd ports/unix
    make submodules
    make \
        CC="${CC_STATIC}" \
        AR="${AR}" \
        RANLIB="${RANLIB}" \
        STRIP="${STRIP}" \
        CFLAGS_EXTRA="-Os -march=${ARCH} -static --sysroot=${SYSROOT}" \
        LDFLAGS_EXTRA="-static --sysroot=${SYSROOT}" \
        MICROPY_PY_SSL=1 \
        MICROPY_SSL_MBEDTLS=1 \
        MICROPY_PY_ZLIB=1 \
        MICROPY_PY_THREAD=1 \
        MICROPY_PY_SOCKET=1 \
        MICROPY_PY_TERMIOS=1 \
        MICROPY_PY_FFI=0 \
        MICROPY_PY_BTREE=0 \
        VARIANT=standard
    install -d "${DESTDIR}/usr/bin"
    sudo install -m 755 build-standard/micropython "${DESTDIR}/usr/bin/micropython"

    # Symlink python and python3 to mg
    sudo ln -sf micropython "$DESTDIR/usr/bin/python"
    sudo ln -sf micropython "$DESTDIR/usr/bin/python3"
}

# Download and compile mpg321
get_mpg321()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/mpg321" ]; then
        echo -e "${LIGHT_RED}mpg321 already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d mpg321 ]; then
        echo -e "${YELLOW}mpg321 source already present, resetting...${RESET}"
        cd mpg321
        git config --global --add safe.directory $CURR_DIR/build/mpg321
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading mpg321...${RESET}"
        git clone $MPG321_SRC
        cd mpg321
        git checkout $MPG321_VER
    fi

    # Its config.sub is too old to recognise musl
    cp "${CURR_DIR}/compilation/config.guess" config.guess
    cp "${CURR_DIR}/compilation/config.sub" config.sub

    # Prevent make from trying to regenerate autotools files
    touch aclocal.m4 configure config.h.in Makefile.in

    # Patch out need for libao
    patch -p1 < "${PATCHES_DIR}/mpg321/0.3.2-1_libao_bypass.patch"

    # Compile and install
    echo -e "${GREEN}Compiling mpg321...${RESET}"
    ./configure \
        --host=$HOST \
        --build=x86_64-linux-gnu \
        --prefix=/usr \
        --enable-alsa=no \
        --with-default-audio=oss \
        AR=$AR \
        CC=$CC_STATIC \
        RANLIB=$RANLIB \
        CPPFLAGS="-nostdinc -I$SYSROOT/usr/include -I$SYSROOT/include -I${PREFIX}/lib/gcc/i486-linux-musl/11.2.1/include" \
        CFLAGS="-static -fcommon -std=gnu89" \
        LDFLAGS="-static -L$SYSROOT/usr/lib" \
        LIBAO_LIBS="-L$SYSROOT/usr/lib -lao" \
        LIBAO_CFLAGS="-I$SYSROOT/usr/include" \
        PKG_CONFIG_PATH="$SYSROOT/usr/lib/pkgconfig" \
        PKG_CONFIG_LIBDIR="$SYSROOT/usr/lib/pkgconfig" \
        PKG_CONFIG_SYSROOT_DIR="$SYSROOT" \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes

    sed -i "s|-L/usr/lib -lao|-L${SYSROOT}/usr/lib -lao|g" Makefile

    make -j$(nproc)
    sudo make DESTDIR=$DESTDIR install
}

# Download and compile nano
get_nano()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/nano" ]; then
        echo -e "${LIGHT_RED}nano already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading nano...${RESET}"
    
    NANO="nano-${NANO_VER}"
    NANO_ARC="${NANO}.tar.xz"
    NANO_URI="${NANO_SRC}/${NANO_DIST}/${NANO_ARC}"

    # Download source
    [ -f $NANO_ARC ] || wget $NANO_URI

    # Extract source
    if [ -d $NANO ]; then
        echo -e "${YELLOW}nano's source archive is already present, re-extracting before proceeding...${RESET}"
        sudo rm -rf $NANO
    fi
    tar xf $NANO_ARC
    cd $NANO

    # Compile program
    echo -e "${GREEN}Compiling nano...${RESET}"

    # In case "cannot find -ltinfo" error 
    find . -name config.cache -delete
    export ac_cv_search_tigetstr='-lncursesw'
    export ac_cv_lib_tinfo_tigetstr='no'
    export LIBS="-lncursesw"

    ./configure --cache-file=/dev/null --host=${HOST} --prefix=/usr --enable-utf8 --enable-color --disable-nls --disable-speller --disable-browser --disable-libmagic --disable-justify --disable-wrapping CC="${CC}" CFLAGS="-Os -march=${ARCH} -mno-fancy-math-387 -I${PREFIX}/include -I${PREFIX}/include/ncursesw" LDFLAGS="-static -L${PREFIX}/lib"

    # In case "cannot find -ltinfo" error 
    grep -rl "\-ltinfo" . | xargs -r sed -i 's/-ltinfo//g' 2>/dev/null || true
    grep -rl "TINFO_LIBS" . | xargs -r sed -i 's/TINFO_LIBS.*/TINFO_LIBS = /' 2>/dev/null || true

    make TINFO_LIBS="" -j$(nproc)
    sudo make DESTDIR=$DESTDIR install
}

# Download and compile NASM
get_nasm()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/nasm" ]; then
        echo -e "${LIGHT_RED}NASM already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d nasm ]; then
        echo -e "${YELLOW}NASM source already present, resetting...${RESET}"
        cd nasm
        git config --global --add safe.directory "$CURR_DIR/build/nasm"
        git reset --hard
    else
        echo -e "${GREEN}Downloading NASM...${RESET}"
        git clone --branch "nasm-${NASM_VER}" $NASM_SRC
        cd nasm
    fi

    # Compile and install
    echo -e "${GREEN}Compiling NASM...${RESET}"
    ./autogen.sh
    ./configure \
        --host=${HOST} \
        --prefix=/usr \
        CC="${CC_STATIC}" \
        CFLAGS="-I${PREFIX}/include" \
        LDFLAGS="-L${PREFIX}/lib -static"
    make -j$(nproc)
    sudo install -D -m 755 nasm "$DESTDIR/usr/bin/nasm"
    sudo install -D -m 755 ndisasm "$DESTDIR/usr/bin/ndisasm"
}

# Download and compile sc-im
get_sc_im()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/sc-im" ]; then
        echo -e "${LIGHT_RED}sc-im already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d sc-im ]; then
        echo -e "${YELLOW}sc-im source already present, resetting...${RESET}"
        cd sc-im
        git config --global --add safe.directory $CURR_DIR/build/sc-im
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading sc-im...${RESET}"
        git clone --branch "v${SC_IM_VER}" $SC_IM_SRC
        cd sc-im
    fi

    # Compile and install
    echo -e "${GREEN}Compiling sc-im...${RESET}"

    # Compile with necessary include paths and static libraries
    echo 'char *curfile = NULL;' >> src/main.c
    echo "extern char * curfile;" >> src/sc.h

    make -C src \
        CC="$CC_STATIC" \
        CFLAGS="-static -O2 -I${PREFIX}/include -I${PREFIX}/include/ncursesw -I${PREFIX}/include/libxml2 \
            -DNCURSES -D_XOPEN_SOURCE_EXTENDED -D_GNU_SOURCE \
            -DSNAME=\\\"sc-im\\\" -DHELP_PATH=\\\"/usr/share/sc-im\\\" \
            -DCONFIG_DIR=\\\".config/sc-im\\\" -DCONFIG_FILE=\\\"scimrc\\\" \
            -DHISTORY_DIR=\\\".cache\\\" -DHISTORY_FILE=\\\"sc-iminfo\\\" \
            -DUSECOLORS -DUNDO -DMAXROWS=65536 \
            -DXLSX -DODS -DXLSX_EXPORT" \
        LDLIBS="-lxlsxwriter -lxml2 -lzip -lz -lm -lncursesw -ltinfo -lpthread" \
        LDFLAGS="-static -L${PREFIX}/lib" \
        -j$(nproc)
    sudo make -C src DESTDIR="$DESTDIR" prefix=/usr install
}

# Download and compile Tiny C Compiler
get_tcc()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/local/bin/i386-tcc" ]; then
        echo -e "${LIGHT_RED}Tiny C Compiler already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d tinycc-mirror-repository ]; then
        echo -e "${YELLOW}Tiny C Compiler source already present, resetting...${RESET}"
        cd tinycc-mirror-repository
        git config --global --add safe.directory "$CURR_DIR/build/tinycc-mirror-repository"
        git reset --hard
    else
        echo -e "${GREEN}Downloading Tiny C Compiler...${RESET}"
        git clone $TCC_SRC
        cd tinycc-mirror-repository
        git checkout $TCC_VER
    fi

    sed -i 's|i386-linux-gnu|local/musl|g' Makefile
    sed -i 's|/lib/ld-linux.so.2|/lib/ld-musl-i386.so.1|g' tcc.h

    # Patch to fix "undefined symbol '__udivmoddi4'"" error
    sed -i 's/^static[[:space:]]\+UDWtype __udivmoddi4/UDWtype __udivmoddi4/' lib/libtcc1.c
    
    # Compile and install
    echo -e "${GREEN}Compiling Tiny C Compiler...${RESET}"
    ./configure --cpu=i386 --cc=$CC_STATIC --enable-cross --enable-static
    sudo make cross-i386 -j$(nproc)
    sudo make DESTDIR=$DESTDIR install
    
    ln -sf /usr/local/bin/i386-tcc $DESTDIR/usr/bin/tcc || true
}

# Download and compile tilde (WIP)
# Once done, uncomment relevant part of get_installed_programs_features
get_tilde()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/tilde" ]; then
        echo -e "${LIGHT_RED}tilde already compiled, skipping...${RESET}"
        #return
    fi

    # The components we need to download and compile for tilde - the order
    # matters!
    TILDE_CMPS=(
        "libunistring       ${LIBUNISTRING_VER}"
        "libtranscript      ${LIBTRANSCRIPT_VER}"
        "libt3config        ${LIBT3CONFIG_VER}"
        "libt3key           ${LIBT3KEY_VER}"
        "libt3window        ${LIBT3WINDOW_VER}"
        "pcre2              ${PCRE2_VER}"
        "libt3widget        ${LIBT3WIDGET_VER}"
        "libt3highlight     ${LIBT3HIGHLIGHT_VER}"
        "tilde              ${TILDE_VER}"
    )

    # We symlinked various cross-compiler components under generic names
    # because tilde/tilde component's build system looks for these
    # specifically; without them, it tries to use the host's versions
    mkdir -p "$CURR_DIR/build/fake-tools"
    ln -sf "$CC"  "$CURR_DIR/build/fake-tools/gcc"
    ln -sf "$CXX" "$CURR_DIR/build/fake-tools/g++"
    ln -sf "$LD"  "$CURR_DIR/build/fake-tools/ld"
    cp "$CURR_DIR/compilation/i486-linux-musl-pkg-config" "$CURR_DIR/build/fake-tools/"
    sudo ln -sf $(which libtool) /usr/local/bin/i486-linux-musl-libtool

    export PATH="$CURR_DIR/build/fake-tools:$PATH"
    mkdir -p staging/usr/lib/pkgconfig
    mkdir -p staging/usr/include

    # Try telling pkg-config to only search our staging sysroot. We had issue
    # using our usual sysroot.
    export PKG_CONFIG_PATH="${DESTDIR}/usr/lib/pkgconfig:${CURR_DIR}/build/staging/usr/lib/pkgconfig"
    export PKG_CONFIG_LIBDIR="${DESTDIR}/usr/lib/pkgconfig:${CURR_DIR}/build/staging/usr/lib/pkgconfig"
    export PKG_CONFIG_SYSROOT_DIR="${CURR_DIR}/build/staging"

    CFLAGS="--sysroot=${SYSROOT} -I${DESTDIR}/usr/include -I${CURR_DIR}/build/staging/usr/include -I${PREFIX}/include -I${PREFIX}/include/ncursesw --static"
    LDFLAGS="--sysroot=${SYSROOT} -L${DESTDIR}/usr/lib -L${CURR_DIR}/build/staging/usr/lib -L${PREFIX}/lib --static"

    # Download and compile each component
    for CMP in "${TILDE_CMPS[@]}"; do
        CMP_NAME=""
        CMP_VER=""
        read -r CMP_NAME CMP_VER <<< "$CMP"

        echo -e "${GREEN}Downloading ${CMP_NAME}...${RESET}"
        CMP_DIR="$CMP_NAME-$CMP_VER"

        # The components come from different sources
        if [ "$CMP_NAME" = "libunistring" ]; then
            CMP_ARC="$CMP_NAME-$CMP_VER.tar.gz"
            CMP_URI="${LIBUNISTRING_SRC}/${CMP_ARC}"
        elif [ "$CMP_NAME" = "pcre2" ]; then
            CMP_ARC="$CMP_NAME-$CMP_VER.tar.gz"
            CMP_URI="${PCRE2_SRC}/${CMP_NAME}-${CMP_VER}/${CMP_ARC}"
        else
            CMP_ARC="$CMP_NAME-$CMP_VER.tar.bz2"
            CMP_URI="${LIBT3_SRC}/${CMP_ARC}"
        fi

        # Download source
        [ -f $CMP_ARC ] || wget $CMP_URI

        # Extract source
        if [ -d $CMP_DIR ]; then
            echo -e "${YELLOW}${CMP_NAME}'s source archive is already present, re-extracting before proceeding...${RESET}"
            sudo rm -rf $CMP_DIR
        fi
        if [ "$CMP_NAME" = "libunistring" ] || [ "$CMP_NAME" = "pcre2" ]; then
            tar xzf $CMP_ARC
        else
            tar xjf $CMP_ARC
        fi

        cd $CMP_DIR

        # Compile and install
        echo -e "${GREEN}Compiling ${CMP_NAME}...${RESET}"
        ./configure \
            --host=i486-linux-musl \
            --prefix=/usr \
            --enable-static \
            --disable-shared \
            CC="${CC}" \
            CXX="${CXX}" \
            AR="${AR}" \
            LD="${LD}" \
            RANLIB="${RANLIB}" \
            CFLAGS="$CFLAGS" \
            CXXFLAGS="$CFLAGS" \
            LDFLAGS="$LDFLAGS"

        if [ "$CMP_NAME" = "tilde" ]; then
            make -j$(nproc)
            sudo make DESTDIR="${DESTDIR}" install
        elif [ "$CMP_NAME" = "libtranscript" ]; then
            # If we tried compiling and installing this normally, the linkltc
            # utility would also be attempted and would fail in a static
            # cross-compile. Thus, we just compile the lib target and install
            # what we need manually.
            make -j$(nproc) lib
            mkdir -p "${CURR_DIR}/build/staging/usr/include/transcript"
            cp src/*.h "${CURR_DIR}/build/staging/usr/include/transcript/"
            install -D "${CURR_DIR}/build/${CMP_DIR}/libtranscript.pc" "${CURR_DIR}/build/staging/usr/lib/pkgconfig/libtranscript.pc"
            sed -i "s|prefix=/usr|prefix=${CURR_DIR}/build/staging/usr|" "${CURR_DIR}/build/staging/usr/lib/pkgconfig/libtranscript.pc"
        elif [ "$CMP_NAME" = "libt3highlight" ]; then
            # Similar to libtranscript...
            make -j$(nproc) lib
            mkdir -p "${CURR_DIR}/build/staging/usr/include/t3highlight"
            cp src/*.h "${CURR_DIR}/build/staging/usr/include/t3highlight/" 2>/dev/null || true

            # Install language definition files tilde needs at runtime
            sudo mkdir -p "${DESTDIR}/usr/share/libt3highlight0"
            find "${CURR_DIR}/build/${CMP_DIR}/src/data" -type f | while read F; do
                sudo install -m0644 "$F" "${DESTDIR}/usr/share/libt3highlight0/"
            done

            install -D "${CURR_DIR}/build/${CMP_DIR}/libt3highlight.pc" "${CURR_DIR}/build/staging/usr/lib/pkgconfig/libt3highlight.pc"
            sed -i "s|prefix=/usr|prefix=${CURR_DIR}/build/staging/usr|" "${CURR_DIR}/build/staging/usr/lib/pkgconfig/libt3highlight.pc"
        else
            make -j$(nproc)
            make DESTDIR="${CURR_DIR}/build/staging" install
            # Rewrite our libtool archives' libdir to our staging location so
            # libtool can resolve them properly when we compile the next
            # component
            find "${CURR_DIR}/build/staging/usr/lib" -name "${CMP_NAME}*.la" | while read LA; do
                sed -i "s|libdir='/usr/lib'|libdir='${CURR_DIR}/build/staging/usr/lib'|g" "$LA"
                sed -i "s|libdir=\"/usr/lib\"|libdir=\"${CURR_DIR}/build/staging/usr/lib\"|g" "$LA"
            done
        fi

        # Install install/lack of install results in now static archive of
        # libtool *.o being made, we'll do it outselves
        OBJS=$(find "${CURR_DIR}/build/${CMP_DIR}" -path "*/.libs/*.o" | tr '\n' ' ')
        $AR rcs "${CURR_DIR}/build/staging/usr/lib/${CMP_NAME}.a" $OBJS
        $RANLIB "${CURR_DIR}/build/staging/usr/lib/${CMP_NAME}.a"

        # In case a compilation only generated its .pc file in the build
        # directory install of installing it...
        if [ -f "${CURR_DIR}/build/${CMP_DIR}/${CMP_NAME}.pc" ]; then
            cp "${CURR_DIR}/build/${CMP_DIR}/${CMP_NAME}.pc" "${CURR_DIR}/build/staging/usr/lib/pkgconfig/"
            sed -i "s|prefix=/usr|prefix=${CURR_DIR}/build/staging/usr|" "${CURR_DIR}/build/staging/usr/lib/pkgconfig/${CMP_NAME}.pc"
        fi

        cd "$CURR_DIR/build"
    done
}

# Download and compile tn5250
get_tn5250()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/tn5250" ]; then
        echo -e "${LIGHT_RED}tn5250 already compiled, skipping...${RESET}"
        return
    fi

    # Download source
    if [ -d tn5250 ]; then
        echo -e "${YELLOW}tn5250 source already present, resetting & cleaning...${RESET}"
        cd tn5250
        git config --global --add safe.directory "$CURR_DIR/build/tn5250"
        git reset --hard
        git clean -fdx
    else
        echo -e "${GREEN}Downloading tn5250...${RESET}"
        git clone --branch "v${TN5250_VER}" $TN5250_SRC
        cd tn5250
    fi

    INTER_HEADERS="$($CC -print-file-name=include)"
    LIBATOMIC_A="$($CC -print-file-name=libatomic.a)"

    export CC="$CC"
    export CFLAGS="-static -fno-pie -fno-pic -D__gnuc_va_list=va_list -nostdinc -I${INTER_HEADERS} -I${PREFIX}/${ARCH}-linux-musl/include -I${PREFIX}/include -I${PREFIX}/include/ncursesw"
    export CPPFLAGS="$CFLAGS"
    export LDFLAGS="-static -static-libgcc -no-pie -Wl,-static -L${PREFIX}/lib -L${SYSROOT}/lib"

    # Compile and install
    ./autogen.sh
    ./configure \
        --host=${ARCH}-linux-musl \
        --prefix=/usr \
        --with-ssl="${SYSROOT}" \
        --disable-shared \
        --enable-static \
        AR="${AR}" \
        RANLIB="${RANLIB}" \
        LIBS="-lssl -lcrypto -lncursesw ${LIBATOMIC_A} -lpthread -ldl"
    make -j"$(nproc)"
    sudo make DESTDIR="$DESTDIR" install
}

# Download and compile tnftp
get_tnftp()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ -f "$DESTDIR/usr/bin/ftp" ]; then
        echo -e "${LIGHT_RED}tnftp already compiled, skipping...${RESET}"
        return
    fi

    echo -e "${GREEN}Downloading tnftp...${RESET}"

    TNFTP="tnftp-${TNFTP_VER}"
    TNFTP_ARC="${TNFTP}.tar.gz"
    TNFTP_URI="${TNFTP_SRC}/${TNFTP_ARC}"

    # Download source
    [ -f $TNFTP_ARC ] || wget $TNFTP_URI

    # Extract source
    if [ -d $TNFTP ]; then
        echo -e "${YELLOW}tnftp's source archive is already present, re-extracting before proceeding...${RESET}"
        sudo rm -rf $TNFTP
    fi
    tar xzf $TNFTP_ARC
    cd $TNFTP

    # Compile and install
    echo -e "${GREEN}Compiling tnftp...${RESET}"
    unset LIBS
    ./configure --host=${HOST} --prefix=/usr --disable-editcomplete --disable-shared --enable-static CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}" CFLAGS="-Os -march=${ARCH}" LDFLAGS=""
    make -j$(nproc)
    sudo make DESTDIR=$DESTDIR install
    ln -sf tnftp "$DESTDIR/usr/bin/ftp"
}



######################################################
## SHORK Utilities building & copying               ##
######################################################

# Download and copy shorkcommon-sh
get_shorkcommon_sh()
{
    cd "$CURR_DIR/build"

    # Skip if already copied
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/usr/bin/shorkcommon.sh" ]; then
        echo -e "${LIGHT_RED}shorkcommon-sh already copied, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorkcommon-sh ]; then
        echo -e "${YELLOW}shorkcommon-sh source already present, recloning...${RESET}"
        sudo rm -r shorkcommon-sh
    fi

    # Download source
    echo -e "${GREEN}Downloading shorkcommon-sh...${RESET}"
    git clone https://github.com/SharktasticA/shorkcommon-sh.git
    cd shorkcommon-sh

    # Copy
    echo -e "${GREEN}Copying shorkcommon-sh...${RESET}"
    sudo cp shorkcommon.sh $DESTDIR/usr/bin/shorkcommon.sh
}

# Download and compile shorkdir
get_shorkdir()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/usr/bin/shorkdir" ]; then
        echo -e "${LIGHT_RED}shorkdir already compiled, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorkdir ]; then
        echo -e "${YELLOW}shorkdir source already present, recloning...${RESET}"
        sudo rm -r shorkdir
    fi

    # Download source
    echo -e "${GREEN}Downloading shorkdir...${RESET}"
    git clone https://github.com/SharktasticA/shorkdir.git
    cd shorkdir

    # Compile and install
    echo -e "${GREEN}Compiling shorkdir...${RESET}"
    make -j$(nproc) CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}"
    sudo make DESTDIR=$DESTDIR install
}

# Download and compile shorkfetch
get_shorkfetch()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/usr/bin/shorkfetch" ]; then
        echo -e "${LIGHT_RED}shorkfetch already compiled, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorkfetch ]; then
        echo -e "${YELLOW}shorkfetch source already present, recloning...${RESET}"
        sudo rm -r shorkfetch
    fi

    # Download source
    echo -e "${GREEN}Downloading shorkfetch...${RESET}"
    git clone --branch "${SHORKFETCH_VER}" $SHORKFETCH_SRC
    cd shorkfetch

    # Compile and install
    echo -e "${GREEN}Compiling shorkfetch...${RESET}"
    make clean
    if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
        make -j$(nproc) CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}"
    elif [ "$ID" == "shork-diskette" ]; then
        make EMBEDDED=1 -j$(nproc) CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}"
    fi
    sudo make DESTDIR=$DESTDIR install
}

# Download and compile shorkhelp
get_shorkhelp()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/usr/bin/shorkhelp" ]; then
        echo -e "${LIGHT_RED}shorkhelp already compiled, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorkhelp ]; then
        echo -e "${YELLOW}shorkhelp source already present, recloning...${RESET}"
        sudo rm -r shorkhelp
    fi

    # Download source
    echo -e "${GREEN}Downloading shorkhelp...${RESET}"
    git clone https://github.com/SharktasticA/shorkhelp.git
    cd shorkhelp

    # Compile and install
    echo -e "${GREEN}Compiling shorkhelp...${RESET}"
    make clean
    make -j$(nproc) CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}"
    sudo make DESTDIR=$DESTDIR install

    # If SHORK DISKETTE, prune programs.csv of programs it never has
    if [ "$ID" == "shork-diskette" ]; then
        sudo sed -i '/,IsOptional,\|,0,busybox,\|,shorkutil,/!d' "$DESTDIR/usr/share/shorkhelp/programs.csv"
    fi
}

# Download and copy shorkoff
get_shorkoff()
{
    cd "$CURR_DIR/build"

    # Skip if already copied
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/sbin/shorkoff" ]; then
        echo -e "${LIGHT_RED}shorkoff already copied, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorkoff ]; then
        echo -e "${YELLOW}shorkoff source already present, recloning...${RESET}"
        sudo rm -r shorkoff
    fi

    # Download source
    echo -e "${GREEN}Downloading shorkoff...${RESET}"
    git clone https://github.com/SharktasticA/shorkoff.git
    cd shorkoff

    # Copy
    echo -e "${GREEN}Copying shorkoff...${RESET}"
    sudo cp shorkoff.486 $DESTDIR/sbin/shorkoff
    sudo chmod +x $DESTDIR/sbin/shorkoff
}

# Download and compile shorkset
get_shorkset()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/usr/libexec/shorkset" ]; then
        echo -e "${LIGHT_RED}shorkset already compiled, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorkset ]; then
        echo -e "${YELLOW}shorkset source already present, recloning...${RESET}"
        sudo rm -r shorkset
    fi

    # Download source
    echo -e "${GREEN}Downloading shorkset...${RESET}"
    git clone https://github.com/SharktasticA/shorkset.git
    cd shorkset

    # Compile and install
    make clean
    echo -e "${GREEN}Compiling shorkset...${RESET}"
    if $ENABLE_FB; then
        make FB=1 -j$(nproc) CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}"
    else
        make -j$(nproc) CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}"
    fi
    sudo make DESTDIR=$DESTDIR install
}

# Download and compile shorkstall
get_shorkstall()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/usr/bin/shorkstall" ]; then
        echo -e "${LIGHT_RED}shorkstall already compiled, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorkstall ]; then
        echo -e "${YELLOW}shorkstall source already present, recloning...${RESET}"
        sudo rm -r shorkstall
    fi

    # Download source
    echo -e "${GREEN}Downloading shorkstall...${RESET}"
    git clone https://github.com/SharktasticA/shorkstall.git
    cd shorkstall

    # Compile and install
    make clean
    echo -e "${GREEN}Compiling shorkstall...${RESET}"
    make -j$(nproc) CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}"
    sudo make DESTDIR=$DESTDIR install
}



######################################################
## SHORK Entertainment building & copying           ##
######################################################

# Download and compile shorklocomotive
get_shorklocomotive()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/usr/bin/sl" ]; then
        echo -e "${LIGHT_RED}shorklocomotive already compiled, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorklocomotive ]; then
        echo -e "${YELLOW}shorklocomotive source already present, recloning...${RESET}"
        sudo rm -r shorklocomotive
    fi

    # Download source
    echo -e "${GREEN}Downloading shorklocomotive...${RESET}"
    git clone https://github.com/SharktasticA/shorklocomotive.git
    cd shorklocomotive

    # Compile and install
    echo -e "${GREEN}Compiling shorklocomotive...${RESET}"
    make -j$(nproc) CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}"
    sudo make DESTDIR=$DESTDIR install

    # Symlink shorklocomotive to sl
    sudo ln -sf sl "$DESTDIR/usr/bin/shorklocomotive"
}

# Download and compile shorkmatrix
get_shorkmatrix()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/usr/bin/shorkmatrix" ]; then
        echo -e "${LIGHT_RED}shorkmatrix already compiled, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorkmatrix ]; then
        echo -e "${YELLOW}shorkmatrix source already present, recloning...${RESET}"
        sudo rm -r shorkmatrix
    fi

    # Download source
    echo -e "${GREEN}Downloading shorkmatrix...${RESET}"
    git clone https://github.com/SharktasticA/shorkmatrix.git
    cd shorkmatrix

    # Compile and install
    echo -e "${GREEN}Compiling shorkmatrix...${RESET}"
    make -j$(nproc) CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}"
    sudo make DESTDIR=$DESTDIR install
    sudo ln -sf shorkmatrix "$DESTDIR/usr/bin/cmatrix"
}

# Download and compile shorkmines
get_shorkmines()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/usr/bin/shorkmines" ]; then
        echo -e "${LIGHT_RED}shorkmines already compiled, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorkmines ]; then
        echo -e "${YELLOW}shorkmines source already present, recloning...${RESET}"
        sudo rm -r shorkmines
    fi

    # Download source
    echo -e "${GREEN}Downloading shorkmines...${RESET}"
    git clone $SHORKMINES_SRC
    cd shorkmines

    git submodule update --init
    sed -i '1i SYSROOT ?=' libminesweeper/makefile
    sed -i 's|^$(CC) $(C_FLAGS) -c lib/minesweeper.c -Iinclude$|$(CC) $(C_FLAGS) -c lib/minesweeper.c -Iinclude -I$(SYSROOT)/include|' libminesweeper/makefile

    # Compile and install
    echo -e "${GREEN}Compiling shorkmines...${RESET}"
    make CC="${CC_STATIC}" EMBEDDED=1 SYSROOT="$PREFIX" -j$(nproc)
    sudo make DESTDIR="${DESTDIR}" PREFIX="/usr" install

    # Symlink shorkmines to terminal-mines
    sudo ln -sf shorkmines "$DESTDIR/usr/bin/terminal-mines"
}

# Download and compile shorksay
get_shorksay()
{
    cd "$CURR_DIR/build"

    # Skip if already compiled
    if [ "$SHORKUTILS_RECLONE" != "true" ] && [ -f "$DESTDIR/usr/bin/shorksay" ]; then
        echo -e "${LIGHT_RED}shorksay already compiled, skipping...${RESET}"
        return
    fi

    # Delete if present
    if [ -d shorksay ]; then
        echo -e "${YELLOW}shorksay source already present, recloning...${RESET}"
        sudo rm -r shorksay
    fi

    # Download source
    echo -e "${GREEN}Downloading shorksay...${RESET}"
    git clone https://github.com/SharktasticA/shorksay.git
    cd shorksay

    # Compile and install
    echo -e "${GREEN}Compiling shorksay...${RESET}"
    make -j$(nproc) CC="${CC_STATIC}" AR="${AR}" RANLIB="${RANLIB}" STRIP="${STRIP}"
    sudo make DESTDIR=$DESTDIR install

    # Symlink shorksay to cowsay
    sudo ln -sf shorksay "$DESTDIR/usr/bin/cowsay"
}



# Removes anything I've seemed unnecessary in the name of space saving 
trim_fat()
{
    echo -e "${GREEN}Trimming any possible fat...${RESET}"

    sudo rm -rf "$DESTDIR/usr/lib/pkgconfig" "$DESTDIR/usr/man" "$DESTDIR/usr/share/bash-completion" "$DESTDIR/usr/share/doc" "$DESTDIR/usr/share/info" "$DESTDIR/usr/share/man"

    if $INCLUDE_DIALOG; then
        sudo rm -rf "$DESTDIR/usr/lib/libdialog.a"
    fi

    if $INCLUDE_FILE; then
        sudo rm -rf "$DESTDIR/usr/include/magic.h"
        sudo rm -rf "$DESTDIR/usr/lib/libmagic.a"
        sudo rm -rf "$DESTDIR/usr/lib/libmagic.la"
    fi

    if $INCLUDE_GCC; then
        sudo rm -rf "$DESTDIR/opt/${ARCH}-linux-musl-native/${ARCH}-linux-musl"
        sudo rm -rf "$DESTDIR/opt/${ARCH}-linux-musl-native/share"
        for bin in "$DESTDIR"/opt/${ARCH}-linux-musl-native/bin/*; do
            if [ -f "$bin" ]; then
                sudo $STRIP $bin 2>/dev/null || true
            fi
        done
        for bin in "$DESTDIR"/opt/${ARCH}-linux-musl-native/libexec/gcc/${ARCH}-linux-musl/11.2.1/*; do
            if [ -f "$bin" ]; then
                sudo $STRIP $bin 2>/dev/null || true
            fi
        done
    fi

    if $INCLUDE_GIT; then
        cd "$DESTDIR/usr/libexec/git-core"
        sudo rm -f git-imap-send git-http-fetch git-http-backend git-daemon git-p4 git-svn git-send-email
        cd "$DESTDIR/usr/bin"
        sudo rm -f git-shell git-cvsserver scalar
        sudo rm -rf "$DESTDIR/usr/share/gitweb" "$DESTDIR/usr/share/perl5" "$DESTDIR/usr/share/git-core/templates"
        # Create empty directory otherwise Git will complain
        sudo mkdir -p "$DESTDIR/usr/share/git-core/templates"
    fi

    if $INCLUDE_GUI && ! $ENABLE_MULTIUSER_REAL; then
        sudo rm -rf "$DESTDIR/home"
    fi

    if $INCLUDE_JOE; then
        sudo rm -rf "$DESTDIR/usr/share/applications/joe.desktop"
    fi

    if $INCLUDE_LYNX; then
        sudo sed -i '/^#/d' $DESTDIR/usr/etc/lynx.lss
        sudo sed -i '/^#/d' $DESTDIR/usr/etc/lynx.cfg
    fi

    if $INCLUDE_MG; then
        sudo rm -rf "$DESTDIR/usr/share/mg"
    fi

    if $INCLUDE_VIM; then
        KEEP='^(nosyntax|syntax|synload|syncolor|a65|asm.*|avra|fasm|ia64|masm|mmix|nasm|tasm|tiasm|vmasm|z8a|cpp?|cs|csc|sh|bash|make|cmake.*|diff|vim.*|basic|freebasic|ibasic|qb64|vb|awk|git.*|tmux|python2?|pyrex|pymanifest|cfg|conf.*|dosini|change(log)?|debchangelog|cabal.*|fortran|rust|tex|plaintex|texinfo|texmf|initex|context|n?roff|man|x?html.*|css|javascript.*|java|javacc|json.*|modula[23].*|m3build|m3quake|php|phtml|xml|xsd|xslt|xquery|dtd|yaml|sql.*|mysql|plsql|esqlc|n1ql|typescript.*)\.vim$'
        for d in syntax indent ftplugin; do
            find "$DESTDIR/usr/share/vim/vim92/$d" -maxdepth 1 -type f -printf '%f\n' 2>/dev/null | grep -Ev "$KEEP" | xargs -I{} sudo rm -f "$DESTDIR/usr/share/vim/vim92/$d/{}"
        done
        find "$DESTDIR/usr/share/vim/vim92/syntax" -maxdepth 1 -type d -printf '%f\n' | grep -v '^shared$\|^modula2$' | xargs -I{} sudo rm -rf "$DESTDIR/usr/share/vim/vim92/syntax/{}"
        find "$DESTDIR/usr/share/vim/vim92/tutor" -maxdepth 1 -type f ! -name 'tutor1' ! -name 'tutor2' ! -name 'tutor.vim' ! -name 'README.txt' -exec sudo rm -f {} +
    fi

    # find . -type f -print -exec file {} \;
    for dir in \
        "$DESTDIR"/bin \
        "$DESTDIR"/sbin \
        "$DESTDIR"/usr/bin; do
        for bin in "$dir"/*; do
            [ -f "$bin" ] && sudo "$STRIP" "$bin" 2>/dev/null || true
        done
    done
}

# Copies all licences for included software
# TODO: GCC, GRUB, xcalc, xclock, xeyes
copy_licences()
{
    cd "$CURR_DIR/build"

    echo -e "${GREEN}Gathering & copying all needed licences for included software...${RESET}"
    mkdir -p "$DESTDIR/LICENCES"
    CSV="Name,Type,File"

    if [ -f "../../COPYING" ]; then
        cp "../../COPYING" "$DESTDIR/LICENCES/shork.txt" || true
        CSV+="\nSHORK,GNU GPLv3,shork.txt"
    fi

    if [ -f "$CURR_DIR/build/linux/COPYING" ]; then
        cp "$CURR_DIR/build/linux/COPYING" "$DESTDIR/LICENCES/linux.txt" || true
        CSV+="\nLinux,GNU GPLv2,linux.txt"
    fi

    if [ -f "$CURR_DIR/build/busybox-$BUSYBOX_VER/LICENSE" ]; then
        cp "$CURR_DIR/build/busybox-$BUSYBOX_VER/LICENSE" "$DESTDIR/LICENCES/busybox.txt" || true
        CSV+="\nBusyBox,GNU GPLv2,busybox.txt"
    fi

    if $INCLUDE_C3270 && 
       [ -f "$CURR_DIR/build/x3270/LICENSE.md" ]; then
        cp "$CURR_DIR/build/x3270/LICENSE.md" "$DESTDIR/LICENCES/c3270.txt" || true
        CSV+="\nc3270,BSD 3-Clause,c3270.txt"
    fi

    if $INCLUDE_CSCOPE && 
       [ -f "$CURR_DIR/build/cscope-cscope/COPYING" ]; then
        cp "$CURR_DIR/build/cscope-cscope/COPYING" "$DESTDIR/LICENCES/cscope.txt" || true
        CSV+="\nCscope,BSD 3-Clause,cscope.txt"
    fi

    if $INCLUDE_DIALOG && 
       [ -f "$CURR_DIR/build/dialog-${DIALOG_VER}/COPYING" ]; then
        cp "$CURR_DIR/build/dialog-${DIALOG_VER}/COPYING" "$DESTDIR/LICENCES/dialog.txt" || true
        CSV+="\ndialog,GNU LGPLv2.1,dialog.txt"
    fi

    if $INCLUDE_DROPBEAR && 
       [ -f "$CURR_DIR/build/dropbear/LICENSE" ]; then
        cp "$CURR_DIR/build/dropbear/LICENSE" "$DESTDIR/LICENCES/dropbear.txt" || true
        CSV+="\nDropbear,MIT + BSD 2-Clause,dropbear.txt"
    fi

    if [ "$ID" == "shork-486" ] &&
       $FIX_EXTLINUX &&
       [ -f "$CURR_DIR/build/syslinux/COPYING" ]; then
        cp "$CURR_DIR/build/syslinux/COPYING" "$DESTDIR/LICENCES/extlinux.txt" || true
        CSV+="\nEXTLINUX,GNU GPLv2,extlinux.txt"
    fi

    if $INCLUDE_FILE && 
       [ -f "$CURR_DIR/build/file/COPYING" ]; then
        cp "$CURR_DIR/build/file/COPYING" "$DESTDIR/LICENCES/file.txt" || true
        CSV+="\nfile,BSD 2-Clause,file.txt"
    fi

    if $INCLUDE_GCC &&
       [ -f "../../COPYING" ]; then
        cp "../../COPYING" "$DESTDIR/LICENCES/gcc.txt" || true
        wget -qO "${DESTDIR}/LICENCES/gcc-exception.txt" "https://raw.githubusercontent.com/gcc-mirror/gcc/master/COPYING.RUNTIME" || true
        CSV+="\nGCC,GNU GPLv3,gcc.txt"
        CSV+="\nGCC Runtime,GCC Runtime Library Exception,gcc-exception.txt"
    fi

    if $INCLUDE_GIT && 
       [ -f "$CURR_DIR/build/git/COPYING" ]; then
        cp "$CURR_DIR/build/git/COPYING" "$DESTDIR/LICENCES/git.txt" || true
        CSV+="\nGit,GNU GPLv2,git.txt"
    fi

    if $INCLUDE_HTOP && 
       [ -f "$CURR_DIR/build/htop/COPYING" ]; then
        cp "$CURR_DIR/build/htop/COPYING" "$DESTDIR/LICENCES/htop.txt" || true
        CSV+="\nhtop,GNU GPLv2,htop.txt"
    fi

    if [ -f "$DESTDIR/usr/share/fonts/opentype/ibm-plex-mono/IBMPlexMono-Regular.otf" ] && 
       [ -f "$CURR_DIR/build/plex/LICENSE.txt" ]; then
        cp "$CURR_DIR/build/plex/LICENSE.txt" "$DESTDIR/LICENCES/ibm-plex.txt" || true
        CSV+="\nIBM Plex,OFL 1.1,ibm-plex.txt"
    fi

    if [ "$ID" == "shork-disc" ] &&
       $FIX_EXTLINUX &&
       [ -f "$CURR_DIR/build/syslinux/COPYING" ]; then
        cp "$CURR_DIR/build/syslinux/COPYING" "$DESTDIR/LICENCES/isolinux.txt" || true
        CSV+="\nISOLINUX,GNU GPLv2,isolinux.txt"
    fi

    if $INCLUDE_INDENT && 
       [ -f "$CURR_DIR/build/indent-${INDENT_VER}/COPYING" ]; then
        cp "$CURR_DIR/build/indent-${INDENT_VER}/COPYING" "$DESTDIR/LICENCES/indent.txt" || true
        CSV+="\nIndent,GNU GPLv3,indent.txt"
    fi

    if $INCLUDE_JOE && 
       [ -f "$CURR_DIR/build/joe/COPYING" ]; then
        cp "$CURR_DIR/build/joe/COPYING" "$DESTDIR/LICENCES/joe.txt" || true
        CSV+="\nJoe's Own Editor,GNU GPLv2,joe.txt"
    fi

    if [ -f "$DESTDIR/usr/local/bin/lapifetch" ] && 
       [ -f "$CURR_DIR/build/lapifetch/LICENSE" ]; then
        cp "$CURR_DIR/build/lapifetch/LICENSE" "$DESTDIR/LICENCES/lapifetch.txt" || true
        CSV+="\nlapitfetch,MIT,lapifetch.txt"
    fi

    if $INCLUDE_LYNX && 
       [ -f "$CURR_DIR/build/lynx-snapshots/COPYING" ]; then
        cp "$CURR_DIR/build/lynx-snapshots/COPYING" "$DESTDIR/LICENCES/lynx.txt" || true
        CSV+="\nLynx,GNU GPLv2,lynx.txt"
    fi

    if [ -f "$DESTDIR/usr/local/musl/lib/libc.so" ] &&
       [ -f "$CURR_DIR/build/musl-$MUSL_VER/COPYRIGHT" ]; then
        cp "$CURR_DIR/build/musl-$MUSL_VER/COPYRIGHT" "$DESTDIR/LICENCES/musl.txt" || true
        CSV+="\nmusl,MIT,musl.txt"
    elif $INCLUDE_GCC; then
        wget -qO "${DESTDIR}/LICENCES/musl.txt" "https://git.musl-libc.org/cgit/musl/plain/COPYRIGHT" || true
        CSV+="\nmusl,MIT,musl.txt"
    fi

    if $INCLUDE_MAKE && 
       [ -f "$CURR_DIR/build/make-${MAKE_VER}/COPYING" ]; then
        cp "$CURR_DIR/build/make-${MAKE_VER}/COPYING" "$DESTDIR/LICENCES/make.txt" || true
        CSV+="\nMake,GNU GPLv3,make.txt"
    fi

    if $INCLUDE_MG && 
       [ -f "$CURR_DIR/build/mg/UNLICENSE" ]; then
        cp "$CURR_DIR/build/mg/UNLICENSE" "$DESTDIR/LICENCES/mg.txt" || true
        CSV+="\nMg,unlicense,mg.txt"
    fi

    if $INCLUDE_MICROPYTHON && 
       [ -f "$CURR_DIR/build/micropython/LICENSE" ]; then
        cp "$CURR_DIR/build/micropython/LICENSE" "$DESTDIR/LICENCES/micropython.txt" || true
        CSV+="\nMicroPython,MIT,micropython.txt"
    fi

    if $INCLUDE_MPG321 && 
       [ -f "$CURR_DIR/build/mpg321/COPYING" ]; then
        cp "$CURR_DIR/build/mpg321/COPYING" "$DESTDIR/LICENCES/mpg321.txt" || true
        CSV+="\nmpg321,GNU GPLv2,mpg321.txt"
    fi

    if $INCLUDE_MT_ST && 
       [ -f "$CURR_DIR/build/mt-st/COPYING" ]; then
        cp "$CURR_DIR/build/mt-st/COPYING" "$DESTDIR/LICENCES/mt-st.txt" || true
        CSV+="\nmt-st,GNU GPLv2,mt-st.txt"
    fi

    if $INCLUDE_NANO && 
       [ -f "$CURR_DIR/build/nano-$NANO_VER/COPYING" ]; then
        cp "$CURR_DIR/build/nano-$NANO_VER/COPYING" "$DESTDIR/LICENCES/nano.txt" || true
        CSV+="\nnano,GNU GPLv3,nano.txt"
    fi

    if $INCLUDE_NASM && 
       [ -f "$CURR_DIR/build/nasm/LICENSE" ]; then
        cp "$CURR_DIR/build/nasm/LICENSE" "$DESTDIR/LICENCES/nasm.txt" || true
        CSV+="\nNASM,BSD 2-Clause,nasm.txt"
    fi

    if [ -f "${PREFIX}/lib/libncursesw.a" ] && 
       [ -f "$CURR_DIR/build/ncurses/COPYING" ]; then
        cp "$CURR_DIR/build/ncurses/COPYING" "$DESTDIR/LICENCES/ncurses.txt" || true
        CSV+="\nncurses,MIT,ncurses.txt"
    fi

    if [ -f "$DESTDIR/usr/bin/nedit" ] && 
       [ -f "$CURR_DIR/build/nedit/COPYRIGHT" ]; then
        cp "$CURR_DIR/build/nedit/COPYRIGHT" "$DESTDIR/LICENCES/nedit.txt" || true
        CSV+="\nNEdit,GNU GPLv2,nedit.txt"
    fi

    if [ -f "$DESTDIR/usr/bin/oneko" ]; then
        echo "Public domain" | sudo tee "$DESTDIR/LICENCES/oneko.txt" > /dev/null
        CSV+="\noneko,public domain,oneko.txt"
    fi

    if $INCLUDE_PCI_IDS && 
       [ -f "../../COPYING" ]; then
        {
            printf "The pci.ids file is distributed with SHORK under the GNU General Public License\nv3. The PCI ID database is a compilation of factual data, and as such the\ncopyright only covers the aggregation and formatting. The copyright is held by\nMartin Mares and Albert Pool.\n\n--------------------------------------------------------------------------------\n\n"
            cat "../../COPYING"
        } > "$DESTDIR/LICENCES/pci-ids.txt" || true
        CSV+="\npci.ids,GNU GPLv3,pci-ids.txt"
    fi

    if $INCLUDE_SC_IM && 
       [ -f "$CURR_DIR/build/sc-im/LICENSE" ]; then
        cp "$CURR_DIR/build/sc-im/LICENSE" "$DESTDIR/LICENCES/sc-im.txt" || true
        CSV+="\nsc-im,BSD 4-Clause,sc-im.txt"
    fi

    if $INCLUDE_SHORKTAINMENT &&
       [ -f "$CURR_DIR/build/shorkmines/LICENSE" ]; then
        cp "$CURR_DIR/build/shorkmines/LICENSE" "$DESTDIR/LICENCES/shorkmines.txt" || true
        CSV+="\nSHORKMINES,MIT,shorkmines.txt"
    fi

    if [ -f "$DESTDIR/usr/bin/st" ] && 
       [ -f "$CURR_DIR/build/st/LICENSE" ]; then
        cp "$CURR_DIR/build/st/LICENSE" "$DESTDIR/LICENCES/st.txt" || true
        CSV+="\nst,MIT,st.txt"
    fi

    if $INCLUDE_STRACE && 
       [ -f "$CURR_DIR/build/strace/COPYING" ]; then
        cp "$CURR_DIR/build/strace/COPYING" "$DESTDIR/LICENCES/strace.txt" || true
        CSV+="\nstrace,GNU LGPLv2.1,strace.txt"
    fi

    if [ "$ID" == "shork-diskette" ] &&
       $FIX_EXTLINUX &&
       [ -f "$CURR_DIR/build/syslinux/COPYING" ]; then
        cp "$CURR_DIR/build/syslinux/COPYING" "$DESTDIR/LICENCES/syslinux.txt" || true
        CSV+="\nSYSLINUX,GNU GPLv2,syslinux.txt"
    fi

    if $INCLUDE_TCC && 
       [ -f "$CURR_DIR/build/tinycc-mirror-repository/COPYING" ]; then
        cp "$CURR_DIR/build/tinycc-mirror-repository/COPYING" "$DESTDIR/LICENCES/tcc.txt" || true
        CSV+="\nTiny C Compiler,GNU LGPLv2.1,tcc.txt"
    fi

    if $INCLUDE_CON_FONTS && 
       [ -f "$CURR_DIR/build/terminus-font-4.49.1.tar.gz" ]; then
        tar -xzf "$CURR_DIR/build/terminus-font-4.49.1.tar.gz" -O terminus-font-4.49.1/OFL.TXT > $DESTDIR/LICENCES/terminus.txt
        CSV+="\nTerminus,OFL 1.1,terminus.txt"
    fi

    if [ -f "$DESTDIR/usr/bin/tic" ] && 
       [ -f "$CURR_DIR/build/ncurses/COPYING" ]; then
        cp "$CURR_DIR/build/ncurses/COPYING" "$DESTDIR/LICENCES/ncurses.txt" || true
        CSV+="\ntic,MIT,ncurses.txt"
    fi

    if $INCLUDE_TILDE && 
       [ -f "$CURR_DIR/build/tilde-$TILDE_VER/COPYING" ]; then
        cp "$CURR_DIR/build/tilde-$TILDE_VER/COPYING" "$DESTDIR/LICENCES/tilde.txt" || true
        CSV+="\nTilde,GNU GPLv3,tilde.txt"
    fi

    if [ -f "$DESTDIR/usr/bin/Xfbdev" ] &&
       [ -f "$CURR_DIR/build/tinyx/COPYING" ]; then
        cp "$CURR_DIR/build/tinyx/COPYING" "$DESTDIR/LICENCES/tinyx.txt" || true
        CSV+="\nTinyX,GNU GPLv3,tinyx.txt"
    fi

    if $INCLUDE_TMUX && 
       [ -f "$CURR_DIR/build/tmux/COPYING" ]; then
        cp "$CURR_DIR/build/tmux/COPYING" "$DESTDIR/LICENCES/tmux.txt" || true
        CSV+="\ntmux,ISC,tmux.txt"
    fi

    if $INCLUDE_TN5250 && 
       [ -f "$CURR_DIR/build/tn5250/COPYING" ]; then
        cp "$CURR_DIR/build/tn5250/COPYING" "$DESTDIR/LICENCES/tn5250.txt" || true
        CSV+="\ntn5250,GNU LGPLv2.1,tn5250.txt"
    fi

    if $INCLUDE_TNFTP && 
       [ -f "$CURR_DIR/build/tnftp-$TNFTP_VER/COPYING" ]; then
        cp "$CURR_DIR/build/tnftp-$TNFTP_VER/COPYING" "$DESTDIR/LICENCES/tnftp.txt" || true
        CSV+="\ntnftp,BSD 2-Clause,tnftp.txt"
    fi

    if [ -f "$DESTDIR/usr/bin/twm" ] && 
       [ -f "$CURR_DIR/build/twm/COPYING" ]; then
        cp "$CURR_DIR/build/twm/COPYING" "$DESTDIR/LICENCES/twm.txt" || true
        CSV+="\nTWM,MIT,twm.txt"
    fi

    if $INCLUDE_CTAGS && 
       [ -f "$CURR_DIR/build/ctags/COPYING" ]; then
        cp "$CURR_DIR/build/ctags/COPYING" "$DESTDIR/LICENCES/ctags.txt" || true
        CSV+="\nUniversal Ctags,GPLv2,ctags.txt"
    fi

    if $INCLUDE_UTIL_LINUX && 
       [ -f "$CURR_DIR/build/util-linux/COPYING" ]; then
        cp "$CURR_DIR/build/util-linux/COPYING" "$DESTDIR/LICENCES/util-linux.txt" || true
        CSV+="\nutil-linux,GNU GPLv2,util-linux.txt"
    fi

    if $INCLUDE_VIM && 
       [ -f "$CURR_DIR/build/vim/LICENSE" ]; then
        cp "$CURR_DIR/build/vim/LICENSE" "$DESTDIR/LICENCES/vim.txt" || true
        CSV+="\nVim,Vim License,vim.txt"
    fi

    if [ -f "$DESTDIR/usr/bin/xli" ] && 
       [ -f "$CURR_DIR/build/xli/LICENSE" ]; then
        cp "$CURR_DIR/build/xli/LICENSE" "$DESTDIR/LICENCES/xli.txt" || true
        CSV+="\nxli,MIT,xli.txt"
    fi

    if [ -f "$DESTDIR/usr/bin/xload" ] && 
       [ -f "$CURR_DIR/build/xload-1.2.0/COPYING" ]; then
        cp "$CURR_DIR/build/xload-1.2.0/COPYING" "$DESTDIR/LICENCES/xload.txt" || true
        CSV+="\nxload,MIT,xload.txt"
    fi

    if [ -f "$DESTDIR/usr/bin/xset" ] && 
       [ -f "$CURR_DIR/build/xset-1.2.5/COPYING" ]; then
        cp "$CURR_DIR/build/xset-1.2.5/COPYING" "$DESTDIR/LICENCES/xset.txt" || true
        CSV+="\nxset,MIT,xset.txt"
    fi

    echo -e "$CSV" > "$DESTDIR/LICENCES/manifest.csv"
}



######################################################
## File system & disk image building                ##
######################################################

# Find and set MBR binary (can be different depending on distro)
find_mbr_bin()
{
    for candidate in /usr/lib/SYSLINUX/mbr.bin /usr/lib/syslinux/mbr/mbr.bin /usr/lib/syslinux/bios/mbr.bin /usr/share/syslinux/mbr.bin /usr/share/syslinux/mbr.bin
    do
        if [ -f "$candidate" ]; then
            MBR_BIN="$candidate"
            break
        fi
    done
}

# Copies test files and shell scripts for testing certain SHORK 486
# features and capabilities
copy_tests()
{
    echo -e "${GREEN}Copying feature/capability tests...${RESET}"
    sudo mkdir -p $DESTDIR/tests
    sudo cp $CURR_DIR/tests/* $DESTDIR/tests
    sudo chmod +x $DESTDIR/tests/*.sh
    cd $DESTDIR
}

# Builds the root file system
build_file_system()
{
    echo -e "${GREEN}Building the root system...${RESET}"
    cd $DESTDIR

    echo -e "${GREEN}Creating required directories...${RESET}"
    sudo mkdir -p {dev,proc,etc/init.d,sys,tmp,usr/share,usr/libexec,banners,mnt}

    echo -e "${GREEN}Configure permissions...${RESET}"
    chmod +x $CURR_DIR/sysfiles/*/rc
    chmod +x $CURR_DIR/sysfiles/default.script
    chmod +x $CURR_DIR/sysfiles/poweroff
    chmod +x $CURR_DIR/shorkutils/shorkgui
    chmod +x $CURR_DIR/sysfiles/shutdown

    echo -e "${GREEN}Copying system files...${RESET}"
    copy_sysfile $CURR_DIR/sysfiles/hostname $DESTDIR/etc/hostname
    copy_sysfile $CURR_DIR/sysfiles/issue $DESTDIR/etc/issue
    copy_sysfile $CURR_DIR/sysfiles/os-release $DESTDIR/etc/os-release

    if [ "$ID" == "shork-486" ]; then
        copy_sysfile $CURR_DIR/sysfiles/486/rc $DESTDIR/etc/init.d/rc
        copy_sysfile $CURR_DIR/sysfiles/486/profile $DESTDIR/etc/profile
        copy_sysfile $CURR_DIR/sysfiles/486/welcome $DESTDIR/banners/welcome
        copy_sysfile $CURR_DIR/sysfiles/goodbye-80 $DESTDIR/banners/goodbye-80
        copy_sysfile $CURR_DIR/sysfiles/goodbye-100 $DESTDIR/banners/goodbye-100
        copy_sysfile $CURR_DIR/sysfiles/goodbye-128 $DESTDIR/banners/goodbye-128
        copy_sysfile $CURR_DIR/sysfiles/passwd $DESTDIR/etc/passwd
        copy_sysfile $CURR_DIR/sysfiles/poweroff $DESTDIR/sbin/poweroff
        copy_sysfile $CURR_DIR/sysfiles/shutdown $DESTDIR/sbin/shutdown
    elif [ "$ID" == "shork-disc" ]; then
        copy_sysfile $CURR_DIR/sysfiles/disc/profile $DESTDIR/etc/profile
        copy_sysfile $CURR_DIR/sysfiles/disc/rc $DESTDIR/etc/init.d/rc
        copy_sysfile $CURR_DIR/sysfiles/disc/welcome $DESTDIR/banners/welcome
    elif [ "$ID" == "shork-diskette" ]; then
        copy_sysfile $CURR_DIR/sysfiles/diskette/profile $DESTDIR/etc/profile
        copy_sysfile $CURR_DIR/sysfiles/diskette/rc $DESTDIR/etc/init.d/rc
        copy_sysfile $CURR_DIR/sysfiles/diskette/welcome $DESTDIR/banners/welcome
    fi

    if $ENABLE_FB; then
        echo -e "${GREEN}Copying and compiling terminfo database...${RESET}"
        sudo mkdir -p $DESTDIR/usr/share/terminfo/src/
        sudo cp $CURR_DIR/sysfiles/terminfo.src $DESTDIR/usr/share/terminfo/src/
        sudo tic -x -1 -o $DESTDIR/usr/share/terminfo $DESTDIR/usr/share/terminfo/src/terminfo.src
    fi

    if $INCLUDE_GUI; then
        echo -e "${GREEN}Installing files needed for SHORKGUI...${RESET}"
        sudo mkdir -p {usr/share/backgrounds,usr/share/X11/app-defaults}
        copy_sysfile $CURR_DIR/shorkutils/shorkgui $DESTDIR/usr/bin/shorkgui
        copy_sysfile $CURR_DIR/sysfiles/shork-486-dark.png $DESTDIR/usr/share/backgrounds/shork-486-dark.png
        copy_sysfile $CURR_DIR/sysfiles/shork-486-light.png $DESTDIR/usr/share/backgrounds/shork-486-light.png
        copy_sysfile $CURR_DIR/sysfiles/XCalc $DESTDIR/usr/share/X11/app-defaults/XCalc
        if [[ $USED_WM == "TWM" ]]; then 
            echo -e "${GREEN}Installing SHORKGUI-specific configuration...${RESET}"
            copy_sysfile $CURR_DIR/sysfiles/dark.twmrc $DESTDIR/usr/share/X11/twm/dark.twmrc
            copy_sysfile $CURR_DIR/sysfiles/light.twmrc $DESTDIR/usr/share/X11/twm/light.twmrc
        fi
    fi

    if $INCLUDE_GIT; then
        echo -e "${GREEN}Copying pre-defined Git settings...${RESET}"
        sudo mkdir -p $DESTDIR/usr/etc
        copy_sysfile $CURR_DIR/sysfiles/gitconfig $DESTDIR/usr/etc/gitconfig
    fi

    if $INCLUDE_KEYMAPS; then
        echo -e "${GREEN}Installing keymaps...${RESET}"
        sudo mkdir -p $DESTDIR/usr/share/keymaps/
        sudo cp $CURR_DIR/sysfiles/keymaps/*.kmap.bin "$DESTDIR/usr/share/keymaps/"
        sudo chmod 644 "$DESTDIR/usr/share/keymaps/"*.kmap.bin

        if [ -n "$SET_KEYMAP" ] && [ -f "$DESTDIR/etc/shorkset.conf" ]; then
            echo -e "${GREEN}Setting default keymap...${RESET}"
            sudo sed -i "s|^KEYMAP=.*|KEYMAP=\"$SET_KEYMAP\"|" "$DESTDIR/etc/shorkset.conf"
        fi
    fi

    if $INCLUDE_MG; then
        echo -e "${GREEN}Copying pre-defined Mg settings...${RESET}"
        copy_sysfile $CURR_DIR/sysfiles/mg $DESTDIR/etc/mg
    fi

    if $ENABLE_MULTIUSER_REAL; then
        echo -e "${GREEN}Copying mutli-user-related files...${RESET}"

        sudo mkdir -p $DESTDIR/home

        copy_sysfile $CURR_DIR/sysfiles/486/inittab.getty $DESTDIR/etc/inittab
        copy_sysfile $CURR_DIR/sysfiles/group $DESTDIR/etc/group
        copy_sysfile $CURR_DIR/sysfiles/shadow $DESTDIR/etc/shadow

        if [ -n "$ROOT_PASSWD" ]; then
            ROOT_PASSWD_LINE="root:$ROOT_PASSWD:0:0:99999:7:::"
            if ! grep -Fxq "$ROOT_PASSWD_LINE" "$DESTDIR/etc/shadow"; then
                printf '%s\n' "$ROOT_PASSWD_LINE" | sudo tee -a "$DESTDIR/etc/shadow" >/dev/null
            fi
        fi

        # Remove hard-coded variables intended for single-user builds
        sudo sed -i '/^export HOME=\/root$/d' "$DESTDIR/etc/profile"
        sudo sed -i '/^export USER=root$/d' "$DESTDIR/etc/profile"
        sudo sed -i '/^export LOGNAME=root$/d' "$DESTDIR/etc/profile"
        sudo sed -i '/^export LOGIN_TIMEOUT=0$/d' "$DESTDIR/etc/profile"
    else
        if [ "$ID" == "shork-486" ]; then
            sudo mkdir -p $DESTDIR/root
            copy_sysfile $CURR_DIR/sysfiles/486/inittab.nogetty $DESTDIR/etc/inittab
        elif [ "$ID" == "shork-disc" ]; then
            sudo mkdir -p $DESTDIR/root
            copy_sysfile $CURR_DIR/sysfiles/disc/inittab $DESTDIR/etc/inittab
        elif [ "$ID" == "shork-diskette" ]; then
            copy_sysfile $CURR_DIR/sysfiles/diskette/inittab $DESTDIR/etc/inittab
        fi
    fi

    if $ENABLE_NET_ETH; then
        echo -e "${GREEN}Copying networking-related files...${RESET}"
        sudo mkdir -p $DESTDIR/etc/iproute2
        sudo mkdir -p $DESTDIR/usr/share/udhcpc
        copy_sysfile $CURR_DIR/sysfiles/default.script $DESTDIR/usr/share/udhcpc/default.script
        copy_sysfile $CURR_DIR/sysfiles/resolv.conf $DESTDIR/etc/resolv.conf
        copy_sysfile $CURR_DIR/sysfiles/services $DESTDIR/etc/services
    fi

    # Configure for SERIAL_CON_PORT if serial console mode is enabled
    if $ENABLE_SERIAL_CON; then
        echo -e "${GREEN}Configuring system files for serial console mode...${RESET}"

        if $ENABLE_MULTIUSER_REAL; then
            sudo sed -i "s/^tty1::respawn:\/sbin\/getty -n 38400 tty1/${SERIAL_CON_PORT}::respawn:\/sbin\/getty -L ${SERIAL_CON_PORT} 115200 vt100/" "${DESTDIR}/etc/inittab"
        else
            sudo sed -i "s/^tty1::respawn/${SERIAL_CON_PORT}::respawn/" "${DESTDIR}/etc/inittab"
        fi
        sudo sed -i "/^tty[23]::respawn/d" "${DESTDIR}/etc/inittab"
    fi

    if $INCLUDE_NANO; then
        echo -e "${GREEN}Copying pre-defined nano settings...${RESET}"
        sudo mkdir -p $DESTDIR/usr/etc
        copy_sysfile $CURR_DIR/sysfiles/nanorc $DESTDIR/usr/etc/nanorc
    fi

    if $INCLUDE_PCI_IDS; then
        # Include PCI IDs for shorkfetch's GPU identification
        # **Work offloaded to Python**
        echo -e "${GREEN}Generating pci.ids database...${RESET}"
        cd $CURR_DIR/
        sudo python3 -c "from helpers import *; build_pci_ids()"
    fi

    echo -e "${GREEN}Copying SHORK Utilities configuration files...${RESET}"
    if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
        sudo mkdir -p $DESTDIR/root/.config/shorkutils
        copy_sysfile $CURR_DIR/sysfiles/shorkfetch.conf $DESTDIR/root/.config/shorkutils/shorkfetch.conf
    fi

    if $INCLUDE_TESTS; then
        copy_tests
    fi

    if $NEED_OPENSSL; then
        # Use host's CA certifications to get OpenSSL working
        echo -e "${GREEN}Installing CA certificates for OpenSSL...${RESET}"
        sudo mkdir -p $DESTDIR/etc/ssl
        copy_sysfile /etc/ssl/certs/ca-certificates.crt $DESTDIR/etc/ssl/cert.pem
    fi

    # Copy any payload
    if [ "$ID" == "shork-disc" ]; then
        find "$CURR_DIR/payload/" -mindepth 1 -not -name "notice.txt" | while read -r item; do
            sudo cp -r "$item" "$DESTDIR/root/"
        done
    fi

    echo -e "${GREEN}Ensure file permissions are correct...${RESET}"
    sudo chown -R root:root "$DESTDIR"
    sudo find "$DESTDIR" -type d -exec chmod 755 {} +
    sudo find "$DESTDIR" -type f ! -perm -111 -exec chmod 644 {} +
}

# Compresses the root file system (SHORK DISKETTE)
compress_file_system()
{
    cd "${DESTDIR}"
    echo -e "${GREEN}Compressing root file system into one file...${RESET}"
    find . | cpio -H newc -o | xz --check=crc32 --lzma2=dict=512KiB -e > $CURR_DIR/build/rootfs.cpio.xz
}

# Partition disk image
partition_disk_img()
{
    cd $CURR_DIR/build/

    local ALIGNED_SECTORS="$1"

    if [ -n "$TARGET_SWAP" ] && [ "$TARGET_SWAP" -gt 0 ]; then
        echo -e "${GREEN}Setting up for root and swap partitions...${RESET}"
        SWAP_SIZE=$((TARGET_SWAP * 2048))
        ROOT_SIZE=$((ALIGNED_SECTORS - DISK_SECTORS_TRACK - SWAP_SIZE))
        SWAP_START=$((DISK_SECTORS_TRACK + ROOT_SIZE))
        sed -e "s/@ROOT_SIZE@/${ROOT_SIZE}/g" -e "s/@SWAP_START@/${SWAP_START}/g" -e "s/@SWAP_SIZE@/${SWAP_SIZE}/g" "$CURR_DIR/sysfiles/partitions_swap" | sudo sfdisk "${CURR_DIR}/images/${ID}.img"
    else
        echo -e "${GREEN}Setting up for just root partition (no swap)...${RESET}"
        ROOT_SIZE=$((ALIGNED_SECTORS - DISK_SECTORS_TRACK))
        sed "s/@ROOT_SIZE@/${ROOT_SIZE}/g" "$CURR_DIR/sysfiles/partitions_noswap" | sudo sfdisk "${CURR_DIR}/images/$ID.img"
    fi

    ROOT_PART_SIZE=$((ROOT_SIZE / 2048))
}

# Install EXTLINUX bootloader (SHORK 486)
install_extlinux_bootloader()
{
    cd $CURR_DIR/build/

    EXTLINUX_BIN="extlinux"
    BOOTLDR_USED="EXTLINUX"
    if $FIX_EXTLINUX; then
        EXTLINUX_BIN="$CURR_DIR/build/syslinux/bios/extlinux/extlinux"
        BOOTLDR_USED="patched EXTLINUX"
    fi

    sudo mkdir -p "/mnt/${ID}/boot/syslinux"

    if $ENABLE_MENU; then
        echo -e "${GREEN}Installing menu-based EXTLINUX bootloader...${RESET}"
        copy_sysfile $CURR_DIR/sysfiles/486/syslinux.cfg.menu  "/mnt/${ID}/boot/syslinux/syslinux.cfg"
        
        SYSLINUX_DIRS="
        /usr/lib/syslinux/modules/bios
        /usr/lib/syslinux/bios
        /usr/share/syslinux
        /usr/lib/syslinux
        "

        copy_syslinux_file()
        {
            for d in $SYSLINUX_DIRS; do
                if [ -f "$d/$1" ]; then
                    sudo cp "$d/$1" "/mnt/${ID}/boot/syslinux/"
                    return 0
                fi
            done
            echo "ERROR: $1 not found"
            exit 1
        }

        copy_syslinux_file menu.c32
        copy_syslinux_file libutil.c32
        copy_syslinux_file libcom32.c32
        copy_syslinux_file libmenu.c32
    else
        echo -e "${GREEN}Installing boot-only EXTLINUX bootloader...${RESET}"
        copy_sysfile $CURR_DIR/sysfiles/486/syslinux.cfg.boot  "/mnt/${ID}/boot/syslinux/syslinux.cfg"
    fi

    # If required, specify the target scancode set
    if [[ $SCANCODE_SET != -1 ]]; then
        sudo sed -i "s/atkbd.extra=1/atkbd.set=${SCANCODE_SET} atkbd.extra=1/" "/mnt/${ID}/boot/syslinux/syslinux.cfg"
    fi

    # Disable vdso32 if ENABLE_NO_VDS032
    if [ "$ENABLE_NO_VDS032" = true ]; then
        sudo sed -i "s/vdso32=1/vdso32=0/" "/mnt/${ID}/boot/syslinux/syslinux.cfg"
    fi

    sudo "$EXTLINUX_BIN" --install "/mnt/${ID}/boot/syslinux"

    # Configure for SERIAL_CON_PORT if serial console mode is enabled
    if $ENABLE_SERIAL_CON; then
        echo -e "${GREEN}Configuring bootloader for serial console mode...${RESET}"
        sudo sed -i "s/Starting ${DIST}/Starting ${DIST} (serial console mode)/g" "/mnt/${ID}/boot/syslinux/syslinux.cfg"
        sudo sed -i "s/console=tty1/console=${SERIAL_CON_PORT},115200n8/g" "/mnt/${ID}/boot/syslinux/syslinux.cfg"
        sudo sed -i "s/ vga=normal//g" "/mnt/${ID}/boot/syslinux/syslinux.cfg"
    fi

    # Install MBR boot code
    sudo dd if="$MBR_BIN" of="${CURR_DIR}/images/${ID}.img" bs=440 count=1 conv=notrunc
}

# Install GRUB bootloader (SHORK 486)
install_grub_bootloader()
{
    cd $CURR_DIR/build/

    sudo mkdir -p "/mnt/${ID}/boot/grub"

    if $ENABLE_MENU; then
        echo -e "${GREEN}Installing menu-based GRUB bootloader...${RESET}"
        copy_sysfile $CURR_DIR/sysfiles/486/grub.cfg.menu "/mnt/${ID}/boot/grub/grub.cfg"
    else
        echo -e "${GREEN}Installing boot-only GRUB bootloader...${RESET}"
        copy_sysfile $CURR_DIR/sysfiles/486/grub.cfg.boot "/mnt/${ID}/boot/grub/grub.cfg"
    fi

    # If required, specify the target scancode set
    if [[ $SCANCODE_SET != -1 ]]; then
        sudo sed -i "s/atkbd.extra=1/atkbd.set=${SCANCODE_SET} atkbd.extra=1/" "/mnt/${ID}/boot/grub/grub.cfg"
    fi

    # Disable vdso32 if ENABLE_NO_VDS032
    if [ "$ENABLE_NO_VDS032" = true ]; then
        sudo sed -i "s/vdso32=1/vdso32=0/" "/mnt/${ID}/boot/grub/grub.cfg"
    fi

    sudo mount --bind /dev  "/mnt/${ID}/dev"
    sudo mount --bind /proc "/mnt/${ID}/proc"
    sudo mount --bind /sys  "/mnt/${ID}/sys"

    GRUB_CMD="grub-install"
    if ! command -v "$GRUB_CMD" >/dev/null 2>&1; then
        GRUB_CMD="/usr/sbin/grub2-install"
    fi
    sudo $GRUB_CMD --target=i386-pc --boot-directory="/mnt/${ID}/boot" --modules="ext2 part_msdos biosdisk" --force "$1"

    # Configure for SERIAL_CON_PORT if serial console mode is enabled
    if $ENABLE_SERIAL_CON; then
        echo -e "${GREEN}Configuring bootloader for serial console mode...${RESET}"
        sudo sed -i "s/Starting ${DIST}/Starting ${DIST} (serial console mode)/g" "/mnt/${ID}/boot/grub/grub.cfg"
        sudo sed -i "s/console=tty1/console=${SERIAL_CON_PORT},115200n8/g" "/mnt/${ID}/boot/grub/grub.cfg"
        sudo sed -i "s/ vga=normal//g" "/mnt/${ID}/boot/grub/grub.cfg"
    fi

    sudo umount "/mnt/${ID}/dev"
    sudo umount "/mnt/${ID}/proc"
    sudo umount "/mnt/${ID}/sys"

    BOOTLDR_USED="GRUB"
}

# Install ISOLINUX bootloader (SHORK DISC)
install_isolinux_bootloader()
{
    cd $CURR_DIR/build/

    echo -e "${GREEN}Installing ISOLINUX bootloader...${RESET}"

    BOOTLDR_USED="ISOLINUX"

    # Copy main bootloader binary
    if $FIX_EXTLINUX; then
        BOOTLDR_USED="patched ISOLINUX"
        sudo cp "${CURR_DIR}/build/syslinux/bios/core/isolinux.bin" "${DESTDIR}/boot/isolinux"
    else
        ISOLINUX_BIN_CANS="
        /usr/lib/ISOLINUX/isolinux.bin
        /usr/lib/syslinux/bios/isolinux.bin
        /usr/share/syslinux/isolinux.bin
        "

        ISOLINUX_BIN_FOUND=false
        for c in $ISOLINUX_BIN_CANS; do
            if [ -f "$c" ]; then
                sudo cp "$c" "${DESTDIR}/boot/isolinux"
                ISOLINUX_BIN_FOUND=true
                break
            fi
        done

        if ! $ISOLINUX_BIN_FOUND; then
            echo -e "${RED}ERROR: ISOLINUX binary not found${RESET}"
            exit 1
        fi
    fi

    # Copy helper(s)
    SYSLINUX_DIRS="
    /usr/lib/syslinux/modules/bios
    /usr/lib/syslinux/bios
    /usr/share/syslinux
    /usr/lib/syslinux
    "

    copy_syslinux_file()
    {
        for d in $SYSLINUX_DIRS; do
            if [ -f "$d/$1" ]; then
                sudo cp "$d/$1" "${DESTDIR}/boot/isolinux"
                return 0
            fi
        done
        echo "ERROR: $1 not found"
        exit 1
    }

    copy_syslinux_file ldlinux.c32
}

# Install SYSLINUX bootloader (SHORK DISKETTE)
install_syslinux_bootloader()
{
    cd $CURR_DIR/build/

    echo -e "${GREEN}Installing SYSLINUX bootloader...${RESET}"

    SYSLINUX_BIN="syslinux"
    BOOTLDR_USED="SYSLINUX"
    if $FIX_EXTLINUX; then
        SYSLINUX_BIN="$CURR_DIR/build/syslinux/bios/linux/syslinux"
        BOOTLDR_USED="patched SYSLINUX"
    fi 
    sudo chmod 666 "${CURR_DIR}/images/${ID}.img"
    sudo "$SYSLINUX_BIN" --install "${CURR_DIR}/images/${ID}.img"
}

# Build a disk image containing our system (SHORK 486)
build_disk_img()
{
    cd $CURR_DIR/build/

    # Cleans up all temporary block-device states when script exits, fails or interrupted
    cleanup()
    {
        set +e

        mountpoint="/mnt/${ID}"
        if mountpoint -q "$mountpoint" 2>/dev/null; then
            sudo umount -lf "$mountpoint" || true
        fi

        if [ -n "$loop" ]; then
            sudo kpartx -dv "$loop" 2>/dev/null || true
            sudo losetup -d "$loop" 2>/dev/null || true
        fi
    }
    trap cleanup EXIT ERR INT TERM



    echo -e "${GREEN}Estimating required disk size...${RESET}"

    # Get the size of our kernel and root fs
    KERNEL_BYTES=$(stat -c %s bzImage)
    ROOT_BYTES=$(du -B1 -s root/ | cut -f1)
    FILES_BYTES=$((KERNEL_BYTES + ROOT_BYTES))
    FILES_MIB=$(((FILES_BYTES + 1048575) / 1048576))

    # For a minimal build, the process is simpler since we have a pretty good
    # idea of the smallest acceptable disk size and have no need to factor in 
    # some overhead
    if [ "$BUILD_TYPE" = "minimal" ] && [ "$TARGET_DISK" -ge "$FILES_MIB" ]; then
        if [ "$TARGET_DISK" -le "$MINIMAL_TARGET_DISK" ]; then
            TOTAL_DISK_SIZE=$MINIMAL_TARGET_DISK
        else
            TOTAL_DISK_SIZE=$TARGET_DISK
        fi

        # Factor in target swap if provided
        if [ "$TARGET_SWAP" -ne 0 ]; then
            TOTAL_DISK_SIZE=$((TOTAL_DISK_SIZE + TARGET_SWAP))
        fi
    # Everything else...
    else
        # Calculate some overhead to take into account metadata, partition
        # alignment, bootloader structures, etc.
        OVERHEAD_BYTES=$((16 * 1024 * 1024))
        if [ "$INCLUDE_GCC" = true ] || [ "$INCLUDE_GUI" = true ]; then
            # We can assume these features demand more
            OVERHEAD_BYTES=$((32 * 1024 * 1024))
        fi
        OVERHEAD_MIB=$(((OVERHEAD_BYTES + 1048575) / 1048576))

        # Estimate how big of a disk we need to contain the three things above
        TOTAL_MIB=$((FILES_MIB + OVERHEAD_MIB))

        # Factor in target swap if provided
        if [ "$TARGET_SWAP" -ne 0 ]; then
            TOTAL_MIB=$((TOTAL_MIB + TARGET_SWAP))
        fi

        # Use target disk value if provided and large enough
        if [ -n "$TARGET_DISK" ]; then
            if [ "$TARGET_DISK" -lt "$TOTAL_MIB" ]; then
                echo -e "${YELLOW}WARNING: the provided target disk value (${TARGET_DISK}MiB) is smaller than required size (${TOTAL_MIB}MiB) - using calculated size instead${RESET}"
                TOTAL_DISK_SIZE=$TOTAL_MIB
            else
                echo -e "${GREEN}Using user-specified disk size (${TARGET_DISK}MiB)${RESET}"
                TOTAL_DISK_SIZE=$TARGET_DISK
            fi
        fi
    fi

    # Align to 4MiB boundary
    TOTAL_DISK_SIZE=$((((TOTAL_DISK_SIZE + 3) / 4) * 4))



    # Create the image
    echo -e "${GREEN}Creating the disk image...${RESET}"
    dd if=/dev/zero of="../images/${ID}.img" bs=1M count="$TOTAL_DISK_SIZE" status=progress

    # Enlarges the image so it ends on a whole CHS-cylinder boundary
    SECTORS_PER_CYL=$((DISK_HEADS*DISK_SECTORS_TRACK))
    IMG_SIZE=$(stat -c %s "../images/${ID}.img")
    SECTORS_NO=$((IMG_SIZE / 512))
    ALIGNED_SECTORS=$(((SECTORS_NO + SECTORS_PER_CYL - 1) / SECTORS_PER_CYL * SECTORS_PER_CYL))
    ALIGNED_IMG_SIZE=$((ALIGNED_SECTORS * 512))
    truncate -s "$ALIGNED_IMG_SIZE" "../images/${ID}.img"
    DISK_CYLINDERS=$((ALIGNED_SECTORS / SECTORS_PER_CYL))



    # Partition the image
    echo -e "${GREEN}Partitioning the disk image...${RESET}"
    partition_disk_img "$ALIGNED_SECTORS"

    # Ensure loop devices exist (Docker does not always create them)
    for i in $(seq 0 255); do
        [ -e /dev/loop$i ] || sudo mknod /dev/loop$i b 7 $i
    done
    [ -e /dev/loop-control ] || sudo mknod /dev/loop-control c 10 237

    # Expose partition
    loop=$(sudo losetup -f --show "../images/${ID}.img")
    sudo kpartx -av "$loop"
    root_part="/dev/mapper/$(basename "$loop")p1"
    if [ "$TARGET_SWAP" -ne 0 ]; then
        swap_part="/dev/mapper/$(basename "$loop")p2"
    fi

    # Create and populate root partition
    echo -e "${GREEN}Creating root partition...${RESET}"
    sudo mkfs.ext4 -F "$root_part"
    sudo mkdir -p "/mnt/${ID}"
    sudo mount "$root_part" "/mnt/${ID}"
    sudo cp -a root//. "/mnt/${ID}"
    sudo mkdir -p /mnt/$ID/{dev,proc,sys,boot}

    # Create swap partition if enabled
    if [ "$TARGET_SWAP" -ne 0 ]; then
        echo -e "${GREEN}Creating swap partition...${RESET}"
        sudo mkswap "$swap_part"
        echo "/dev/sda2 none swap sw 0 0" | sudo tee -a "/mnt/${ID}/etc/fstab"
    fi



    # Install the kernel
    echo -e "${GREEN}Copying kernel image...${RESET}"
    sudo cp bzImage "/mnt/${ID}/boot/bzImage"



    # Install a bootloader
    if $USE_GRUB; then
        install_grub_bootloader "$loop"
    else
        install_extlinux_bootloader
    fi



    # Ensure file system is in a clean state
    echo -e "${GREEN}Unmounting file system...${RESET}"
    sudo umount "/mnt/${ID}"
    sudo fsck.ext4 -f -p "$root_part"
}

# Copy after-build report to system (SHORK 486)
copy_report()
{
    cd $CURR_DIR/build/

    cleanup()
    {
        set +e

        mountpoint="/mnt/${ID}"
        if mountpoint -q "$mountpoint" 2>/dev/null; then
            sudo umount -lf "$mountpoint" || true
        fi

        if [ -n "$loop" ]; then
            sudo kpartx -dv "$loop" 2>/dev/null || true
            sudo losetup -d "$loop" 2>/dev/null || true
        fi
    }
    trap cleanup EXIT ERR INT TERM

    echo -e "${GREEN}Copying after-build report to disk image...${RESET}"

    # Expose the partition(s) in the existing image
    loop=$(sudo losetup -f --show "../images/${ID}.img")
    sudo kpartx -av "$loop"
    root_part="/dev/mapper/$(basename "$loop")p1"

    # Mount root partition and copy the report in
    sudo mkdir -p "/mnt/${ID}"
    sudo mount "$root_part" "/mnt/${ID}"
    sudo mkdir -p "/mnt/${ID}/var/log/shork"
    sudo cp "$CURR_DIR/images/report.txt" "/mnt/${ID}/var/log/shork/build-report.log"

    # Ensure file system is in a clean state
    echo -e "${GREEN}Unmounting file system...${RESET}"
    sudo umount "/mnt/${ID}"
    sudo fsck.ext4 -f -p "$root_part"
}

# Converts the disk image to VMware virtual machine disk format for testing
# (SHORK 486)
convert_disk_img()
{
    cd $CURR_DIR/images/

    echo -e "${GREEN}Creating VMware virtual machine disk from raw disk image...${RESET}"
    qemu-img convert -f raw -O vmdk "${ID}.img" "${ID}.vmdk"
}

# Build an optical disc image containing our system (SHORK DISC)
build_disc_img()
{
    cd $CURR_DIR/build/

    sudo mkdir -p "${DESTDIR}/boot/isolinux"

    # Install bootloader
    install_isolinux_bootloader

    # Copy ISOLINUX configuration
    echo -e "${GREEN}Copying ISOLINUX configuration...${RESET}"
    copy_sysfile $CURR_DIR/sysfiles/disc/isolinux.cfg  "${DESTDIR}/boot/isolinux/isolinux.cfg"

    # If required, specify the target scancode set
    if [[ $SCANCODE_SET != -1 ]]; then
        sudo sed -i "s/atkbd.extra=1/atkbd.set=${SCANCODE_SET} atkbd.extra=1/" "${DESTDIR}/boot/isolinux/isolinux.cfg"
    fi

    # Disable vdso32 if ENABLE_NO_VDS032
    if [ "$ENABLE_NO_VDS032" = true ]; then
        sudo sed -i "s/vdso32=1/vdso32=0/" "${DESTDIR}/boot/isolinux/isolinux.cfg"
    fi

    # Install the kernel
    echo -e "${GREEN}Copying kernel image...${RESET}"
    sudo cp bzImage "${DESTDIR}/boot/bzImage"

    sudo genisoimage \
        -o "${CURR_DIR}/images/${ID}.iso" \
        -b boot/isolinux/isolinux.bin \
        -c boot/isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -R -J \
        -V "SHORKDISC" \
        "$DESTDIR"
}

# Build a floppy diskette image containing our system (SHORK DISKETTE)
build_diskette_img()
{
    cd $CURR_DIR/build/

    # Cleans up all temporary block-device states when script exits, fails or interrupted
    cleanup()
    {
        set +e

        mountpoint="/mnt/${ID}"
        if mountpoint -q "$mountpoint" 2>/dev/null; then
            sudo umount -lf "$mountpoint" || true
        fi

        if [ -n "$loop" ]; then
            sudo kpartx -dv "$loop" 2>/dev/null || true
            sudo losetup -d "$loop" 2>/dev/null || true
        fi

        sudo rm -rf /mnt/$ID || true
    }
    trap cleanup EXIT ERR INT TERM

    # Create a diskette image
    DISKETTE_SIZE=$((1440 * TARGET_DISK))
    echo -e "${GREEN}Creating a ${DISKETTE_SIZE}-byte floppy diskette image...${RESET}"
    sudo dd if=/dev/zero of="../images/${ID}.img" bs=1k count=$DISKETTE_SIZE
    sudo mkdosfs -n SHORKDISK "../images/${ID}.img"

    # Install a bootloader
    install_syslinux_bootloader

    # Ensure loop devices exist (Docker does not always create them)
    for i in $(seq 0 255); do
        [ -e /dev/loop$i ] || sudo mknod /dev/loop$i b 7 $i
    done
    [ -e /dev/loop-control ] || sudo mknod /dev/loop-control c 10 237

    # Mount it for copying files
    echo -e "${GREEN}Mounting diskette image for copying files...${RESET}"
    sudo mkdir -p "/mnt/${ID}"
    LOOP=$(sudo losetup -f --show "../images/${ID}.img")
    sudo mount -t msdos -o rw "$LOOP" "/mnt/${ID}"

    # Copy SYSLINUX configuration
    echo -e "${GREEN}Copying SYSLINUX configuration...${RESET}"
    copy_sysfile $CURR_DIR/sysfiles/diskette/syslinux.cfg  "/mnt/${ID}/syslinux.cfg"

    # If required, specify the target scancode set
    if [[ $SCANCODE_SET != -1 ]]; then
        sudo sed -i "s/atkbd.extra=1/atkbd.set=${SCANCODE_SET} atkbd.extra=1/" "/mnt/${ID}/syslinux.cfg"
    fi

    # Disable vdso32 if ENABLE_NO_VDS032
    if [ "$ENABLE_NO_VDS032" = true ]; then
        sudo sed -i "s/vdso32=1/vdso32=0/" "/mnt/${ID}/syslinux.cfg"
    fi

    # Install the kernel
    echo -e "${GREEN}Copying kernel image...${RESET}"
    sudo cp bzImage "/mnt/${ID}"

    # Copy compressed root file system
    echo -e "${GREEN}Copying compressed root file system...${RESET}"
    sudo cp rootfs.cpio.xz "/mnt/${ID}"

    # Make directory to be used as /home when booted
    sudo mkdir "/mnt/${ID}/data" || true

    # Unmount the image
    echo -e "${GREEN}Unmounting diskette image...${RESET}"
    sudo umount "/mnt/${ID}"
    sudo losetup -d "$LOOP"
}



######################################################
## End of build report generation                   ##
######################################################

# Checks if a given BusyBox .config feature is included and puts it in either
# an EXCLUDED or INCLUDED list for the after-build report to display
check_bb_config()
{
    DOT_CONFIG="${CURR_DIR}/build/busybox-${BUSYBOX_VER}/.config"

    local symbol="$1"
    local name="$2"

    if [ -z "$symbol" ] && [ -z "$name" ] ; then
        return
    fi

    if [ -z "$name" ]; then
        name="${symbol#CONFIG_}"
        name="${name,,}"
    fi

    if grep -q "${symbol}=y" "$DOT_CONFIG"; then
        INCLUDED_BB_CMDS+=("$name")
    else
        EXCLUDED_BB_CMDS+=("$name")
    fi
}

# Checks what BusyBox commands are enabled
get_included_busybox_commands()
{
    check_bb_config "CONFIG_AR" ""
    check_bb_config "CONFIG_XZ" ""
    check_bb_config "CONFIG_GZIP" ""
    check_bb_config "CONFIG_TAR" ""
    check_bb_config "CONFIG_UNZIP" ""
    check_bb_config "CONFIG_BASENAME" ""
    check_bb_config "CONFIG_CAT" ""
    check_bb_config "CONFIG_CHGRP" ""
    check_bb_config "CONFIG_CHMOD" ""
    check_bb_config "CONFIG_CHOWN" ""
    check_bb_config "CONFIG_CHROOT" ""
    check_bb_config "CONFIG_CP" ""
    check_bb_config "CONFIG_CUT" ""
    check_bb_config "CONFIG_DATE" ""
    check_bb_config "CONFIG_DD" ""
    check_bb_config "CONFIG_DF" ""
    check_bb_config "CONFIG_DIRNAME" ""
    check_bb_config "CONFIG_DOS2UNIX" ""
    check_bb_config "CONFIG_UNIX2DOS" ""
    check_bb_config "CONFIG_DU" ""
    check_bb_config "CONFIG_ECHO" ""
    check_bb_config "CONFIG_ENV" ""
    check_bb_config "CONFIG_EXPAND" ""
    check_bb_config "CONFIG_UNEXPAND" ""
    check_bb_config "CONFIG_EXPR" ""
    check_bb_config "CONFIG_FALSE" ""
    check_bb_config "CONFIG_FOLD" ""
    check_bb_config "CONFIG_HEAD" ""
    check_bb_config "CONFIG_LN" ""
    check_bb_config "CONFIG_LS" ""
    check_bb_config "CONFIG_MKDIR" ""
    check_bb_config "CONFIG_MKNOD" ""
    check_bb_config "CONFIG_MV" ""
    check_bb_config "CONFIG_NICE" ""
    check_bb_config "CONFIG_NOHUP" ""
    check_bb_config "CONFIG_NPROC" ""
    check_bb_config "CONFIG_PASTE" ""
    check_bb_config "CONFIG_PRINTENV" ""
    check_bb_config "CONFIG_PRINTF" ""
    check_bb_config "CONFIG_PWD" ""
    check_bb_config "CONFIG_READLINK" ""
    check_bb_config "CONFIG_RM" ""
    check_bb_config "CONFIG_RMDIR" ""
    check_bb_config "CONFIG_SEQ" ""
    check_bb_config "CONFIG_SLEEP" ""
    check_bb_config "CONFIG_STAT" ""
    check_bb_config "CONFIG_STTY" ""
    check_bb_config "CONFIG_SYNC" ""
    check_bb_config "CONFIG_TEE" ""
    check_bb_config "CONFIG_TEST" ""
    check_bb_config "CONFIG_TOUCH" ""
    check_bb_config "CONFIG_TR" ""
    check_bb_config "CONFIG_TRUE" ""
    check_bb_config "CONFIG_TRUNCATE" ""
    check_bb_config "CONFIG_TTY" ""
    check_bb_config "CONFIG_UNAME" ""
    check_bb_config "CONFIG_BB_ARCH" "arch"
    check_bb_config "CONFIG_USLEEP" ""
    check_bb_config "CONFIG_WC" ""
    check_bb_config "CONFIG_WHO" ""
    check_bb_config "CONFIG_W" ""
    check_bb_config "CONFIG_USERS" ""
    check_bb_config "CONFIG_WHOAMI" ""
    check_bb_config "CONFIG_YES" ""
    check_bb_config "CONFIG_CHVT" ""
    check_bb_config "CONFIG_CLEAR" ""
    check_bb_config "CONFIG_SETFONT" ""
    check_bb_config "CONFIG_LOADKMAP" ""
    check_bb_config "CONFIG_SHOWKEY" ""
    check_bb_config "CONFIG_WHICH" ""
    check_bb_config "CONFIG_AWK" ""
    check_bb_config "CONFIG_DIFF" ""
    check_bb_config "CONFIG_ED" ""
    check_bb_config "CONFIG_PATCH" ""
    check_bb_config "CONFIG_SED" ""
    check_bb_config "CONFIG_VI" ""
    check_bb_config "CONFIG_FIND" ""
    check_bb_config "CONFIG_GREP" ""
    check_bb_config "CONFIG_HALT" ""
    check_bb_config "CONFIG_INIT" ""
    check_bb_config "CONFIG_ADDGROUP" ""
    check_bb_config "CONFIG_ADDUSER" ""
    check_bb_config "CONFIG_CHPASSWD" ""
    check_bb_config "CONFIG_CRYPTPW" ""
    check_bb_config "CONFIG_MKPASSWD" ""
    check_bb_config "CONFIG_DELUSER" ""
    check_bb_config "CONFIG_DELGROUP" ""
    check_bb_config "CONFIG_GETTY" ""
    check_bb_config "CONFIG_LOGIN" ""
    check_bb_config "CONFIG_PASSWD" ""
    check_bb_config "CONFIG_SU" ""
    check_bb_config "CONFIG_SULOGIN" ""
    check_bb_config "CONFIG_BLKID" ""
    check_bb_config "CONFIG_CAL" ""
    check_bb_config "CONFIG_DMESG" ""
    check_bb_config "CONFIG_EJECT" ""
    check_bb_config "CONFIG_FDFORMAT" ""
    check_bb_config "CONFIG_FDISK" ""
    check_bb_config "CONFIG_HEXDUMP" ""
    if ! $INCLUDE_VIM; then
        check_bb_config "CONFIG_XXD" ""
    else
        EXCLUDED_BB_CMDS+=("xxd")
    fi
    check_bb_config "CONFIG_LOSETUP" ""
    check_bb_config "CONFIG_LSBLK" ""
    check_bb_config "CONFIG_LSPCI" ""
    check_bb_config "CONFIG_LSUSB" ""
    check_bb_config "CONFIG_MDEV" ""
    check_bb_config "CONFIG_MKFS_EXT2" "mkdosfs/mkfs.ext2"
    check_bb_config "CONFIG_MKFS_VFAT" "mke2fs/mkfs.vfat"
    check_bb_config "CONFIG_MKSWAP" ""
    check_bb_config "CONFIG_MOUNT" ""
    check_bb_config "CONFIG_MOUNTPOINT" ""
    check_bb_config "CONFIG_REV" ""
    check_bb_config "CONFIG_SWAPON" ""
    check_bb_config "CONFIG_SWAPOFF" ""
    check_bb_config "CONFIG_TASKSET" ""
    check_bb_config "CONFIG_UMOUNT" ""
    check_bb_config "CONFIG_UUIDGEN" ""
    check_bb_config "CONFIG_ASCII" ""
    check_bb_config "CONFIG_BC" ""
    check_bb_config "CONFIG_DC" ""
    check_bb_config "CONFIG_BEEP" ""
    check_bb_config "CONFIG_CRONTAB" ""
    check_bb_config "CONFIG_GETFATTR" ""
    check_bb_config "CONFIG_LESS" ""
    check_bb_config "CONFIG_MAN" ""
    check_bb_config "CONFIG_PARTPROBE" ""
    check_bb_config "CONFIG_SETFATTR" ""
    check_bb_config "CONFIG_TIME" ""
    check_bb_config "CONFIG_TREE" ""
    check_bb_config "CONFIG_VOLNAME" ""
    check_bb_config "CONFIG_FTPGET" ""
    check_bb_config "CONFIG_FTPPUT" ""
    check_bb_config "CONFIG_HOSTNAME" ""
    check_bb_config "CONFIG_IFCONFIG" ""
    check_bb_config "CONFIG_IP" ""
    check_bb_config "CONFIG_PING" ""
    check_bb_config "CONFIG_ROUTE" ""
    check_bb_config "CONFIG_TELNET" ""
    check_bb_config "CONFIG_TRACEROUTE" ""
    check_bb_config "CONFIG_WGET" ""
    check_bb_config "CONFIG_WHOIS" ""
    check_bb_config "CONFIG_UDHCPC" ""
    check_bb_config "CONFIG_FREE" ""
    check_bb_config "CONFIG_KILL" ""
    check_bb_config "CONFIG_KILLALL" ""
    check_bb_config "CONFIG_PKILL" ""
    check_bb_config "CONFIG_PMAP" ""
    check_bb_config "CONFIG_PS" ""
    check_bb_config "CONFIG_PSTREE" ""
    check_bb_config "CONFIG_TOP" ""
    check_bb_config "CONFIG_UPTIME" ""
    check_bb_config "CONFIG_VMSTAT" ""
    check_bb_config "CONFIG_ASH" ""

    # Added 2026-06-30
    check_bb_config "CONFIG_UNCOMPRESS" ""
    check_bb_config "CONFIG_GUNZIP" ""
    check_bb_config "CONFIG_ZCAT" ""
    check_bb_config "CONFIG_BUNZIP2" ""
    check_bb_config "CONFIG_BZCAT" ""
    check_bb_config "CONFIG_UNLZMA" ""
    check_bb_config "CONFIG_LZCAT" ""
    check_bb_config "CONFIG_LZMA" ""
    check_bb_config "CONFIG_UNXZ" ""
    check_bb_config "CONFIG_XZCAT" ""
    check_bb_config "CONFIG_BZIP2" ""
    check_bb_config "CONFIG_CPIO" ""
    check_bb_config "CONFIG_LZOP" ""
    check_bb_config "CONFIG_UNLZOP" ""
    check_bb_config "CONFIG_LZOPCAT" ""

    # Added 2026-07-16
    check_bb_config "CONFIG_CKSUM" ""
    check_bb_config "CONFIG_CRC32" ""
    check_bb_config "CONFIG_COMM" ""
    check_bb_config "CONFIG_FACTOR" ""
    check_bb_config "CONFIG_HOSTID" ""
    check_bb_config "CONFIG_INSTALL" ""
    check_bb_config "CONFIG_LINK" ""
    check_bb_config "CONFIG_MD5SUM" ""
    check_bb_config "CONFIG_SHA1SUM" ""
    check_bb_config "CONFIG_SHA256SUM" ""
    check_bb_config "CONFIG_SHA384SUM" ""
    check_bb_config "CONFIG_SHA512SUM" ""
    check_bb_config "CONFIG_SHA3SUM" ""
    check_bb_config "CONFIG_MKFIFO" ""
    check_bb_config "CONFIG_MKTEMP" ""
    check_bb_config "CONFIG_NL" ""
    check_bb_config "CONFIG_OD" ""
    check_bb_config "CONFIG_REALPATH" ""
    check_bb_config "CONFIG_SHRED" ""
    check_bb_config "CONFIG_SHUF" ""
    check_bb_config "CONFIG_SORT" ""
    check_bb_config "CONFIG_SPLIT" ""
    check_bb_config "CONFIG_SUM" ""
    check_bb_config "CONFIG_TAC" ""
    check_bb_config "CONFIG_TAIL" ""
    check_bb_config "CONFIG_TIMEOUT" ""
    check_bb_config "CONFIG_TSORT" ""
    check_bb_config "CONFIG_UNIQ" ""
    check_bb_config "CONFIG_UNLINK" ""
    check_bb_config "CONFIG_BASE32" ""
    check_bb_config "CONFIG_BASE64" ""
    check_bb_config "CONFIG_ID" ""
    check_bb_config "CONFIG_LOGNAME" ""

    # Added 2026-07-17
    check_bb_config "CONFIG_FALLOCATE" ""

    # Added 2026-07-18
    check_bb_config "CONFIG_EGREP" ""
    check_bb_config "CONFIG_FGREP" ""
    check_bb_config "CONFIG_XARGS" ""
    check_bb_config "CONFIG_FDFLUSH" ""
    check_bb_config "CONFIG_GETOPT" ""
    check_bb_config "CONFIG_HWCLOCK" ""
    check_bb_config "CONFIG_MORE" ""
    check_bb_config "CONFIG_HEXEDIT" ""
    check_bb_config "CONFIG_LSSCSI" ""
    check_bb_config "CONFIG_STRINGS" ""
    check_bb_config "CONFIG_FUSER" ""
    check_bb_config "CONFIG_IOSTAT" ""
    check_bb_config "CONFIG_LSOF" ""
    check_bb_config "CONFIG_PGREP" ""
    check_bb_config "CONFIG_PIDOF" ""
    check_bb_config "CONFIG_PWDX" ""
    check_bb_config "CONFIG_WATCH" ""
    check_bb_config "CONFIG_NETCAT" ""

    readarray -t INCLUDED_BB_CMDS < <(printf '%s\n' "${INCLUDED_BB_CMDS[@]}" | sort)
    readarray -t EXCLUDED_BB_CMDS < <(printf '%s\n' "${EXCLUDED_BB_CMDS[@]}" | sort)
}

# Checks what kernel-level support, programs and features are enabled and
# puts them in either an EXCLUDED or INCLUDED list for the after-build report
# to display
get_installed_programs_features()
{
    # Kernel features
    if [ "$ID" == "shork-486" ]; then
        if $INCLUDE_GUI; then
            INCLUDED_FEATURES+="\n * kernel-level event interface support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level event interface support"
        fi
    fi

    if [ "$ID" != "shork-disc" ]; then
        if $ENABLE_CDROM; then
            INCLUDED_FEATURES+="\n * kernel-level CD-ROM & DVD-ROM support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level CD-ROM & DVD-ROM support"
        fi
    fi

    if [ "$ID" == "shork-486" ]; then
        if $ENABLE_FB; then
            INCLUDED_FEATURES+="\n * kernel-level framebuffer, VESA & enhanced VGA support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level framebuffer, VESA & enhanced VGA support"
        fi

        if $ENABLE_HIGHMEM; then
            INCLUDED_FEATURES+="\n * kernel-level high memory support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level high memory support"
        fi

        if $ENABLE_MULTIUSER_KRN; then
            INCLUDED_FEATURES+="\n * kernel-level multi-user support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level multi-user support"
        fi

        if $ENABLE_NET_BASE; then
            INCLUDED_FEATURES+="\n * kernel-level networking support (base)"
        else
            EXCLUDED_FEATURES+="\n * kernel-level networking support (base)"
        fi

        if $ENABLE_NET_ETH; then
            INCLUDED_FEATURES+="\n * kernel-level networking support (ethernet)"
        else
            EXCLUDED_FEATURES+="\n * kernel-level networking support (ethernet)"
        fi

        if $ENABLE_NET_PCMCIA; then
            INCLUDED_FEATURES+="\n * kernel-level networking support (PCMCIA)"
        else
            EXCLUDED_FEATURES+="\n * kernel-level networking support (PCMCIA)"
        fi

        if $ENABLE_PCMCIA; then
            INCLUDED_FEATURES+="\n * kernel-level PCMCIA support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level PCMCIA support"
        fi

        if $ENABLE_SATA; then
            INCLUDED_FEATURES+="\n * kernel-level SATA support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level SATA support"
        fi

        if $ENABLE_SCSI_EXP; then
            INCLUDED_FEATURES+="\n * kernel-level SCSI media changer & tape drive support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level SCSI media changer & tape drive support"
        fi

        if $ENABLE_SOUND; then
            INCLUDED_FEATURES+="\n * kernel-level sound support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level sound support"
        fi

        if $ENABLE_TASKSTATS; then
            INCLUDED_FEATURES+="\n * kernel-level taskstats support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level taskstats support"
        fi

        if $ENABLE_USB; then
            INCLUDED_FEATURES+="\n * kernel-level USB & HID support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level USB & HID support"
        fi

        if $ENABLE_ZSWAP; then
            INCLUDED_FEATURES+="\n * kernel-level zswap support"
        else
            EXCLUDED_FEATURES+="\n * kernel-level zswap support"
        fi
    fi

    # Misc features
    if [ "$ID" == "shork-486" ]; then
        if [ -d "$DESTDIR/usr/share/consolefonts" ]; then
            INCLUDED_FEATURES+="\n * console fonts pack"
        else
            EXCLUDED_FEATURES+="\n * console fonts pack"
        fi

        if [ -d "$DESTDIR/usr/share/keymaps" ]; then
            INCLUDED_FEATURES+="\n * keymaps"
        else
            EXCLUDED_FEATURES+="\n * keymaps"
        fi

        if [ -f "$DESTDIR/usr/local/musl/lib/libc.so" ]; then
            INCLUDED_FEATURES+="\n * musl (for TCC, $MUSL_VER)"
        else
            EXCLUDED_FEATURES+="\n * musl (for TCC)"
        fi

        if [ -f "$DESTDIR/usr/share/misc/pci.ids" ]; then
            INCLUDED_FEATURES+="\n * pci.ids database"
        else
            EXCLUDED_FEATURES+="\n * pci.ids database"
        fi
    fi

    # SHORK Utilities
    if [ "$ID" != "shork-diskette" ]; then
        if [ -f "$DESTDIR/usr/bin/shorkdir" ]; then
            INCLUDED_FEATURES+="\n * shorkdir"
        else
            EXCLUDED_FEATURES+="\n * shorkdir"
        fi
    fi

    if [ -f "$DESTDIR/usr/bin/shorkfetch" ]; then
        INCLUDED_FEATURES+="\n * shorkfetch"
    else
        EXCLUDED_FEATURES+="\n * shorkfetch"
    fi

    if [ "$ID" == "shork-486" ]; then
        if [ -f "$DESTDIR/usr/bin/shorkgui" ]; then
            INCLUDED_FEATURES+="\n * shorkgui"
        else
            EXCLUDED_FEATURES+="\n * shorkgui"
        fi
    fi

    if [ -f "$DESTDIR/usr/bin/shorkhelp" ]; then
        INCLUDED_FEATURES+="\n * shorkhelp"
    else
        EXCLUDED_FEATURES+="\n * shorkhelp"
    fi

    if [ "$ID" == "shork-486" ]; then
        if [ -f "$DESTDIR/sbin/shorkoff" ]; then
            INCLUDED_FEATURES+="\n * shorkoff"
        else
            EXCLUDED_FEATURES+="\n * shorkoff"
        fi

        if [ -f "$DESTDIR/usr/libexec/shorkset" ]; then
            INCLUDED_FEATURES+="\n * shorkset"
        else
            EXCLUDED_FEATURES+="\n * shorkset"
        fi
    fi

    # SHORK Entertainment
    if [ "$ID" != "shork-diskette" ]; then
        if [ -f "$DESTDIR/usr/bin/shorklocomotive" ]; then
            INCLUDED_FEATURES+="\n * shorklocomotive"
        else
            EXCLUDED_FEATURES+="\n * shorklocomotive"
        fi

        if [ -f "$DESTDIR/usr/bin/shorkmatrix" ]; then
            INCLUDED_FEATURES+="\n * shorkmatrix"
        else
            EXCLUDED_FEATURES+="\n * shorkmatrix"
        fi

        if [ -f "$DESTDIR/usr/bin/shorkmines" ]; then
            INCLUDED_FEATURES+="\n * shorkmines"
        else
            EXCLUDED_FEATURES+="\n * shorkmines"
        fi

        if [ -f "$DESTDIR/usr/bin/shorksay" ]; then
            INCLUDED_FEATURES+="\n * shorksay"
        else
            EXCLUDED_FEATURES+="\n * shorksay"
        fi
    fi

    # SHORKGUI
    if [ "$ID" == "shork-486" ]; then
        if [ -f "$DESTDIR/usr/bin/oneko" ]; then
            INCLUDED_FEATURES+="\n * oneko"
        else
            EXCLUDED_FEATURES+="\n * oneko"
        fi

        if [ -f "$DESTDIR/usr/bin/st" ]; then
            INCLUDED_FEATURES+="\n * st"
        else
            EXCLUDED_FEATURES+="\n * st"
        fi

        if [ -f "$DESTDIR/usr/bin/twm" ]; then
            INCLUDED_FEATURES+="\n * twm"
        else
            EXCLUDED_FEATURES+="\n * twm"
        fi

        if [ -f "$DESTDIR/usr/bin/xcalc" ]; then
            INCLUDED_FEATURES+="\n * xcalc"
        else
            EXCLUDED_FEATURES+="\n * xcalc"
        fi

        if [ -f "$DESTDIR/usr/bin/xclock" ]; then
            INCLUDED_FEATURES+="\n * xclock"
        else
            EXCLUDED_FEATURES+="\n * xclock"
        fi

        if [ -f "$DESTDIR/usr/bin/xeyes" ]; then
            INCLUDED_FEATURES+="\n * xeyes"
        else
            EXCLUDED_FEATURES+="\n * xeyes"
        fi

        if [ -f "$DESTDIR/usr/bin/xli" ]; then
            INCLUDED_FEATURES+="\n * xli"
        else
            EXCLUDED_FEATURES+="\n * xli"
        fi

        if [ -f "$DESTDIR/usr/bin/xload" ]; then
            INCLUDED_FEATURES+="\n * xload"
        else
            EXCLUDED_FEATURES+="\n * xload"
        fi

        if [ -f "$DESTDIR/usr/bin/Xfbdev" ]; then
            INCLUDED_FEATURES+="\n * Xfbdev (TinyX)"
        else
            EXCLUDED_FEATURES+="\n * Xfbdev (TinyX)"
        fi

        if [ -f "$DESTDIR/usr/bin/xset" ]; then
            INCLUDED_FEATURES+="\n * xset"
        else
            EXCLUDED_FEATURES+="\n * xset"
        fi
    fi

    # SHORKTUI
    if [ "$ID" == "shork-486" ]; then
        if $INCLUDE_GCC; then
            INCLUDED_FEATURES+="\n * as"
            INCLUDED_FEATURES+="\n * g++"
            INCLUDED_FEATURES+="\n * gcc"
            INCLUDED_FEATURES+="\n * gfortran"
        else
            EXCLUDED_FEATURES+="\n * as"
            EXCLUDED_FEATURES+="\n * g++"
            EXCLUDED_FEATURES+="\n * gcc"
            EXCLUDED_FEATURES+="\n * gfortran"
        fi

        # TODO: Add Binutils

        if [ -f "$DESTDIR/usr/bin/c3270" ]; then
            INCLUDED_FEATURES+="\n * c3270 ($C3270_VER)"
        else
            EXCLUDED_FEATURES+="\n * c3270"
        fi

        if [ -f "$DESTDIR/usr/bin/cscope" ]; then
            INCLUDED_FEATURES+="\n * cscope ($CSCOPE_VER)"
        else
            EXCLUDED_FEATURES+="\n * cscope"
        fi

        if [ -f "$DESTDIR/usr/bin/ctags" ]; then
            INCLUDED_FEATURES+="\n * ctags (Universal Ctags, $CTAGS_VER)"
        else
            EXCLUDED_FEATURES+="\n * ctags"
        fi

        if [ -f "$DESTDIR/usr/bin/dialog" ]; then
            INCLUDED_FEATURES+="\n * dialog ($DIALOG_VER)"
        else
            EXCLUDED_FEATURES+="\n * dialog"
        fi
    fi

    if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
        if [ -f "$DESTDIR/usr/bin/file" ]; then
            INCLUDED_FEATURES+="\n * file ($FILE_VER)"
        else
            EXCLUDED_FEATURES+="\n * file"
        fi
    fi

    if [ "$ID" == "shork-486" ]; then
        if [ -f "$DESTDIR/usr/bin/ftp" ]; then
            INCLUDED_FEATURES+="\n * ftp (tnftp, $TNFTP_VER)"
        else
            EXCLUDED_FEATURES+="\n * ftp (tnftp)"
        fi

        if [ -f "$DESTDIR/usr/bin/git" ]; then
            INCLUDED_FEATURES+="\n * git ($GIT_VER)"
        else
            EXCLUDED_FEATURES+="\n * git"
        fi

        if [ -f "$DESTDIR/usr/bin/htop" ]; then
            INCLUDED_FEATURES+="\n * htop ($HTOP_VER)"
        else
            EXCLUDED_FEATURES+="\n * htop"
        fi

        if [ -f "$DESTDIR/usr/bin/indent" ]; then
            INCLUDED_FEATURES+="\n * indent ($INDENT_VER)"
        else
            EXCLUDED_FEATURES+="\n * indent"
        fi

        if [ -f "$DESTDIR/usr/bin/joe" ]; then
            INCLUDED_FEATURES+="\n * joe ($JOE_VER)"
        else
            EXCLUDED_FEATURES+="\n * joe"
        fi
    fi

    if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
        if [ -f "$DESTDIR/usr/bin/lscpu" ]; then
            INCLUDED_FEATURES+="\n * lscpu (util-linux, $UTIL_LINUX_VER)"
        else
            EXCLUDED_FEATURES+="\n * lscpu (util-linux)"
        fi
    fi

    if [ "$ID" == "shork-486" ]; then
        if [ -f "$DESTDIR/usr/bin/lynx" ]; then
            INCLUDED_FEATURES+="\n * lynx ($LYNX_VER)"
        else
            EXCLUDED_FEATURES+="\n * lynx"
        fi

        if [ -f "$DESTDIR/usr/bin/make" ]; then
            INCLUDED_FEATURES+="\n * make ($MAKE_VER)"
        else
            EXCLUDED_FEATURES+="\n * make"
        fi

        if [ -f "$DESTDIR/usr/bin/mg" ]; then
            INCLUDED_FEATURES+="\n * mg ($MG_VER)"
        else
            EXCLUDED_FEATURES+="\n * mg"
        fi

        if [ -f "$DESTDIR/usr/bin/micropython" ]; then
            INCLUDED_FEATURES+="\n * micropython ($MICROPYTHON_VER)"
        else
            EXCLUDED_FEATURES+="\n * micropython"
        fi

        if [ -f "$DESTDIR/usr/bin/mpg321" ]; then
            INCLUDED_FEATURES+="\n * mpg321 ($MPG321_VER)"
        else
            EXCLUDED_FEATURES+="\n * mpg321"
        fi

        if [ -f "$DESTDIR/bin/mt" ]; then
            INCLUDED_FEATURES+="\n * mt (mt-st, $MT_ST_VER)"
        else
            EXCLUDED_FEATURES+="\n * mt"
        fi

        if [ -f "$DESTDIR/usr/bin/nano" ]; then
            INCLUDED_FEATURES+="\n * nano ($NANO_VER)"
        else
            EXCLUDED_FEATURES+="\n * nano"
        fi

        if [ -f "$DESTDIR/usr/bin/nasm" ]; then
            INCLUDED_FEATURES+="\n * nasm (NASM, $NASM_VER)"
        else
            EXCLUDED_FEATURES+="\n * nasm"
        fi

        if [ -f "$DESTDIR/usr/bin/ndisasm" ]; then
            INCLUDED_FEATURES+="\n * ndisasm (NASM, $NASM_VER)"
        else
            EXCLUDED_FEATURES+="\n * ndisasm"
        fi
    fi

    if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
        if [ -f "$DESTDIR/usr/bin/partx" ]; then
            INCLUDED_FEATURES+="\n * partx (util-linux, $UTIL_LINUX_VER)"
        else
            EXCLUDED_FEATURES+="\n * partx (util-linux)"
        fi
    fi

    if [ "$ID" == "shork-486" ]; then
        if [ -f "$DESTDIR/usr/bin/readtags" ]; then
            INCLUDED_FEATURES+="\n * readtags (Universal Ctags, $CTAGS_VER)"
        else
            EXCLUDED_FEATURES+="\n * readtags"
        fi

        if [ -f "$DESTDIR/usr/bin/scp" ]; then
            INCLUDED_FEATURES+="\n * scp (Dropbear, $DROPBEAR_VER)"
        else
            EXCLUDED_FEATURES+="\n * scp (Dropbear)"
        fi

        if [ -f "$DESTDIR/usr/bin/sc-im" ]; then
            INCLUDED_FEATURES+="\n * sc-im ($SC_IM_VER)"
        else
            EXCLUDED_FEATURES+="\n * sc-im"
        fi
    fi

    if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
        if [ -f "$DESTDIR/usr/sbin/sfdisk" ]; then
            INCLUDED_FEATURES+="\n * sfdisk (util-linux, $UTIL_LINUX_VER)"
        else
            EXCLUDED_FEATURES+="\n * sfdisk (util-linux)"
        fi
    fi

    if [ "$ID" == "shork-486" ]; then
        if [ -f "$DESTDIR/usr/bin/ssh" ]; then
            INCLUDED_FEATURES+="\n * ssh (Dropbear, $DROPBEAR_VER)"
        else
            EXCLUDED_FEATURES+="\n * ssh (Dropbear)"
        fi

        if [ -f "$DESTDIR/sbin/stinit" ]; then
            INCLUDED_FEATURES+="\n * stinit (mt-st, $MT_ST_VER)"
        else
            EXCLUDED_FEATURES+="\n * stinit"
        fi
    fi

    if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
        if [ -f "$DESTDIR/usr/bin/strace" ]; then
            INCLUDED_FEATURES+="\n * strace ($STRACE_VER)"
        else
            EXCLUDED_FEATURES+="\n * strace"
        fi
    fi

    if [ "$ID" == "shork-486" ]; then
        if [ -f "$DESTDIR/usr/local/bin/i386-tcc" ]; then
            INCLUDED_FEATURES+="\n * tcc ($TCC_VER)"
        else
            EXCLUDED_FEATURES+="\n * tcc"
        fi

        if [ -f "$DESTDIR/usr/bin/tic" ]; then
            INCLUDED_FEATURES+="\n * tic ($NCURSES_VER)"
        else
            EXCLUDED_FEATURES+="\n * tic"
        fi

        #if [ -f "$DESTDIR/usr/bin/tilde" ]; then
        #    INCLUDED_FEATURES+="\n * tilde ($TILDE_VER)"
        #else
        #    EXCLUDED_FEATURES+="\n * tilde"
        #fi

        if [ -f "$DESTDIR/usr/bin/tmux" ]; then
            INCLUDED_FEATURES+="\n * tmux ($TMUX_VER)"
        else
            EXCLUDED_FEATURES+="\n * tmux"
        fi

        if [ -f "$DESTDIR/usr/bin/tn5250" ]; then
            INCLUDED_FEATURES+="\n * tn5250 ($TN5250_VER)"
        else
            EXCLUDED_FEATURES+="\n * tn5250"
        fi

        if [ -f "$DESTDIR/usr/bin/vim" ]; then
            INCLUDED_FEATURES+="\n * vim (Vim, $VIM_VER)"
        else
            EXCLUDED_FEATURES+="\n * vim (Vim)"
        fi

        if [ -f "$DESTDIR/usr/bin/vimtutor" ]; then
            INCLUDED_FEATURES+="\n * vimtutor (Vim, $VIM_VER)"
        else
            EXCLUDED_FEATURES+="\n * vimtutor (Vim)"
        fi
    fi

    if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
        if [ -f "$DESTDIR/usr/bin/whereis" ]; then
            INCLUDED_FEATURES+="\n * whereis (util-linux, $UTIL_LINUX_VER)"
        else
            EXCLUDED_FEATURES+="\n * whereis (util-linux)"
        fi
    fi

    if [ "$ID" == "shork-486" ]; then
        if $INCLUDE_VIM && [ -f "$DESTDIR/usr/bin/xxd" ]; then
            INCLUDED_FEATURES+="\n * xxd (Vim, $VIM_VER)"
        else
            EXCLUDED_FEATURES+="\n * xxd (Vim)"
        fi
    fi
}

# Generate a report to go in the images folder to indicate details about this build
generate_report()
{
    DATE=$(date "+%Y-%m-%d  %H:%M:%S")
    END_TIME=$(date +%s)
    TOTAL_SECONDS=$(( END_TIME - START_TIME ))
    MINS=$(( TOTAL_SECONDS / 60 ))
    SECS=$(( TOTAL_SECONDS % 60 ))

    BUSYBOX_VER="${BUSYBOX_VER//_/.}"

    local lines=(
        "================================================================================"
        "==                          SHORK after-build report                          =="
        "================================================================================"
        "==                            $DATE                            =="
        "================================================================================"
        ""
        "OS/version:          $DIST $VER"
        "Kernel:              Linux $LINUX_VER"
        "Base:                BusyBox $BUSYBOX_VER"
        "Bootloader:          $BOOTLDR_USED"
    )

    if [ "$ID" == "shork-486" ]; then
        lines+=(
            ""
            "Build type:          $BUILD_TYPE"
            "Build time:          $MINS minutes, $SECS seconds"
        )
    else
        lines+=(
            ""
            "Build time:          $MINS minutes, $SECS seconds"
        )
    fi

    if [ -n "$USED_PARAMS" ]; then
        lines+=(
            "Build parameters:$USED_PARAMS"
        )
    fi
    
    if $DOTENV_USED; then
        lines+=(".env used:           yes")
    else
        lines+=(".env used:           no")
    fi

    if [ "$ID" == "shork-486" ]; then
        lines+=(
            ""
            "Est. minimum RAM:    ${EST_MIN_RAM}"
            "Total disk size:     ${TOTAL_DISK_SIZE}MiB"
            "Root partition size: ${ROOT_PART_SIZE}MiB"
        )

        if [ "$TARGET_SWAP" -ne 0 ]; then
            lines+=("Swap partition size: ${TARGET_SWAP}MiB")
        fi

        lines+=(
            "CHS geometry:        $DISK_CYLINDERS/$DISK_HEADS/$DISK_SECTORS_TRACK"
        )

        if $ENABLE_MENU; then
            lines+=("Boot style:          menu")
        else
            lines+=("Boot style:          boot only")
        fi
    elif [ "$ID" == "shork-disc" ]; then
        DISC_B=$(stat -c%s "${CURR_DIR}/images/${ID}.iso")
        DISC_MB=$(echo "scale=2; $DISC_B / 1000000" | bc)
        lines+=(
            ""
            "Est. minimum RAM:    ${EST_MIN_RAM}"
            "Disc size:           ${DISC_MB}MB"
        )
    elif [ "$ID" == "shork-diskette" ]; then
        DISKETTE_B=$(( 1440 * TARGET_DISK ))
        DISKETTE_MB=$(echo "scale=2; $DISKETTE_B / 1000" | bc)
        lines+=(
            ""
            "Est. minimum RAM:    ${EST_MIN_RAM}"
            "Diskette size:       ${DISKETTE_MB}MB"
        )
    fi



    if [[ ${#INCLUDED_BB_CMDS[@]} -gt 0 ]]; then
        INCL_BB_CMDS_LINES=()
        line=""
        for CMD in "${INCLUDED_BB_CMDS[@]}"; do
            if [[ -z "$line" ]]; then
                NEW=" * $CMD"
            else
                NEW="$line, $CMD"
            fi
            if (( ${#NEW} > 80 )); then
                INCL_BB_CMDS_LINES+=("$line")
                line=" * $CMD"
            else
                line="$NEW"
            fi
        done
        INCL_BB_CMDS_LINES+=("$line")

        lines+=(
            ""
            "Included BusyBox commands:"
        )
        for l in "${INCL_BB_CMDS_LINES[@]}"; do
            lines+=("$l")
        done
    fi



    if [ -n "$INCLUDED_FEATURES" ]; then
        lines+=(
            ""
            "Included programs & features:$INCLUDED_FEATURES"
        )
    fi


    if [ "$ID" == "shork-486" ] && [[ ${#EXCLUDED_BB_CMDS[@]} -gt 0 ]]; then
        EXCL_BB_CMDS_LINES=()
        line=""
        for CMD in "${EXCLUDED_BB_CMDS[@]}"; do
            if [[ -z "$line" ]]; then
                NEW=" * $CMD"
            else
                NEW="$line, $CMD"
            fi
            if (( ${#NEW} > 80 )); then
                EXCL_BB_CMDS_LINES+=("$line")
                line=" * $CMD"
            else
                line="$NEW"
            fi
        done
        EXCL_BB_CMDS_LINES+=("$line")

        lines+=(
            ""
            "Excluded BusyBox commands:"
        )
        for l in "${EXCL_BB_CMDS_LINES[@]}"; do
            lines+=("$l")
        done
    fi



    if [ -n "$EXCLUDED_FEATURES" ]; then
        lines+=(
            ""
            "Excluded programs & features:$EXCLUDED_FEATURES"
        )
    fi

    if $DOTENV_USED; then
         if [ -f "$CURR_DIR/.env" ]; then
            lines+=(
                ""
                ".env contents:"
            )
            while IFS= read -r envline; do
                case "$envline" in
                    ROOT_PASSWD=*)
                        lines+=("ROOT_PASSWD=*REDACTED*")
                        ;;
                    *)
                        lines+=("$envline")
                        ;;
                esac
            done < "${CURR_DIR}/.env"
        fi
    fi

    printf "%b\n" "${lines[@]}" | tee "$CURR_DIR/images/report.txt" > /dev/null
}



fix_perms

mkdir -p images

if ! $DONT_DEL_ROOT; then
    delete_root_dir
fi

mkdir -p build/staging
get_prerequisites
get_musl_cross
chmod +x "${CURR_DIR}/compilation/"*

if ! $SKIP_BB; then
    get_busybox
fi

get_ncurses
if $ENABLE_FB; then
    get_tic
fi

if $INCLUDE_STRACE; then
    get_strace
fi
if $INCLUDE_UTIL_LINUX; then
    get_util_linux
fi

if ! $SKIP_KRN; then
    get_kernel
fi

if $NEED_ZLIB; then
    get_zlib
fi
if $NEED_OPENSSL; then
    get_openssl
fi
if $NEED_CURL; then
    get_curl
fi
if $NEED_LIBAO; then
    get_libao
fi
if $NEED_LIBEVENT; then
    get_libevent
fi
if $NEED_LIBID3TAG; then
    get_libid3tag
fi
if $NEED_LIBMAD; then
    get_libmad
fi
if $NEED_LIBXLSXWRITER; then
    get_libxlsxwriter
fi
if $NEED_LIBXML2; then
    get_libxml2
fi
if $NEED_LIBZIP; then
    get_libzip
fi
if $NEED_LIBUUID; then
    get_libuuid
fi
if $NEED_X86EMU; then
    get_x86emu
fi

if $INCLUDE_GUI; then
    prepare_x11
    get_tinyx
    if [[ $USED_WM == "TWM" ]]; then
        get_twm
    fi
    get_oneko
    get_st
    get_xcalc
    get_xclock
    get_xeyes
    get_xli
    get_xload
    get_xset
fi

if $INCLUDE_CON_FONTS; then
    get_console_fonts
fi

if $INCLUDE_C3270; then
    get_prog_git \
        "usr/bin" \
        "c3270" \
        "c3270" \
        "x3270" \
        "$C3270_SRC" \
        "$C3270_VER" \
        "" \
        false \
        false \
        "/usr" \
        "--enable-c3270 --disable-x3270 --disable-s3270 --disable-b3270 --disable-tcl3270 --disable-pr3287 --disable-x3270if --disable-playback  --disable-mitm --disable-wc3270"
fi
if $INCLUDE_CSCOPE; then
    get_prog_git \
        "usr/bin" \
        "cscope" \
        "cscope" \
        "cscope-cscope" \
        "$CSCOPE_SRC" \
        "v$CSCOPE_VER" \
        "" \
        false \
        true \
        "/usr" \
        ""
fi
if $INCLUDE_CTAGS; then
    get_prog_git \
        "usr/bin" \
        "ctags" \
        "ctags" \
        "ctags" \
        "$CTAGS_SRC" \
        "$CTAGS_VER" \
        "" \
        true \
        false \
        "/usr" \
        "--disable-pcre2 --disable-external-sort --disable-yaml --disable-json --disable-iconv --disable-seccomp"
fi
if $INCLUDE_DIALOG; then
    get_prog_tar \
        "usr/bin" \
        "dialog" \
        "dialog" \
        "dialog-${DIALOG_VER}" \
        "tgz" \
        "$DIALOG_SRC" \
        "xzf" \
        false \
        false \
        "/usr" \
        ""
fi
if $INCLUDE_DROPBEAR; then
    get_dropbear
fi
if $INCLUDE_FILE; then
    get_file
fi
if $INCLUDE_GCC; then
    get_gcc
fi
if $INCLUDE_GIT; then
    get_git
fi
if $INCLUDE_HTOP; then
    get_htop
fi
if $INCLUDE_HWINFO; then
    get_hwinfo
fi
if $INCLUDE_INDENT; then
    get_prog_tar \
        "usr/bin" \
        "indent" \
        "indent" \
        "indent-${INDENT_VER}" \
        "tar.xz" \
        "$INDENT_SRC" \
        "xf" \
        false \
        false \
        "/usr" \
        ""
fi
if $INCLUDE_JOE; then
    get_joe
fi
if $INCLUDE_LYNX; then
    get_prog_git \
        "usr/bin" \
        "lynx" \
        "lynx" \
        "lynx-snapshots" \
        "$LYNX_SRC" \
        "v$LYNX_VER" \
        "" \
        false \
        false \
        "/usr" \
        "-with-ssl --with-ssl-dir=\"$SYSROOT\" --with-openssl LIBS=\"-lncursesw -ltinfo -latomic\""
fi
if $INCLUDE_MAKE; then
    get_prog_tar \
        "usr/bin" \
        "make" \
        "make" \
        "make-${MAKE_VER}" \
        "tar.gz" \
        "$MAKE_SRC" \
        "xzf" \
        false \
        false \
        "/usr" \
        ""
fi
if $INCLUDE_MG; then
    get_mg
fi
if $INCLUDE_MICROPYTHON; then
    get_micropython
fi
if $INCLUDE_MPG321; then
    get_mpg321
fi
if $INCLUDE_MT_ST; then
    get_prog_git \
        "bin" \
        "mt" \
        "mt-st" \
        "mt-st" \
        "$MT_ST_SRC" \
        "v$MT_ST_VER" \
        "" \
        false \
        false \
        "/usr" \
        ""
fi
if $INCLUDE_NANO; then
    get_nano
fi
if $INCLUDE_NASM; then
    get_nasm
fi
if $INCLUDE_SC_IM; then
    get_sc_im
fi
if $INCLUDE_TCC; then
    get_prog_tar \
        "usr/local/musl/lib" \
        "libc.so" \
        "musl" \
        "musl-${MUSL_VER}" \
        "tar.gz" \
        "$MUSL_SRC" \
        "xzf" \
        false \
        false \
        "" \
        ""
    get_tcc
fi
if $INCLUDE_TILDE; then
    get_tilde
fi
if $INCLUDE_TMUX; then
    get_prog_git \
        "usr/bin" \
        "tmux" \
        "tmux" \
        "tmux" \
        "$TMUX_SRC" \
        "$TMUX_VER" \
        "" \
        true \
        false \
        "/usr" \
        "LIBS=\"-levent -lncursesw -lutil -lrt -lpthread -lm\""
fi
if $INCLUDE_TN5250; then
    get_tn5250
fi
if $INCLUDE_TNFTP; then
    get_tnftp
fi
if $INCLUDE_VIM; then
    get_prog_git \
        "usr/bin" \
        "vim" \
        "vim" \
        "vim" \
        "$VIM_SRC" \
        "v$VIM_VER" \
        "vim/9.2_ext_feature_culling.patch" \
        false \
        false \
        "/usr" \
        "--with-features=normal --disable-gui --without-x --disable-nls --disable-channel --disable-netbeans --disable-terminal --disable-python3interp --disable-perlinterp --disable-rubyinterp --disable-luainterp --disable-tclinterp --disable-cscope --disable-acl --disable-gpm --disable-sysmouse --disable-selinux --disable-canberra --without-wayland --disable-libsodium --disable-smack"
fi

get_shorkhelp
get_shorkfetch
if [ "$ID" == "shork-486" ] || [ "$ID" == "shork-disc" ]; then
    get_shorkdir
fi
if [ "$ID" == "shork-486" ]; then
    get_shorkcommon_sh
    get_shorkoff
    get_shorkset
fi
if [ "$ID" == "shork-disc" ]; then
    if $INCLUDE_SHORKSTALL; then
        get_shorkstall
    fi
fi

if $INCLUDE_SHORKTAINMENT; then
    get_shorklocomotive
    get_shorkmatrix
    get_shorkmines
    get_shorksay
fi

trim_fat
copy_licences

if $FIX_EXTLINUX; then
    get_patched_xlinux
fi

find_mbr_bin
build_file_system
if [ "$ID" == "shork-486" ]; then
    build_disk_img
elif [ "$ID" == "shork-disc" ]; then
    build_disc_img
elif [ "$ID" == "shork-diskette" ]; then
    compress_file_system
    build_diskette_img
fi

get_included_busybox_commands
get_installed_programs_features
generate_report
if [ "$ID" == "shork-486" ]; then
    copy_report
    convert_disk_img
fi
fix_perms
clean_stale_mounts
