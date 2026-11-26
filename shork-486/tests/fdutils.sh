#!/bin/sh

if [ ! -f /etc/mtools.conf ]; then
    cat > /etc/mtools.conf << 'EOT'
drive a: file="/dev/fd0" exclusive
EOT
fi

[ -f /etc/mtab ] || : > /etc/mtab

fdlist
getfdprm /dev/fd0
floppycontrol -p
# floppymeter is expected to fail on emulated hardware:
floppymeter --hd -f /dev/fd0
yes | superformat --deviation=0 /dev/fd0 hd
getfdprm /dev/fd0
setfdprm /dev/fd0 1440/1440
getfdprm /dev/fd0
fdrawcmd drive=/dev/fd0 recalibrate 0
fdrawcmd drive=/dev/fd0 seek 0 10
fdrawcmd drive=/dev/fd0 recalibrate 0
mkdir -p /mnt/floppy
fdmount fd0 /mnt/floppy
echo "Hello, SHORK!" > /mnt/floppy/test.txt
ls /mnt/floppy
fdumount fd0
