echo "Theming: deploy nvim/tmux/yazi configs, install TPM, apply default theme"

ISLAND_PATH="${ISLAND_PATH:-$HOME/.local/share/island-mac}"

# Deploy the new app configs (no-clobber — never overwrite user changes).
for d in nvim tmux yazi; do
  mkdir -p "$HOME/.config/$d"
  cp -Rn "$ISLAND_PATH/config/$d/." "$HOME/.config/$d/" 2>/dev/null || true
done

# Install TPM (tmux plugin manager) if missing.
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  echo "  Installing tmux plugin manager (tpm)..."
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR" 2>/dev/null || true
fi

# Apply the default theme if the user hasn't chosen one yet. This generates the
# ghostty/tmux/nvim theme files and sets the wallpaper.
if [[ ! -f "$HOME/.local/state/island-mac/current-theme" ]]; then
  "$ISLAND_PATH/bin/island-theme-set" rose-pine-moon || true
fi
