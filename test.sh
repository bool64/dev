#!/bin/bash

PWD=$(pwd)

TESTDATA_PATH="$PWD/testdata"
OUTPUT="$PWD/testdata/make.output"
TEST_OUTPUT="make.out"

# tmake is the base command to run make
# Every timme the command runs, it runs in a new shell with the local env
# avoiding to use the env from the upstream runner
tmake="make"


strip_output() {
    # Regular expression to match both error message formats and extract "Error 1"
    error_pattern='make(\\[[0-9]+\\])?:.*Error 1'

    cat "$TEST_OUTPUT" | \
        grep -v 'Entering directory' | \
        grep -v 'Leaving directory' | \
        grep -v 'awk: warning: command line argument .* is a directory: skipped' | \
        awk -v pattern="$error_pattern" '{ while (match($0, pattern)) { $0 = substr($0, 1, RSTART-1) "Error 1" substr($0, RSTART+RLENGTH); } } 1' \
        > "$TEST_OUTPUT.tmp" && mv "$TEST_OUTPUT.tmp" "$TEST_OUTPUT"
}

check_output() {
#    cat "$1" > "$2"
    # Checking the output
    diff "$1" "$2"
    if [ $? -ne 0 ]; then
      if [ -n "$TEST_FILE" ]; then
        echo "Error in $TEST_FILE:${BASH_LINENO[0]}: make output is not the same"
      fi
      exit 1
    fi
}

# Record the start time
start_time=$(date +%s)

# Running test
printf "Test make -> "
cd "$TESTDATA_PATH" && PWD="$TESTDATA_PATH"
$tmake > "$TEST_OUTPUT" 2>/dev/null
if [ $? -ne 0 ]; then
      echo "make failed"
      exit 1
fi

# Removing the lines that are not part of the output but are appended by github actions
strip_output
# Checking the output
check_output "$TEST_OUTPUT" "$OUTPUT"

# Record the end time
end_time=$(date +%s.%N)

# Calculate the elapsed time with two decimal places
elapsed_time=$(echo "$end_time - $start_time" | bc -l | xargs printf "%.2f\n")

echo "[OK] ${elapsed_time}s"