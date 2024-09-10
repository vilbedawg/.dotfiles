return {
	-- Utilities
	{
		"nvim-lua/plenary.nvim",
	},
	-- Schemas
	{ "b0o/schemastore.nvim" },
	-- Buffer Delete
	{
		"moll/vim-bbye",
		cmd = { "Bdelete", "Bwipeout" },
	},

	{
		"nvim-tree/nvim-web-devicons",
	},

  -- Tmux navigation
  {
    "christoomey/vim-tmux-navigator",
  },

	{ "tpope/vim-repeat" },
	{ "tpope/vim-surround" },
	{ "tpope/vim-unimpaired" },
	{ "tpope/vim-rhubarb" },
	{
		"tpope/vim-fugitive",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Add Luarocks support for lazy.nvim
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
}
