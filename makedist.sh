#!/bin/bash

cd book || exit 1

DOCS=(
	linearalgebra
	linearalgebra-book
	linearalgebra-solutions
	linearalgebra-instructor
	linearalgebra-slides
)

# Make version of the book.
#
# Every document gets its own output directory. The extra indexes are declared
# with fixed names (definitions.idx, symbols.idx) rather than per-jobname ones,
# so building them all in one directory makes the parallel jobs clobber each
# other's index files and makeindex never converges.
PIDS=()
for doc in "${DOCS[@]}"; do
	latexmk -lualatex -outdir="build/$doc" -latexoption="-interaction nonstopmode -halt-on-error -file-line-error" "$doc" &
	PIDS+=($!)
done

# We process all the latex files in parallel and wait for them to finish.
# A failure of any one of them has to show up in our exit status, otherwise a
# broken build looks like a successful one.
STATUS=0
for i in "${!DOCS[@]}"; do
	if ! wait "${PIDS[$i]}"; then
		echo "ERROR: ${DOCS[$i]}.pdf failed to build" >&2
		STATUS=1
	fi
done

for doc in "${DOCS[@]}"; do
	cp "build/$doc/$doc.pdf" ../dist/ || STATUS=1
done

exit $STATUS
