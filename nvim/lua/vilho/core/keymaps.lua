vim.g.mapleader = " "

local keymap = vim.keymap   -- for conciseness

-- general keymaps

-- use jk or kj to exit insert mode 
keymap.set("i", "jk", "<ESC>")                  
keymap.set("i", "kj", "<ESC>")  

    

--  clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")      

--  delete single character without copying to register 
keymap.set("n", "x", '"_x')                     

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>")           --  increment
keymap.set("n", "<leader>-", "<C-x>")           --  decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v")         --  split window vertically
keymap.set("n", "<leader>sh", "<C-w>s")         --  split window horizontally
keymap.set("n", "<leader>se", "<C-w>=")         --  make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>")     --  close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>")    --  open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>")  --  close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>")      --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>")      --  go to previous tab

-- plugin keymaps

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
keymap.set("n", "<leader><tab>", ":NvimTreeFocus<CR>")

