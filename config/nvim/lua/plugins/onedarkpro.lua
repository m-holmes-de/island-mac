-- One Dark Pro colorscheme (available for island-theme-set)
return {
  "olimorris/onedarkpro.nvim",
  lazy = true,
  config = function()
    require("onedarkpro").setup({
      options = { transparency = true },
    })
  end,
}
