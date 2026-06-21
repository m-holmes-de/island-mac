# Island (macOS)

My reproducible macOS setup — base apps via [Homebrew](https://brew.sh), the
[AeroSpace](https://nikitabobko.github.io/AeroSpace/) tiling window manager, and a
themed terminal environment (Ghostty / tmux / Neovim / Yazi / Starship).

The macOS counterpart to [island](https://github.com/m-holmes-de/island)
(Linux / Hyprland). Minimal, TUI-first, idempotent — safe to re-run `./install.sh`
any time.

## Install

```bash
git clone https://github.com/m-holmes-de/island-mac.git
cd island-mac
./install.sh
```

`install.sh` installs Homebrew (if missing), installs everything in the
[`Brewfile`](Brewfile), deploys default configs to `~/.config/` (never overwriting
your edits), and applies the default theme.

> **Casks need a password.** Apps that install into `/Applications` (Ghostty,
> AeroSpace, Hyperkey) prompt for your macOS password, so install those
> interactively the first time: `brew install --cask ghostty nikitabobko/tap/aerospace hyperkey`.

After install, open a new terminal (for the managed `~/.zshrc`) and grant
**AeroSpace** Accessibility permission on first launch.

## What you get

- **AeroSpace** — i3-style tiling WM (no SIP changes needed), driven by a **Hyper**
  key (Caps Lock → ⌘⌃⌥ via [Hyperkey](https://hyperkey.app/))
- **Ghostty** terminal, **tmux**, **Neovim** (LazyVim), **Yazi**, **Starship**,
  **fzf**, **lazygit**, plus `git`, `gh`, `ripgrep`, `fd`, `eza`, `bat`, `zoxide`
- **Theme system** — switch the whole terminal env (+ wallpaper) with one command
- **`island`** — a gum control-center TUI

See the [`Brewfile`](Brewfile) for the full package list.

## The control center

```
island
```

A gum TUI to manage the setup — switch theme, update apps (`brew update && upgrade
&& cleanup`). Theme-aware (its colors match the active theme).

## Theming

Two themes ship: **rose-pine-moon** (default) and **one-dark-pro**.

```bash
island-theme-select            # fzf picker (also `theme`)
island-theme-set one-dark-pro  # apply directly (add --dark for pure-black bg)
```

Switching re-themes Ghostty, tmux, Neovim (LazyVim colorscheme) and Starship, and
sets the desktop wallpaper. Reload Ghostty with **Cmd+Shift+,** to repaint.
Add a theme by dropping a `themes/<name>/colors.sh` (see
[docs/architecture.md](docs/architecture.md#theme-system)).

## Keybindings

Full reference: [docs/keybindings.md](docs/keybindings.md). Highlights
(**Hyper = Caps Lock = ⌘⌃⌥**):

| Keys | Action |
|------|--------|
| Hyper + H/J/K/L | Focus window (+ Shift to move it) |
| Hyper + S / D | Shrink / grow window |
| Hyper + T / A | Tiling / accordion layout |
| Hyper + M / F | Fullscreen / float toggle |
| Hyper + 1–9 | Switch desktop (+ Shift to send window) |

**tmux** prefix is **Ctrl+Space**. **Ctrl+F** opens `tmux-sessionizer` (fzf project
picker). Every new tmux session auto-opens 4 windows: `claude / server / yazi / term`.

## Commands

| Command | Purpose |
|---------|---------|
| `island` | Control-center TUI |
| `island-theme-set` / `island-theme-select` | Apply / pick a theme |
| `island-update` | `brew update && upgrade && cleanup` |
| `island-pkg-add [--cask] <pkg>` | Install a package + record it in the Brewfile |
| `island-migrate` | Run pending config migrations |
| `island-config-refresh <name>` | Reset a deployed config to the default |
| `island-wallpaper-set <img>` | Set the desktop wallpaper |
| `island-tmux-windows` | Build the standard tmux window layout |
| `tmux-sessionizer` | fzf project-session picker |

## How it works

Configs live in `config/` and deploy to `~/.config/` with `cp -n` (never
overwriting). After that, **every config change goes through a timestamped
migration** in `migrations/` — protecting your live edits. Theme-managed files
(Ghostty, tmux, Neovim, Starship) are regenerated from `templates/` on each theme
switch. Full design: [docs/architecture.md](docs/architecture.md).

## License

MIT
