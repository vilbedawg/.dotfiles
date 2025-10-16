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

    keymap("n", "gss", function()
      vim.cmd.vsplit()
      vim.lsp.buf.definition()
    end, { silent = true, desc = "split vertical and go to definition" })

    keymap("n", "gsv", function()
      vim.cmd.split()
      vim.lsp.buf.definition()
    end, { silent = true, desc = "split horizontal and go to definition" })

    keymap({ "n", "v" }, "<leader>F", function()
      require("conform").format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      })
    end, { desc = "Format file or range (in visual mode)" })

    keymap("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    keymap("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
    keymap("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
    keymap("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
    keymap("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename symbol" })
    keymap("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature documentation" })
    keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover doc" })
    keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

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

vim.cmd([[set completeopt+=menuone,noselect,popup]])
