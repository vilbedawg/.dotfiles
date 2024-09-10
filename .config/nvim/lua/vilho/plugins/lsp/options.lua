local M = {}
local keymap = vim.keymap
local cmp_nvim_lsp = require("cmp_nvim_lsp")

M.capabilities = cmp_nvim_lsp.default_capabilities()

local function lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- set keybinds
  opts.desc = "Symbol definition"
  keymap.set("n", "gh", "<cmd>Lspsaga finder<CR>", opts)

  opts.desc = "Code action"
  keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)

  opts.desc = "Rename occurrences (file)"
  keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", opts)

  opts.desc = "Rename occurrences (project)"
  keymap.set("n", "gR", "<cmd>Lspsaga rename ++project<CR>", opts)

  opts.desc = "Peek definition"
  keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>", opts)

  opts.desc = "Go to definition"
  keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)

  opts.desc = "Peek type definition"
  keymap.set("n", "gT", "<cmd>Lspsaga peek_type_definition<CR>", opts)

  opts.desc = "Go to type definition"
  keymap.set("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", opts)

  opts.desc = "Show line diagnostics"
  keymap.set("n", "<leader>xl", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)

  opts.desc = "Show buffer diagnostics"
  keymap.set("n", "<leader>xb", "<cmd>Lspsaga show_buf_diagnostics<CR>", opts)

  opts.desc = "Show workspace diagnostics"
  keymap.set("n", "<leader>xw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", opts)

  opts.desc = "Show cursor diagnostics"
  keymap.set("n", "<leader>xc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)

  opts.desc = "Next diagnostic"
  keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)

  opts.desc = "Previous diagnostic"
  keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)

  opts.desc = "Previous error"
  keymap.set("n", "[E", function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, opts)

  opts.desc = "Next error"
  keymap.set("n", "]E", function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, opts)

  opts.desc = "Toggle outline"
  keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts)

  opts.desc = "Hover doc"
  keymap.set("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>", opts)

  opts.desc = "Incoming calls"
  keymap.set("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", opts)

  opts.desc = "Outgoing calls"
  keymap.set("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", opts)

  opts.desc = "Floating term toggle"
  keymap.set({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>", opts)

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
