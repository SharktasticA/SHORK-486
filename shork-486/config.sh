#!/bin/bash

######################################################
## SHORK 486 build configurator                     ##
######################################################
## Kali (links.sharktastica.co.uk)                  ##
######################################################



# Check if dialog is present
if ! command -v dialog &> /dev/null; then
    echo "SHORK 486 Build Configurator requires the dialog utility to be installed. The package containing it is most likely simply \"dialog\"."
    exit 1
fi



CURR_DIR=$(pwd)
WIDTH=76
HEIGHT=20



CUSTOM_DEF_SWAP=0
CUSTOM_MIN_DISK=8
DEFAULT_DEF_SWAP=8
DEFAULT_MIN_DISK=80
MAXIMAL_DEF_SWAP=8
MAXIMAL_MIN_DISK=440
MINIMAL_DEF_SWAP=0
MINIMAL_MIN_DISK=8
OFFLINE_DEF_SWAP=8
OFFLINE_MIN_DISK=50

ALWAYS_BUILD=true
DIST="SHORK 486"
ID="shork-486"
IS_ARCH=false
IS_FEDORA=false
IS_DEBIAN=true
BUILD_TYPE="default"
KERNEL_VER="7.1"
TARGET_DISK=80
TARGET_SWAP=8
SCANCODE_SET=-1
SET_KEYMAP="en_us"
HOSTNAME="shork-486"
ENABLE_MULTIUSER_REAL=false
ROOT_PASSWD=""
ENABLE_NET_ETH=false
FIX_EXTLINUX=true
INCLUDE_C3270=false
INCLUDE_CMATRIX=false
INCLUDE_DROPBEAR=false
INCLUDE_FILE=false
INCLUDE_GCC=false
INCLUDE_GIT=false
INCLUDE_HTOP=false
INCLUDE_JOE=false
INCLUDE_LYNX=false
INCLUDE_MG=false
INCLUDE_MICROPYTHON=false
INCLUDE_MT_ST=false
INCLUDE_NANO=false
INCLUDE_SC_IM=false
INCLUDE_SHORKTAINMENT=false
INCLUDE_STRACE=false
INCLUDE_TCC=false
INCLUDE_TILDE=false
INCLUDE_TN5250=false
INCLUDE_TNFTP=false
INCLUDE_TMUX=false
INCLUDE_UTIL_LINUX=false
ENABLE_CDROM=false
INCLUDE_CON_FONTS=false
USE_GRUB=false
ENABLE_FB=false
INCLUDE_GUI=false
ENABLE_HIGHMEM=false
INCLUDE_KEYMAPS=false
ENABLE_MENU=false
INCLUDE_PCI_IDS=false
ENABLE_PCMCIA=false
ENABLE_SATA=false
ENABLE_SCSI_EXP=false
ENABLE_SMP=false
ENABLE_USB=false
ENABLE_ZSWAP=false

keymap_name()
{
    case "$1" in
        cz)             echo "Czech" ;;
        de)             echo "German" ;;
        dk)             echo "Danish" ;;
        en_gb)          echo "English (United Kingdom)" ;;
        en_gb_dvorak)   echo "English (United Kingdom, Dvorak)" ;;
        en_us)          echo "English (United States)" ;;
        en_us_dvorak)   echo "English (United States, Dvorak)" ;;
        es)             echo "Spanish" ;;
        es_la)          echo "Spanish (Latin America)" ;;
        fi)             echo "Finnish" ;;
        fr)             echo "French" ;;
        fr_ca)          echo "French (Canada)" ;;
        hr)             echo "Croatian" ;;
        hu)             echo "Hungarian" ;;
        it)             echo "Italian" ;;
        jp)             echo "Japanese" ;;
        nl)             echo "Dutch" ;;
        no)             echo "Norwegian" ;;
        pl)             echo "Polish" ;;
        pt)             echo "Portuguese" ;;
        pt_br)          echo "Portuguese (Brazil)" ;;
        ro)             echo "Romanian" ;;
        rs)             echo "Serbian" ;;
        se)             echo "Swedish" ;;
        si)             echo "Slovenian" ;;
        *)              echo "..." ;;
    esac
}

load_env()
{
    if [[ -f .env ]]; then
        source .env
    fi
}

