# Install base packages from the Brewfile (idempotent — brew bundle skips installed)
echo "Installing base packages from Brewfile..."
brew bundle --file="$ISLAND_PATH/Brewfile"
