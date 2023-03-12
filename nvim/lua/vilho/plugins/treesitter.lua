return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "p00f/nvim-ts-rainbow",
     -- "nvim-treesitter/nvim-treesitter-textobjects"
  },
  config = function ()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "javascript", "typescript", "vue", "lua", "css", "bash", "json", "typescript",
        "dockerfile", "html", "python", "scss", "markdown", "tsx", "cpp", "make", "cmake", "c", "yaml" },
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
      }
    })
  end
}
