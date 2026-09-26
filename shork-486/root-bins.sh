#!/bin/bash

######################################################
## Gets a list of all binaries and executable files ##
## in DESTDIR and their size in KiB.                ##
######################################################
## Kali (links.sharktastica.co.uk)                  ##
######################################################



set -euo pipefail



DESTDIR="build/root"

find \
    "$DESTDIR/sbin" \
    "$DESTDIR/usr/sbin" \
    "$DESTDIR/bin" \
    "$DESTDIR/usr/bin" \
    "$DESTDIR/usr/libexec" \
    -type f -executable 2>/dev/null |
while IFS= read -r FILE; do
    SIZE_B=$(stat -c '%s' "$FILE" 2>/dev/null) || continue
    SIZE_KiB=$(awk -v s="$SIZE_B" 'BEGIN { printf "%.1f", s / 1024 }')
    printf "%-64s%sKiB\n" "$FILE" "$SIZE_KiB"
done > root-bins.txt

cat root-bins.txt
