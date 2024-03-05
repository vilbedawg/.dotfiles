local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
  vim.notify("Null-ls not installed!")
  return
end

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint_d,
  },
})
