return {
  setup = function(on_attach, capabilities)
    require("lspconfig").tsserver.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
