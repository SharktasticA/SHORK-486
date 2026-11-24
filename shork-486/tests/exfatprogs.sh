#!/bin/sh

dd if=/dev/zero of=/tmp/exfat.img bs=1k count=16384
mkfs.exfat -L TESTEXF /tmp/exfat.img
fsck.exfat /tmp/exfat.img
exfatlabel /tmp/exfat.img 
exfatlabel /tmp/exfat.img NEWLABEL
exfatlabel /tmp/exfat.img 
tune.exfat -l /tmp/exfat.img
fsck.exfat /tmp/exfat.img