save_env()
{
    cat > .env <<EOF
ALWAYS_BUILD=$ALWAYS_BUILD
DIST="$DIST"
ID="$ID"
IS_ARCH=$IS_ARCH
IS_DEBIAN=$IS_DEBIAN
IS_FEDORA=$IS_FEDORA
BUILD_TYPE="$BUILD_TYPE"
KERNEL_VER="$KERNEL_VER"
TARGET_DISK=$TARGET_DISK
TARGET_SWAP=$TARGET_SWAP
SCANCODE_SET=$SCANCODE_SET
SET_KEYMAP="$SET_KEYMAP"
HOSTNAME="$HOSTNAME"
ENABLE_MULTIUSER_REAL=$ENABLE_MULTIUSER_REAL
ROOT_PASSWD=$ROOT_PASSWD
ENABLE_NET_ETH=$ENABLE_NET_ETH
FIX_EXTLINUX=$FIX_EXTLINUX
INCLUDE_C3270=$INCLUDE_C3270
INCLUDE_CMATRIX=$INCLUDE_CMATRIX
INCLUDE_DROPBEAR=$INCLUDE_DROPBEAR
INCLUDE_FILE=$INCLUDE_FILE
INCLUDE_GCC=$INCLUDE_GCC
INCLUDE_GIT=$INCLUDE_GIT
INCLUDE_HTOP=$INCLUDE_HTOP
INCLUDE_JOE=$INCLUDE_JOE
INCLUDE_LYNX=$INCLUDE_LYNX
INCLUDE_MG=$INCLUDE_MG
INCLUDE_MICROPYTHON=$INCLUDE_MICROPYTHON
INCLUDE_MT_ST=$INCLUDE_MT_ST
INCLUDE_NANO=$INCLUDE_NANO
INCLUDE_SC_IM=$INCLUDE_SC_IM
INCLUDE_SHORKTAINMENT=$INCLUDE_SHORKTAINMENT
INCLUDE_STRACE=$INCLUDE_STRACE
INCLUDE_TCC=$INCLUDE_TCC
INCLUDE_TILDE=$INCLUDE_TILDE
INCLUDE_TN5250=$INCLUDE_TN5250
INCLUDE_TNFTP=$INCLUDE_TNFTP
INCLUDE_TMUX=$INCLUDE_TMUX
INCLUDE_UTIL_LINUX=$INCLUDE_UTIL_LINUX
ENABLE_CDROM=$ENABLE_CDROM
INCLUDE_CON_FONTS=$INCLUDE_CON_FONTS
USE_GRUB=$USE_GRUB
ENABLE_FB=$ENABLE_FB
INCLUDE_GUI=$INCLUDE_GUI
ENABLE_HIGHMEM=$ENABLE_HIGHMEM
INCLUDE_KEYMAPS=$INCLUDE_KEYMAPS
ENABLE_MENU=$ENABLE_MENU
INCLUDE_PCI_IDS=$INCLUDE_PCI_IDS
ENABLE_PCMCIA=$ENABLE_PCMCIA
ENABLE_SATA=$ENABLE_SATA
ENABLE_SCSI_EXP=$ENABLE_SCSI_EXP
ENABLE_SMP=$ENABLE_SMP
ENABLE_USB=$ENABLE_USB
ENABLE_ZSWAP=$ENABLE_ZSWAP
EOF

    echo "Your desired SHORK 486 build configuration has been saved to a .env file in the current directory. This configuration will automatically be used when SHORK 486 is next built. If you are using the \"--skip-busybox\" or \"--skip-kernel\" build parameters, you may need to build without them for some changes to take effect."
}

val()
{
    [[ "$1" == true ]] && echo on || echo off
}

val_inv()
{
    [[ "$1" != true ]] && echo on || echo off
}

val_str()
{
    [[ "$1" == "$2" ]] && echo on || echo off
}

set_minimal_vars()
{
    SET_KEYMAP="en_us"
    ENABLE_MULTIUSER_REAL=false
    ENABLE_NET_ETH=false
    INCLUDE_C3270=false
    #INCLUDE_CMATRIX=false
    INCLUDE_DROPBEAR=false
    INCLUDE_FILE=false
    INCLUDE_GCC=false
    INCLUDE_GIT=false
    INCLUDE_HTOP=false
    INCLUDE_JOE=false
    INCLUDE_LYNX=false
    INCLUDE_MG=false
    INCLUDE_MICROPYTHON=false
    INCLUDE_MT_ST=false
    INCLUDE_NANO=false
    INCLUDE_SC_IM=false
    INCLUDE_SHORKTAINMENT=false
    INCLUDE_STRACE=false
    INCLUDE_TCC=false
    INCLUDE_TILDE=false
    INCLUDE_TN5250=false
    INCLUDE_TNFTP=false
    INCLUDE_TMUX=false
    INCLUDE_UTIL_LINUX=false
    ENABLE_CDROM=false
    INCLUDE_CON_FONTS=false
    USE_GRUB=false
    ENABLE_FB=false
    INCLUDE_GUI=false
    ENABLE_HIGHMEM=false
    INCLUDE_KEYMAPS=false
    ENABLE_MENU=false
    INCLUDE_PCI_IDS=false
    ENABLE_PCMCIA=false
    ENABLE_SATA=false
    ENABLE_SCSI_EXP=false
    ENABLE_SMP=false
    ENABLE_USB=false
    ENABLE_ZSWAP=false
}

set_default_vars()
{
    ENABLE_NET_ETH=true
    INCLUDE_C3270=false
    #INCLUDE_CMATRIX=true
    INCLUDE_DROPBEAR=true
    INCLUDE_FILE=true
    INCLUDE_GCC=false
    INCLUDE_GIT=true
    INCLUDE_HTOP=true
    INCLUDE_JOE=false
    INCLUDE_LYNX=true
    INCLUDE_MG=true
    INCLUDE_MICROPYTHON=true
    INCLUDE_MT_ST=true
    INCLUDE_NANO=true
    INCLUDE_SC_IM=true
    INCLUDE_SHORKTAINMENT=true
    INCLUDE_STRACE=true
    INCLUDE_TCC=true
    INCLUDE_TILDE=false
    INCLUDE_TN5250=false
    INCLUDE_TNFTP=true
    INCLUDE_TMUX=true
    INCLUDE_UTIL_LINUX=true
    ENABLE_CDROM=true
    INCLUDE_CON_FONTS=true
    USE_GRUB=false
    ENABLE_FB=true
    INCLUDE_GUI=false
    ENABLE_HIGHMEM=false
    INCLUDE_KEYMAPS=true
    ENABLE_MENU=true
    INCLUDE_PCI_IDS=true
    ENABLE_PCMCIA=true
    ENABLE_SATA=false
    ENABLE_SCSI_EXP=true
    ENABLE_SMP=false
    ENABLE_USB=false
    ENABLE_ZSWAP=true
}

set_offline_vars()
{
    set_default_vars
    ENABLE_NET_ETH=false
    INCLUDE_DROPBEAR=false
    INCLUDE_GIT=false
    INCLUDE_LYNX=false
    INCLUDE_TN5250=false
    INCLUDE_TNFTP=false
}

