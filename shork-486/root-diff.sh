#!/bin/bash

######################################################
## Takes two snapshots of build/root directory to   ##
# work out the size difference and added files      ##
# between the two.                                  ##
######################################################
## Kali (links.sharktastica.co.uk)                  ##
######################################################



set -euo pipefail



TARGET_DIR="${1:-build/root}"
if [ ! -d "$TARGET_DIR" ]; then
    echo "ERROR: $TARGET_DIR does not exist\n" >&2
    exit 1
fi




BEFORE_LIST="$(mktemp)"
AFTER_LIST="$(mktemp)"
trap 'rm -f "$BEFORE_LIST" "$AFTER_LIST"' EXIT



get_size()
{
    du -sm "$TARGET_DIR" 2>/dev/null | cut -f1
}

get_file_count()
{
    get_file_list | wc -l
}

get_file_list()
{
    (cd "$TARGET_DIR" && find . \( -type f -o -type l \) | sort)
}




read -rp "Press ENTER to make BEFORE snapshot..."
BEFORE_SIZE=$(get_size)
get_file_list > "$BEFORE_LIST"
BEFORE_FILES=$(wc -l < "$BEFORE_LIST")

printf "Before:\n"
printf "Size: ${BEFORE_SIZE}MiB\n"
printf "Files: ${BEFORE_FILES}\n\n"



read -rp "Press ENTER to make AFTER snapshot..."
AFTER_SIZE=$(get_size)
get_file_list > "$AFTER_LIST"
AFTER_FILES=$(wc -l < "$AFTER_LIST")

ADDED_FILES=$(comm -13 "$BEFORE_LIST" "$AFTER_LIST")
ADDED_COUNT=0
if [ -n "$ADDED_FILES" ]; then
    ADDED_COUNT=$(echo "$ADDED_FILES" | wc -l)
fi

printf "After:\n"
printf "Size: ${AFTER_SIZE}MiB\n"
printf "Files: ${AFTER_FILES}\n"
printf "Files added:\n"
if [ "$ADDED_COUNT" -eq 0 ]; then
    echo "(none)"
else
    echo "$ADDED_FILES" | sed 's/^\.\//  /'
fi
