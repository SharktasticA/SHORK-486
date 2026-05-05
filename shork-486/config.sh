#!/bin/bash

######################################################
## SHORK 486 build configurator                     ##
######################################################
## Kali (sharktastica.co.uk)                        ##
######################################################



# Check if dialog is present
if ! command -v dialog &> /dev/null; then
    echo "SHORK 486 Build Configurator requires the dialog utility to be installed. The package containing it is most likely simply \"dialog\"."
    exit 1
fi



CURR_DIR=$(pwd)
WIDTH=76
HEIGHT=20



ALWAYS_BUILD=true
IS_ARCH=false
IS_FEDORA=false
IS_DEBIAN=true
BUILD_TYPE="default"
TARGET_DISK=80
TARGET_SWAP=8
SET_KEYMAP="en_us"
HOSTNAME="shork-486"
FIX_EXTLINUX=false
ENABLE_NET_ETH=false
INCLUDE_C3270=false
INCLUDE_CMATRIX=false
INCLUDE_DROPBEAR=false
INCLUDE_FILE=false
INCLUDE_GCC=false
INCLUDE_GIT=false
INCLUDE_HTOP=false
INCLUDE_LYNX=false
INCLUDE_MG=false
INCLUDE_MICROPYTHON=false
INCLUDE_MT_ST=false
INCLUDE_NANO=false
INCLUDE_SC_IM=false
INCLUDE_SHORKTAINMENT=false
INCLUDE_STRACE=false
INCLUDE_TCC=false
INCLUDE_TN5250=false
INCLUDE_TNFTP=false
INCLUDE_TMUX=false
INCLUDE_UTIL_LINUX=false
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

is_set_keymap()
{
    [[ "$1" == $SET_KEYMAP ]] && echo on || echo off
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
IS_ARCH=$IS_ARCH
IS_DEBIAN=$IS_DEBIAN
IS_FEDORA=$IS_FEDORA
BUILD_TYPE="$BUILD_TYPE"
TARGET_DISK=$TARGET_DISK
TARGET_SWAP=$TARGET_SWAP
SET_KEYMAP="$SET_KEYMAP"
HOSTNAME="$HOSTNAME"
FIX_EXTLINUX=$FIX_EXTLINUX
ENABLE_NET_ETH=$ENABLE_NET_ETH
INCLUDE_C3270=$INCLUDE_C3270
INCLUDE_CMATRIX=$INCLUDE_CMATRIX
INCLUDE_DROPBEAR=$INCLUDE_DROPBEAR
INCLUDE_FILE=$INCLUDE_FILE
INCLUDE_GCC=$INCLUDE_GCC
INCLUDE_GIT=$INCLUDE_GIT
INCLUDE_HTOP=$INCLUDE_HTOP
INCLUDE_LYNX=$INCLUDE_LYNX
INCLUDE_MG=$INCLUDE_MG
INCLUDE_MICROPYTHON=$INCLUDE_MICROPYTHON
INCLUDE_MT_ST=$INCLUDE_MT_ST
INCLUDE_NANO=$INCLUDE_NANO
INCLUDE_SC_IM=$INCLUDE_SC_IM
INCLUDE_SHORKTAINMENT=$INCLUDE_SHORKTAINMENT
INCLUDE_STRACE=$INCLUDE_STRACE
INCLUDE_TCC=$INCLUDE_TCC
INCLUDE_TN5250=$INCLUDE_TN5250
INCLUDE_TNFTP=$INCLUDE_TNFTP
INCLUDE_TMUX=$INCLUDE_TMUX
INCLUDE_UTIL_LINUX=$INCLUDE_UTIL_LINUX
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
    ENABLE_NET_ETH=false
    INCLUDE_C3270=false
    #INCLUDE_CMATRIX=false
    INCLUDE_DROPBEAR=false
    INCLUDE_FILE=false
    INCLUDE_GCC=false
    INCLUDE_GIT=false
    INCLUDE_HTOP=false
    INCLUDE_LYNX=false
    INCLUDE_MG=false
    INCLUDE_MICROPYTHON=false
    INCLUDE_MT_ST=false
    INCLUDE_NANO=false
    INCLUDE_SC_IM=false
    INCLUDE_SHORKTAINMENT=false
    INCLUDE_STRACE=false
    INCLUDE_TCC=false
    INCLUDE_TN5250=false
    INCLUDE_TNFTP=false
    INCLUDE_TMUX=false
    INCLUDE_UTIL_LINUX=false
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
    INCLUDE_LYNX=true
    INCLUDE_MG=true
    INCLUDE_MICROPYTHON=true
    INCLUDE_MT_ST=true
    INCLUDE_NANO=true
    INCLUDE_SC_IM=true
    INCLUDE_SHORKTAINMENT=true
    INCLUDE_STRACE=true
    INCLUDE_TCC=true
    INCLUDE_TN5250=false
    INCLUDE_TNFTP=true
    INCLUDE_TMUX=true
    INCLUDE_UTIL_LINUX=true
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
    INCLUDE_TNFTP=true
    INCLUDE_TMUX=true
    INCLUDE_UTIL_LINUX=true
    INCLUDE_CON_FONTS=true
    ENABLE_FB=true
    INCLUDE_GUI=true
    ENABLE_HIGHMEM=true
    INCLUDE_KEYMAPS=true
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
ENV=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Build Environment" \
    --cancel-label "Quit" \
    --radiolist "Select the host environment you plan to build SHORK 486 with." $HEIGHT $WIDTH 3 \
    "Arch"    "Native building on Arch"                         $(val $IS_ARCH) \
    "Debian"  "Native building on Debian/Dockerised building"   $(val $IS_DEBIAN) \
    "Fedora"  "Native building on Fedora"                       $(val $IS_FEDORA) \
    2>&1 >/dev/tty)

if [[ ! -n "$ENV" ]]; then
    exit 0
else
    IS_ARCH=false
    IS_DEBIAN=false
    IS_FEDORA=false

    if [ "$ENV" == "Arch" ]; then
        IS_ARCH=true
    elif [ "$ENV" == "Debian" ]; then
        IS_DEBIAN=true
    elif [ "$ENV" == "Fedora" ]; then
        IS_FEDORA=true
    fi
fi



# Get build type
PREV_BUILD_TYPE=$BUILD_TYPE
BUILD_TYPE=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Build Type" \
    --cancel-label "Quit" \
    --radiolist "Select the build type, presets for SHORK 486 feature levels. The minimum requirements for each are enclosed in brackets. The \"custom\" option will enable further prompts for software and feature selection." $HEIGHT $WIDTH 6 \
    "default" "Typical experience (16MiB RAM + 80MiB disk)"         $(val_str "$BUILD_TYPE" default) \
    "offline" "Default sans networking (12MiB RAM + 50MiB disk)"    $(val_str "$BUILD_TYPE" offline) \
    "minimal" "Minimal build (8MiB RAM + 8MiB disk)"                $(val_str "$BUILD_TYPE" minimal) \
    "maximal" "Maximal build (24MiB RAM + 440MiB disk)"             $(val_str "$BUILD_TYPE" maximal) \
    "custom"  "Requirements depend on subsequent choices"           $(val_str "$BUILD_TYPE" custom) \
    2>&1 >/dev/tty)

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



