#!/usr/bin/env bash

# Install the current TeX Live from CTAN's tlnet repository.
#
# Ubuntu's texlive packages lag the upstream release by a year or more, and this
# book needs recent versions of several packages (nicematrix in particular --- see
# the note in book/common/preamble.tex). Installing from tlnet gives us the same
# "latest TeX Live + tlmgr" setup the CI image (ci/Dockerfile) uses.

set -eu

SCHEME="${SCHEME:-scheme-small}"
PACKAGES="${PACKAGES:-}"
STYFILES="${STYFILES:-}"

TEXLIVE_ROOT=/usr/local/texlive
REMOTE_USER="${_REMOTE_USER:-vscode}"

export DEBIAN_FRONTEND=noninteractive

echo "texlive: installing OS dependencies"
apt-get update -y
apt-get install -y --no-install-recommends \
    ca-certificates \
    fontconfig \
    libfontconfig1 \
    perl \
    tar \
    wget \
    xz-utils
rm -rf /var/lib/apt/lists/*

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

echo "texlive: downloading the tlnet installer"
# mirror.ctan.org redirects to a nearby mirror; occasionally one is mid-sync, so retry.
wget --tries=5 --retry-connrefused --waitretry=10 -qO "$WORKDIR/install-tl-unx.tar.gz" \
    https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf "$WORKDIR/install-tl-unx.tar.gz" -C "$WORKDIR"
INSTALLER_DIR="$(find "$WORKDIR" -maxdepth 1 -type d -name 'install-tl-*' | head -1)"

# TEXDIR is set to $TEXLIVE_ROOT rather than the default $TEXLIVE_ROOT/<year> so
# that PATH and any tooling stay stable across TeX Live releases.
cat > "$WORKDIR/texlive.profile" <<EOF
selected_scheme $SCHEME
TEXDIR $TEXLIVE_ROOT
TEXMFLOCAL $TEXLIVE_ROOT/texmf-local
TEXMFSYSCONFIG $TEXLIVE_ROOT/texmf-config
TEXMFSYSVAR $TEXLIVE_ROOT/texmf-var
TEXMFCONFIG ~/.texlive/texmf-config
TEXMFVAR ~/.texlive/texmf-var
TEXMFHOME ~/texmf
instopt_adjustpath 0
instopt_letter 1
tlpdbopt_autobackup 0
tlpdbopt_install_docfiles 0
tlpdbopt_install_srcfiles 0
EOF

echo "texlive: installing $SCHEME (this takes a few minutes)"
perl "$INSTALLER_DIR/install-tl" \
    -profile "$WORKDIR/texlive.profile" \
    -repository https://mirror.ctan.org/systems/texlive/tlnet/ \
    -no-interaction

# The binary directory is named after the platform (x86_64-linux, aarch64-linux, ...).
TEXBIN="$(find "$TEXLIVE_ROOT/bin" -mindepth 1 -maxdepth 1 -type d | head -1)"
if [ -z "$TEXBIN" ]; then
    echo "texlive: ERROR --- no binary directory under $TEXLIVE_ROOT/bin" >&2
    exit 1
fi
export PATH="$TEXBIN:$PATH"

# `tlmgr path add` symlinks the binaries into /usr/local/bin, so every shell (and
# every non-login process) picks them up without touching PATH.
mkdir -p /usr/local/bin /usr/local/man /usr/local/info
tlmgr path add

install_packages() {
    # Installing the whole list in one call is much faster, but a single bad name
    # aborts the batch --- so fall back to one-at-a-time and report what failed.
    local pkgs="$1"
    [ -n "$pkgs" ] || return 0
    # shellcheck disable=SC2086
    if tlmgr install $pkgs; then
        return 0
    fi
    echo "texlive: batch install failed; retrying package by package"
    local pkg failed=""
    for pkg in $pkgs; do
        tlmgr install "$pkg" >/dev/null 2>&1 || failed="$failed $pkg"
    done
    if [ -n "$failed" ]; then
        echo "texlive: WARNING --- these packages could not be installed:$failed" >&2
    fi
}

echo "texlive: updating tlmgr and installing requested packages"
tlmgr update --self
install_packages "$(echo "$PACKAGES" | tr ',' ' ')"

# Anything still missing gets resolved from the file name itself. This keeps the
# container working when the sources start loading a package that is not in the
# list above.
missing=""
for sty in $(echo "$STYFILES" | tr ',' ' '); do
    [ -n "$sty" ] || continue
    kpsewhich "$sty" >/dev/null 2>&1 || missing="$missing $sty"
done

if [ -n "$missing" ]; then
    echo "texlive: resolving missing style files:$missing"
    resolved=""
    for sty in $missing; do
        # `tlmgr search --global --file` prints "<package>:" followed by matching paths.
        pkg="$(tlmgr search --global --file "/$sty" 2>/dev/null | grep -E '^[^[:space:]].*:$' | head -1 | sed 's/:$//')"
        if [ -n "$pkg" ]; then
            resolved="$resolved $pkg"
        else
            echo "texlive: WARNING --- no TeX Live package provides $sty" >&2
        fi
    done
    install_packages "$resolved"

    still_missing=""
    for sty in $missing; do
        kpsewhich "$sty" >/dev/null 2>&1 || still_missing="$still_missing $sty"
    done
    [ -z "$still_missing" ] || echo "texlive: WARNING --- still missing:$still_missing" >&2
fi

mktexlsr
fc-cache -f >/dev/null 2>&1 || true

# Make the tree writable by the developer so `tlmgr install <pkg>` works inside the
# container without sudo. This has to come *after* mktexlsr, which recreates the ls-R
# filename databases as root and mode 0444 --- leave them like that and a later
# `tlmgr install` puts files on disk that kpsewhich (and therefore LaTeX) never sees.
chown -R "$REMOTE_USER" "$TEXLIVE_ROOT"
chmod -R u+w "$TEXLIVE_ROOT"

echo "texlive: installed $(tex --version | head -1)"
echo "texlive: latexmk $(latexmk -v 2>/dev/null | head -1)"
