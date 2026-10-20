vim.g.mapleader, vim.g.maplocalleader = " ", " "

local opts = {
  smartindent = true, expandtab = true, tabstop = 4, softtabstop = 4,
  shiftwidth = 4, shiftround = true, ignorecase = true, swapfile = false,
  undofile = true, autoread = true, signcolumn = "yes", number = true,
  relativenumber = true, numberwidth = 2, wrap = false, scrolloff = 8,
  clipboard = "unnamedplus", jumpoptions = "stack",
  shada = "!,'100,<50,s10,h,:1000,/1000",
}

for name, value in pairs(opts) do
  vim.opt[name] = value
end

vim.opt.shortmess:append("c")
vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove("c")
vim.o.statusline = "%t %h%w%m%r %{get(b:,'gitsigns_status','')}%=%-14.(%l,%c%V%) %P"

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
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/vague-theme/vague.nvim" },
  { src = "https://github.com/chentoast/marks.nvim" },
})

local function noop() end
vim.pack.add({
  { src = "https://github.com/meanderingprogrammer/render-markdown.nvim" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
  { src = "https://github.com/seblyng/roslyn.nvim" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
}, { load = noop })

vim.cmd.colorscheme("vague")

require("oil").setup()

require("marks").setup({ builtin_marks = { "<", ">", "^" } })

require("conform").setup({
  default_format_opts = { lsp_format = "fallback" },
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

local fzf_setup_done = false
local function fzf(picker)
  return function(...)
    local fzflua = require("fzf-lua")
    if not fzf_setup_done then
      fzf_setup_done = true
      fzflua.setup({
        defaults = { formatter = "path.filename_first" },
        file_ignore_patterns = {
          "node_modules/", "dist/", ".next/", ".git/", ".gitlab/", "build/",
          "target/", "package-lock.json", "pnpm-lock.yaml", "yarn.lock",
          "tsconfig.tsbuildinfo",
        },
      })
    end
    return fzflua[picker](...)
  end
end

local gitsigns = require("gitsigns")
gitsigns.setup({
  on_attach = function(bufnr)
    local function hunk_nav(dir)
      return function()
        if vim.wo.diff then
          vim.cmd.normal({ dir == 1 and "]c" or "[c", bang = true })
        else
          gitsigns.nav_hunk(dir == 1 and "next" or "prev")
        end
      end
    end
    map("n", "]h", hunk_nav(1), { buffer = bufnr })
    map("n", "[h", hunk_nav(-1), { buffer = bufnr })
    map("n", "<leader>hd", gitsigns.diffthis, { buffer = bufnr })
    map("n", "<leader>hq", gitsigns.setqflist, { buffer = bufnr })
    map("n", "<leader>hs", gitsigns.stage_hunk, { buffer = bufnr })
    map("n", "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr })
    map("n", "<leader>hS", gitsigns.stage_buffer, { buffer = bufnr })
    map("n", "<leader>hR", gitsigns.reset_buffer, { buffer = bufnr })
    map("n", "<leader>hD", function() gitsigns.diffthis("~") end, { buffer = bufnr })
    map("n", "<leader>hQ", function() gitsigns.setqflist("all") end, { buffer = bufnr })
    map("n", "<leader>hB", "<cmd>Gitsigns blame<cr>", { buffer = bufnr, silent = true })
    map("n", "<leader>hc", "<cmd>Gitsigns show_commit<cr>", { buffer = bufnr, silent = true })
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
    vim.cmd.packadd("LuaSnip")
    require("luasnip").setup({ enable_autosnippets = true })
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach-config", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    local lsp_opts = { silent = true, buffer = bufnr }

    map({ "n", "v" }, "<leader>F", function() require("conform").format({ bufnr = args.buf }) end, lsp_opts)
    map("n", "gd", vim.lsp.buf.definition, lsp_opts)
    map("n", "gt", vim.lsp.buf.type_definition, lsp_opts)
    map("n", "gr", vim.lsp.buf.references, lsp_opts)
    map("n", "gi", vim.lsp.buf.implementation, lsp_opts)
    map("n", "gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", lsp_opts)
    map("n", "<leader>r", vim.lsp.buf.rename, lsp_opts)
    map("n", "K", vim.lsp.buf.hover, lsp_opts)
    map("n", "<leader>vd", vim.diagnostic.open_float, lsp_opts)
    map("n", "<leader>vD", "<cmd>lua vim.diagnostic.open_float({ scope = 'line' })<CR>", lsp_opts)

    map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, lsp_opts)
    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, lsp_opts)

    map("n", "<leader>ca", fzf("lsp_code_actions"), lsp_opts)
    map("n", "<leader>fl", fzf("lsp_finder"), lsp_opts)
    map("n", "<leader>fr", fzf("lsp_references"), lsp_opts)
    map("n", "<leader>ft", fzf("lsp_typedefs"), lsp_opts)
    map("n", "<leader>ds", fzf("lsp_document_symbols"), lsp_opts)
    map("n", "<leader>ws", fzf("lsp_workspace_symbols"), lsp_opts)
    map("n", "<leader>fi", fzf("lsp_implementations"), lsp_opts)

    if client.name == "clangd" then
      map("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", lsp_opts)
    end
  end,
})

vim.lsp.enable({
  "lua_ls", "tinymist", "clangd", "vtsls",
  "pyright", "yamlls", "marksman", "postgres_lsp",
  "rust_analyzer", "cssls", "jsonls", "terraformls",
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
map("n", "<leader>ff", fzf("files"))
map("n", "<leader><leader>", fzf("buffers"))
map("n", "<leader>fd", fzf("diagnostics_document"))
map("n", "<leader>fD", fzf("diagnostics_workspace"))
map("n", "<leader>fs", fzf("live_grep"))
map("n", "<leader>fc", fzf("lsp_document_symbols"))
map("n", "<leader>fw", fzf("grep_cword"))
map("n", "<leader>fW", fzf("grep_cWORD"))
map("n", "<leader>fk", fzf("keymaps"))
map("n", "<leader>fg", fzf("git_status"))
map("n", "<leader>fG", fzf("git_commits"))

-- Incremental selection (treesitter, falls back to LSP)
local function ts_or_lsp_select(direction)
  return function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
      local select = direction > 0
        and require("vim.treesitter._select").select_parent
        or require("vim.treesitter._select").select_child
      select(vim.v.count1)
    else
      vim.lsp.buf.selection_range(direction * vim.v.count1)
    end
  end
end

vim.keymap.set({ "n", "x", "o" }, "<A-o>", ts_or_lsp_select(1))
vim.keymap.set({ "n", "x", "o" }, "<A-i>", ts_or_lsp_select(-1))

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

for ft, plugin in pairs({
  markdown = "render-markdown.nvim",
  typst = "typst-preview.nvim",
  cs = "roslyn.nvim",
}) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    once = true,
    callback = function()
      vim.cmd.packadd(plugin)
    end,
  })
end
