#!/bin/bash

######################################################
## Gets the latest version numbers of SHORK 486's   ##
## software components.                             ##
######################################################
## Kali (links.sharktastica.co.uk)                  ##
######################################################



CURR_DIR=$(pwd)
ENV="$CURR_DIR/ght.env"
if [ -f "$ENV" ]; then
    set -a
    source "$ENV"
    set +a
fi
AUTH_HEADER=(-H "Authorization: Bearer $GITHUB_TOKEN")
COL_WIDTH=44



REPOS=(
    "pmattes/x3270"
    "universal-ctags/ctags"
    "dosemu2/dosemu2"
    "dosfstools/dosfstools"
    "mkj/dropbear"
    "file/file"
    "git/git"
    "telmich/gpm"
    "htop-dev/htop"
    "joe-editor/joe"
    "xiph/libao"
    "libevent/libevent"
    "jmcnamara/libxlsxwriter"
    "gnome/libxml2"
    "nih-at/libzip"
    "llvm/llvm-project"
    "deepin-community/lsb-release-minimal"
    "lua/lua"
    "jqlang/jq"
    "ThomasDickey/lynx-snapshots"
    "troglobit/mg"
    "micro-editor/MICRO"
    "micropython/micropython"
    "iustin/mt-st"
    "netwide-assembler/nasm"
    "mirror/ncurses"
    "openssl/openssl"
    "NixOS/patchelf"
    "PCRE2Project/pcre2"
    "andmarti1424/sc-im"
    "strace/strace"
    "tmux/tmux"
    "tn5250/tn5250"
    "util-linux/util-linux"
    "vim/vim"
    "wfeldt/libx86emu"
    "madler/zlib"
)

echo -e "------------------------------------------------------------------------------------ GitHub ------------------------------------------------------------------------------------"
for repo in "${REPOS[@]}"; do
    name="${repo##*/}"
    releases=$(curl -s "${AUTH_HEADER[@]}" "https://api.github.com/repos/$repo/releases" | jq -r '.[0:3] | map(.tag_name + " (" + (.updated_at[0:10]) + ")") | @tsv')
    if [ -z "$releases" ]; then
        releases=$(curl -s "${AUTH_HEADER[@]}" "https://api.github.com/repos/$repo/tags" | jq -r '.[0:3] | map(.name) | @tsv')
    fi
    IFS=$'\t' read -r v1 v2 v3 <<< "$releases"
    printf "%-${COL_WIDTH}s%-${COL_WIDTH}s%-${COL_WIDTH}s%-${COL_WIDTH}s\n" "$name:" "$v1" "$v2" "$v3"
    sleep 0.5
done

echo -e "Manual check needed for:"
echo "https://github.com/ThomasDickey/lynx-snapshots.git"
