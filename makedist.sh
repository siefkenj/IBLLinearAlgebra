#!/bin/bash

cd book || exit 1

# Make version of the book.
#
# Every document gets its own output directory. The extra indexes are declared
# with fixed names (definitions.idx, symbols.idx) rather than per-jobname ones,
# so building them all in one directory makes the parallel jobs clobber each
# other's index files and makeindex never converges.
latexmk -lualatex -outdir=build/linearalgebra -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" linearalgebra &
PID_STANDARD=$!
latexmk -lualatex -outdir=build/linearalgebra-book -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" linearalgebra-book &
PID_BOOK=$!
latexmk -lualatex -outdir=build/linearalgebra-solutions -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" linearalgebra-solutions &
PID_SOLUTIONS=$!
latexmk -lualatex -outdir=build/linearalgebra-instructor -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" linearalgebra-instructor &
PID_INSTRUCTOR=$!
latexmk -lualatex -outdir=build/linearalgebra-slides -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" linearalgebra-slides &
PID_SLIDES=$!

# We process all the latex files in parallel and wait for them to finish.
# A failure of any one of them has to show up in our exit status, otherwise a
# broken build looks like a successful one.
STATUS=0
wait $PID_STANDARD   || { echo "ERROR: linearalgebra.pdf failed to build" >&2; STATUS=1; }
wait $PID_BOOK       || { echo "ERROR: linearalgebra-book.pdf failed to build" >&2; STATUS=1; }
wait $PID_SOLUTIONS  || { echo "ERROR: linearalgebra-solutions.pdf failed to build" >&2; STATUS=1; }
wait $PID_INSTRUCTOR || { echo "ERROR: linearalgebra-instructor.pdf failed to build" >&2; STATUS=1; }
wait $PID_SLIDES     || { echo "ERROR: linearalgebra-slides.pdf failed to build" >&2; STATUS=1; }

cp build/linearalgebra/linearalgebra.pdf ../dist/                       || STATUS=1
cp build/linearalgebra-book/linearalgebra-book.pdf ../dist/             || STATUS=1
cp build/linearalgebra-solutions/linearalgebra-solutions.pdf ../dist/   || STATUS=1
cp build/linearalgebra-instructor/linearalgebra-instructor.pdf ../dist/ || STATUS=1
cp build/linearalgebra-slides/linearalgebra-slides.pdf ../dist/         || STATUS=1

exit $STATUS
