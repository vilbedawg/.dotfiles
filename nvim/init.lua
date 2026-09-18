vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.smartindent = true
vim.opt.signcolumn = "yes"
vim.opt.ignorecase = true
vim.opt.swapfile = false
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.wrap = false
vim.opt.scrolloff = 8 -- Keep 8 lines above and below the cursor
vim.opt.jumpoptions = "stack" -- Make <C-o>/<C-i> behave like browser back/forward
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append("-") -- hyphenated words recognized by searches
vim.opt.formatoptions:remove("c") -- don't auto-wrap comments using 'textwidth'
vim.o.statusline = "%<%f %h%w%m%r %{get(b:,'gitsigns_status','')}%=%-14.(%l,%c%V%) %P"

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/seblyng/roslyn.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/tpope/vim-surround" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/tpope/vim-rhubarb" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/blazkowolf/gruber-darker.nvim" },
  { src = "https://github.com/chentoast/marks.nvim" },
  { src = "https://github.com/meanderingprogrammer/render-markdown.nvim" },
})

require("mason").setup({
  registries = {
    "github:Crashdummyy/mason-registry", -- for Roslyn
    "github:mason-org/mason-registry",
  },
})

vim.cmd.colorscheme("gruber-darker")

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

local keymap = vim.keymap.set
local fzflua = require("fzf-lua")
local ls = require("luasnip")

fzflua.setup({
  file_ignore_patterns = {
    "node_modules/",
    "dist/",
    ".next/",
    ".git/",
    ".gitlab/",
    "build/",
    "target/",
    "package-lock.json",
    "pnpm-lock.yaml",
    "yarn.lock",
    "tsconfig.tsbuildinfo",
  },
})