if [ "$BUILD_TYPE" != "$PREV_BUILD_TYPE" ]; then
    if [ "$BUILD_TYPE" == "default" ]; then
        TARGET_DISK=80
        TARGET_SWAP=8
    elif [ "$BUILD_TYPE" == "offline" ]; then
        TARGET_DISK=50
        TARGET_SWAP=8
    elif [ "$BUILD_TYPE" == "minimal" ]; then
        TARGET_DISK=8
        TARGET_SWAP=0
    elif [ "$BUILD_TYPE" == "maximal" ]; then
        TARGET_DISK=440
        TARGET_SWAP=8
    elif [ "$BUILD_TYPE" == "custom" ]; then
        TARGET_DISK=80
        TARGET_SWAP=8
    fi
fi



# Get target disk size
while true; do
    TARGET_DISK_TMP=$(dialog --clear \
        --backtitle "SHORK 486 Build Configurator" \
        --title "Target Disk Size" \
        --cancel-label "Skip" \
        --inputbox "Enter a target disk size in mebibytes (between 8 and 4096) to use when creating the disk image containing SHORK 486. Whilst the build script will try to honour this, it will override it if the combined compiled system and optional swap partition size is larger than the target disk size so the build doesn't fail." \
        11 $WIDTH "$TARGET_DISK" \
        2>&1 >/dev/tty)

    SKIPPED=$?

    if [[ $SKIPPED -eq 1 ]]; then
        break
    fi

    if ! [[ "$TARGET_DISK_TMP" =~ ^[0-9]+$ ]]; then
        dialog --clear \
            --backtitle "SHORK 486 Build Configurator" \
            --title "Target Disk Size" \
            --msgbox "The value must be numeric only." 12 $WIDTH
        continue
    fi

    if (( TARGET_DISK_TMP < 8 || TARGET_DISK_TMP > 4096 )); then
        dialog --clear \
            --backtitle "SHORK 486 Build Configurator" \
            --title "Target Disk Size" \
            --msgbox "The value must be between 8 and 4096." 12 $WIDTH
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
            --msgbox "The value must be numeric only." 12 $WIDTH
        continue
    fi

    if (( TARGET_SWAP_TMP < 0 || TARGET_SWAP_TMP > 64 )); then
        dialog --clear \
            --backtitle "SHORK 486 Build Configurator" \
            --title "Swap Partition Size" \
            --msgbox "The value must be between 0 and 64." 12 $WIDTH
        continue
    fi

    TARGET_SWAP=$TARGET_SWAP_TMP
    break
