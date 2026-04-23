vim.pack.add({
    { src = "https://github.com/vague-theme/vague.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/seblyng/roslyn.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/tpope/vim-surround" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/christoomey/vim-tmux-navigator" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("mason").setup({
    registries = {
        "github:Crashdummyy/mason-registry", -- for Roslyn
        "github:mason-org/mason-registry",
    },
})

require("vague").setup({ transparent = false })
vim.cmd.colorscheme("vague")

require("oil").setup()

require("nvim-treesitter").install({
    "lua", "python", "typescript",
    "tsx", "javascript", "c",
    "cpp", "c_sharp", "json",
    "yaml", "rust", "html",
    "css", "bash", "markdown",
    "markdown_inline", "vim", "vimdoc",
    "toml", "dockerfile", "cmake",
})

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

require("gitsigns").setup({
    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
            else
                gitsigns.nav_hunk("next")
            end
        end, { desc = "next hunk" })

        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
            else
                gitsigns.nav_hunk("prev")
            end
        end, { desc = "prev hunk" })

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "reset hunk" })

        map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "stage selection" })

        map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "reset selection" })

        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "stage buffer" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "reset buffer" })

        map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
        end, { desc = "blame line" })

        map("n", "<leader>hd", gitsigns.diffthis, { desc = "diff this" })

        map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
        end, { desc = "diff file" })

        map("n", "<leader>hQ", function()
            gitsigns.setqflist("all")
        end, { desc = "send all to qf list" })
        map("n", "<leader>hq", gitsigns.setqflist, { desc = "send to qf list" })
    end,
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

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach-config", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end

        local bufnr = args.buf
        local keymap = vim.keymap.set

        local opts = { silent = true, buffer = bufnr, }

        local function fzf_vertical(command)
            return function()
                require("fzf-lua")[command]({
                    winopts = { preview = { layout = "vertical" } },
                })
            end
        end

        -- Native nvim keymaps
        keymap({ "n", "v" }, "<leader>F", vim.lsp.buf.format, opts)                                   -- Format
        keymap("n", "gd", vim.lsp.buf.definition, opts)                                               -- Go to definition
        keymap("n", "gt", vim.lsp.buf.type_definition, opts)                                          -- Go to type def
        keymap("n", "gr", vim.lsp.buf.references, opts)                                               -- Go to type def
        keymap("n", "gi", vim.lsp.buf.implementation, opts)                                           -- Go to implementation
        keymap("n", "gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)                     -- Go to definition in split
        keymap("n", "<leader>r", vim.lsp.buf.rename, opts)                                            -- Rename
        keymap("n", "K", vim.lsp.buf.hover, opts)                                                     -- Hover doc
        keymap("n", "<leader>vd", vim.diagnostic.open_float, opts)                                    -- cursor diagnostics
        keymap("n", "<leader>vD", "<cmd>lua vim.diagnostic.open_float({ scope = 'line' })<CR>", opts) -- line diagnostics

        keymap('n', ']d', function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, opts)
        keymap('n', '[d', function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, opts)

        -- FzfLua LSP keymaps
        keymap("n", "<leader>ca", fzf_vertical("lsp_code_actions"), opts)      -- lsp code actions
        keymap("n", "<leader>fl", fzf_vertical("lsp_finder"), opts)            -- lsp finder (definitions + references)
        keymap("n", "<leader>fr", fzf_vertical("lsp_references"), opts)        -- show all references to symbol under cursor
        keymap("n", "<leader>ft", fzf_vertical("lsp_typedefs"), opts)          -- jump to the typedefs of symbol under cursor
        keymap("n", "<leader>ds", fzf_vertical("lsp_document_symbols"), opts)  -- list all symbols in file
        keymap("n", "<leader>ws", fzf_vertical("lsp_workspace_symbols"), opts) -- search for symbol across entire project
        keymap("n", "<leader>fi", fzf_vertical("lsp_implementations"), opts)   -- go to implementation

        if client.name == "clangd" then
            keymap("n", "<leader>gw", "<cmd>LspClangdSwitchSourceHeader<cr>", { buffer = bufnr, desc = "Switch source/header" })
        end

        if client.name == "tinymist" then
            -- Necessary for typst to pickup the main file when dealing with multiple files
            -- This is a temporary workaround for writing my thesis
            local main = client.root_dir .. "/Thesis/main.typ"
            client:exec_cmd({
                title = "tinymist.pinMain",
                command = "tinymist.pinMain",
                arguments = { main },
            }, { bufnr = bufnr })
        end
    end,
})

vim.lsp.enable({
	"lua_ls", "cssls", "tinymist", "rust_analyzer", "clangd",
	"ts_ls", "emmet_language_server", "emmet_ls", "pyright",
    "roslyn", "jsonls", "yamlls",
})

-- typst-preview: only needed for typst files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "typst",
    once = true,
    callback = function()
        vim.pack.add({ { src = "https://github.com/chomosuke/typst-preview.nvim" } })
    end,
})
