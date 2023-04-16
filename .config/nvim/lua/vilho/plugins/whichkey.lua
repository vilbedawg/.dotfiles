return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		plugins = { spelling = true },
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register({
			mode = { "n", "v" },
			["]"] = { name = "+next" },
			["["] = { name = "+prev" },
			["<leader>t"] = { name = "+tabs" },
			["<leader>c"] = { name = "+code" },
			["<leader>f"] = { name = "+file/find" },
			["<leader>g"] = { name = "+git" },
			["<leader>q"] = { name = "+quit/session" },
			["<leader>x"] = { name = "+diagnostics" },
			["<leader>s"] = { name = "+search" },
			["<leader>w"] = { name = "+windows" },
			["<leader>b"] = { name = "+buffers" },
			["g"] = { name = "+goto" },
		})
	end,
}
