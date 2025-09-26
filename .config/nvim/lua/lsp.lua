vim.lsp.enable({
    "clangd",
    "jsonls",
    "lua_ls",
    "omnisharp",
    "ts_ls",
    "yamlls",
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

vim.cmd [[set completeopt+=menuone,noselect,popup]]

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        vim.keymap.set("n", "gss", function()
            vim.cmd.vsplit()
            vim.lsp.buf.definition()
        end, { silent = true, desc = "split vertical and go to definition", buffer = args.buf })

        vim.keymap.set("n", "gsv", function()
            vim.cmd.split()
            vim.lsp.buf.definition()
        end, { silent = true, desc = "split horizontal and go to definition", buffer = args.buf })
    end,
})
