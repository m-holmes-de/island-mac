return {
  "isakbm/gitgraph.nvim",
  dependencies = { "sindrets/diffview.nvim" },
  opts = {
    symbols = {
      merge_commit = "",
      commit = "",
    },
    format = {
      timestamp = "%H:%M:%S %d-%m-%Y",
      fields = { "hash", "timestamp", "author", "branch_name", "tag" },
    },
  },
  keys = {
    {
      "<leader>ll",
      function()
        require("gitgraph").draw({}, { all = true, max_count = 5000 })
      end,
      desc = "GitGraph - Draw",
    },
  },
}
