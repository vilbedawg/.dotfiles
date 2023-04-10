return {
	"alvarosevilla95/luatab.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("luatab").setup({
			separator = function()
				return ""
			end,
		})
	end,
}
