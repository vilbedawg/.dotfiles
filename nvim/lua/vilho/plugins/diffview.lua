return {
  "sindrets/diffview.nvim",
  requires = "nvim-lua/plenary.nvim",
  config = function()
    require("diffview").setup({})
  end
}
