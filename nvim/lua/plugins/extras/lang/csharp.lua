return {
    {
        "neovim/nvim-lspconfig",
    },

    -- add c# to treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "c_sharp" })
        end,
    },

    -- correctly setup mason lsp / dap extensions
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "csharp-language-server", "csharpier", "omnisharp" })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = { "Hoffs/omnisharp-extended-lsp.nvim" },
        opts = {
            servers = {
                omnisharp = {
                    filetypes = { "cs", "csx" },
                    root_dir = function(fname)
                        if fname:sub(-#".csx") == ".csx" then
                            return require("lspconfig").util.path.dirname(fname)
                        end
                        return vim.fn.getcwd()
                    end,
                },
            },
            setup = {
                omnisharp = function(_, opts)
                    opts.handlers = {
                        ["textDocument/definition"] = require("omnisharp_extended").handler,
                    }
                    require("lazyvim.util").on_attach(function(client, _)
                        -- INFO https://github.com/OmniSharp/omnisharp-roslyn/issues/2483
                        if client.name == "omnisharp" then
                            client.server_capabilities.semanticTokensProvider.legend = {
                                tokenModifiers = { "static" },
                                tokenTypes = {
                                    "comment",
                                    "excluded",
                                    "identifier",
                                    "keyword",
                                    "number",
                                    "operator",
                                    "preprocessor",
                                    "string",
                                    "whitespace",
                                    "text",
                                    "static",
                                    "punctuation",
                                    "class",
                                    "delegate",
                                    "enum",
                                    "interface",
                                    "module",
                                    "struct",
                                    "typeParameter",
                                    "field",
                                    "enumMember",
                                    "constant",
                                    "local",
                                    "parameter",
                                    "method",
                                    "property",
                                    "event",
                                    "namespace",
                                    "label",
                                    "xml",
                                    "regexp",
                                },
                            }
                        end
                    end)
                    return false
                end,
            },
        },
    },
}
