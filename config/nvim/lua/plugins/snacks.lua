return {
  "folke/snacks.nvim",
  opts = {
    -- Enable GitHub integration
    gh = {},
    picker = {
      sources = {
        explorer = {
          hidden = true,
        },
        files = {
          hidden = true,
        },
      },
    },
  },
  keys = {
    -- Swap ff and fF behavior (cwd first, root second)
    { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },

    -- Custom: space space for buffer list
    { "<leader><leader>", false }, -- Disable default if it exists
    {
      "<leader><leader>",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },

    -- GitHub integration keybindings
    {
      "<leader>gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>gI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>gP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },
  },
}
