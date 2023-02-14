return {
	{
		"neovim/nvim-lspconfig",
	},

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server",
				"pyright",
			},
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "",
					package_uninstalled = "✗",
				},
			},
		},
	},

	-- language specific extension modules
	{ import = "lazyvim.plugins.extras.lang.typescript" },
	{ import = "lazyvim.plugins.extras.lang.json" },
	-- { import = "plugins.extras.lang.nodejs" },
	{ import = "plugins.extras.lang.csharp" },
	{ import = "plugins.extras.lang.cpp" },
}
