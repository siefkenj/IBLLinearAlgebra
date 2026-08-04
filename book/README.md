Developing the Book
===================

*IBLLinearAlgebra* is developed using the `workbook` document class. This document
class allows one to create environments with different colored "banners" that
run along the side of the text.

The main entry point for the book is `linearalgebra.tex`. This file contains/links to all
the content.

Multiple Versions
-----------------

The files `linearalgebra-book.tex`, etc., are all symbolic links to `linearalgebra.tex`.
When `latex` is run, the file name is parsed and options are set depending on whether `book`,
`instructor`, `solutions`, or nothing is detected. In this way, there is only *one source of truth*
for the book even though multiple versions can be created.

Compiling
---------

It is recommended you compile the book with `lualatex`, though `xelatex` should work (but the colors
will be off because of a lack of support for the `pdfx` package).

You can compile the book by running

```
lualatex linearalgebra-book.tex
```

On the command line. You'll need to compile several times to get the index and references correct. Alternatively, you can run

```
latexmk -lualatex linearalgebra-book.tex
```

which will recompile as many times as necessary to produce a finished output.

Development
-----------

If you're developing content, it's a pain to recompile the whole book to see a change.
In the `draft` folder is a small example document. To develop content, do

```
cd draft
cp draft.tex myexamplecontent.tex
lualatex myexamplecontent.tex
```

If you plan to make a *pull request* featuring new content, make sure you work on a *copy* of `draft.tex`
rather than `draft.tex` itself (since `draft.tex` is monitored by `git` for changes).
