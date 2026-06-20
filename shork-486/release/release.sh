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
    DIST=""
    if [[ "$BASE" == "shork-486" || "$BASE" == *"shork-486"* ]]; then
        DIST="shork-486"
    elif [[ "$BASE" == "shork-disc" || "$BASE" == *"shork-disc"* ]]; then
        DIST="shork-disc"
    elif [[ "$BASE" == "shork-diskette" || "$BASE" == *"shork-diskette"* ]]; then
        DIST="shork-diskette"
    fi
    NAME="${BASE}_${DATE}_${VER,,}"

    # Rename and move result
    if [[ "$DIST" != "shork-disc" ]]; then
        # .imgs get moved to payload since they will be included in SHORK DISC
        mv "images/${DIST}.img" "payload/${NAME}.img"
        mv "images/report.txt" "payload/${NAME}.txt"
    else
        # SHORK DISC should not be a payload
        mv "images/${DIST}.iso" "release/images/${NAME}.iso"
        mv "images/report.txt" "release/images/${NAME}.txt"
    fi

    cd "$BASE_DIR"
done

# Now the other images have been payload'd into SHORK DISC, also move them into
# release/images
cd ..
find "payload/" -mindepth 1 -not -name "notice.txt" | while read -r item; do
    mv -r "$item" "release/images/"
done
