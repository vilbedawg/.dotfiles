-- Check if required plugins are installed
local function check_plugin(plugin_name)
  local ok, _ = pcall(require, plugin_name)
  return ok
end

local required_plugins = {
  "cmp_nvim_lsp",
  "mason",
  "mason-lspconfig",
  "mason-null-ls",
  "nvim-navic",
}

for _, plugin in ipairs(required_plugins) do
  if not check_plugin(plugin) then
    print(plugin .. " not installed!")
    return
  end
end

-- Plugin setup
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local mason_null_ls = require("mason-null-ls")
local navic = require("nvim-navic")

mason.setup()

-- LSP configuration
local on_attach = function(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  -- Debounce by 300ms by default
  client.config.flags.debounce_text_changes = 300
  -- This will set up formatting for the attached LSPs
  client.server_capabilities.documentFormattingProvider = true

  -- Key mappings
  vim.keymap.set("n", "gh", "<cmd>Lspsaga finder<CR>", { desc = "Symbol definition" })
  vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code action" })
  vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", { desc = "Rename occurences (file)" })
  vim.keymap.set("n", "gR", "<cmd>Lspsaga rename ++project<CR>", { desc = "Rename occurences (project)" })
  vim.keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
  vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition" })
  vim.keymap.set("n", "gT", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek type definition" })
  vim.keymap.set("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", { desc = "Go to type definition" })
  vim.keymap.set("n", "<leader>xl", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Show line diagnostics" })
  vim.keymap.set("n", "<leader>xb", "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "Show buffer diagnostics" })
  vim.keymap.set(
    "n",
    "<leader>xw",
    "<cmd>Lspsaga show_workspace_diagnostics<CR>",
    { desc = "Show workspace diagnostics" }
  )
  vim.keymap.set("n", "<leader>xc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { desc = "Show cursor diagnostics" })
  vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Next diagnostic" })
  vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Previous next diagnostic" })

  vim.keymap.set("n", "[E", function()
    require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Previous error" })

  vim.keymap.set("n", "]E", function()
    require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Next error" })

  vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "Toggle outline" })
  vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>", { desc = "Hover doc" })
  vim.keymap.set("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", { desc = "Incoming calls" })
  vim.keymap.set("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", { desc = "Outgoing calls" })
  vim.keymap.set({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>", { desc = "Floating term toggle" })
  vim.keymap.set(
    "n",
    "<Leader>j",
    "<cmd>lua require('illuminate').goto_next_reference(wrap)<CR>",
    { desc = "Go to next highlight" }
  )
  vim.keymap.set(
    "n",
    "<Leader>k",
    "<cmd>lua require('illuminate').goto_prev_reference(wrap)<CR>",
    { desc = "Go to prev highlight" }
  )

  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])

  -- Check for specific client and adjust capabilities
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  if client.name == "tsserver" then
    client.resolved_capabilities.document_formatting = false
  end

  -- Omnisharps provided tokens dont conform to the LSP semantic tokens specification, therefore Neovim cannot support it. This fixes the issue.
  if client.name == "omnisharp" then
    client.server_capabilities.semanticTokensProvider = {
      full = vim.empty_dict(),
      legend = {
        tokenModifiers = { "static_symbol" },
        tokenTypes = {
          "comment",
          "excluded_code",
          "identifier",
          "keyword",
          "keyword_control",
          "number",
          "operator",
          "operator_overloaded",
          "preprocessor_keyword",
          "string",
          "whitespace",
          "text",
          "static_symbol",
          "preprocessor_text",
          "punctuation",
          "string_verbatim",
          "string_escape_character",
          "class_name",
          "delegate_name",
          "enum_name",
          "interface_name",
          "module_name",
          "struct_name",
          "type_parameter_name",
          "field_name",
          "enum_member_name",
          "constant_name",
          "local_name",
          "parameter_name",
          "method_name",
          "extension_method_name",
          "property_name",
          "event_name",
          "namespace_name",
          "label_name",
          "xml_doc_comment_attribute_name",
          "xml_doc_comment_attribute_quotes",
          "xml_doc_comment_attribute_value",
          "xml_doc_comment_cdata_section",
          "xml_doc_comment_comment",
          "xml_doc_comment_delimiter",
          "xml_doc_comment_entity_reference",
          "xml_doc_comment_name",
          "xml_doc_comment_processing_instruction",
          "xml_doc_comment_text",
          "xml_literal_attribute_name",
          "xml_literal_attribute_quotes",
          "xml_literal_attribute_value",
          "xml_literal_cdata_section",
          "xml_literal_comment",
          "xml_literal_delimiter",
          "xml_literal_embedded_expression",
          "xml_literal_entity_reference",
          "xml_literal_name",
          "xml_literal_processing_instruction",
          "xml_literal_text",
          "regex_comment",
          "regex_character_class",
          "regex_anchor",
          "regex_quantifier",
          "regex_grouping",
          "regex_alternation",
          "regex_text",
          "regex_self_escaped_character",
          "regex_other_escape",
        },
      },
      range = true,
    }
  end
end

-- Enable autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- List of LSP servers to set up
local servers = {
  "tsserver",
  "html",
  "cssls",
  "lua_ls",
  "clangd",
  "cmake",
  "pyright",
  "omnisharp",
  "jsonls",
  "erlangls",
}

-- Setup Mason + LSPs + CMP + Null-ls + Navic
require("vilho.lsp.cmp")
require("vilho.lsp.lsp-colors")
require("vilho.lsp.null-ls")
require("vilho.lsp.navic")

mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

mason_null_ls.setup({
  ensure_installed = {
    "prettier",
    "stylua",
    "cs",
    "c cpp",
  },
  automatic_installation = true,
})

-- Set up individual LSP servers
for _, server in ipairs(servers) do
  local server_config_ok, mod = pcall(require, "vilho.lsp.servers." .. server)
  if not server_config_ok then
    print("The LSP '" .. server .. "' does not have a config.")
  else
    mod.setup(on_attach, capabilities)
  end
end

-- Global diagnostic settings
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  update_in_insert = false,
  signs = true,
  float = {
    header = "",
    source = "always",
    border = "solid",
    focusable = true,
  },
})

local signs = { Error = "✘", Warn = " ", Hint = "", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon })
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
