local set = vim.opt -- For conciseness

-- Line numbers
set.relativenumber = true
set.number = true

-- Tabs and indentation
set.tabstop = 4
set.shiftwidth = 4
set.expandtab = true
set.autoindent = true

-- line wrapping
set.ignorecase = true
set.smartcase = true

-- appearance
set.termguicolors = true
set.background = "dark"
set.signcolumn = "yes"

-- backspace 
set.backspace = "indent,eol,start"

-- clipboard
set.clipboard:append("unnamedplus")

--split windows
set.splitright = true
set.splitbelow = true

set.iskeyword:append("-") -- consider string-string as whole word
