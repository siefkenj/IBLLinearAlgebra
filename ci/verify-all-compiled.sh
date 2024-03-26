#!/bin/bash

BUILD_DIR=./book-copy
EXIT_CODE=0

for texfile in $BUILD_DIR/linearalgebra*.tex; do
    # Get the base name of the file (without path and extension)
    basefile=$(basename "$texfile" .tex)

    # Check if the corresponding PDF file exists
    if [[ ! -f "./dist/$basefile.pdf" ]]; then
        # If the PDF file does not exist, cat the corresponding log file
        if [[ -f "$BUILD_DIR/$basefile.log" ]]; then
            echo "" >&2
            echo "" >&2
            echo "THERE WAS AN ERROR WHEN BUILDING $basefile.pdf" >&2
            echo "Log file for $basefile:" >&2

            cat "$BUILD_DIR/$basefile.log" >&2
            
            echo "" >&2
            EXIT_CODE=1
        else
            echo "Log file for $basefile does not exist." >&2
            EXIT_CODE=1
        fi
    fi
done

exit $EXIT_CODE
