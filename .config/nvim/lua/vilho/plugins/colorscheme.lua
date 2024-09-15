return {
  "Mofiqul/vscode.nvim",
  opts = {
    italic_comments = true,
    transparent = true,
    disable_nvimtree_bg = true,
    group_overrides = {
      NormalFloat = { bg = "NONE" }, -- transparent background
    },
  },
  init = function()
    vim.o.background = "dark"
    vim.cmd.colorscheme("vscode")
  end,
}
