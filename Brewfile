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
brew "neovim"    # editor (LazyVim distro, configured in config/nvim)
brew "tmux"      # terminal multiplexer (theme-managed)
brew "yazi"      # TUI file manager (Rose Pine themed)
brew "fzf"       # fuzzy finder (theme picker + LazyVim)
brew "ripgrep"   # fast grep (LazyVim dependency)
brew "fd"        # fast find (LazyVim dependency)
brew "lazygit"   # git TUI (used from nvim)
brew "starship"  # shell prompt
brew "zoxide"    # smarter cd
brew "eza"       # ls replacement (used in .zshrc aliases)
brew "bat"       # cat replacement (used in .zshrc aliases)
brew "gum"       # TUI toolkit (powers the `island` control center)
brew "chafa"     # terminal image renderer (wallpaper preview in the picker)

# --- Taps ---
tap "nikitabobko/tap"   # AeroSpace window manager

# --- GUI apps (casks) ---
# Casks that install into /Applications may prompt for your password.
cask "ghostty"
cask "aerospace"        # tiling window manager (i3-like, no SIP changes needed)
cask "hyperkey"         # Caps Lock -> Hyper (Cmd+Ctrl+Alt); modifier for AeroSpace

# --- Fonts ---
cask "font-jetbrains-mono-nerd-font"   # used by ghostty, tmux, yazi, nvim
