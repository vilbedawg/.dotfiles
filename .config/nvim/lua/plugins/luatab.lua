return {
  "alvarosevilla95/luatab.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 1000,
  config = function()
    require("luatab").setup({
      separator = function()
        return ""
      end,
    })
  end,
}
