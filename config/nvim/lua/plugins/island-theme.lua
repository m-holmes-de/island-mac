-- Active colorscheme (managed by island-theme-set, do not edit manually)
return {
  "rose-pine/neovim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme rose-pine-main")
  end,
}
