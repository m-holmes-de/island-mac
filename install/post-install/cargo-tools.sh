# Install cargo-based tools that have no Homebrew formula. Non-fatal by design:
# a slow or failing build here must never abort the install (always exits 0).
#
# ai-usagebar — the Claude usage TUI (island-tokens launches it). No macOS prebuilt
# exists, so it compiles from source; `rust` in the Brewfile provides cargo.

if command -v ai-usagebar-tui >/dev/null 2>&1 || [[ -x "$HOME/.cargo/bin/ai-usagebar-tui" ]]; then
  echo "  ai-usagebar already installed"
  exit 0
fi

if ! command -v cargo >/dev/null 2>&1; then
  echo "  cargo not found — skipping ai-usagebar (install rust, then: cargo install ai-usagebar)"
  exit 0
fi

echo "  Building ai-usagebar (cargo install — first build takes a few minutes)…"
if cargo install ai-usagebar; then
  echo "  ai-usagebar installed to ~/.cargo/bin (open the TUI with: island-tokens)"
else
  echo "  ai-usagebar build failed — run 'cargo install ai-usagebar' manually later"
fi

exit 0
