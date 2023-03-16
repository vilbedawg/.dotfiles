return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register({
      mode = { "n", "v" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<leader>t"] = { name = "+tabs" },
      ["<leader>c"] = { name = "+code" },
      ["<leader>f"] = { name = "+file/find" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>q"] = { name = "+quit/session" },
      ["<leader>x"] = { name = "+diagnostics" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>w"] = { name = "+windows" },
      ["<leader>b"] = { name = "+buffers" },

      -- LSP + git
      ["g"] = { name = "+goto" },
      ["gd"] = { desc = "Go To Definition"},
      ["gs"] = { desc = "Open Definition In New Split"},
      ["K"] = { desc = "Hover"},
      ["gi"] = { desc = "Go to Implementation"},
      ["gt"] = { desc = "Type Definition"},
      ["<C-k>"] = { desc = "Function Signature"},
      ["<leader>r"] = { desc = "Rename All"},
      ["<leader>lq"] = { desc = "Show Diagnostics"},

      ["<leader>]W"] = { desc = "Next Error"},
      ["<leader>[W"] = { desc = "Previous Error"},
      ["<leader>]w"] = { desc = "Next Warning"},
      ["<leader>[w"] = { desc = "Previous Warning"},
    })
  end,
}
