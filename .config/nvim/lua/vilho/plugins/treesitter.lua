return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local disable_function = function(lang, bufnr)
      if not bufnr then
        bufnr = 0
      end

      if lang == "help" then
        return true
      end

      local line_count = vim.api.nvim_buf_line_count(bufnr)
      if line_count > 20000 or (line_count == 1 and lang == "json") then
        vim.g.matchup_matchparen_enabled = 0
        return true
      else
        return false
      end
    end
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "javascript",
        "typescript",
        "vue",
        "lua",
        "css",
        "bash",
        "json",
        "typescript",
        "dockerfile",
        "html",
        "python",
        "scss",
        "markdown",
        "tsx",
        "cpp",
        "make",
        "cmake",
        "c",
        "yaml",
        "c_sharp",
        "markdown_inline",
      },
      sync_install = true,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
        disable = disable_function,
      },
      indent = {
        enable = true,
        disable = { "yaml" },
      },
      autotag = {
        enable = true,
      },
      matchup = {
        enable = true,
        disable = { "json", "csv" },
      },
      context_commentstring = {
        enable = true,
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]b"] = "@parameter.outer",
            ["]d"] = "@block.inner",
            ["]e"] = "@function.inner",
            ["]a"] = "@attribute.inner",
            ["]s"] = "@this_method_call",
            ["]c"] = "@method_object_call",
            ["]o"] = "@object_declaration",
            ["]k"] = "@object_key",
            ["]v"] = "@object_value",
            ["]w"] = "@method_parameter",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]B"] = "@parameter.outer",
            ["]D"] = "@block.inner",
            ["]E"] = "@function.inner",
            ["]A"] = "@attribute.inner",
            ["]S"] = "@this_method_call",
            ["]C"] = "@method_object_call",
            ["]O"] = "@object_declaration",
            ["]K"] = "@object_key",
            ["]V"] = "@object_value",
            ["]W"] = "@method_parameter",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[b"] = "@parameter.outer",
            ["[d"] = "@block.inner",
            ["[e"] = "@function.inner",
            ["[a"] = "@attribute.inner",
            ["[s"] = "@this_method_call",
            ["[c"] = "@method_object_call",
            ["[o"] = "@object_declaration",
            ["[k"] = "@object_key",
            ["[v"] = "@object_value",
            ["[w"] = "@method_parameter",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[B"] = "@parameter.outer",
            ["[D"] = "@block.inner",
            ["[E"] = "@function.inner",
            ["[A"] = "@attribute.inner",
            ["[S"] = "@this_method_call",
            ["[C"] = "@method_object_call",
            ["[O"] = "@object_declaration",
            ["[K"] = "@object_key",
            ["[V"] = "@object_value",
            ["[W"] = "@method_parameter",
          },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@call.outer",
            ["ic"] = "@call.inner",
            ["aC"] = "@class.outer",
            ["iC"] = "@class.inner",
            ["ib"] = "@parameter.inner",
            ["ab"] = "@parameter.outer",
            ["iB"] = "@block.inner",
            ["aB"] = "@block.outer",
            ["id"] = "@block.inner",
            ["ad"] = "@block.outer",
            ["il"] = "@loop.inner",
            ["al"] = "@loop.outer",
            ["ia"] = "@attribute.inner",
            ["aa"] = "@attribute.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    })
  end,
}
