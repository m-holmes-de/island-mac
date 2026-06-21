# Island-mac Architecture

## Overview

Island-mac is a base macOS setup system: it installs apps via Homebrew and deploys
their configs. It reuses the migration-based, idempotent install architecture of the
Linux `island` repo, adapted for macOS (Homebrew instead of pacman, no sudo).

## Install Flow

```
install.sh
  -> rsync repo to ~/.local/share/island-mac/
  -> preflight   (assert macOS, ensure Homebrew, brew update)
  -> packaging   (brew bundle --file=Brewfile)
  -> config      (deploy config/ to ~/.config/ via cp -n)
  -> post-install(run pending migrations)
```

## Key Directories

| Path | Purpose |
|------|---------|
| `Brewfile` | Source of truth for installed packages (formulae + casks) |
| `bin/` | CLI tools prefixed `island-` |
| `config/` | Default configs, copied to `~/.config/` |
| `default/` | Home-directory dotfiles (`.zshrc`, …), copied to `$HOME` |
| `install/` | Install phase scripts |
| `migrations/` | Timestamped evolution scripts |
| `docs/` | Documentation |

## Runtime Paths

| Path | Purpose |
|------|---------|
| `~/.local/share/island-mac/` | Installed copy of the repo |
| `~/.local/state/island-mac/migrations/` | Migration state tracking |
| `~/.config/<app>/` | Deployed config (the user's live copy) |

## Packaging — Homebrew

- The `Brewfile` is the single source of truth. `brew bundle` is idempotent.
- `island-pkg-add` installs a package AND records it in the `Brewfile`, so the set of
  installed apps stays reproducible from the repo.
- Homebrew never runs as root. Casks that move an app into `/Applications` may prompt
  for a password and therefore can't be installed non-interactively.

## Config Deployment

Configs are deployed with `cp -n` (no-clobber):
- First install: all defaults are copied to `~/.config/`
- Re-runs: existing user modifications are never overwritten
- To reset a config to default: `island-config-refresh <name>` (interactive, overwrites)

**CRITICAL: After initial deployment, ALL config changes go through migrations.**
The `config/` directory is only for new installs. Never force-copy over `~/.config/`.

## Migration System

Migrations handle evolution over time (config changes, new packages).

- Named `<unix-timestamp>_description.sh` in `migrations/`
- Tracked via empty state files in `~/.local/state/island-mac/migrations/`
- Only pending migrations run; completed ones are skipped
- Failed migrations can be skipped and retried later

### When to create a migration

| Change | What to do |
|--------|-----------|
| Fix a setting in a config | Update `config/` default + migration to patch `~/.config/` |
| Add a package | Add to `Brewfile` (or `island-pkg-add`) — no migration needed |
| Add a config file for a new tool | Add to `config/` (deployed on next install) + migration to copy it |
| Change a default setting | Update `config/` + migration to apply to existing installs |

## Theme system

Targets: Ghostty, tmux, Neovim, Starship, and the desktop wallpaper (no desktop
theming on macOS beyond the wallpaper).

- `themes/<name>/colors.sh` defines a `THEME_*` palette plus app hooks
  (`THEME_GHOSTTY`, `THEME_NVIM_PLUGIN`, `THEME_NVIM_COLORSCHEME`) and an optional
  `wallpapers/` directory.
- `templates/*.tpl` hold `{{THEME_VAR}}` placeholders. `island-theme-set` sources
  the palette and substitutes every `THEME_*` variable into each template:
  - `ghostty-config.tpl`  → `~/.config/ghostty/config`
  - `tmux-theme.conf.tpl` → `~/.config/tmux/theme.conf` (sourced by `tmux.conf`)
  - `starship.toml.tpl`   → `~/.config/starship.toml`
  - rewrites `~/.config/nvim/lua/plugins/island-theme.lua` (LazyVim `colorscheme`)
  - sets the wallpaper from the theme's first `wallpapers/` image
- State is saved in `~/.local/state/island-mac/current-theme`.
- `island-theme-set <name> [--dark]` applies a theme; `island-theme-select` is an
  fzf picker. The `island` TUI also wraps this.
- These theme-managed files are regenerated on every switch, so customise them via
  the templates, not the deployed copies. The Ghostty template intentionally keeps
  `macos-option-as-alt = false`. Yazi is themed statically (Rose Pine), not switched.

### Adding a theme

Add `themes/<name>/colors.sh` (copy an existing one and change the hex values), set
the `THEME_GHOSTTY` / `THEME_NVIM_*` hooks, optionally add `wallpapers/`, then
`island-theme-set <name>`.

## Idempotency

Every operation is safe to re-run:
- `brew bundle` / `brew install` skip installed packages
- `mkdir -p` is safe on existing directories
- `cp -n` never overwrites
- Migrations track their own state
