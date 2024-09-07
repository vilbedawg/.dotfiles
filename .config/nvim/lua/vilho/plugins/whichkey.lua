return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    defaults = {},
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>t", group = "tabs" },
        { "<leader>w", group = "windows" },
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "git hunks" },
        { "<leader>s", group = "search" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader>nh", group = "clear highlights" },
        { "<leader>q",  group = "session" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        -- { "z", group = "fold" },
      }
    },
    preset = "modern",
    icons = {
      mappings = false
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end,
}
