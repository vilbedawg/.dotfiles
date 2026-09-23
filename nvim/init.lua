vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Indentation
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth

-- Search
vim.opt.ignorecase = true

-- Files
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.autoread = true

-- UI/display
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.wrap = false
vim.opt.scrolloff = 8 -- Keep 8 lines above and below the cursor
vim.o.statusline = "%<%f %h%w%m%r %{get(b:,'gitsigns_status','')}%=%-14.(%l,%c%V%) %P"

-- Editing behavior
vim.opt.jumpoptions = "stack" -- Make <C-o>/<C-i> behave like browser back/forward
vim.opt.clipboard = "unnamedplus"
vim.opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append("-") -- hyphenated words recognized by searches
vim.opt.formatoptions:remove("c") -- don't auto-wrap comments using 'textwidth'

vim.diagnostic.config({
  virtual_text = { prefix = "" },
  float = { border = "single" },
  underline = true,
  severity_sort = true,
})

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/tpope/vim-surround" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/vague-theme/vague.nvim" },
  { src = "https://github.com/chentoast/marks.nvim" },
})

vim.pack.add({
  { src = "https://github.com/meanderingprogrammer/render-markdown.nvim" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
  { src = "https://github.com/seblyng/roslyn.nvim" },
}, { load = false })

require("mason").setup({
  registries = {
    "github:Crashdummyy/mason-registry", -- for Roslyn
    "github:mason-org/mason-registry",
  },
})

vim.cmd.colorscheme("vague")

require("oil").setup()

require("marks").setup({
  builtin_marks = { "<", ">", "^" },
})

require("conform").setup({
  default_format_opts = {
    -- Allow formatting from LSP server if no dedicated formatter is available
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "prettier", "biome", "biome", stop_after_first = true },
    typescript = { "prettier", "biome", stop_after_first = true },
    javascriptreact = { "prettier", "biome", stop_after_first = true },
    typescriptreact = { "prettier", "biome", stop_after_first = true },
  },
})

local map = vim.keymap.set
local fzflua = require("fzf-lua")

fzflua.setup({
  file_ignore_patterns = {
    "node_modules/", "dist/", ".next/",
    ".git/", ".gitlab/", "build/",
    "target/", "package-lock.json",
    "pnpm-lock.yaml", "yarn.lock",
    "tsconfig.tsbuildinfo",
  },
})

local gitsigns = require("gitsigns")
gitsigns.setup({
  on_attach = function(bufnr)
    map("n", "]h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { buffer = bufnr })

    map("n", "[h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { buffer = bufnr })

    map("n", "<leader>hd", gitsigns.diffthis, { buffer = bufnr })
    map("n", "<leader>hq", gitsigns.setqflist, { buffer = bufnr })
    map("n", "<leader>hs", gitsigns.stage_hunk, { buffer = bufnr })
    map("n", "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr })
    map("n", "<leader>hS", gitsigns.stage_buffer, { buffer = bufnr })
    map("n", "<leader>hR", gitsigns.reset_buffer, { buffer = bufnr })
    map("n", "<leader>hB", "<cmd>Gitsigns blame<cr>", { buffer = bufnr, silent = true })
    map("n", "<leader>hc", "<cmd>Gitsigns show_commit<cr>", { buffer = bufnr, silent = true })
    map("n", "<leader>hD", function() gitsigns.diffthis("~") end, { buffer = bufnr })
    map("n", "<leader>hQ", function() gitsigns.setqflist("all") end, { buffer = bufnr })
    map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { buffer = bufnr })
    map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { buffer = bufnr })
    map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { buffer = bufnr })
  end,
})

require("blink.cmp").setup({
  keymap = { preset = "default" },
  signature = { enabled = true },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "normal",
  },
  completion = {
    menu = {
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "kind" },
          { "source_name" },
        },
      },
    },
  },
  snippets = {
    preset = "luasnip",
  },
})

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    require("luasnip").setup({ enable_autosnippets = true })
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach-config", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    local opts = { silent = true, buffer = bufnr }

    map({ "n", "v" }, "<leader>F", function() require("conform").format({ bufnr = args.buf }) end, opts)
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gt", vim.lsp.buf.type_definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
    map("n", "<leader>r", vim.lsp.buf.rename, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>vd", vim.diagnostic.open_float, opts)
    map("n", "<leader>vD", "<cmd>lua vim.diagnostic.open_float({ scope = 'line' })<CR>", opts)

    map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)

    map("n", "<leader>ca", fzflua["lsp_code_actions"], opts)
    map("n", "<leader>fl", fzflua["lsp_finder"], opts)
    map("n", "<leader>fr", fzflua["lsp_references"], opts)
    map("n", "<leader>ft", fzflua["lsp_typedefs"], opts)
    map("n", "<leader>ds", fzflua["lsp_document_symbols"], opts)
    map("n", "<leader>ws", fzflua["lsp_workspace_symbols"], opts)
    map("n", "<leader>fi", fzflua["lsp_implementations"], opts)

    if client.name == "clangd" then
      map("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", opts)
    end
  end,
})

