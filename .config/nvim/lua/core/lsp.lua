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

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gt", vim.lsp.buf.type_definition, "Go to type definition")
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
    map("gr", vim.lsp.buf.references, "Go to references")
    map("<Leader>r", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>R", vim.lsp.buf.rename, "Rename all references")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature documentation")
    map("K", vim.lsp.buf.hover, "Hover doc")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

    map("gss", function()
      vim.cmd.vsplit()
      vim.lsp.buf.definition()
    end, "Split vertical and go to definition")

    map("gsv", function()
      vim.cmd.split()
      vim.lsp.buf.definition()
    end, "Split horizontal and go to definition")

    map("<leader>lq", vim.diagnostic.setqflist, "Add diagnostics to quickfix list")
    map("<leader>d", function()
      vim.diagnostic.setqflist({})
    end, "Clear quickfix list")

    map("[e", function()
      vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
    end, "Previous warning")

    map("]e", function()
      vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
    end, "Next warning")

    map("[E", function()
      vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end, "Previous error")

    map("]E", function()
      vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
    end, "Next error")

    map("<Leader>j", "<cmd>lua require('illuminate').goto_next_reference(wrap)<CR>", "Go to next highlight")
    map("<Leader>k", "<cmd>lua require('illuminate').goto_prev_reference(wrap)<CR>", "Go to previous highlight")

    local function client_supports_method(method, bufnr)
      if vim.fn.has("nvim-0.11") == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    if client_supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    if client_supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})
