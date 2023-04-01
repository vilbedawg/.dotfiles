-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader= " "

-- Splits
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split Vertically"} )
keymap("n", "<leader>wh", "<C-w>s", { desc = "Split Horizontally"} )
keymap("n", "<leader>we", "<C-w>=", { desc = "Set Windows Equal Width & Height"} )
keymap("n", "<leader>wx", ":close<CR>", { desc = "Close Split"} )
keymap("n", "<leader>to", ":tabnew<CR>", { desc = "New Tab"} )
keymap("n", "<leader>tx", ":tabclose<CR>", { desc = "Close Tab"} )
keymap("n", "<leader>tn", ":tabn<CR>", { desc = "Next Tab"} )
keymap("n", "<leader>tp", ":tabp<CR>", { desc = "Previous Tab"} )

keymap("n", "<leader>nh", ":nohl<CR>", { desc = "Clear Highlights"} )

--  delete single character without copying to register 
keymap("n", "x", '"_x', opts)

-- better up/down
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize window using <ctrl> arrow keys
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", opts)
keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", opts)
keymap("n", "<leader>bd", ":bd<CR>", { desc = "Close Buffer" })
keymap("n", "<leader>bD", ":bd!<CR>", { desc = "Close Buffer (force)" })


-- Move Lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", opts)
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", opts)
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", opts)
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", opts)
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", opts)
keymap("x", "<A-j>", ":m '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":m '<-2<CR>gv-gv", opts)

-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better yank insert
keymap("v", "p", '"_dP', opts)

-- nvim-tree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "File Tree"})

-- Telescope
keymap("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command History" } )
keymap("n", "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", { desc = "Switch Buffer" })

-- Find
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files"} )
keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Grep"} )
keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Grep Word"} )
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers"} )
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Pages"} )
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent"} )

-- git
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "commits" })
keymap("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "status" })

-- -- search
keymap("n", "<leader>sa", "<cmd>Telescope autocommands<cr>", { desc = "Auto Commands" } )
keymap("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer"  })
keymap("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics"  })
keymap("n", "<leader>sH", "<cmd>Telescope highlights<cr>", { desc = "Search Highlight Groups"  })
keymap("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps"  })
keymap("n", "<leader>sM", "<cmd>Telescope man_pages<cr>", { desc = "Man Pages"  })
keymap("n", "<leader>sm", "<cmd>Telescope marks<cr>", { desc = "Jump to Mark"  })
keymap("n", "<leader>so", "<cmd>Telescope vim_options<cr>", { desc = "Options"  })
keymap("n", "<leader>sR", "<cmd>Telescope resume<cr>", { desc = "Resume"  })

-- restore the session for the current directory
keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], { desc = "Restore Current Session"})
-- restore the last session
keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], { desc = "Restore Last Session"})
-- stop Persistence => session won't be saved on exit
keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], { desc = "Stop Persistence From Saving"})
