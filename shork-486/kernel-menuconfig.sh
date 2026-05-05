#!/bin/sh

CURR_DIR=$(pwd)
ARCH="$(cat ${CURR_DIR}/branding/ARCH | tr -d '\n')"
CROSS="${ARCH}-linux-musl-cross"
PREFIX="${CURR_DIR}/build/${CROSS}"

cd build/linux
make ARCH="${ARCH}" CROSS_COMPILE="${PREFIX}/bin/${ARCH}-linux-musl-" menuconfig
