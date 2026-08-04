#!/usr/bin/env bash

# Install the Typst compiler from the official GitHub release tarballs. There is no
# apt package, and the devcontainer registry features for Typst are third-party, so
# fetching the release binary directly is both simpler and easier to pin.

set -eu

VERSION="${VERSION:-latest}"
INSTALLTYPSTYLE="${INSTALLTYPSTYLE:-true}"

TYPST_REPO=typst/typst
TYPSTYLE_REPO=typstyle-rs/typstyle

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y --no-install-recommends ca-certificates curl tar xz-utils
rm -rf /var/lib/apt/lists/*

case "$(uname -m)" in
    x86_64 | amd64)
        TYPST_TARGET=x86_64-unknown-linux-musl
        TYPSTYLE_TARGET=x86_64-unknown-linux-musl
        ;;
    aarch64 | arm64)
        TYPST_TARGET=aarch64-unknown-linux-musl
        # typstyle publishes no musl build for arm64.
        TYPSTYLE_TARGET=aarch64-unknown-linux-gnu
        ;;
    *)
        echo "typst: ERROR --- unsupported architecture $(uname -m)" >&2
        exit 1
        ;;
esac

resolve_latest() {
    # Buffer the response rather than piping it: `grep -m1` exits on the first match
    # and curl then dies of EPIPE with a confusing "failure writing output" error.
    local body
    body="$(curl -sSfL "https://api.github.com/repos/$1/releases/latest")"
    printf '%s\n' "$body" | grep -m1 '"tag_name"' | sed -E 's/.*"v?([^"]+)".*/\1/'
}

if [ "$VERSION" = "latest" ]; then
    VERSION="$(resolve_latest "$TYPST_REPO")"
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

echo "typst: installing v$VERSION ($TYPST_TARGET)"
curl -sSfL "https://github.com/$TYPST_REPO/releases/download/v${VERSION}/typst-${TYPST_TARGET}.tar.xz" \
    -o "$WORKDIR/typst.tar.xz"
tar -xJf "$WORKDIR/typst.tar.xz" -C "$WORKDIR"
install -m 0755 "$WORKDIR/typst-${TYPST_TARGET}/typst" /usr/local/bin/typst

if [ "$INSTALLTYPSTYLE" = "true" ]; then
    # typstyle's version numbers track Typst's, so try the matching tag first and
    # fall back to whatever the newest release is. The formatter is a convenience,
    # so a failure here must not fail the build.
    fetch_typstyle() {
        curl -sSfL "https://github.com/$TYPSTYLE_REPO/releases/download/$1/typstyle-${TYPSTYLE_TARGET}" \
            -o "$WORKDIR/typstyle" 2>/dev/null \
            && install -m 0755 "$WORKDIR/typstyle" /usr/local/bin/typstyle \
            && echo "typst: installed typstyle $1"
    }
    fetch_typstyle "v$VERSION" || fetch_typstyle "v$(resolve_latest "$TYPSTYLE_REPO")" || true
    [ -x /usr/local/bin/typstyle ] || echo "typst: WARNING --- could not install typstyle" >&2
fi

echo "typst: $(typst --version)"
