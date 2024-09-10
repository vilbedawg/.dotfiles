return {
	"folke/lsp-colors.nvim",
	config = function()
		local colors = require("lsp-colors")

		colors.setup({
			Error = "#db4b4b",
			Warning = "#e0af68",
			Information = "#10bbbb",
			Hint = "#906fbb",
		})
	end,
}
