#!/usr/bin/env bash

set -eu

# The first LuaLaTeX run of a document has to build the luaotfload font database,
# which takes a minute or two and looks like a hang. Do it here instead, as the
# developer user, so the cache lands in the user's TEXMFVAR.
echo "Warming the LuaTeX font cache..."
luaotfload-tool --update --quiet || true

# makedist.sh copies the built PDFs here.
mkdir -p dist

echo
echo "Toolchain:"
echo "  $(tex --version | head -1)"
echo "  latexmk $(latexmk -v 2>/dev/null | sed -E 's/.*Version ([0-9.]+).*/\1/')"
echo "  lualatex $(lualatex --version | head -1)"
echo "  $(typst --version)"
echo "  node $(node --version)"
echo
echo "Build the book with:  ./makedist.sh"
echo "Build one PDF with:   cd book && latexmk -lualatex linearalgebra"
