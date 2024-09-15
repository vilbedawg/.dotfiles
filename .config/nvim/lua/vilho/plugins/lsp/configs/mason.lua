return {
  "williamboman/mason.nvim",
  event = "BufReadPost",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local on_attach = require("vilho.plugins.lsp.options").on_attach
      local on_init = require("vilho.plugins.lsp.options").on_init
      local capabilities = require("vilho.plugins.lsp.options").capabilities

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

      local disabled_servers = {
        "ts_ls",
      }

      mason_lspconfig.setup_handlers({
        -- Automatically configure the LSP installed
        function(server_name)
          for _, name in pairs(disabled_servers) do
            if name == server_name then
              return
            end
          end
          local opts = {
            on_attach = on_attach,
            on_init = on_init,
            capabilities = capabilities,
          }

          local require_ok, server = pcall(require, "vilho.plugins.lsp.settings." .. server_name)
          if require_ok then
            opts = vim.tbl_deep_extend("force", server, opts)
          end

          require("lspconfig")[server_name].setup(opts)
        end,
      })
    end,
  },
}
