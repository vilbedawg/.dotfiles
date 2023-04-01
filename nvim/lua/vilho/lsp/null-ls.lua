local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
  vim.notify("Null-ls not installed!")
  return
end

null_ls.setup({
    sources = {
        formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote"}}),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
    },
})
