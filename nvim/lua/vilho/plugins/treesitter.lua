return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "p00f/nvim-ts-rainbow",
    "nvim-treesitter/nvim-treesitter-textobjects"
  },
  config = function ()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "javascript", "typescript", "vue", "lua", "css", "bash", "json", "typescript",
        "dockerfile", "html", "python", "scss", "markdown", "tsx", "cpp", "make", "cmake", "c", "yaml", "c_sharp" },
      sync_install = false,
      ignore_install = {""},
      highlight = {
        enable = true,
        disable = { "" },
        additional_vim_regex_highlighting = true,
      },
      indent = { enable = true, disable = { "yaml" } },
      rainbow = {
        enable = true,
        max_file_lines = nil,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = { query = "@function.outer", desc = "All of a function definition" },
            ["if"] = { query = "@function.inner", desc = "Inner part of a function definition" },
            ["ac"] = { query = "@comment.outer", desc = "All of a comment" },
          },
          selection_modes = {
            ['@function.outer'] = 'V', -- linewise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace.
          include_surrounding_whitespace = true,
        },
      },
    })
  end
}
