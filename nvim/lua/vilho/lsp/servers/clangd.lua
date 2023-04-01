return {
	setup = function(on_attach, capabilities)
		require("lspconfig").clangd.setup({
			capabilities = capabilities,
			on_attach = on_attach,
      cmd = {
        "clangd",
        "--background-index",
        "--pch-storage=memory",
        "--clang-tidy",
        "--suggest-missing-includes",
        "--all-scopes-completion",
        "--pretty",
        "--header-insertion=never",
        "-j=4",
        "--inlay-hints",
        "--header-insertion-decorators",
      },
      filetypes = {"c", "cpp", "objc", "objcpp"},
      -- root_dir = utils.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
      init_option = { fallbackFlags = {  "-std=c++2a"  } }
    })
	end,
}