set_maximal_vars()
{
    set_default_vars
    INCLUDE_C3270=true
    INCLUDE_GCC=true
    INCLUDE_TN5250=true
    INCLUDE_GUI=true
    ENABLE_HIGHMEM=true
    ENABLE_SATA=true
    ENABLE_SMP=true
    ENABLE_USB=true
}

set_custom_vars()
{
    INCLUDE_KEYMAPS=true
    ENABLE_FB=true
}



trap 'tput reset; save_env' EXIT
load_env



# Get build environment
if [[ $IS_ARCH == true ]]; then 
    CHOICE_DEFAULT="Arch"
elif [[ $IS_FEDORA == true ]]; then
    CHOICE_DEFAULT="Fedora"
else 
    CHOICE_DEFAULT="Debian"
fi

CHOICE=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Build Environment" \
    --cancel-label "Quit" \
    --default-item "$CHOICE_DEFAULT" \
    --menu "Select the host environment you plan to build SHORK 486 with." 10 $WIDTH 3 \
    "Arch"    "Native building on Arch" \
    "Debian"  "Native building on Debian/Dockerised building" \
    "Fedora"  "Native building on Fedora" \
    3>&1 1>&2 2>&3)

if [[ ! -n "$CHOICE" ]]; then
    exit 0
else
    IS_ARCH=false
    IS_DEBIAN=false
    IS_FEDORA=false
    if [ "$CHOICE" == "Arch" ]; then
        IS_ARCH=true
    elif [ "$CHOICE" == "Debian" ]; then
        IS_DEBIAN=true
    elif [ "$CHOICE" == "Fedora" ]; then
        IS_FEDORA=true
    fi
fi



# Get target distribution
CHOICE=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Target Distribution" \
    --cancel-label "Quit" \
    --default-item "$ID" \
    --menu "Select which exact SHORK 486-based distribution you wish to build." 10 $WIDTH 3 \
    "shork-486"         "SHORK 486 (for hard disks)" \
    "shork-diskette"    "SHORK DISKETTE (for floppy diskettes)" \
    3>&1 1>&2 2>&3)

if [[ ! -n "$CHOICE" ]]; then
    exit 0
else
    if [ "$CHOICE" == "shork-486" ]; then
        if [ "$CHOICE" != "$ID" ]; then
            HOSTNAME="$CHOICE"
            set_default_vars
            BUILD_TYPE="default"
            TARGET_DISK=80
            TARGET_SWAP=8
        fi
        DIST="SHORK 486"
        ID="$CHOICE"
    elif [ "$CHOICE" == "shork-diskette" ]; then
        if [ "$CHOICE" != "$ID" ]; then
            HOSTNAME="$CHOICE"
            set_minimal_vars
            BUILD_TYPE="minimal"
            TARGET_DISK=1
            TARGET_SWAP=0
        fi
        DIST="SHORK DISKETTE"
        ID="$CHOICE"
    fi
fi



# Get Linux kernel version
KERNEL_VER=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Linux Kernel Version" \
    --cancel-label "Quit" \
    --default-item "$KERNEL_VER" \
    --menu "Please select which Linux kernel version you wish to use with SHORK 486. It is generally safe to use the newest major version, but if you experience hardware compatibility issues, try building with an older kernel to see if that resolves them. If so, please report it as an issue on the SHORK 486 GitHub repository." 13 $WIDTH 5 \
    "7.1"       "7.1 (2026-06-14)" \
    "7.0.12"    "7.0.12 (2026-06-09)" \
    3>&1 1>&2 2>&3)

if [[ ! -n "$KERNEL_VER" ]]; then
    exit 0
fi



