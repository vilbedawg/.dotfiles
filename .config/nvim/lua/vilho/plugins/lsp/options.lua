local M = {}
local keymap = vim.keymap
local cmp_nvim_lsp = require("cmp_nvim_lsp")

M.capabilities = cmp_nvim_lsp.default_capabilities()

local function lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- set keybinds
  opts.desc = "Go to definition"
  keymap.set("n", "gd", vim.lsp.buf.definition, opts)

  opts.desc = "Go to type definition"
  keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

  opts.desc = "Go to implementation"
  keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

  opts.desc = "Go to references"
  keymap.set("n", "gr", vim.lsp.buf.references, opts)

  opts.desc = "Split vertical and go to definition"
  keymap.set("n", "gss", function()
    vim.cmd.vsplit()
    vim.lsp.buf.definition()
  end, opts)

  opts.desc = "Split horizontal and go to definition"
  keymap.set("n", "gsv", function()
    vim.cmd.split()
    vim.lsp.buf.definition()
  end, opts)

  opts.desc = "Add diagnostics to quickfix list"
  keymap.set("n", "<leader>lq", vim.diagnostic.setqflist, opts)

  opts.desc = "Clear quickfix list"
  keymap.set("n", "<leader>d", function()
    vim.diagnostic.setqflist({})
  end, opts)

  opts.desc = "Rename symbol"
  keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)

  opts.desc = "Signature documentation"
  keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

  opts.desc = "Hover doc"
  keymap.set("n", "K", vim.lsp.buf.hover, opts)

  opts.desc = "Previous warning"
  keymap.set("n", "[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
  end, opts)

  opts.desc = "Next warning"
  keymap.set("n", "]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
  end, opts)

  opts.desc = "Previous error"
  keymap.set("n", "[E", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, opts)

  opts.desc = "Next error"
  keymap.set("n", "]E", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, opts)

  opts.desc = "Go to next highlight"
  keymap.set("n", "<Leader>j", "<cmd>lua require('illuminate').goto_next_reference(wrap)<CR>", opts)

  opts.desc = "Go to prev highlight"
  keymap.set("n", "<Leader>k", "<cmd>lua require('illuminate').goto_prev_reference(wrap)<CR>", opts)
end

-- Highlight symbol under cursor
local function lsp_highlight(client, bufnr)
  if client.supports_method("textDocument/documentHighlight") then
    vim.api.nvim_create_augroup("lsp_document_highlight", {
      clear = false,
    })
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = "lsp_document_highlight",
    })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight(client, bufnr)
end

M.on_init = function(client, _)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

return M
