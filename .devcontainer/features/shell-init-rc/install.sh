#!/usr/bin/env bash

set -eu

# VS Code's "Auto Attach" debugger injects NODE_OPTIONS (and
# VSCODE_INSPECTOR_OPTIONS) into integrated terminals, pointing --require at a
# bootloader.js inside the ms-vscode.js-debug extension's workspaceStorage. When
# that extension folder is updated or cleaned up, the path goes stale and every
# node/npm invocation in the terminal fails before it starts:
#
#   Error: Cannot find module '.../ms-vscode.js-debug/bootloader.js'
#
# Unsetting these two variables at the top of each shell restores a clean
# environment without disabling the debugger. This feature runs as root at
# build time, so it writes into the *remote* user's home directory.

REMOTE_USER="${_REMOTE_USER:-vscode}"
USER_HOME="${_REMOTE_USER_HOME:-$(getent passwd "$REMOTE_USER" | cut -d: -f6)}"
USER_HOME="${USER_HOME:-/home/$REMOTE_USER}"

MARKER="# shell-init-rc: drop stale VS Code Auto Attach debugger injection"
CLEANUP_LINE="unset NODE_OPTIONS VSCODE_INSPECTOR_OPTIONS"

for rc in .bashrc .zshrc .profile; do
    rc_path="$USER_HOME/$rc"
    [ -f "$rc_path" ] || continue
    if ! grep -qF "$CLEANUP_LINE" "$rc_path"; then
        printf '\n%s\n%s\n' "$MARKER" "$CLEANUP_LINE" >> "$rc_path"
        chown "$REMOTE_USER" "$rc_path" 2>/dev/null || true
    fi
done

echo "shell-init-rc: added NODE_OPTIONS/VSCODE_INSPECTOR_OPTIONS cleanup to shell rc files"
