#!/bin/sh

FILE="keyboards.json"
TMP=$(mktemp)

check() {
    if [ "$2" = "$3" ]; then
        echo "PASS: $1 (got \"$3\")"
    else
        echo "FAIL: $1 (expected \"$2\", got \"$3\")"
    fi
}

check "read name"   "Model M"   "$(jq -r '.families[2].name' "$FILE")"
check "read year"   "1984"      "$(jq '.families[2].year' "$FILE")"

jq '.families[2].year = 1985' "$FILE" > "$TMP"
check "changed year"            "1985"      "$(jq '.families[2].year' "$TMP")"
check "other fields intact"     "Model M"   "$(jq -r '.families[2].name' "$TMP")"
check "original not modified"   "1984"      "$(jq '.families[2].year' "$FILE")"
