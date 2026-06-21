# Island-mac — Base macOS setup via Homebrew

## What is this?
Island-mac installs a base set of apps (via Homebrew) and deploys their configs on
macOS. It is the macOS counterpart to `island` (the Linux/Hyprland repo) and reuses
the same migration-based, idempotent install architecture.

## Project structure
- `install.sh` - Entry point, sources install phases in order
- `Brewfile` - Single source of truth for installed packages (formulae + casks)
- `bin/` - CLI tools, all prefixed with `island-`
- `config/` - Default configs, copied to `~/.config/` on install (never overwrites)
- `default/` - Home-directory dotfiles (e.g. `.zshrc`), copied to `$HOME` (never overwrites)
- `install/` - Install phase scripts (preflight, packaging, config, post-install)
- `migrations/` - Timestamped migration scripts for evolving deployed configs
- `themes/` - Theme palettes (`<name>/colors.sh` + optional `wallpapers/`)
- `templates/` - `{{THEME_VAR}}` templates rendered into `~/.config/` on theme switch
- `docs/` - Documentation

## Key paths at runtime
- Install location: `~/.local/share/island-mac/`
- Migration state: `~/.local/state/island-mac/migrations/`
- User configs: `~/.config/<app>/` (e.g. `~/.config/ghostty/`)

## Development commands
- `./install.sh` - Run full install (idempotent, safe to re-run)
- `island-migrate` - Run pending migrations only
- `island-pkg-add <formula>` / `island-pkg-add --cask <app>` - Add a package idempotently
- `island-config-refresh <name>` - Reset a deployed config to the island-mac default

## Coding conventions
- All scripts use `#!/bin/bash` with `set -eEo pipefail` (entry points)
- Scripts under `install/` and `migrations/` may omit shebangs (they are sourced/run via bash)
- Two spaces for indentation, no tabs
- Use `[[ ]]` for string/file tests, `(( ))` for numeric
- Quote variables in double quotes except inside `[[ ]]`
- All `bin/` scripts are prefixed `island-`
- The `Brewfile` is the package manifest — `brew "x"` for formulae, `cask "x"` for GUI apps

## Packaging — Homebrew, no sudo
- Homebrew must NOT run as root; never add `sudo` to install scripts.
- The `Brewfile` is the source of truth. `brew bundle` is idempotent (skips installed).
- `island-pkg-add` both installs AND appends to the `Brewfile` so installs stay reproducible.
- Casks that move apps into `/Applications` may prompt for a password — they can't be
  installed in a non-interactive context (this is why ghostty must be installed interactively).

## CRITICAL: Migration-first rule
Any change to deployed configs (`~/.config/`) MUST go through a migration.
- `config/` holds defaults for NEW installs only (deployed via `cp -n`, never overwrites)
- To update configs on existing installs, create a migration in `migrations/`
- Update `config/` defaults AND create a migration — both are required
- Migrations must be idempotent (safe to run if the change is already applied)
- Never force-copy from `config/` to `~/.config/` — that destroys user customizations
  (the deliberate, interactive exception is `island-config-refresh`)

## Idempotency patterns
- `brew bundle` / `brew install` skip already-installed packages
- `mkdir -p` for directory creation
- `cp -n` / `cp -Rn` for config deployment (no-clobber)
- Migration state files in `~/.local/state/island-mac/migrations/` prevent re-execution

## Theming
Ported from the Linux `island` repo (desktop theming omitted — macOS only does
terminal apps + wallpaper). Targets: **ghostty, tmux, neovim, starship, wallpaper**.

- `themes/<name>/colors.sh` defines a `THEME_*` palette + app hooks
  (`THEME_GHOSTTY`, `THEME_NVIM_PLUGIN`, `THEME_NVIM_COLORSCHEME`).
- `templates/*.tpl` hold `{{THEME_VAR}}` placeholders. `island-theme-set` sources
  the palette, sed-substitutes every `THEME_*` var, and writes:
  - `templates/ghostty-config.tpl` -> `~/.config/ghostty/config`
  - `templates/tmux-theme.conf.tpl` -> `~/.config/tmux/theme.conf` (sourced by tmux.conf)
  - rewrites `~/.config/nvim/lua/plugins/island-theme.lua` (active colorscheme)
  - sets the macOS wallpaper to the theme's first `wallpapers/` image
- State: `~/.local/state/island-mac/current-theme`.
- `island-theme-set <name> [--dark]` applies a theme; `island-theme-select` is an
  fzf picker (pops up inside tmux, like tmux-sessionizer).
- yazi is themed statically (Rose Pine in `config/yazi/`), not switched — matches island.
- The ghostty template MUST keep `macos-option-as-alt = false` (regeneration would
  otherwise drop it and break Option+L = @).
- Themes available: `rose-pine-moon` (default), `one-dark-pro`.

## Testing
Run `./install.sh` on a macOS machine. It is idempotent. Run it twice — the second
run should install nothing new and skip every completed migration.

## Reference
- Linux counterpart and shared design: `../island` (`CLAUDE.md`, `AGENTS.md`)
- Homebrew Bundle: https://github.com/Homebrew/homebrew-bundle
- Ghostty config: https://ghostty.org/docs/config
