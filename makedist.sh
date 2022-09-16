#!/bin/bash

cd book
# Make version of the book
latexmk -lualatex -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" linearalgebra &
latexmk -lualatex -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" linearalgebra-book &
latexmk -lualatex -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" linearalgebra-solutions &
latexmk -lualatex -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" linearalgebra-instructor &
latexmk -lualatex -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" linearalgebra-slides &

# We process all the latex files in parallel and wait for them to finish
wait $(jobs -p)

cp linearalgebra*.pdf ../dist/