if [ "$ID" == "shork-486" ]; then
    # Get build type
    PREV_BUILD_TYPE=$BUILD_TYPE
    BUILD_TYPE=$(dialog --clear \
        --backtitle "SHORK 486 Build Configurator" \
        --title "Build Type" \
        --cancel-label "Quit" \
        --default-item "$BUILD_TYPE" \
        --menu "Select the build type, presets for SHORK 486 feature levels. The minimum requirements for each are enclosed in brackets. The \"custom\" option will enable further prompts for software and feature selection." 14 $WIDTH 5 \
        "default" "Typical experience (16MiB RAM + 80MiB disk)" \
        "offline" "Default sans networking (12MiB RAM + 50MiB disk)" \
        "minimal" "Minimal build (8MiB RAM + 8MiB disk)" \
        "maximal" "Maximal build (24MiB RAM + 440MiB disk)" \
        "custom"  "Requirements depend on subsequent choices" \
        3>&1 1>&2 2>&3)

    if [[ ! -n "$BUILD_TYPE" ]]; then
        exit 0
    elif [ "$BUILD_TYPE" == "default" ]; then
        set_default_vars
    elif [ "$BUILD_TYPE" == "offline" ]; then
        set_offline_vars
    elif [ "$BUILD_TYPE" == "minimal" ]; then
        set_minimal_vars
    elif [ "$BUILD_TYPE" == "maximal" ]; then
        set_maximal_vars
    elif [ "$BUILD_TYPE" == "custom" ]; then
        set_custom_vars
    fi



    # Get target disk size
    CURR_MIN_DISK=0
    if [ "$BUILD_TYPE" == "default" ]; then
        CURR_MIN_DISK=$DEFAULT_MIN_DISK
        if [ "$BUILD_TYPE" != "$PREV_BUILD_TYPE" ]; then
            TARGET_DISK=$DEFAULT_MIN_DISK
            TARGET_SWAP=$DEFAULT_DEF_SWAP
        fi
    elif [ "$BUILD_TYPE" == "offline" ]; then
        CURR_MIN_DISK=$OFFLINE_MIN_DISK
        if [ "$BUILD_TYPE" != "$PREV_BUILD_TYPE" ]; then
            TARGET_DISK=$OFFLINE_MIN_DISK
            TARGET_SWAP=$OFFLINE_DEF_SWAP
        fi
    elif [ "$BUILD_TYPE" == "minimal" ]; then
        CURR_MIN_DISK=$MINIMAL_MIN_DISK
        if [ "$BUILD_TYPE" != "$PREV_BUILD_TYPE" ]; then
            TARGET_DISK=$MINIMAL_MIN_DISK
            TARGET_SWAP=$MINIMAL_DEF_SWAP
        fi
    elif [ "$BUILD_TYPE" == "maximal" ]; then
        CURR_MIN_DISK=$MAXIMAL_MIN_DISK
        if [ "$BUILD_TYPE" != "$PREV_BUILD_TYPE" ]; then
            TARGET_DISK=$MAXIMAL_MIN_DISK
            TARGET_SWAP=$MAXIMAL_DEF_SWAP
        fi
    elif [ "$BUILD_TYPE" == "custom" ]; then
        CURR_MIN_DISK=$CUSTOM_MIN_DISK
        if [ "$BUILD_TYPE" != "$PREV_BUILD_TYPE" ]; then
            TARGET_DISK=$CUSTOM_MIN_DISK
            TARGET_SWAP=$CUSTOM_DEF_SWAP
        fi
    fi

    while true; do
        TARGET_DISK_TMP=$(dialog --clear \
            --backtitle "SHORK 486 Build Configurator" \
            --title "Target Disk Size" \
            --cancel-label "Skip" \
            --inputbox "Enter a target disk size in mebibytes (between $CURR_MIN_DISK and 4096) to use when creating the disk image containing SHORK 486. Whilst the build script will try to honour this, it may be increased automatically to satisfy 4MiB alignment requirements, or if the combined kernel size, root partition size, optional swap partition size, and partition table overhead exceeds the target disk size." \
            12 $WIDTH "$TARGET_DISK" \
            2>&1 >/dev/tty)

        SKIPPED=$?

        if [[ $SKIPPED -eq 1 ]]; then
            break
        fi

        if ! [[ "$TARGET_DISK_TMP" =~ ^[0-9]+$ ]]; then
            dialog --clear \
                --backtitle "SHORK 486 Build Configurator" \
                --title "Target Disk Size" \
                --msgbox "The value must be numeric and a whole number (integer)." 5 $WIDTH
            continue
        fi

        if (( TARGET_DISK_TMP < $CURR_MIN_DISK || TARGET_DISK_TMP > 4096 )); then
            dialog --clear \
                --backtitle "SHORK 486 Build Configurator" \
                --title "Target Disk Size" \
                --msgbox "The value must be between $CURR_MIN_DISK and 4096." 5 $WIDTH
            continue
        fi

        TARGET_DISK=$TARGET_DISK_TMP
        break
    done



    # Get swap partition size
    while true; do
        TARGET_SWAP_TMP=$(dialog --clear \
            --backtitle "SHORK 486 Build Configurator" \
            --title "Swap Partition Size" \
            --cancel-label "Skip" \
            --inputbox "If desired, enter a swap partition size in mebibytes (between 1 and 64) to use when creating the disk image containing SHORK 486. If a swap partition isn't needed or desired, please skip or enter \"0\"." \
            9 $WIDTH "$TARGET_SWAP" \
            2>&1 >/dev/tty)

        SKIPPED=$?

        if [[ $SKIPPED -eq 1 ]]; then
            TARGET_SWAP=0
            break
        fi

        if ! [[ "$TARGET_SWAP_TMP" =~ ^[0-9]+$ ]]; then
            dialog --clear \
                --backtitle "SHORK 486 Build Configurator" \
                --title "Swap Partition Size" \
                --msgbox "The value must be numeric and a whole number (integer)." 5 $WIDTH
            continue
        fi

        if (( TARGET_SWAP_TMP < 0 || TARGET_SWAP_TMP > 64 )); then
            dialog --clear \
                --backtitle "SHORK 486 Build Configurator" \
                --title "Swap Partition Size" \
                --msgbox "The value must be between 0 and 64." 5 $WIDTH
            continue
        fi

        TARGET_SWAP=$TARGET_SWAP_TMP
        break
    done
elif [ "$ID" == "shork-diskette" ]; then
    DEFAULT_FLAG=""
    if [[ "$TARGET_DISK" -eq 2 ]]; then
        DEFAULT_FLAG="--defaultno"
    fi

    dialog --clear \
        --backtitle "SHORK 486 Build Configurator" \
        --title "Target Diskette Size" \
        --yes-label "1.44MB" \
        --no-label "2.88MB" \
        $DEFAULT_FLAG \
        --yesno "Please select which floppy diskette size you are targeting so that the image will be created to the appropriate size." \
        6 "$WIDTH"

    CHOICE=$?

    if [[ $CHOICE -eq 0 ]]; then
        TARGET_DISK=1
    elif [[ $CHOICE -eq 1 ]]; then
        TARGET_DISK=2
    fi
fi



# Get keyboard scancode set choice
case $SCANCODE_SET in
    2)  CHOICE_DEFAULT="2" ;;
    3)  CHOICE_DEFAULT="3" ;;
    *)  CHOICE_DEFAULT="-" ;;
esac

