return {
	{
		"luisiacc/gruvbox-baby",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_baby_backround_color = "dark"
			vim.g.gruvbox_baby_function_style = "NONE"
			vim.g.gruvbox_baby_keyword_style = "italic"
			-- Enable telescope theme
			-- vim.g.gruvbox_baby_telescope_theme = 1
			vim.cmd([[colorscheme gruvbox-baby]])
		end,
	},
}
