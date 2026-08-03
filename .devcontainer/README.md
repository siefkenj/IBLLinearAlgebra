# Dev Container

A development container that can compile the LaTeX sources in `book/` (and the Typst
sources that will live in this repo) without installing anything on the host.

## What's inside

| Tool                | Where it comes from                                                             |
| ------------------- | ------------------------------------------------------------------------------- |
| TeX Live (current)  | `features/texlive` — installed from CTAN's tlnet, so it's the latest release     |
| `latexmk`, `lualatex` | part of the TeX Live install                                                   |
| Typst + `typstyle`  | `features/typst` — official GitHub release binaries, pinned in `devcontainer.json` |
| Node LTS            | `ghcr.io/devcontainers/features/node`, for `html-conversion/`, `slide-conversion/` and the PreTeXt conversion script |
| Ghostscript, poppler-utils, Inkscape, rsync, unzip | `apt-packages` feature                          |

VS Code gets LaTeX Workshop, tinymist (Typst), and Code Spell Checker.

## Usage

Open the repository in VS Code and choose **Reopen in Container**, or from the CLI:

```bash
npm install -g @devcontainers/cli
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . ./makedist.sh
```

Inside the container:

```bash
./makedist.sh                                   # build all five PDFs into dist/
cd book && latexmk -lualatex linearalgebra      # build just one
typst compile some-file.typ                     # Typst
```

The first build is slow: LuaLaTeX has to load a lot of fonts and the book is long.
`postCreateCommand.sh` pre-builds the luaotfload font cache to take the worst of
that out of the first compile.

## Adding LaTeX packages

TeX Live lives in `/usr/local/texlive` and is owned by the container user, so you can
just run

```bash
tlmgr install <package>
```

To make the change permanent, add the package to the `packages` option of the
`texlive` feature in `devcontainer.json` (or, if you only know the file name, add the
`.sty` to `styFiles` — the feature resolves it to a package with
`tlmgr search --global --file` at build time).

## Relationship to CI

`ci/Dockerfile` builds the image used by `.github/workflows/on-pull-request.yml`. It's
a separate, smaller image (`ghcr.io/xu-cheng/texlive-small` plus `tlmgr install`)
whose only job is running `makedist.sh`. The dev container is the interactive
counterpart: same current TeX Live and the same package set, plus the editor tooling,
Node, and Typst. If you add a LaTeX package here, add it to `ci/Dockerfile` too.
