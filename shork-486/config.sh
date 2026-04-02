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
WIDTH=66
HEIGHT=16



ALWAYS_BUILD=true
IS_ARCH=false
IS_FEDORA=false
IS_DEBIAN=true
BUILD_TYPE="default"
DEFAULT=true
MINIMAL=false
MAXIMAL=false
CUSTOM=false
TARGET_DISK=72
TARGET_SWAP=8
SET_KEYMAP="en_us"
HOSTNAME="shork-486"
FIX_EXTLINUX=true
ENABLE_NET=true
SKIP_DROPBEAR=false
SKIP_FILE=false
SKIP_GIT=false
SKIP_EMACS=false
SKIP_NANO=false
SKIP_TCC=false
SKIP_TNFTP=false
NO_MENU=false
ENABLE_GCC=false
USE_GRUB=false
ENABLE_CFONTS=true
ENABLE_GUI=false
ENABLE_HIGHMEM=false
SKIP_KEYMAPS=false
SKIP_PCIIDS=false
ENABLE_PCMCIA=true
ENABLE_SATA=false
ENABLE_SL=true
ENABLE_SMP=false
ENABLE_USB=false

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
DEFAULT=$DEFAULT
MINIMAL=$MINIMAL
MAXIMAL=$MAXIMAL
CUSTOM=$CUSTOM
TARGET_DISK=$TARGET_DISK
TARGET_SWAP=$TARGET_SWAP
SET_KEYMAP="$SET_KEYMAP"
HOSTNAME="$HOSTNAME"
FIX_EXTLINUX=$FIX_EXTLINUX
ENABLE_NET=$ENABLE_NET
SKIP_DROPBEAR=$SKIP_DROPBEAR
SKIP_FILE=$SKIP_FILE
ENABLE_GCC=$ENABLE_GCC
SKIP_GIT=$SKIP_GIT
SKIP_EMACS=$SKIP_EMACS
SKIP_NANO=$SKIP_NANO
SKIP_TCC=$SKIP_TCC
SKIP_TNFTP=$SKIP_TNFTP
NO_MENU=$NO_MENU
USE_GRUB=$USE_GRUB
ENABLE_CFONTS=$ENABLE_CFONTS
ENABLE_GUI=$ENABLE_GUI
ENABLE_HIGHMEM=$ENABLE_HIGHMEM
SKIP_KEYMAPS=$SKIP_KEYMAPS
SKIP_PCIIDS=$SKIP_PCIIDS
ENABLE_PCMCIA=$ENABLE_PCMCIA
ENABLE_SATA=$ENABLE_SATA
ENABLE_SL=$ENABLE_SL
ENABLE_SMP=$ENABLE_SMP
ENABLE_USB=$ENABLE_USB
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
TYPE=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Build Type" \
    --cancel-label "Quit" \
    --radiolist "Select the build type, presets for SHORK 486 feature levels. All except \"Custom\" will complete configuration now." $HEIGHT $WIDTH 6 \
    "Default" "Requires 16MiB RAM + 72MiB disk"             $(val $DEFAULT) \
    "Minimal" "Requires 8MiB RAM + 16MiB disk"              $(val $MINIMAL) \
    "Maximal" "Requires 24MiB RAM + 440MiB disk"            $(val $MAXIMAL) \
    "Custom"  "Requirements depend on subsequent choices"   $(val $CUSTOM) \
    2>&1 >/dev/tty)

if [[ ! -n "$TYPE" ]]; then
    exit 0
elif [ "$TYPE" == "Default" ]; then
    BUILD_TYPE="default"
    DEFAULT=true
    MINIMAL=false
    MAXIMAL=false
    CUSTOM=false
    ENABLE_NET=true
    SKIP_DROPBEAR=false
    SKIP_FILE=false
    SKIP_GIT=false
    SKIP_EMACS=false
    SKIP_NANO=false
    SKIP_TCC=false
    SKIP_TNFTP=false
    NO_MENU=false
    ENABLE_GCC=false
    USE_GRUB=false
    ENABLE_GUI=false
    ENABLE_CFONTS=true
    ENABLE_HIGHMEM=false
    SKIP_KEYMAPS=false
    SKIP_PCIIDS=false
    ENABLE_PCMCIA=true
    ENABLE_SATA=false
    ENABLE_SL=true
    ENABLE_SMP=false
    ENABLE_USB=false
elif [ "$TYPE" == "Minimal" ]; then
    BUILD_TYPE="minimal"
    DEFAULT=false
    MINIMAL=true
    MAXIMAL=false
    CUSTOM=false
    ENABLE_NET=false
    SKIP_DROPBEAR=true
    SKIP_FILE=true
    SKIP_GIT=true
    SKIP_EMACS=true
    SKIP_NANO=true
    SKIP_TCC=true
    SKIP_TNFTP=true
    NO_MENU=true
    ENABLE_GCC=false
    USE_GRUB=false
    ENABLE_GUI=false
    ENABLE_CFONTS=false
    ENABLE_HIGHMEM=false
    SKIP_KEYMAPS=true
    SKIP_PCIIDS=true
    ENABLE_PCMCIA=false
    ENABLE_SATA=false
    ENABLE_SL=false
    ENABLE_SMP=false
    ENABLE_USB=false
