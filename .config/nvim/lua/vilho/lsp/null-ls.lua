local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
	vim.notify("Null-ls not installed!")
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	sources = {
		formatting.prettier.with({ extra_args = { "--semi", "--single-quote", "--jsx-single-quote" } }),
		formatting.stylua,
		diagnostics.eslint_d,
	},
})
