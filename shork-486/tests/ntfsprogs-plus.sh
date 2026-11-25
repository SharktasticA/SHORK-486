#!/bin/sh

dd if=/dev/zero of=/tmp/ntfs.img bs=1k count=16384
mkntfs -F -L TESTNTFS /tmp/ntfs.img
ntfsck -n /tmp/ntfs.img
ntfslabel /tmp/ntfs.img
ntfslabel /tmp/ntfs.img NEWLABEL
ntfslabel /tmp/ntfs.img
ntfsinfo -m /tmp/ntfs.img
ntfsck -n /tmp/ntfs.img
ntfsresize -f -s 8M /tmp/ntfs.img
ntfsck -n /tmp/ntfs.img
