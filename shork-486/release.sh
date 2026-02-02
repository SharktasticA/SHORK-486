#!/bin/bash

######################################################
## SHORK 486 release build script                   ##
######################################################
## Kali (sharktastica.co.uk)                        ##
######################################################



set -e
mkdir -p release

DATE=$(date "+%Y%m%d")
VER=$(cat branding/VER)



NAME="${DATE}_SHORK-486_${VER}_minimal"
if [[ ! -f "release/${NAME}.zip" ]]; then
    ./build.sh --always-build --is-debian --target-swap=8 --minimal --fix-extlinux
    cp images/shork-486.img "release/${NAME}.img"
    cp images/report.txt "release/${NAME}.txt"
    cd release
    zip "${NAME}.zip" "${NAME}.img" "${NAME}.txt"
    rm *.img *.txt
    cd ..
fi



NAME="${DATE}_SHORK-486_${VER}_default"
if [[ ! -f "release/${NAME}.zip" ]]; then
    ./build.sh --always-build --is-debian --target-swap=8 --fix-extlinux
    cp images/shork-486.img "release/${NAME}.img"
    cp images/report.txt "release/${NAME}.txt"
    cd release
    zip "${NAME}.zip" "${NAME}.img" "${NAME}.txt"
    rm *.img *.txt
    cd ..
fi



NAME="${DATE}_SHORK-486_${VER}_x11"
if [[ ! -f "release/${NAME}.zip" ]]; then
    ./build.sh --always-build --is-debian --target-swap=16 --enable-gui --enable-twm --fix-extlinux
    cp images/shork-486.img "release/${NAME}.img"
    cp images/report.txt "release/${NAME}.txt"
    cd release
    zip "${NAME}.zip" "${NAME}.img" "${NAME}.txt"
    rm *.img *.txt
    cd ..
fi



NAME="${DATE}_SHORK-486_${VER}_maximal"
if [[ ! -f "release/${NAME}.zip" ]]; then
    ./build.sh --always-build --is-debian --target-swap=16 --maximal --fix-extlinux
    cp images/shork-486.img "release/${NAME}.img"
    cp images/report.txt "release/${NAME}.txt"
    cd release
    zip "${NAME}.zip" "${NAME}.img" "${NAME}.txt"
    rm *.img *.txt
    cd ..
fi