local gitsigns = require("gitsigns")
gitsigns.setup({
  on_attach = function(bufnr)
    keymap("n", "]h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { buffer = bufnr })

    keymap("n", "[h", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { buffer = bufnr })

    keymap("n", "<leader>hs", gitsigns.stage_hunk, { buffer = bufnr })
    keymap("n", "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr })
    keymap("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { buffer = bufnr })
    keymap("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { buffer = bufnr })
    keymap("n", "<leader>hS", gitsigns.stage_buffer, { buffer = bufnr })
    keymap("n", "<leader>hR", gitsigns.reset_buffer, { buffer = bufnr })
    keymap("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end, { buffer = bufnr })
    keymap("n", "<leader>hd", gitsigns.diffthis, { buffer = bufnr })
    keymap("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end, { buffer = bufnr })
    keymap("n", "<leader>hQ", function()
      gitsigns.setqflist("all")
    end, { buffer = bufnr })
    keymap("n", "<leader>hq", gitsigns.setqflist, { buffer = bufnr })
  end,
})

ls.setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

require("blink.cmp").setup({
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

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach-config", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    local opts = { silent = true, buffer = bufnr }

    keymap({ "n", "v" }, "<leader>F", function() -- Format
      require("conform").format({ bufnr = args.buf })
    end, opts)

    keymap("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
    keymap("n", "gt", vim.lsp.buf.type_definition, opts) -- Go to type def
    keymap("n", "gr", vim.lsp.buf.references, opts) -- Go to type def
    keymap("n", "gi", vim.lsp.buf.implementation, opts) -- Go to implementation
    keymap("n", "gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts) -- Go to definition in split
    keymap("n", "<leader>r", vim.lsp.buf.rename, opts) -- Rename
    keymap("n", "K", vim.lsp.buf.hover, opts) -- Hover doc
    keymap("n", "<leader>vd", vim.diagnostic.open_float, opts) -- cursor diagnostics
    keymap("n", "<leader>vD", "<cmd>lua vim.diagnostic.open_float({ scope = 'line' })<CR>", opts) -- line diagnostics

    keymap("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts)
    keymap("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts)

    -- FzfLua LSP keymaps
    keymap("n", "<leader>ca", fzflua["lsp_code_actions"], opts) -- lsp code actions
    keymap("n", "<leader>fl", fzflua["lsp_finder"], opts) -- lsp finder (definitions + references)
    keymap("n", "<leader>fr", fzflua["lsp_references"], opts) -- show all references to symbol under cursor
    keymap("n", "<leader>ft", fzflua["lsp_typedefs"], opts) -- jump to the typedefs of symbol under cursor
    keymap("n", "<leader>ds", fzflua["lsp_document_symbols"], opts) -- list all symbols in file
    keymap("n", "<leader>ws", fzflua["lsp_workspace_symbols"], opts) -- search for symbol across entire project
    keymap("n", "<leader>fi", fzflua["lsp_implementations"], opts) -- go to implementation

    if client.name == "clangd" then
      keymap(
        "n",
        "<leader>ch",
        "<cmd>LspClangdSwitchSourceHeader<cr>",
        { buffer = bufnr, desc = "Switch source/header" }
      )
    end
  end,
})

vim.lsp.enable({
  "lua_ls",
  "cssls",
  "tinymist",
  "rust_analyzer",
  "clangd",
  "ts_ls",
  "emmet_language_server",
  "pyright",
  "roslyn",
  "jsonls",
  "yamlls",
  "marksman",
})

local opts = { silent = true }

keymap("n", "<leader>to", ":tabnew<CR>", opts)
keymap("n", "<leader>tx", ":tabclose<CR>", opts)
for i = 1, 8 do
  keymap({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

keymap("n", "x", '"_x', opts)

keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

keymap("n", "<leader>bd", ":bd<CR>", opts)
keymap("n", "<leader>bD", ":bd!<CR>", opts)
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

keymap("n", "<M-j>", "<cmd>m .+1<cr>==", opts)
keymap("n", "<M-k>", "<cmd>m .-2<cr>==", opts)
keymap("v", "<M-j>", ":m '>+1<cr>gv=gv", opts)
keymap("v", "<M-k>", ":m '<-2<cr>gv=gv", opts)

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("v", "p", '"_dP', opts)

keymap({ "n", "v", "x" }, "<leader>sw", [[:s/\V]], { desc = "Enter substitue mode in selection" })
keymap({ "n", "v", "x" }, "<leader>n", ":norm ", { desc = "ENTER NORM COMMAND." })
keymap("n", "<ESC>", ":nohl<CR>", { noremap = true, silent = true })

keymap("n", "<leader>e", "<cmd>Oil<CR>")

keymap({ "i", "s" }, "<C-e>", function()
  ls.expand_or_jump(1)
end, { silent = true })
keymap({ "i", "s" }, "<C-J>", function()
  ls.jump(1)
end, { silent = true })
keymap({ "i", "s" }, "<C-K>", function()
  ls.jump(-1)
end, { silent = true })

keymap("n", "<leader>ff", fzflua["files"])
keymap("n", "<leader><leader>", fzflua["buffers"])
keymap("n", "<leader>fd", fzflua["diagnostics_document"])
keymap("n", "<leader>fD", fzflua["diagnostics_workspace"])
keymap("n", "<leader>fs", fzflua["live_grep"])
keymap("n", "<leader>fc", fzflua["grep_curbuf"])
keymap("n", "<leader>fw", fzflua["grep_cword"])
keymap("n", "<leader>fW", fzflua["grep_cWORD"])
keymap("n", "<leader>fk", fzflua["keymaps"])
keymap("n", "<leader>fg", fzflua["git_status"], opts)

keymap("n", "<leader>gg", "<cmd>leftabove vertical Git<cr>", { silent = true })
keymap("n", "<leader>ga", "<cmd>Git add %:p<cr><cr>", { silent = true })
keymap("n", "<leader>gd", "<cmd>Gdiff<cr>", { silent = true })
keymap("n", "<leader>ge", "<cmd>Gedit<cr>", { silent = true })
keymap("n", "<leader>gw", "<cmd>Gwrite<cr>", { silent = true })
keymap("n", "<leader>gf", "<cmd>FzfLua git_commits<cr>", { silent = true })
keymap("n", "<leader>gb", function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "fugitiveblame" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  vim.cmd("G blame")
end, { silent = true, desc = "Toggle git blame" })

-- incremental selection treesitter/lsp
keymap({ "n", "x", "o" }, "<A-o>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

keymap({ "n", "x", "o" }, "<A-i>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

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

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  desc = "Reload files changed outside of nvim",
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
  pattern = "typst",
  once = true,
  callback = function()
    vim.pack.add({ { src = "https://github.com/chomosuke/typst-preview.nvim" } })
  end,
})

-- PR review: `:Gh <subcommand> [body]`, active only on branches created by pr-review-picker.sh.
-- No network calls for metadata: the worktree's HEAD is the PR's head commit, the repo slug
-- comes from the origin remote, and the description is the file pr-review-picker.sh already
-- cached to disk. A visual range targets an inline comment on the current file; no range means
-- a top-level PR comment.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local branch = vim.trim(vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"))
    local pr_number = branch:match("^pr%-review%-(%d+)$")
    if not pr_number then
      return
    end

    local remote_url = vim.trim(vim.fn.system("git remote get-url origin"))
    local repo = remote_url:match("github%.com[:/](.+)"):gsub("%.git$", "")
    local head_sha = vim.trim(vim.fn.system("git rev-parse HEAD"))
    local cache_file = vim.fn.expand("~/.cache/pr-review-picker/pr-" .. pr_number .. ".md")

    local function run(cmd)
      vim.system(cmd, { text = true }, function(res)
        vim.schedule(function()
          local msg = res.code == 0 and "ok" or res.stderr
          vim.notify(msg, res.code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR, { title = "gh " .. cmd[2] })
        end)
      end)
    end

    vim.api.nvim_create_user_command("Gh", function(opts)
      local args = vim.split(opts.args, " ", { trimempty = true })
      local subcmd = table.remove(args, 1)
      local body = table.concat(args, " ")

      if subcmd == "view" then
        vim.cmd.tabedit(vim.fn.fnameescape(cache_file))
      elseif subcmd == "comment" and opts.range > 0 then
        local cmd = {
          "gh",
          "api",
          string.format("repos/%s/pulls/%s/comments", repo, pr_number),
          "-f",
          "path=" .. vim.fn.expand("%:."),
          "-f",
          "commit_id=" .. head_sha,
          "-f",
          "body=" .. body,
          "-f",
          "side=RIGHT",
          "-F",
          "line=" .. opts.line2,
        }
        if opts.line1 ~= opts.line2 then
          vim.list_extend(cmd, { "-F", "start_line=" .. opts.line1, "-f", "start_side=RIGHT" })
        end
        run(cmd)
      elseif subcmd == "comment" then
        run({ "gh", "pr", "comment", pr_number, "--body", body })
      elseif subcmd == "approve" then
        local cmd = { "gh", "pr", "review", pr_number, "--approve" }
        if body ~= "" then
          vim.list_extend(cmd, { "--body", body })
        end
        run(cmd)
      elseif subcmd == "request-changes" then
        run({ "gh", "pr", "review", pr_number, "--request-changes", "--body", body })
      elseif subcmd == "review" then
        run({ "gh", "pr", "review", pr_number, "--comment", "--body", body })
      else
        vim.notify("unknown :Gh subcommand: " .. tostring(subcmd), vim.log.levels.ERROR)
      end
    end, {
      nargs = "*",
      range = true,
      complete = function(arglead)
        return vim.tbl_filter(function(c)
          return c:find(arglead, 1, true) == 1
        end, { "view", "comment", "approve", "request-changes", "review" })
      end,
    })
  end,
})
