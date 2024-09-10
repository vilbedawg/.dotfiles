return {
	"SmiteshP/nvim-navic",
	dependencies = { "neovim/nvim-lspconfig" },
	config = function()
		local navic = require("nvim-navic")

		navic.setup({
			icons = {
				File = " ",
				Module = " ",
				Namespace = " ",
				Package = " ",
				Class = " ",
				Method = " ",
				Property = " ",
				Field = " ",
				Constructor = " ",
				Enum = "練",
				Interface = "練",
				Function = " ",
				Variable = " ",
				Constant = " ",
				String = " ",
				Number = " ",
				Boolean = "◩ ",
				Array = " ",
				Object = " ",
				Key = " ",
				Null = "ﳠ ",
				EnumMember = " ",
				Struct = " ",
				Event = " ",
				Operator = " ",
				TypeParameter = " ",
			},
			lsp = {
				auto_attach = false,
				preference = nil,
			},
			highlight = true,
			separator = " > ",
			depth_limit = 0,
			depth_limit_indicator = "..",
			safe_output = true,
		})
	end,
}
