return {
    {
        "cdelledonne/vim-cmake",
    },
    {
        "neovim/nvim-lspconfig",
    },
    -- add cpp to treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "cpp" })
        end,
        indent = { enable = false },
    },

    -- correctly setup mason lsp / dap extensions
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "codelldb", "clang-format", "cpptools", "clangd" })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {},
        opts = {
            servers = {
                clangd = {},
            },
        },
    },
}