CHOICE=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Keyboard Scancode Set" \
    --default-item "$CHOICE_DEFAULT" \
    --menu "Do you want to specify an IBM scancode set for SHORK 486 to request? For most AT and PS/2 keyboards, this is likely not needed and can be skipped. But some specific keyboards or computers with integrated keyboards have been known to require a specific one and are listed below.\n\nKnown to require set 3: IBM 9545 ThinkPad 755C" \
    16 $WIDTH 3 \
    "-"     "Skip (recommended for most)" \
    "2"     "Set 2 (AT & PS/2)" \
    "3"     "Set 3 (PS/2 & 315X/316X/3179/3180/319X/3270 PC/3290-2/InfoWindow)" \
    3>&1 1>&2 2>&3)

case $CHOICE in
    "2")    SCANCODE_SET=2 ;;
    "3")    SCANCODE_SET=3 ;;
    *)      SCANCODE_SET=-1 ;;
esac



# Get desired keymap
if [ "$BUILD_TYPE" != "minimal" ] && [ "$ID" == "shork-486" ]; then
    KEYMAP_ITEMS=()
    for f in "$CURR_DIR/sysfiles/keymaps/"*.kmap.bin; do
        name=$(basename "$f" .kmap.bin)
        KEYMAP_ITEMS+=("$name" "$(keymap_name $name)")
    done

    SET_KEYMAP=$(dialog --clear \
        --backtitle "SHORK 486 Build Configurator" \
        --title "Keyboard Layout" \
        --cancel-label "Skip" \
        --default-item "$SET_KEYMAP" \
        --menu "Select what keyboard layout (keymap) you wish to use. This can later be changed inside SHORK 486 by running shorkmap." $HEIGHT $WIDTH 25 \
        "${KEYMAP_ITEMS[@]}" \
        3>&1 1>&2 2>&3)
fi



# Get hostname
HOSTNAME=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Hostname" \
    --cancel-label "Skip" \
    --inputbox "Enter a hostname for your computer. It may be a simple local name or a Fully Qualified Domain Name." \
    8 $WIDTH "$HOSTNAME" \
    2>&1 >/dev/tty)



# Get multi-user support choice
if [ "$BUILD_TYPE" != "minimal" ] && [ "$ID" == "shork-486" ]; then
    DEFAULT_FLAG="--defaultno"
    if $ENABLE_MULTIUSER_REAL; then
        DEFAULT_FLAG=""
    fi

    dialog --clear \
        --backtitle "SHORK 486 Build Configurator" \
        --title "Multi-User Support" \
        $DEFAULT_FLAG \
        --yesno "Do you want to enable multi-user support in SHORK 486? It will enable BusyBox's multi-user-related utilities and you will be able to set a root password in the next prompt." \
        7 $WIDTH

    CHOICE=$?

    if [[ $CHOICE -eq 0 ]]; then
        ENABLE_MULTIUSER_REAL=true
    elif [[ $CHOICE -eq 1 ]]; then
        ENABLE_MULTIUSER_REAL=false
        ROOT_PASSWD=""
    fi



    # Get root password
    if [ "$ENABLE_MULTIUSER_REAL" == true ]; then
        while true; do
            # If root password has already been set, offer to reuse it...
            if [ -n "$ROOT_PASSWD" ]; then
                dialog --clear \
                    --backtitle "SHORK 486 Build Configurator" \
                    --title "Root Password" \
                    --yesno "A root password has already been set before. Do you want to reuse it?" 5 $WIDTH

                USE_EXISTING=$?
                if [ "$USE_EXISTING" -eq 0 ]; then
                    ROOT_PASSWD="'$ROOT_PASSWD'"
                    break
                fi
            fi

            ROOT_PASSWD_TMP=$(dialog --clear \
                --insecure \
                --backtitle "SHORK 486 Build Configurator" \
                --title "Root Password" \
                --cancel-label "Skip" \
                --passwordbox "If desired, enter a password for SHORK 486's root user account. It must be at least 8 characters long. If a root password isn't needed or desired, please skip or leave the input box empty." \
                9 $WIDTH \
                2>&1 >/dev/tty)

            SKIPPED=$?

            if [[ $SKIPPED -eq 1 ]]; then
                break
            fi

            if [ "${#ROOT_PASSWD_TMP}" -lt 8 ]; then
                dialog --clear \
                    --backtitle "SHORK 486 Build Configurator" \
                    --title "Root Password" \
                    --msgbox "The password must be at least 8 characters long." 5 $WIDTH
                continue
            fi

            if printf '%s' "$ROOT_PASSWD_TMP" | grep -q ' '; then
                dialog --clear \
                    --backtitle "SHORK 486 Build Configurator" \
                    --title "Root Password" \
                    --msgbox "The password cannot contain any spaces." 5 $WIDTH
                continue
            fi

            if printf '%s' "$ROOT_PASSWD_TMP" | grep -q '[[:cntrl:]]'; then
                dialog --clear \
                    --backtitle "SHORK 486 Build Configurator" \
                    --title "Root Password" \
                    --msgbox "The password cannot contain any control characters." 5 $WIDTH
                continue
            fi

            MKPASSWD_METHOD="md5"
            OPENSSL_METHOD="-1"
            
            ROOT_PASSWD_HASH=""
            if command -v mkpasswd >/dev/null 2>&1; then
                ROOT_PASSWD_HASH="$(mkpasswd -m "$MKPASSWD_METHOD" "$ROOT_PASSWD_TMP")"
            elif command -v openssl >/dev/null 2>&1; then
                ROOT_PASSWD_HASH="$(openssl passwd "$OPENSSL_METHOD" "$ROOT_PASSWD_TMP")"
            else
                echo "ERROR: there are no tools available for hashing passwords (tried mkpasswd and openssl)." >&2
                exit 1
            fi

            ROOT_PASSWD="'$ROOT_PASSWD_HASH'"
            break
        done
    fi
