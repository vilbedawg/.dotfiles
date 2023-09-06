local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
  vim.notify("Null-ls not installed!")
  return
end

local formatting = null_ls.builtins.formatting

null_ls.setup({
  sources = {
    formatting.prettier,
    formatting.stylua,
    formatting.eslint_d,
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.completion.spell,
  },
})
