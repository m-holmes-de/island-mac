-- Rose Pine colorscheme (available for island-theme-set)
return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = true,
  config = function()
    require("rose-pine").setup({
      variant = "main",
      styles = { transparency = true },
    })
  end,
}
