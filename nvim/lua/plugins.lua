vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/tpope/vim-surround" },
  { src = "https://github.com/vague-theme/vague.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/seblyng/roslyn.nvim" },
  { src = "https://github.com/christoomey/vim-tmux-navigator" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
})

require("mason").setup({
  registries = {
    "github:Crashdummyy/mason-registry", -- for Roslyn
    "github:mason-org/mason-registry",
  },
})

require("oil").setup()

-- Treesitter
local ensure_installed = {
  "javascript",
  "typescript",
  "lua",
  "bash",
  "json",
  "dockerfile",
  "html",
  "python",
  "markdown",
  "tsx",
  "cpp",
  "make",
  "cmake",
  "yaml",
  "c_sharp",
  "markdown_inline",
  "tinymist",
}
require("nvim-treesitter").install(ensure_installed)

-- Conform
require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    lua = { "stylua" },
    python = { "isort", "black" },
  },
  format_after_save = nil,
  default_format_opts = {
    lsp_format = "fallback",
  },
})

-- Colorscheme
require("vague").setup({ transparent = false })
vim.cmd.colorscheme("vague")


-- Luasnip
require("luasnip.loaders.from_vscode").lazy_load()

-- Blink
require("blink.cmp").setup({
  fuzzy = { implementation = "prefer_rust_with_warning" },
  signature = { enabled = true },
  keymap = {
    preset = "default",
    ["<C-space>"] = {},
    ["<C-p>"] = {},
    ["<Tab>"] = {},
    ["<S-Tab>"] = {},
    ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
    ["<CR>"] = { "accept", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-b>"] = { "scroll_documentation_down", "fallback" },
    ["<C-f>"] = { "scroll_documentation_up", "fallback" },
    ["<C-l>"] = { "snippet_forward", "fallback" },
    ["<C-h>"] = { "snippet_backward", "fallback" },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "normal",
  },
  completion = {
    menu = {
      border = nil,
      scrolloff = 1,
      scrollbar = false,
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "kind" },
          { "source_name" },
        },
      },
    },
    documentation = {
      window = {
        border = nil,
        scrollbar = false,
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
      },
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
  cmdline = {
    keymap = {
      preset = "inherit",
      ["<CR>"] = { "accept_and_enter", "fallback" },
    },
  },
  snippets = {
    preset = "luasnip",
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      cmdline = {
        min_keyword_length = 2,
      },
    },
  },
})

-- Fzf
local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
  winopts = { backdrop = 85 },
  keymap = {
    builtin = {
      ["<C-f>"] = "preview-page-down",
      ["<C-b>"] = "preview-page-up",
      ["<C-p>"] = "toggle-preview",
    },
    fzf = {
      ["ctrl-a"] = "toggle-all",
      ["ctrl-t"] = "first",
      ["ctrl-g"] = "last",
      ["ctrl-d"] = "half-page-down",
      ["ctrl-u"] = "half-page-up",
    },
  },
  actions = {
    files = {
      ["ctrl-q"] = actions.file_sel_to_qf,
      ["ctrl-n"] = actions.toggle_ignore,
      ["ctrl-h"] = actions.toggle_hidden,
      ["enter"] = actions.file_edit_or_qf,
    },
  },
})

-- gitsigns
require("gitsigns").setup({
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "next hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "prev hunk" })

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage hunk" })
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "reset hunk" })

    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "stage selection" })

    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "reset selection" })

    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "stage buffer" })
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "reset buffer" })

    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end, { desc = "blame line" })

    map("n", "<leader>hd", gitsigns.diffthis, { desc = "diff this" })

    map("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end, { desc = "diff file" })

    map("n", "<leader>hQ", function()
      gitsigns.setqflist("all")
    end, { desc = "send all to qf list" })
    map("n", "<leader>hq", gitsigns.setqflist, { desc = "send to qf list" })
  end,
})
