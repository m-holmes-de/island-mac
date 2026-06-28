# Keybindings

## AeroSpace (window manager)

**Hyper = Caps Lock = ⌘⌃⌥** (via the Hyperkey app). Defined in
`config/aerospace/aerospace.toml`.

| Keys | Action |
|------|--------|
| Hyper + H / J / K / L | Focus left / down / up / right |
| Hyper + Shift + H / J / K / L | Move window left / down / up / right |
| Hyper + S / D | Shrink / grow window |
| Hyper + T | Tiling layout |
| Hyper + A | Accordion layout |
| Hyper + M | Maximize → monocle mode (un-maximize with Hyper + M) |
| Hyper + F | Toggle floating / tiling |
| Hyper + 1–9, 0 | Switch to desktop 1–10 (0 = workspace 10) |
| Hyper + Shift + 1–9, 0 | Move window to desktop 1–10 |
| Hyper + Tab | Previous desktop (back-and-forth) |
| Hyper + Shift + Tab | Move workspace to next monitor |
| Hyper + ; | Enter service mode (key is `ö` on a DE keyboard) |

**Service mode** (after Hyper + ;):

| Key | Action |
|-----|--------|
| Esc | Reload config & exit |
| R | Flatten / reset the layout |
| Backspace | Close all windows but the focused one |
| Hyper + Shift + H/J/K/L | Join window with neighbor (build splits) |

**Monocle mode** (after Hyper + M maximizes a window):

| Key | Action |
|-----|--------|
| Hyper + H/J/K/L | Flip to the neighbouring window, keeping it maximized |
| Hyper + M | Un-maximize and return to tiling |

> While maximized you stay in monocle mode; unbound keys pass through, so you can
> keep typing in the window (Esc is **not** captured). Press Hyper + M to leave.

> The Hyper key is the full ⌘⌃⌥ chord, so plain `Option+key` (e.g. `Option+L` = `@`
> on a German layout) is unaffected. Keybindings are QWERTZ-aware (Z/Y swapped).

## tmux

Prefix is **Ctrl+Space** (with **Ctrl+b** as a fallback). Defined in
`config/tmux/tmux.conf`. `<prefix>` below means press the prefix, release, then the key.

| Keys | Action |
|------|--------|
| `<prefix>` - | Split pane vertical |
| `<prefix>` v | Split pane horizontal |
| `<prefix>` x | Kill pane |
| `<prefix>` h | Enter copy mode (scrollback) |
| `<prefix>` c / k / r | New / kill / rename window |
| `<prefix>` C / K / R | New / kill / rename session |
| `<prefix>` q | Reload tmux config |
| Ctrl+Opt+arrows | Move between panes |
| Ctrl+Opt+Shift+arrows | Resize the focused pane |
| Alt + 1–9 | Select window 1–9 |
| Alt + ←/→ | Previous / next window |
| Alt + Shift + ←/→ | Move window left / right |
| Alt + ↑/↓ | Previous / next session |

**Standard windows:** every new session auto-opens four windows —
`claude / server / yazi / term` (yazi auto-starts in its window). See
`bin/island-tmux-windows`.

## Shell (zsh)

| Keys | Action |
|------|--------|
| Ctrl+F | `tmux-sessionizer` — fzf project-session picker |
| Ctrl+R | fzf history search |
| `theme` | Launch the theme picker (`island-theme-select`) |
| `island` | Launch the control-center TUI |

The shell uses vi mode (`bindkey -v`).