done



# Get desired keymap
if [ "$BUILD_TYPE" != "minimal" ]; then
    KEYMAP_ITEMS=()
    for f in "$CURR_DIR/sysfiles/keymaps/"*.kmap.bin; do
        name=$(basename "$f" .kmap.bin)
        KEYMAP_ITEMS+=("$name" "$(keymap_name $name)" "$(is_set_keymap $name)")
    done

    SET_KEYMAP=$(dialog --clear \
        --backtitle "SHORK 486 Build Configurator" \
        --title "Keyboard Layout" \
        --cancel-label "Skip" \
        --radiolist "Select what keyboard layout (keymap) you wish to use. This can later be changed inside SHORK 486 by running shorkmap." \
        $HEIGHT $WIDTH 25 \
        "${KEYMAP_ITEMS[@]}" \
        2>&1 >/dev/tty)
fi



# Get hostname
HOSTNAME=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Hostname" \
    --cancel-label "Skip" \
    --inputbox "Enter a hostname for your computer. It may be a simple local name or a Fully Qualified Domain Name." \
    8 $WIDTH "$HOSTNAME" \
    2>&1 >/dev/tty)



# Get patched EXTLINUX choice
dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Patched EXTLINUX" \
    --yesno "Do you want to use SHORK's patched fork of the EXTLINUX bootloader, instead of your host distribution's maintained package version? The patched fork fixes a memory detection issue that *may* prevent booting with certain old BIOS implementations. It is recommended to say \"Yes\" but it will increase build time." \
    9 $WIDTH

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



# Get networking support choice
dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Ethernet Networking Support" \
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



# Get bundled software choices
BUNDLED_ITEMS=()

if [ "$ENABLE_NET_ETH" == true ]; then
    BUNDLED_ITEMS+=(
        "c3270"        "3270 terminal emulator (+1.8MiB)"                   "$(val "$INCLUDE_C3270")"
        #"cmatrix"      "Scrolling text screensaver (+0.4MiB)"              "$(val "$INCLUDE_CMATRIX")"
        "dropbear"      "*SCP & SSH client (+0.4MiB)"                       "$(val "$INCLUDE_DROPBEAR")"
        "file"          "*File type identification (+10MiB)"                "$(val "$INCLUDE_FILE")"
        "gcc"           "**GCC (as, g++, gcc, gfortran) + musl (+215MiB)"   "$(val "$INCLUDE_GCC")"
        "git"           "*Source control client (+19MiB)"                   "$(val "$INCLUDE_GIT")"
        "htop"          "*Interactive process viewer (+0.6MiB)"             "$(val "$INCLUDE_HTOP")"
        "lynx"          "*Terminal web browser (+7.3MiB)"                   "$(val "$INCLUDE_LYNX")"
        "mg"            "*Emacs-style text editor (+0.3MiB)"                "$(val "$INCLUDE_MG")"
        "micropython"   "*Python 3.4-syntax intepreter (+0.7MiB)"           "$(val "$INCLUDE_MICROPYTHON")"
        "mt-st"         "*Tape drive tools (+0.2MiB)"                       "$(val "$INCLUDE_MT_ST")"
        "nano"          "*Text editor (+0.8MiB)"                            "$(val "$INCLUDE_NANO")"
        "sc-im"         "*Terminal spreadsheet editor (+2.8MiB)"            "$(val "$INCLUDE_SC_IM")"
        "shorktainment" "*shorkmatrix, shorksay & sl (+0.1MiB)"             "$(val "$INCLUDE_SHORKTAINMENT")"
        "strace"        "*System calls & signals tracer (+1.1MiB)"          "$(val "$INCLUDE_STRACE")"
        "tcc"           "*Tiny C Compiler + musl (+4MiB)"                   "$(val "$INCLUDE_TCC")"
        "tn5250"        "TCP/IP 5250 terminal emulator (+6.4MiB)"           "$(val "$INCLUDE_TN5250")"
        "tnftp"         "*FTP client (+0.3MiB)"                             "$(val "$INCLUDE_TNFTP")"
        "tmux"          "*Terminal multiplexer (+1.7MiB)"                   "$(val "$INCLUDE_TMUX")"
        "util-linux"    "*lsblk, partx, sfdisk & whereis (+1.9MiB)"         "$(val "$INCLUDE_UTIL_LINUX")"
    )
