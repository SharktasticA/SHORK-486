#!/bin/bash

######################################################
## SHORK 486 release build script                   ##
######################################################
## Kali (links.sharktastica.co.uk)                  ##
######################################################



set -e

BASE_DIR=$(pwd)
DATE=$(date "+%Y%m%d")
VER=$(cat ../branding/VER)

ENVS="
1-shork-diskette.env
3-shork-486-min.env
7-shork-disc.env
"

mkdir -p images

for ENV in $ENVS; do
    # Copy .env and build
    cp "envs/$ENV" ../.env
    cd ..
    ./build.sh

    # Build new file name
    BASE="${ENV#*-}"
    BASE="${BASE%.env}"
    NAME="${BASE}_${DATE}_${VER,,}"

    # Rename and move result
    if [[ "$BASE" != "shork-disc" ]]; then
        # .imgs get moved to payloads since they will be included in SHORK DISC
        mv "images/${BASE}.img" "payloads/${NAME}.img"
    else
        # SHORK DISC should not be a payload
        mv "images/${BASE}.iso" "releases/images/${NAME}.iso"
    fi

    cd "$BASE_DIR"
done

# Now the other images have been payload'd into SHORK DISC, also move them into
# releases/images
cd ..
find "payload/" -mindepth 1 -not -name "notice.txt" | while read -r item; do
    sudo cp -r "$item" "releases/images/"
done
