vim.opt.list = true

return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- char = "│",
    filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
  },
}
