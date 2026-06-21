-- Active colorscheme (managed by island-theme-set, do not edit manually)
-- Set via LazyVim's colorscheme opt so LazyVim applies it at the right time
-- (a plain vim.cmd("colorscheme ...") loses the race with LazyVim's default).
return {
  { "rose-pine/neovim", lazy = false, priority = 1000 },
  { "LazyVim/LazyVim", opts = { colorscheme = "rose-pine-main" } },
}
