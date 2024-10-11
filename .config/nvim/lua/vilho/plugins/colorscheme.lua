return {
  -- Colorscheme
  "ellisonleao/gruvbox.nvim",
  config = function()
    require("gruvbox").setup({
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = false,
        operators = false,
        comments = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {
        SignColumn = { bg = "NONE" },
      },
      dim_inactive = false,
      transparent_mode = false,
    })
    vim.cmd("colorscheme gruvbox")
    vim.cmd("hi! GruvboxYellowSign guibg=NONE ")
    vim.cmd("hi! GruvboxPurpleSign guibg=NONE ")
    vim.cmd("hi! GruvboxOrangeSign guibg=NONE ")
    vim.cmd("hi! GruvboxGreenSign guibg=NONE ")
    vim.cmd("hi! GruvboxBlueSign guibg=NONE ")
    vim.cmd("hi! GruvboxAquaSign guibg=NONE ")
    vim.cmd("hi! GruvboxRedSign guibg=NONE ")
  end,
}