else
    BUNDLED_ITEMS+=(
        "c3270"        "3270 terminal emulator (+1.8MiB)"                   "$(val "$INCLUDE_C3270")"
        #"cmatrix"      "Scrolling text screensaver (+0.4MiB)"              "$(val "$INCLUDE_CMATRIX")"
        "file"          "*File type identification (+10MiB)"                "$(val "$INCLUDE_FILE")"
        "gcc"           "**GCC (as, g++, gcc, gfortran) + musl (+215MiB)"   "$(val "$INCLUDE_GCC")"
        "htop"          "*Interactive process viewer (+0.6MiB)"             "$(val "$INCLUDE_HTOP")"
        "mg"            "*Emacs-style text editor (+0.3MiB)"                "$(val "$INCLUDE_MG")"
        "micropython"   "*Python 3.4-syntax intepreter (+0.7MiB)"           "$(val "$INCLUDE_MICROPYTHON")"
        "mt-st"         "*Tape drive tools (+0.2MiB)"                       "$(val "$INCLUDE_MT_ST")"
        "nano"          "*Text editor (+0.8MiB)"                            "$(val "$INCLUDE_NANO")"
        "sc-im"         "*Terminal spreadsheet editor (+2.8MiB)"            "$(val "$INCLUDE_SC_IM")"
        "shorktainment" "*shorkmatrix, shorksay & sl (+0.1MiB)"             "$(val "$INCLUDE_SHORKTAINMENT")"
        "strace"        "*System calls & signals tracer (+1.1MiB)"          "$(val "$INCLUDE_STRACE")"
        "tcc"           "*Tiny C Compiler + musl (+4MiB)"                   "$(val "$INCLUDE_TCC")"
        "util-linux"    "*lsblk, partx, sfdisk & whereis (+1.9MiB)"         "$(val "$INCLUDE_UTIL_LINUX")"
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
    #if [[ $BUNDLED =~ "cmatrix" ]];        then INCLUDE_CMATRIX=true;          else INCLUDE_CMATRIX=false;         fi
    if [[ $BUNDLED =~ "dropbear" ]];        then INCLUDE_DROPBEAR=true;         else INCLUDE_DROPBEAR=false;        fi
    if [[ $BUNDLED =~ "file" ]];            then INCLUDE_FILE=true;             else INCLUDE_FILE=false;            fi
    if [[ $BUNDLED =~ "gcc" ]];             then INCLUDE_GCC=true;              else INCLUDE_GCC=false;             fi
    if [[ $BUNDLED =~ "git" ]];             then INCLUDE_GIT=true;              else INCLUDE_GIT=false;             fi
    if [[ $BUNDLED =~ "htop" ]];            then INCLUDE_HTOP=true;             else INCLUDE_HTOP=false;            fi
    if [[ $BUNDLED =~ "lynx" ]];            then INCLUDE_LYNX=true;             else INCLUDE_LYNX=false;            fi
    if [[ $BUNDLED =~ "mg" ]];              then INCLUDE_MG=true;               else INCLUDE_MG=false;              fi
    if [[ $BUNDLED =~ "micropython" ]];     then INCLUDE_MICROPYTHON=true;      else INCLUDE_MICROPYTHON=false;     fi
    if [[ $BUNDLED =~ "nano" ]];            then INCLUDE_NANO=true;             else INCLUDE_NANO=false;            fi
    if [[ $BUNDLED =~ "sc-im" ]];           then INCLUDE_SC_IM=true;            else INCLUDE_SC_IM=false;           fi
    if [[ $BUNDLED =~ "shorktainment" ]];   then INCLUDE_SHORKTAINMENT=true;    else INCLUDE_SHORKTAINMENT=false;   fi
    if [[ $BUNDLED =~ "strace" ]];          then INCLUDE_STRACE=true;           else INCLUDE_STRACE=false;          fi
    if [[ $BUNDLED =~ "tcc" ]];             then INCLUDE_TCC=true;              else INCLUDE_TCC=false;             fi
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
    "con-fonts"     "*Console fonts pack (+0.05MiB)"                            $(val $INCLUDE_CON_FONTS) \
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
