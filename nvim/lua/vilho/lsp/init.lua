local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local mason_status_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")

if not (mason_status_ok and mason_lspconfig_ok and cmp_nvim_lsp_status_ok and mason_null_ls_ok) then
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
	-- Check for the existence of Trouble plugin
	if vim.fn.exists(":TroubleToggle") then
		-- If it exists, use Trouble's keymap
		vim.keymap.set("n", "gd", "<cmd>TroubleToggle lsp_definitions<cr>", opts) -- Go to definition
		vim.keymap.set("n", "gi", "<cmd>TroubleToggle lsp_implementations<cr>", opts) -- Go to implementation
		vim.keymap.set("n", "gt", "<cmd>TroubleToggle lsp_type_definitions<cr>", opts) -- Go to type definition
		vim.keymap.set("n", "gr", "<cmd>TroubleToggle lsp_references<cr>", opts) -- Find references
	else
		-- Otherwise, use the default LSP keymap
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- Go to definition
		vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts) -- Go to type definition
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- Go to implementation
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts) -- Find references
	end

	vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts) -- Rename symbol
	vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- Code actions
	vim.keymap.set("n", "<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) -- Signature help
	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- Show hover information
	vim.keymap.set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts) -- Go to next diagnostic
	vim.keymap.set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts) -- Go to previous diagnostic
	-- vim.keymap.set("n", "<leader>l", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts) -- Show diagnostic information

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
	"omnisharp",
}
-- Setup Mason + LSPs + CMP + Null-ls
require("vilho.lsp.cmp")
require("vilho.lsp.lsp-colors")
require("vilho.lsp.null-ls")

mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

mason_null_ls.setup({
	ensure_installed = {
		"prettier",
		"stylua",
		"eslint_d",
		"cs",
		"c cpp",
	},
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

local signs = { Error = "✘", Warn = " ", Hint = "", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon })
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
