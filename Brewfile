# Brewfile — base apps installed via `brew bundle`.
# This is the single source of truth for what island-mac installs.
# Docs: https://github.com/Homebrew/homebrew-bundle
#
# Install everything:   brew bundle --file=Brewfile   (or ./install.sh)
# Add a CLI tool:       island-pkg-add <name>          (or: brew "<name>" here)
# Add a GUI app:        island-pkg-add --cask <name>   (or: cask "<name>" here)

# --- CLI tools (formulae) ---
brew "git"
brew "gh"        # GitHub CLI
brew "neovim"

# --- Taps ---
tap "nikitabobko/tap"   # AeroSpace window manager

# --- GUI apps (casks) ---
# Casks that install into /Applications may prompt for your password.
cask "ghostty"
cask "aerospace"        # tiling window manager (i3-like, no SIP changes needed)
cask "hyperkey"         # Caps Lock -> Hyper (Cmd+Ctrl+Alt); modifier for AeroSpace
