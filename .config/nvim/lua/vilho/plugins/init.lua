return {
	-- LSP stuff
	{ "neovim/nvim-lspconfig" }, -- Configs for the nvim lsp client
	{ "williamboman/mason.nvim" }, -- LSP server manager
	{ "williamboman/mason-lspconfig.nvim" }, -- Helper for mason
	{ "onsails/lspkind-nvim" }, -- VScode-like pictograms
	{ "nvim-lua/plenary.nvim" }, -- Useful lua functions used by lots of plugins
	{ "lukas-reineke/lsp-format.nvim" }, -- A wrapper around Neovims native LSP formatting
	{ "jose-elias-alvarez/null-ls.nvim" }, -- For formatters and linters
	{ "jayp0521/mason-null-ls.nvim" }, -- For managing formatters and linters

	-- Snippets
	{
		"L3MON4D3/LuaSnip", -- Snippet engine
		dependencies = {
			"rafamadriz/friendly-snippets", -- A bunch of useful snippets
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
	},

	{
		"hrsh7th/nvim-cmp", -- A completion engine
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- cmp-source for neovim's built-in language client
			"hrsh7th/cmp-buffer", -- cmp-source for buffer words
			"hrsh7th/cmp-path", -- cmp-source for filesystem paths
			"saadparwaiz1/cmp_luasnip", --Luasnip source for nvim-cmp
			"hrsh7th/cmp-nvim-lsp-signature-help", -- Display functions signatures
			"onsails/lspkind.nvim", -- Icons for autocompletion
		},
	},

	{ "folke/neodev.nvim" }, -- Neovim setup for init.lua and plugin development
	{ "folke/lsp-colors.nvim" }, -- LSP colors

	{ "tpope/vim-repeat" },
	{ "tpope/vim-surround" },
	{ "tpope/vim-unimpaired" },
	{ "tpope/vim-rhubarb" },

	-- Better commenting
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({})
		end,
	},

	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({})
		end,
	},

	{ "christoomey/vim-tmux-navigator" }, -- For tmux window navigation

	{
		"SmiteshP/nvim-navic",
		dependencies = { "neovim/nvim-lspconfig" },
	},
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({})
    end,
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" }
  }
}
