return {
  "williamboman/mason.nvim",
  event = "BufReadPost",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup({
        ui = {
          -- Whether to automatically check for new versions when opening the :Mason window.
          check_outdated_packages_on_open = false,
          icons = {
            package_installed = "✓ ",
            package_pending = "➜ ",
            package_uninstalled = "✗ ",
          },
        },
      })

      local servers = { "lua_ls", "ts_ls", "yamlls", "omnisharp", "jsonls", "clangd" }
      local lsp_opts = require("vilho.plugins.lsp.options")
      local on_attach = lsp_opts.on_attach
      local on_init = lsp_opts.on_init
      local capabilities = lsp_opts.capabilities

      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_enable = false, -- Enable after Neovim is updated to 0.11.
        automatic_installation = true,
        automatic_setup = true,
      })

      for _, server in ipairs(servers) do
        local opts = {
          on_attach = on_attach,
          on_init = on_init,
          capabilities = capabilities,
        }

        -- Load server-specific settings if available
        local ok, server_opts = pcall(require, "vilho.plugins.lsp.settings." .. server)
        if ok then
          opts = vim.tbl_deep_extend("force", opts, server_opts)
        end

        require("lspconfig")[server].setup(opts)
      end
    end,
  },
}
