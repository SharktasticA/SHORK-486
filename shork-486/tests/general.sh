#!/bin/sh



RESULTS_FILE="general_results.txt"
RESULTS=""
PASSES=0
FAILS=0
SKIPS=0



# Tests if a given command's output watches the expected [sub]string
output_test()
{
    NAME="$1"
    EXPECTED="$2"
    shift 2

    OUTPUT="$("$@" 2>/dev/null)"
    STATUS=$?
    if [ "$STATUS" -eq 127 ]; then
        RESULTS="${RESULTS}${NAME} SKIP (command not found)
"
        SKIPS=$((SKIPS + 1))
        return
    fi

    case "$OUTPUT" in
        *"$EXPECTED"*)
            RESULTS="${RESULTS}${NAME} PASS
"
            PASSES=$((PASSES + 1))
            ;;
        *)
            RESULTS="${RESULTS}${NAME} FAIL
"
            FAILS=$((FAILS + 1))
            ;;
    esac
}



output_test "ascii      "   "75 4b K"                   ascii
output_test "basename   "   "selectric-golfball-70.txt" basename /tests/selectric-golfball-70.txt
output_test "bc         "   "4"                         sh -c 'echo "2 + 2" | bc'
output_test "bc -l      "   "1.414"                     sh -c 'echo "sqrt(2)" | bc -l'
output_test "cal        "   "Mo Tu We"                  cal
# chvt
# clear
# cp
output_test "date       "   "2026"                      date
output_test "dc         "   "4"                         sh -c 'echo "2 2 + p" | dc'
output_test "dirname    "   "/tests"                    dirname /tests/selectric-golfball-70.text
output_test "echo       "   "An echo test"              echo "An echo test"
output_test "env        "   "SHELL=/bin/"               env
output_test "expr       "   "4"                         expr 2 + 2
output_test "factor     "   "9: 3 3"                    factor 9
# false
output_test "find       "   "/etc/profile"              find /etc/p*




printf "%s" "$RESULTS" > "$RESULTS_FILE"
printf "SHORK 486 general commands test suite\n"
printf "Passes  $PASSES\n"
printf "Fails   $FAILS\n"
printf "Skips   $SKIPS\n"
printf "Results written to $RESULTS_FILE\n"
