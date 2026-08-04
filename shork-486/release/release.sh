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
DISC_NUM=0

ENVS="
1-shork-diskette.env
3-shork-486-min.env
4-shork-486-off.env
5-shork-486-wtr.env
6-shork-486-def.env
shork-disc.env
6-shork-486-def.env
7-shork-486-plus.env
shork-disc.env
8-shork-486-max.env
shork-disc.env
"



# Assembles output file name for the given .env file name
build_name()
{
    local env="$1"
    local BASE DIST
    BASE="${env%.env}"
    BASE="${BASE#[0-9]*-}"
    DIST=""
    if [[ "$BASE" == *"shork-486"* ]]; then
        DIST="shork-486"
    elif [[ "$BASE" == *"shork-disc"* ]]; then
        DIST="shork-disc"
    elif [[ "$BASE" == *"shork-diskette"* ]]; then
        DIST="shork-diskette"
    fi
    echo "${DIST} ${BASE}_${DATE}_${VER,,}"
}

# Moves SHORK images from payload to releases/images
move_imgs()
{
    find "payload/" -mindepth 1 -not -name "notice.txt" | while read -r item; do
        mv "$item" "release/images/"
    done
}



mkdir -p images

for ENV in $ENVS; do
    read -r DIST NAME <<< "$(build_name "$ENV")"

    # if we already have any image in this name, reuse it
    if [[ "$DIST" != "shork-disc" && -f "release/images/${NAME}.img" ]]; then
        cd ..
        cp "release/images/${NAME}.img" "payload/${NAME}.img"
        cp "release/images/${NAME}.txt" "payload/${NAME}.txt"
    # else, build a new image
    else
        # Copy .env and build
        cp "envs/$ENV" ../.env
        cd ..
        ./build.sh

        # Rename and move result
        if [[ "$DIST" != "shork-disc" ]]; then
            # .imgs get moved to payload since they will be included in SHORK DISC
            mv "images/${DIST}.img" "payload/${NAME}.img"
            mv "images/report.txt" "payload/${NAME}.txt"
        else
            # SHORK DISC should not be a payload
            DISC_NUM=$((DISC_NUM+1))
            mv "images/${DIST}.iso" "release/images/${NAME}-${DISC_NUM}.iso"
            mv "images/report.txt" "release/images/${NAME}-${DISC_NUM}.txt"
            move_imgs
        fi
    fi

    cd "$BASE_DIR"
done
