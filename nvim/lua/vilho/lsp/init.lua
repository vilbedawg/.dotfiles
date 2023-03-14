local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local mason_status_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")

if not (mason_status_ok and mason_lspconfig_ok and cmp_nvim_lsp_status_ok) then
  print("Mason, Mason LSP Config or Completion not installed!")
  return
end

mason.setup()

local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Debounce by 300ms by default
  client.config.flags.debounce_text_changes = 300

  -- This will set up formatting for the attached LSPs
  client.server_capabilities.documentFormattingProvider = true

  -- Keymaps
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gs", function()
    vim.cmd.vsplit()
    vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)

  vim.keymap.set("n", "]W", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end)

  vim.keymap.set("n", "[W", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end)

  vim.keymap.set("n", "]w", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARNING })
  end)

  vim.keymap.set("n", "[w", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARNING })
  end)

end
-- used to enable autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

local servers = {
  "tsserver",
  "html",
  "cssls",
  "lua_ls",
  "clangd",
  "cmake",
  "pyright",
}
-- Setup Mason + LSPs + CMP
require "vilho.lsp.cmp"
require "vilho.lsp.lsp-colors"

mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true
})

for _, s in pairs(servers) do
  local server_config_ok, mod = pcall(require, "vilho.lsp.servers." .. s)
  if not server_config_ok then
    print("The LSP '" .. s .. "' does not have a config.")
    -- require("notify")("The LSP '" .. s .. "' does not have a config.", "warn")
  else
    mod.setup(on_attach, capabilities)
  end
end

-- Global diagnostic settings
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  update_in_insert = false,
  float = {
    header = "",
    source = "always",
    border = "solid",
    focusable = true,
  },
})

-- local signs = { Error = "✘", Warn = " ", Hint = "", Info = " " }
-- for type, icon in pairs(signs) do
  -- local hl = "DiagnosticSign" .. type
  -- vim.fn.sign_define(hl, { text = icon })
  -- vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
-- end

