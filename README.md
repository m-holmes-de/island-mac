# Island (macOS)

My base macOS setup — apps installed via [Homebrew](https://brew.sh) and configs
deployed to `~/.config/`. The macOS counterpart to [island](../island) (Linux/Hyprland).

Minimal, reproducible, idempotent. Safe to re-run `./install.sh` at any time.

## Install

```bash
git clone https://github.com/area9/island-mac.git
cd island-mac
./install.sh
```

`install.sh` installs Homebrew (if missing), installs everything in the `Brewfile`,
then deploys default configs to `~/.config/` **without overwriting** anything you've
already customized.

## What you get

- **git**, **gh** (GitHub CLI), **neovim** — base CLI tools
- **Ghostty** terminal, pre-configured (`config/ghostty/`)

See the [`Brewfile`](Brewfile) for the full list.

## Day-to-day

```bash
island-pkg-add ripgrep            # add a CLI tool (records it in the Brewfile)
island-pkg-add --cask rectangle   # add a GUI app
island-migrate                    # apply pending config migrations
brew bundle --file=Brewfile       # reinstall everything from the Brewfile
```

## Architecture

See [docs/architecture.md](docs/architecture.md). The short version:

- `config/` holds **default** configs, deployed once to `~/.config/` with `cp -n`.
- After that, **every config change goes through a migration** in `migrations/` —
  this protects your live customizations. The `config/` defaults are only for fresh
  machines.

## License

MIT
