return {
	setup = function(on_attach, capabilities)
		require("lspconfig").cssls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,
}