vim.lsp.enable({
  "lua_ls", "cssls", "tinymist",
  "rust_analyzer", "clangd", "ts_ls",
  "emmet_language_server", "pyright", "jsonls",
  "yamlls", "marksman",
})

-- Tabs
map("n", "<leader>to", ":tabnew<CR>", { silent = true })
map("n", "<leader>tx", ":tabclose<CR>", { silent = true })
for i = 1, 8 do
  map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>", { silent = true })
end

-- Buffers
map("n", "<leader>bd", ":bd<CR>", { silent = true })
map("n", "<leader>bD", ":bd!<CR>", { silent = true })
map("n", "<S-l>", ":bnext<CR>", { silent = true })
map("n", "<S-h>", ":bprevious<CR>", { silent = true })

-- Editing
map("n", "x", '"_x', { silent = true })

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "<M-j>", "<cmd>m .+1<cr>==", { silent = true })
map("n", "<M-k>", "<cmd>m .-2<cr>==", { silent = true })
map("v", "<M-j>", ":m '>+1<cr>gv=gv", { silent = true })
map("v", "<M-k>", ":m '<-2<cr>gv=gv", { silent = true })

map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })

map("v", "p", '"_dP', { silent = true })

map({ "n", "v", "x" }, "<leader>sw", [[:s/\V]])
map({ "n", "v", "x" }, "<leader>n", ":norm ")
map("n", "<ESC>", ":nohl<CR>", { silent = true })

-- Files
map("n", "<leader>e", "<cmd>Oil<CR>", { silent = true })

-- Snippets
map({ "i", "s" }, "<C-e>", function() require("luasnip").expand_or_jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() require("luasnip").jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() require("luasnip").jump(-1) end, { silent = true })

-- FzfLua
map("n", "<leader>ff", fzflua["files"])
map("n", "<leader><leader>", fzflua["buffers"])
map("n", "<leader>fd", fzflua["diagnostics_document"])
map("n", "<leader>fD", fzflua["diagnostics_workspace"])
map("n", "<leader>fs", fzflua["live_grep"])
map("n", "<leader>fc", fzflua["lsp_document_symbols"])
map("n", "<leader>fw", fzflua["grep_cword"])
map("n", "<leader>fW", fzflua["grep_cWORD"])
map("n", "<leader>fk", fzflua["keymaps"])
map("n", "<leader>fg", fzflua["git_status"])
map("n", "<leader>fG", "<cmd>FzfLua git_commits<cr>", { silent = true })

-- Incremental selection (treesitter, falls back to LSP)
map({ "n", "x", "o" }, "<A-o>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end)

map({ "n", "x", "o" }, "<A-i>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end)

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
  desc = "Go To The Last Cursor Position",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    require("vim.hl").hl_op({ higroup = "Visual", timeout = 200 })
  end,
  desc = "Highlight when yanking",
})

vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
  desc = "Equalize splits on terminal resize",
})

vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Handle nvim-treesitter updates",
  pattern = "*/nvim-treesitter",
  callback = function(ev)
    if ev.data.kind == "install" or ev.data.kind == "update" then
      vim.schedule(function()
        vim.cmd("TSUpdate")
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "User: enable treesitter highlighting and folds",
  callback = function(details)
    local bufnr = details.buf
    if not pcall(vim.treesitter.start, bufnr) then
      return
    end
    vim.bo[bufnr].syntax = "on" -- Use regex based syntax-highlighting as fallback as some plugins might need it
    vim.wo.foldlevel = 99
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folds
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  once = true,
  callback = function()
    vim.cmd.packadd("render-markdown.nvim")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  once = true,
  callback = function()
    vim.cmd.packadd("typst-preview.nvim")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cs", "razor" },
  once = true,
  callback = function()
    vim.cmd.packadd("roslyn.nvim")
  end,
})
