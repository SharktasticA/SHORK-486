#!/bin/bash

######################################################
## Gets list of changed files from a lore.kernel.   ##
## org message.                                     ##
######################################################
## Kali (links.sharktastica.co.uk)                  ##
######################################################



set -euo pipefail

# Input: lore.kernel.org message to get patch from
INPUT="https://lore.kernel.org/netdev/20260521001631.45434-1-enelsonmoore@gmail.com/T/"

# Strip trailing /T/
BASE_URL="${INPUT%%/T/}"
MSGID="${BASE_URL##*/}"

# Compressed patch file
MBOX_URL="${BASE_URL}/t.mbox.gz"

# Output
WORK_DIR="tmp/${MSGID}"
mkdir -p "$WORKDIR"

# Download message
MBOX="$WORK_DIR/thread.mbox"
b4 mbox "$MSGID" -o "$WORK_DIR" -n "thread.mbox"

# Get list of changed files
FILE_LIST="$WORK_DIR/changed.txt"
{
    grep -oE '^diff --git a/\S+ b/\S+' "$MBOX" | awk '{print $4}' | sed 's#^b/##'
    grep -oE '^\+\+\+ b/\S+' "$MBOX" | sed 's#^+++ b/##'
} | sort -u > "$FILE_LIST"
echo "Created $FILE_LIST"
