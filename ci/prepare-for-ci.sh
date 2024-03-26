#/bin/bash

rm -rf book-copy

# make a copy of all essential files
rsync -rlv --include='*/' --include='*.tex' --include='*.sty' --include='*.png' --include='*.jpg' --include='*.svg' --include="*.cls" --include="images/*" --exclude='*' ../book/ ./book-copy/
