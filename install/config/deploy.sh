# Deploy config files to ~/.config (no-clobber)
echo "Deploying configuration files..."
mkdir -p ~/.config

for dir in "$ISLAND_PATH"/config/*/; do
  [[ -d "$dir" ]] || continue
  dirname=$(basename "$dir")
  mkdir -p ~/.config/"$dirname"
  # cp -Rn: recursive, no-clobber (never overwrite existing)
  cp -Rn "$dir"* ~/.config/"$dirname"/ 2>/dev/null || true
done

# Copy standalone config files
for file in "$ISLAND_PATH"/config/*; do
  [[ -f "$file" ]] || continue
  cp -n "$file" ~/.config/ 2>/dev/null || true
done

echo "Configs deployed to ~/.config/"

# Deploy home-directory dotfiles (.zshrc, etc.)
shopt -s nullglob dotglob
for file in "$ISLAND_PATH"/default/*; do
  [[ -f "$file" ]] || continue
  cp -n "$file" ~/ 2>/dev/null || true
done
shopt -u nullglob dotglob
echo "Home dotfiles deployed."