fi



# Get networking support choice
if [ "$BUILD_TYPE" == "custom" ] && [ "$ID" == "shork-486" ]; then
    DEFAULT_FLAG=""
    if ! $ENABLE_NET_ETH; then
        DEFAULT_FLAG="--defaultno"
    fi

    dialog --clear \
        --backtitle "SHORK 486 Build Configurator" \
        --title "Ethernet Networking Support" \
        $DEFAULT_FLAG \
        --yesno "Do you want to enable ethernet networking support in SHORK 486? It includes kernel-level ethernet networking support and BusyBox's networking-related utilities, and you will be able to choose software that requires an internet connection in the next prompt." \
        8 $WIDTH

    CHOICE=$?

    if [[ $CHOICE -eq 0 ]]; then
        ENABLE_NET_ETH=true
    elif [[ $CHOICE -eq 1 ]]; then
        ENABLE_NET_ETH=false
        INCLUDE_DROPBEAR=false
        INCLUDE_GIT=false
        INCLUDE_LYNX=false
        INCLUDE_TN5250=false
        INCLUDE_TNFTP=false
    fi
fi



# Get patched EXTLINUX/SYSLINUX choice
DEFAULT_FLAG=""
if ! $FIX_EXTLINUX; then
    DEFAULT_FLAG="--defaultno"
fi

dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Patched EXTLINUX/SYSLINUX" \
    $DEFAULT_FLAG \
    --yesno "Do you want to use SHORK's patched fork of the EXTLINUX/SYSLINUX bootloader, instead of your host distribution's maintained package version? The patched fork fixes a memory detection issue that *may* prevent booting with certain old BIOS implementations. It is recommended to say \"Yes\" but it will increase build time.\n\nKnown computers that require this: Chicony NB5/derivatives, HP OmniBook 800CT, IBM 2625 ThinkPad 365E/365ED and IBM 6381 PS/ValuePoint" \
    12 $WIDTH

CHOICE=$?

if [[ $CHOICE -eq 0 ]]; then
    FIX_EXTLINUX=true
elif [[ $CHOICE -eq 1 ]]; then
    FIX_EXTLINUX=false
fi



# If build type isn't custom, it's time to exit!
if [ "$BUILD_TYPE" != "custom" ]; then
    exit 0
fi



# Get bundled software choices
BUNDLED_ITEMS=()

if [ "$ENABLE_NET_ETH" == true ]; then
    BUNDLED_ITEMS+=(
        "c3270"        "3270 terminal emulator (+1.8MiB)"                   "$(val "$INCLUDE_C3270")"
        #"cmatrix"       "Scrolling text screensaver (+0.4MiB)"              "$(val "$INCLUDE_CMATRIX")"
        "dropbear"      "*SCP & SSH client (+0.4MiB)"                       "$(val "$INCLUDE_DROPBEAR")"
        "file"          "*File type identification (+10MiB)"                "$(val "$INCLUDE_FILE")"
        "gcc"           "**GCC (as, g++, gcc, gfortran) + musl (+215MiB)"   "$(val "$INCLUDE_GCC")"
        "git"           "*Source control client (+19MiB)"                   "$(val "$INCLUDE_GIT")"
        "htop"          "*Interactive process viewer (+0.6MiB)"             "$(val "$INCLUDE_HTOP")"
        "joe"           "WordStar-style text editor (+1.9MiB)"              "$(val "$INCLUDE_JOE")"
        "lynx"          "*Terminal web browser (+7.3MiB)"                   "$(val "$INCLUDE_LYNX")"
        "mg"            "*Emacs-style text editor (+0.3MiB)"                "$(val "$INCLUDE_MG")"
        "micropython"   "*Python 3.4-syntax intepreter (+0.7MiB)"           "$(val "$INCLUDE_MICROPYTHON")"
        "mt-st"         "*Tape drive tools (+0.2MiB)"                       "$(val "$INCLUDE_MT_ST")"
        "nano"          "*Text editor (+0.8MiB)"                            "$(val "$INCLUDE_NANO")"
        "sc-im"         "*Terminal spreadsheet editor (+2.8MiB)"            "$(val "$INCLUDE_SC_IM")"
        "shorktainment" "*shorkmatrix, shorksay & sl (+0.1MiB)"             "$(val "$INCLUDE_SHORKTAINMENT")"
        "strace"        "*System calls & signals tracer (+1.1MiB)"          "$(val "$INCLUDE_STRACE")"
        "tcc"           "*Tiny C Compiler + musl (+4MiB)"                   "$(val "$INCLUDE_TCC")"
        #"tilde"         "GUI-like text editor (+4.5MiB)"                    "$(val "$INCLUDE_TILDE")"
        "tn5250"        "TCP/IP 5250 terminal emulator (+6.4MiB)"           "$(val "$INCLUDE_TN5250")"
        "tnftp"         "*FTP client (+0.3MiB)"                             "$(val "$INCLUDE_TNFTP")"
        "tmux"          "*Terminal multiplexer (+1.7MiB)"                   "$(val "$INCLUDE_TMUX")"
        "util-linux"    "*partx, sfdisk & whereis (+1.9MiB)"                "$(val "$INCLUDE_UTIL_LINUX")"
    )
