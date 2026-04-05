local languages = {
    { ts = "lua",            lsp = "lua_ls" },
    { ts = "python" },
    { ts = "typescript",     lsp = "ts_ls" },
    { ts = "tsx" },
    { ts = "javascript" },
    { ts = "jsdoc" },
    { ts = "c",              lsp = "clangd" },
    { ts = "cpp" },
    { ts = "c_sharp",        lsp = "roslyn" },
    { ts = "json",           lsp = "jsonls" },
    { ts = "yaml",           lsp = "yamlls" },
    { ts = "html" },
    { ts = "css" },
    { ts = "bash" },
    { ts = "markdown" },
    { ts = "markdown_inline" },
    { ts = "vim" },
    { ts = "vimdoc" },
    { ts = "query" },
    { ts = "diff" },
    { ts = "comment" },
    { ts = "editorconfig" },
    { ts = "git_config" },
    { ts = "git_rebase" },
    { ts = "gitattributes" },
    { ts = "gitcommit" },
    { ts = "gitignore" },
    { ts = "toml" },
    { ts = "dockerfile" },
    { ts = "make" },
    { ts = "cmake" },
    { ts = "luadoc" },
    { lsp = "tinymist" },
    { lsp = "eslint_d" },
}

local ts_parsers = {}
local lsp_servers = {}
for _, lang in ipairs(languages) do
    if lang.ts then table.insert(ts_parsers, lang.ts) end
    if lang.lsp then table.insert(lsp_servers, lang.lsp) end
end

vim.pack.add({
    { src = "https://github.com/vague-theme/vague.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/seblyng/roslyn.nvim" },
})

require("vague").setup({ transparent = false })
vim.cmd.colorscheme("vague")

vim.lsp.enable(lsp_servers)

vim.api.nvim_create_user_command("Mason", function(opts)
    vim.pack.add({ { src = "https://github.com/mason-org/mason.nvim" } })
    require("mason").setup({
        registries = {
            "github:Crashdummyy/mason-registry", -- for Roslyn
            "github:mason-org/mason-registry",
        },
    })
    vim.cmd("Mason " .. opts.args)
end, { nargs = "*" })

vim.schedule(function()
    vim.pack.add({
        { src = "https://github.com/stevearc/oil.nvim" },
        { src = "https://github.com/ibhagwan/fzf-lua" },
        { src = "https://github.com/nvim-tree/nvim-web-devicons" },
        { src = "https://github.com/tpope/vim-surround" },
        { src = "https://github.com/tpope/vim-fugitive" },
        { src = "https://github.com/christoomey/vim-tmux-navigator" },
    })

    require("oil").setup()

    require("nvim-treesitter").install(ts_parsers)

    local actions = require("fzf-lua.actions")
    require("fzf-lua").setup({
        winopts = { backdrop = 85 },
        keymap = {
            builtin = {
                ["<C-f>"] = "preview-page-down",
                ["<C-b>"] = "preview-page-up",
                ["<C-p>"] = "toggle-preview",
            },
            fzf = {
                ["ctrl-a"] = "toggle-all",
                ["ctrl-t"] = "first",
                ["ctrl-g"] = "last",
                ["ctrl-d"] = "half-page-down",
                ["ctrl-u"] = "half-page-up",
            },
        },
        actions = {
            files = {
                ["ctrl-q"] = actions.file_sel_to_qf,
                ["ctrl-n"] = actions.toggle_ignore,
                ["ctrl-h"] = actions.toggle_hidden,
                ["enter"] = actions.file_edit_or_qf,
            },
        },
    })
end)

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    once = true,
    callback = function()
        vim.pack.add({
            { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
            { src = "https://github.com/L3MON4D3/LuaSnip" },
            { src = "https://github.com/rafamadriz/friendly-snippets" },
        })

        require("luasnip.loaders.from_vscode").lazy_load()

        require("blink.cmp").setup({
            fuzzy = { implementation = "prefer_rust_with_warning" },
            signature = { enabled = true },
            keymap = {
                preset = "default",
                ["<C-space>"] = {},
                ["<C-p>"] = {},
                ["<Tab>"] = {},
                ["<S-Tab>"] = {},
                ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-b>"] = { "scroll_documentation_down", "fallback" },
                ["<C-f>"] = { "scroll_documentation_up", "fallback" },
                ["<C-l>"] = { "snippet_forward", "fallback" },
                ["<C-h>"] = { "snippet_backward", "fallback" },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "normal",
            },
            completion = {
                menu = {
                    border = nil,
                    scrolloff = 1,
                    scrollbar = false,
                    draw = {
                        columns = {
                            { "kind_icon" },
                            { "label",      "label_description", gap = 1 },
                            { "kind" },
                            { "source_name" },
                        },
                    },
                },
                documentation = {
                    window = {
                        border = nil,
                        scrollbar = false,
                        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
                    },
                    auto_show = true,
                    auto_show_delay_ms = 500,
                },
            },
            cmdline = {
                keymap = {
                    preset = "inherit",
                    ["<CR>"] = { "accept_and_enter", "fallback" },
                },
            },
            snippets = {
                preset = "luasnip",
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    cmdline = {
                        min_keyword_length = 2,
                    },
                },
            },
        })
    end,
})

-- typst-preview: only needed for typst files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "typst",
    once = true,
    callback = function()
        vim.pack.add({ { src = "https://github.com/chomosuke/typst-preview.nvim" } })
    end,
})
