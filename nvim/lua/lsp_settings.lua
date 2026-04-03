vim.lsp.enable({
    "clangd",
    "jsonls",
    "lua_ls",
    "roslyn",
    "ts_ls",
    "yamlls",
    "eslint_d",
    "tinymist",
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

        local opts = {
            noremap = true, -- prevent recursive mapping
            silent = true,  -- don't print the cmd to cli
            buffer = bufnr,
        }

        -- require("fzf-lua").register_ui_select()
        -- Native nvim keymaps
        keymap({ "n", "v" }, "<leader>F", vim.lsp.buf.format, opts)                                   -- Format
        keymap("n", "gd", vim.lsp.buf.definition, opts)                                               -- Go to definition
        keymap("n", "gt", vim.lsp.buf.type_definition, opts)                                          -- Go to type def
        keymap("n", "gi", vim.lsp.buf.implementation, opts)                                           -- Go to implementation
        keymap("n", "gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)                     -- Go to definition in split
        keymap("n", "<leader>r", vim.lsp.buf.rename, opts)                                            -- Rename
        keymap("n", "K", vim.lsp.buf.hover, opts)                                                     -- Hover doc
        keymap("n", "<leader>vd", vim.diagnostic.open_float, opts)                                    -- cursor diagnostics
        keymap("n", "<leader>vD", "<cmd>lua vim.diagnostic.open_float({ scope = 'line' })<CR>", opts) -- line diagnostics

        keymap('n', ']d', function()
            vim.diagnostic.jump({ count = 1, float = true }) -- float=true shows diagnostic automatically
        end)
        keymap('n', '[d', function()
            vim.diagnostic.jump({ count = -1, float = true })
        end)

        keymap("n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<CR>", opts)      -- lsp code actions
        keymap("n", "<leader>fd", "<cmd>FzfLua lsp_finder<CR>", opts)            -- lsp finder (definitions + references)
        keymap("n", "<leader>fr", "<cmd>FzfLua lsp_references<CR>", opts)        -- show all references to symbol under cursor
        keymap("n", "<leader>ft", "<cmd>FzfLua lsp_typedefs<CR>", opts)          -- jump to the typedefs of symbol under cursor
        keymap("n", "<leader>ds", "<cmd>FzfLua lsp_document_symbols<CR>", opts)  -- list all symbols in file
        keymap("n", "<leader>ws", "<cmd>FzfLua lsp_workspace_symbols<CR>", opts) -- search for symbol across entire project
        keymap("n", "<leader>fi", "<cmd>FzfLua lsp_implementations<CR>", opts)   -- go to implementation


        if client.name == "clangd" then
            keymap("n", "<leader>gw", "<cmd>LspClangdSwitchSourceHeader<cr>", { desc = "Hover doc" })
        end
    end,
})

vim.cmd([[set completeopt+=menuone,noselect,popup]])