else
    BUNDLED_ITEMS+=(
        "c3270"        "3270 terminal emulator (+1.8MiB)"                   "$(val "$INCLUDE_C3270")"
        #"cmatrix"       "Scrolling text screensaver (+0.4MiB)"              "$(val "$INCLUDE_CMATRIX")"
        "file"          "*File type identification (+10MiB)"                "$(val "$INCLUDE_FILE")"
        "gcc"           "**GCC (as, g++, gcc, gfortran) + musl (+215MiB)"   "$(val "$INCLUDE_GCC")"
        "htop"          "*Interactive process viewer (+0.6MiB)"             "$(val "$INCLUDE_HTOP")"
        "joe"           "Joe's Own Editor (+1.9MiB)"                        "$(val "$INCLUDE_JOE")"
        "mg"            "*Emacs-style text editor (+0.3MiB)"                "$(val "$INCLUDE_MG")"
        "micropython"   "*Python 3.4-syntax intepreter (+0.7MiB)"           "$(val "$INCLUDE_MICROPYTHON")"
        "mt-st"         "*Tape drive tools (+0.2MiB)"                       "$(val "$INCLUDE_MT_ST")"
        "nano"          "*Text editor (+0.8MiB)"                            "$(val "$INCLUDE_NANO")"
        "sc-im"         "*Terminal spreadsheet editor (+2.8MiB)"            "$(val "$INCLUDE_SC_IM")"
        "shorktainment" "*shorkmatrix, shorksay & sl (+0.1MiB)"             "$(val "$INCLUDE_SHORKTAINMENT")"
        "strace"        "*System calls & signals tracer (+1.1MiB)"          "$(val "$INCLUDE_STRACE")"
        "tcc"           "*Tiny C Compiler + musl (+4MiB)"                   "$(val "$INCLUDE_TCC")"
        #"tilde"         "GUI-like text editor (+4.5MiB)"                    "$(val "$INCLUDE_TILDE")"
        "util-linux"    "*partx, sfdisk & whereis (+1.2MiB)"                "$(val "$INCLUDE_UTIL_LINUX")"
    )
fi



BUNDLED=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Bundled Software" \
    --cancel-label "Skip" \
    --checklist "Select what software to bundle with SHORK 486.\n* This option would be included in a \"default\" build\n** This option can raise system memory requirements" $HEIGHT $WIDTH 8 \
    "${BUNDLED_ITEMS[@]}" \
    2>&1 >/dev/tty)

SKIPPED=$?

if [[ $SKIPPED -eq 1 ]]; then
    :
else
    if [[ $BUNDLED =~ "c3270" ]];           then INCLUDE_C3270=true;            else INCLUDE_C3270=false;         fi
    #if [[ $BUNDLED =~ "cmatrix" ]];         then INCLUDE_CMATRIX=true;          else INCLUDE_CMATRIX=false;         fi
    if [[ $BUNDLED =~ "dropbear" ]];        then INCLUDE_DROPBEAR=true;         else INCLUDE_DROPBEAR=false;        fi
    if [[ $BUNDLED =~ "file" ]];            then INCLUDE_FILE=true;             else INCLUDE_FILE=false;            fi
    if [[ $BUNDLED =~ "gcc" ]];             then INCLUDE_GCC=true;              else INCLUDE_GCC=false;             fi
    if [[ $BUNDLED =~ "git" ]];             then INCLUDE_GIT=true;              else INCLUDE_GIT=false;             fi
    if [[ $BUNDLED =~ "htop" ]];            then INCLUDE_HTOP=true;             else INCLUDE_HTOP=false;            fi
    if [[ $BUNDLED =~ "joe" ]];             then INCLUDE_JOE=true;              else INCLUDE_JOE=false;             fi
    if [[ $BUNDLED =~ "lynx" ]];            then INCLUDE_LYNX=true;             else INCLUDE_LYNX=false;            fi
    if [[ $BUNDLED =~ "mg" ]];              then INCLUDE_MG=true;               else INCLUDE_MG=false;              fi
    if [[ $BUNDLED =~ "micropython" ]];     then INCLUDE_MICROPYTHON=true;      else INCLUDE_MICROPYTHON=false;     fi
    if [[ $BUNDLED =~ "nano" ]];            then INCLUDE_NANO=true;             else INCLUDE_NANO=false;            fi
    if [[ $BUNDLED =~ "sc-im" ]];           then INCLUDE_SC_IM=true;            else INCLUDE_SC_IM=false;           fi
    if [[ $BUNDLED =~ "shorktainment" ]];   then INCLUDE_SHORKTAINMENT=true;    else INCLUDE_SHORKTAINMENT=false;   fi
    if [[ $BUNDLED =~ "strace" ]];          then INCLUDE_STRACE=true;           else INCLUDE_STRACE=false;          fi
    if [[ $BUNDLED =~ "tcc" ]];             then INCLUDE_TCC=true;              else INCLUDE_TCC=false;             fi
    #if [[ $BUNDLED =~ "tilde" ]];           then INCLUDE_TILDE=true;            else INCLUDE_TILDE=false;           fi
    if [[ $BUNDLED =~ "tmux" ]];            then INCLUDE_TMUX=true;             else INCLUDE_TMUX=false;            fi
    if [[ $BUNDLED =~ "tn5250" ]];          then INCLUDE_TN5250=true;           else INCLUDE_TN5250=false;          fi
    if [[ $BUNDLED =~ "tnftp" ]];           then INCLUDE_TNFTP=true;            else INCLUDE_TNFTP=false;           fi
    if [[ $BUNDLED =~ "util-linux" ]];      then INCLUDE_UTIL_LINUX=true;       else INCLUDE_UTIL_LINUX=false;      fi
fi