elif [ "$TYPE" == "Maximal" ]; then
    BUILD_TYPE="maximal"
    DEFAULT=false
    MINIMAL=false
    MAXIMAL=true
    CUSTOM=false
    ENABLE_NET=true
    SKIP_DROPBEAR=false
    SKIP_FILE=false
    SKIP_GIT=false
    SKIP_EMACS=false
    SKIP_NANO=false
    SKIP_TCC=false
    SKIP_TNFTP=false
    NO_MENU=false
    ENABLE_GCC=true
    USE_GRUB=false
    ENABLE_GUI=true
    ENABLE_CFONTS=true
    ENABLE_HIGHMEM=true
    SKIP_KEYMAPS=false
    SKIP_PCIIDS=false
    ENABLE_PCMCIA=true
    ENABLE_SATA=true
    ENABLE_SL=true
    ENABLE_SMP=true
    ENABLE_USB=true
elif [ "$TYPE" == "Custom" ]; then
    BUILD_TYPE="custom"
    DEFAULT=false
    MINIMAL=false
    MAXIMAL=false
    CUSTOM=true
fi



# Get target disk size
while true; do
    TARGET_DISK_TMP=$(dialog --clear \
        --backtitle "SHORK 486 Build Configurator" \
        --title "Target Disk Size" \
        --cancel-label "Skip" \
        --inputbox "Enter a target disk size in mebibytes (between 16 and 4096) to use when creating the disk image containing SHORK 486. Whilst the build script will try to honour this, if the complete build's size is larger, it will calculate a new size so the build doesn't fail." \
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
            --msgbox "The value must be numeric only." 12 $WIDTH
        continue
    fi

    if (( TARGET_DISK_TMP < 16 || TARGET_DISK_TMP > 4096 )); then
        dialog --clear \
            --backtitle "SHORK 486 Build Configurator" \
            --title "Target Disk Size" \
            --msgbox "The value must be between 16 and 4096." 12 $WIDTH
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
        12 $WIDTH "$TARGET_SWAP" \
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
if [ "$TYPE" != "Minimal" ]; then
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
    10 $WIDTH

CHOICE=$?

if [[ $CHOICE -eq 0 ]]; then
    FIX_EXTLINUX=true
elif [[ $CHOICE -eq 1 ]]; then
    FIX_EXTLINUX=false
fi



# If build type isn't custom, it's time to exit!
if [ "$TYPE" != "Custom" ]; then
    exit 0
fi



# Get networking support choice
dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Networking Support" \
    --yesno "Do you want to enable networking support in SHORK 486? It includes kernel-level networking support and BusyBox's networking-related utilities, and you will be able to choose software that requires an internet connection in the next prompt." \
    9 $WIDTH

CHOICE=$?

if [[ $CHOICE -eq 0 ]]; then
    ENABLE_NET=true
elif [[ $CHOICE -eq 1 ]]; then
    ENABLE_NET=false
    SKIP_DROPBEAR=true
    SKIP_GIT=true
    SKIP_TNFTP=true
fi



# Get bundled software choices
BUNDLED_ITEMS=()

if [ "$ENABLE_NET" == true ]; then
    BUNDLED_ITEMS+=(
        "dropbear"  "SCP & SSH client (+0.4MiB)"                        "$(val_inv "$SKIP_DROPBEAR")"
        "file"      "File type identification (+10MiB)"                 "$(val_inv "$SKIP_FILE")"
        "gcc"       "*GCC (as, g++, gcc, gfortran) + musl (+215MiB)"    "$(val "$ENABLE_GCC")"
        "git"       "Source control client (+19MiB)"                    "$(val_inv "$SKIP_GIT")"
        "mg"        "Emacs-style text editor (+0.3MiB)"                 "$(val_inv "$SKIP_EMACS")"
        "nano"      "Text editor (+1MiB)"                               "$(val_inv "$SKIP_NANO")"
        "tcc"       "Tiny C Compiler & musl (+4MiB)"                    "$(val_inv "$SKIP_TCC")"
        "tnftp"     "FTP client (+0.3MiB)"                              "$(val_inv "$SKIP_TNFTP")"
    )
else
    BUNDLED_ITEMS+=(
        "file"      "File type identification (+10MiB)"                 "$(val_inv "$SKIP_FILE")"
        "gcc"       "*GCC (as, g++, gcc, gfortran) + musl (+215MiB)"    "$(val "$ENABLE_GCC")"
        "mg"        "Emacs-style text editor (+0.3MiB)"                 "$(val_inv "$SKIP_EMACS")"
        "nano"      "Text editor (+1MiB)"                               "$(val_inv "$SKIP_NANO")"
        "tcc"       "Tiny C Compiler & musl (+4MiB)"                    "$(val_inv "$SKIP_TCC")"
    )
fi

BUNDLED=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Bundled Software" \
    --cancel-label "Skip" \
    --checklist "Select what software to bundle with SHORK 486. Options marked with \"*\" particularly affect RAM requirements." $HEIGHT $WIDTH 8 \
    "${BUNDLED_ITEMS[@]}" \
    2>&1 >/dev/tty)

