#!/bin/bash
set -eEo pipefail

# Island paths
export ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"
export ISLAND_INSTALL="$ISLAND_PATH/install"
export ISLAND_LOG_FILE="${ISLAND_LOG_FILE:-/tmp/island-mac-install.log}"
export PATH="$ISLAND_PATH/bin:$PATH"

# Sync repo to install location if running from git checkout
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$SCRIPT_DIR" != "$ISLAND_PATH" ]]; then
  # Safety: `rsync --delete` removes anything at the destination not in the repo.
  # Refuse if ISLAND_PATH points at a non-empty dir that isn't already an
  # island-mac checkout (guards against a typo'd/overridden ISLAND_PATH).
  if [[ -d "$ISLAND_PATH" && -n "$(ls -A "$ISLAND_PATH" 2>/dev/null)" && ! -f "$ISLAND_PATH/install.sh" ]]; then
    echo "Refusing to sync into '$ISLAND_PATH': not empty and not an island-mac checkout." >&2
    echo "Point ISLAND_PATH at an empty directory or the existing install location." >&2
    exit 1
  fi
  mkdir -p "$ISLAND_PATH"
  rsync -a --delete --exclude='.git' "$SCRIPT_DIR/" "$ISLAND_PATH/"
fi

# Run install phases
source "$ISLAND_INSTALL/helpers/all.sh"

island_header
echo "  Installing Island base apps for macOS..."

# No sudo: Homebrew installs into a user-writable prefix and must not run as root.

source "$ISLAND_INSTALL/preflight/all.sh"
source "$ISLAND_INSTALL/packaging/all.sh"
source "$ISLAND_INSTALL/config/all.sh"
source "$ISLAND_INSTALL/post-install/all.sh"
