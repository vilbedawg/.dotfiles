return {
  "alvarosevilla95/luatab.nvim",
  requires = "kyazdani42/nvim-web-devicons",
  config = function()
    require("luatab").setup({ separator = function() return "" end })
  end
}
