-- Lua
return {
  "folke/trouble.nvim",
  requires = "nvim-tree/nvim-web-devicons",
  config = function()
    require("trouble").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end,
    vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
      {silent = true, noremap = true, desc = "Toggle Diagnostics"}
    ),
    vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
      {silent = true, noremap = true, desc = "Workspace Diagnostics"}
    ),
    vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
      {silent = true, noremap = true, desc = "Document Diagnostics"}
    ),
    vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
      {silent = true, noremap = true, desc = "Location List"}
    ),
    vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
      {silent = true, noremap = true, desc = "Quickfix List"}
    ),
    vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
      {silent = true, noremap = true, desc = "LSP References List"}
    ),
}
