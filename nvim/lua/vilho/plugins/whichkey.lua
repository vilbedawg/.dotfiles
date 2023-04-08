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
			["<leader>c"] = { name = "+code action" },
			["<leader>f"] = { name = "+file/find" },
			["<leader>g"] = { name = "+git" },
			["<leader>q"] = { name = "+quit/session" },
			["<leader>x"] = { name = "+diagnostics" },
			["<leader>s"] = { name = "+search" },
			["<leader>w"] = { name = "+windows" },
			["<leader>b"] = { name = "+buffers" },

			-- LSP + git
			["g"] = { name = "+goto" },
			["gd"] = { desc = "Go to definition" },
			["gD"] = { desc = "Go to type definition" },
			["gi"] = { desc = "Go to Implementation" },
			["gr"] = { desc = "Find references" },
			["<leader>n"] = { desc = "Rename symbol" },
			["<leader>k"] = { desc = "Signature help" },
			["<leader>l"] = { desc = "Show line diagnostics" },
			["K"] = { desc = "Show hover information" },
			["<leader>[d"] = { desc = "Go to previous diagnostic" },
			["<leader>]d"] = { desc = "Go to next diagnostic" },
		})
	end,
}