SKIPPED=$?

if [[ $SKIPPED -eq 1 ]]; then
    :
else
    if [[ $BUNDLED =~ "dropbear" ]];    then SKIP_DROPBEAR=false;   else SKIP_DROPBEAR=true;    fi
    if [[ $BUNDLED =~ "file" ]];        then SKIP_FILE=false;       else SKIP_FILE=true;        fi
    if [[ $BUNDLED =~ "gcc" ]];         then ENABLE_GCC=true;       else ENABLE_GCC=false;      fi
    if [[ $BUNDLED =~ "git" ]];         then SKIP_GIT=false;        else SKIP_GIT=true;         fi
    if [[ $BUNDLED =~ "mg" ]];          then SKIP_EMACS=false;      else SKIP_EMACS=true;       fi
    if [[ $BUNDLED =~ "nano" ]];        then SKIP_NANO=false;       else SKIP_NANO=true;        fi
    if [[ $BUNDLED =~ "tcc" ]];         then SKIP_TCC=false;        else SKIP_TCC=true;         fi
    if [[ $BUNDLED =~ "tnftp" ]];       then SKIP_TNFTP=false;      else SKIP_TNFTP=true;       fi
fi



# Get option choices
OPTIONS=$(dialog --clear \
    --backtitle "SHORK 486 Build Configurator" \
    --title "Options" \
    --cancel-label "Skip" \
    --checklist "Select what other options to include. Some of these are benign, some may increase the RAM and disk space requirement considerably, some are experimental. Options marked with \"*\" particularly affect RAM requirements." $HEIGHT $WIDTH 9 \
    "cfonts"    "Alternative console fonts (+0.05MiB)"      $(val $ENABLE_CFONTS) \
    "grub"      "GRUB 2.x instead of EXTLINUX (+4MiB)"      $(val $USE_GRUB) \
    "gui"       "*SHORKGUI (+46MiB, EXPERIMENTAL)"          $(val $ENABLE_GUI) \
    "highmem"   "*Kernel-level high memory support"         $(val $ENABLE_HIGHMEM) \
    "menu"      "Menu-based bootloader (+0.5MiB)"           $(val_inv $NO_MENU) \
    "pci.ids"   "PCI IDs database (+0.1MiB)"                $(val_inv $SKIP_PCIIDS) \
    "pcmcia"    "Kernel-level PCMCIA support"               $(val $ENABLE_PCMCIA) \
    "sata"      "*Kernel-level SATA support"                $(val $ENABLE_SATA) \
    "sl"        "shorklocomotive (+0.03MiB)"                $(val $ENABLE_SL) \
    "smp"       "*Kernel-level SMP support"                 $(val $ENABLE_SMP) \
    "usb"       "Kernel-level USB & HID support (+0.2MiB)"  $(val $ENABLE_USB) \
    2>&1 >/dev/tty)
    #"keymaps"   "Keymaps & shorkmap (+0.06MiB)"             $(val_inv $SKIP_KEYMAPS) \
    
SKIPPED=$?

if [[ $SKIPPED -eq 1 ]]; then
    :
else
    if [[ $OPTIONS =~ "cfonts" ]];     then ENABLE_CFONTS=true;     else ENABLE_CFONTS=false;  fi
    if [[ $OPTIONS =~ "grub" ]];       then USE_GRUB=true;         else USE_GRUB=false;        fi
    if [[ $OPTIONS =~ "gui" ]];        then ENABLE_GUI=true;       else ENABLE_GUI=false;      fi
    if [[ $OPTIONS =~ "highmem" ]];    then ENABLE_HIGHMEM=true;   else ENABLE_HIGHMEM=false;  fi
    #if [[ $OPTIONS =~ "keymaps" ]];    then SKIP_KEYMAPS=false;    else SKIP_KEYMAPS=true;     fi
    if [[ $OPTIONS =~ "pci.ids" ]];    then SKIP_PCIIDS=false;     else SKIP_PCIIDS=true;      fi
    if [[ $OPTIONS =~ "pcmcia" ]];     then ENABLE_PCMCIA=true;    else ENABLE_PCMCIA=false;   fi
    if [[ $OPTIONS =~ "sata" ]];       then ENABLE_SATA=true;      else ENABLE_SATA=false;     fi
    if [[ $OPTIONS =~ "sl" ]];         then ENABLE_SL=true;        else ENABLE_SL=false;       fi
    if [[ $OPTIONS =~ "smp" ]];        then ENABLE_SMP=true;       else ENABLE_SMP=false;      fi
    if [[ $OPTIONS =~ "usb" ]];        then ENABLE_USB=true;       else ENABLE_USB=false;      fi
fi
