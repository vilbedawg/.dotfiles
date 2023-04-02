return {
	"lewis6991/gitsigns.nvim",
	requires = { "nvim-lua/plenary.nvim" },
	config = function()
		local gitsigns = require("gitsigns")
		gitsigns.setup({
			signs = {
				add = {
					hl = "GitSignsAdd",
					numhl = "GitSignsAddNr",
					linehl = "GitSignsAddLn",
				},
				change = {
					hl = "GitSignsChange",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
				delete = {
					hl = "GitSignsDelete",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn",
				},
				topdelete = {
					hl = "GitSignsDelete",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn",
				},
				changedelete = {
					hl = "GitSignsChange",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			keymaps = {}, -- Turn off default keymaps
			watch_gitdir = { interval = 1000, follow_files = true },
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter_opts = { relative_time = false },
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000,
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			yadm = { enable = false },
		})

		-- Gitsigns w/ hunks and blames.
		vim.keymap.set("n", "<leader>ga", gitsigns.stage_hunk, { desc = "Stage Hunk" })
		vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "Blame Line" })
		vim.keymap.set("n", "<leader>gp", gitsigns.prev_hunk, { desc = "Previous Hunk" })
		vim.keymap.set("n", "[g", gitsigns.prev_hunk, { desc = "Previous Hunk" })
		vim.keymap.set("n", "<leader>gn", gitsigns.next_hunk, { desc = "Next Hunk" })
		vim.keymap.set("n", "]g", gitsigns.next_hunk, { desc = "Next Hunk" })
		vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
		vim.keymap.set("n", "<leader>gd", gitsigns.preview_hunk, { desc = "Preview Hunk" })
		vim.keymap.set("n", "<leader>gq", function()
			gitsigns.setqflist("all")
		end, { desc = "Changes Location List" })
	end,
}