# Get option choices
OPTIONS=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Options" \
    --cancel-label "Skip" \
    --checklist "Select what other options to include. Some of these are benign, some may increase the RAM and disk space requirement considerably, some are experimental.\n* This option would be included in a \"default\" build\n** This option can raise system memory requirements" $HEIGHT $WIDTH 9 \
    "cdrom"         "*Kernel-level CD-ROM & DVD-ROM support"                    $(val $ENABLE_CDROM) \
    "con-fonts"     "*Console fonts pack (+0.1MiB)"                             $(val $INCLUDE_CON_FONTS) \
    "grub"          "GRUB 2.x instead of EXTLINUX (+4MiB)"                      $(val $USE_GRUB) \
    "gui"           "**SHORKGUI (+46MiB, EXPERIMENTAL)"                         $(val $INCLUDE_GUI) \
    "highmem"       "**Kernel-level high memory support"                        $(val $ENABLE_HIGHMEM) \
    "menu"          "*Menu-based bootloader (+0.5MiB)"                          $(val $ENABLE_MENU) \
    "pci.ids"       "*PCI IDs database (+0.1MiB)"                               $(val $INCLUDE_PCI_IDS) \
    "pcmcia"        "*Kernel-level PCMCIA support"                              $(val $ENABLE_PCMCIA) \
    "sata"          "**Kernel-level SATA support"                               $(val $ENABLE_SATA) \
    "scsi-exp"      "*Kernel-level SCSI media changer & tape drive support"     $(val $ENABLE_SCSI_EXP) \
    "smp"           "**Kernel-level SMP support"                                $(val $ENABLE_SMP) \
    "usb"           "Kernel-level USB & HID support & lsusb (+0.2MiB)"          $(val $ENABLE_USB) \
    "zswap"         "*Kernel-level zswap support"                               $(val $ENABLE_ZSWAP) \
    2>&1 >/dev/tty)
    #"keymaps"   "Keymaps & shorkmap (+0.06MiB)"             $(val $INCLUDE_KEYMAPS) \
    
SKIPPED=$?

if [[ $SKIPPED -eq 1 ]]; then
    :
else
    if [[ $OPTIONS =~ "cdrom" ]];       then ENABLE_CDROM=true;         else ENABLE_CDROM=false;        fi
    if [[ $OPTIONS =~ "con-fonts" ]];   then INCLUDE_CON_FONTS=true;    else INCLUDE_CON_FONTS=false;   fi
    if [[ $OPTIONS =~ "grub" ]];        then USE_GRUB=true;             else USE_GRUB=false;            fi
    if [[ $OPTIONS =~ "gui" ]];         then INCLUDE_GUI=true;          else INCLUDE_GUI=false;         fi
    if [[ $OPTIONS =~ "highmem" ]];     then ENABLE_HIGHMEM=true;       else ENABLE_HIGHMEM=false;      fi
    #if [[ $OPTIONS =~ "keymaps" ]];    then $INCLUDE_KEYMAPS=true;     else $INCLUDE_KEYMAPS=false;    fi
    if [[ $OPTIONS =~ "menu" ]];        then ENABLE_MENU=true;          else ENABLE_MENU=false;         fi
    if [[ $OPTIONS =~ "pci.ids" ]];     then INCLUDE_PCI_IDS=true;      else INCLUDE_PCI_IDS=false;     fi
    if [[ $OPTIONS =~ "pcmcia" ]];      then ENABLE_PCMCIA=true;        else ENABLE_PCMCIA=false;       fi
    if [[ $OPTIONS =~ "sata" ]];        then ENABLE_SATA=true;          else ENABLE_SATA=false;         fi
    if [[ $OPTIONS =~ "scsi-exp" ]];    then ENABLE_SCSI_EXP=true;      else ENABLE_SCSI_EXP=false;     fi
    if [[ $OPTIONS =~ "smp" ]];         then ENABLE_SMP=true;           else ENABLE_SMP=false;          fi
    if [[ $OPTIONS =~ "usb" ]];         then ENABLE_USB=true;           else ENABLE_USB=false;          fi
    if [[ $OPTIONS =~ "zswap" ]];       then ENABLE_ZSWAP=true;         else ENABLE_ZSWAP=false;        fi
fi



# Conflict Resolution - +FIX_EXTLINUX/+USE_GRUB
if [ "$FIX_EXTLINUX" = true ] && [ "$USE_GRUB" = true ]; then
    dialog --clear \
        --backtitle "SHORK 486 Build Configurator" \
        --title "Conflict Resolution - +FIX_EXTLINUX/+USE_GRUB" \
        --yes-label "EXTLINUX" \
        --no-label "GRUB" \
        --yesno "You have chosen to enable \"patched EXTLINUX\" and selected \"GRUB 2.x instead of EXTLINUX\". Please confirm which bootloader you wish to use." \
        6 "$WIDTH"

    CHOICE=$?

    if [[ $CHOICE -eq 0 ]]; then
        USE_GRUB=false
    elif [[ $CHOICE -eq 1 ]]; then
        FIX_EXTLINUX=false
    fi
fi

# Conflict Resolution - +MT_ST/-SCSI_EXP
if [ "$INCLUDE_MT_ST" = true ] && [ "$ENABLE_SCSI_EXP" = false ]; then
    dialog --clear \
        --backtitle "SHORK 486 Build Configurator" \
        --title "Conflict Resolution - +MT_ST/-SCSI_EXP" \
        --yes-label "Enable support" \
        --no-label "Disable tools" \
        --yesno "You have chosen to enable \"tape drive tools\" but disable \"kernel-level SCSI media changer & tape drive support\". Kernel-level support is required for the tape drive tools to work. Do you wish to enable the required support, or disable the tools?" \
        8 "$WIDTH"

    CHOICE=$?

    if [[ $CHOICE -eq 0 ]]; then
        ENABLE_SCSI_EXP=true
    elif [[ $CHOICE -eq 1 ]]; then
        INCLUDE_MT_ST=false
    fi
fi
