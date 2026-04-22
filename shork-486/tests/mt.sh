#!/bin/sh

dd if=/dev/zero of=tape.img bs=1M count=4
mknod /dev/loop5 b 7 1
chmod 660 /dev/loop5
losetup /dev/loop5 tape.img
