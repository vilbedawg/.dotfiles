-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Splits
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split vertically" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Split horizontally" })
keymap("n", "<leader>we", "<C-w>=", { desc = "Set windows equal width & height" })
keymap("n", "<leader>wx", ":close<CR>", { desc = "Close split" })
keymap("n", "<leader>to", ":tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader>tn", ":tabn<CR>", { desc = "Next tab" })
keymap("n", "<leader>tp", ":tabp<CR>", { desc = "Previous tab" })
keymap("n", "<leader>nh", ":nohl<CR>", { desc = "Clear highlights" })

-- delete single character without copying to register
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
keymap("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
keymap("n", "<leader>bD", ":bd!<CR>", { desc = "Close buffer (force)" })

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
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "File tree" })

-- Telescope
keymap("n", "<leader>:", "<cmd>Telescope command_history<cr>", { desc = "Command history" })
keymap("n", "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", { desc = "Switch buffer" })

-- Find
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Grep" })
keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Grep word" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help pages" })
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent" })
keymap("n", "<leader>fx", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })

-- git
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Commits" })
keymap("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Status" })
keymap("n", "<leader>gg", "<cmd>G<CR>", { desc = "Git menu" })


-- search
keymap("n", "<leader>sa", "<cmd>Telescope autocommands<cr>", { desc = "Auto commands" })
keymap("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer" })
keymap("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
keymap("n", "<leader>sH", "<cmd>Telescope highlights<cr>", { desc = "Search highlight groups" })
keymap("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Key maps" })
keymap("n", "<leader>sM", "<cmd>Telescope man_pages<cr>", { desc = "Man pages" })
keymap("n", "<leader>sm", "<cmd>Telescope marks<cr>", { desc = "Jump to mark" })
keymap("n", "<leader>so", "<cmd>Telescope vim_options<cr>", { desc = "Options" })
keymap("n", "<leader>sR", "<cmd>Telescope resume<cr>", { desc = "Resume" })

-- restore the session for the current directory
keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], { desc = "Restore current session" })

-- restore the last session
keymap(
  "n",
  "<leader>ql",
  [[<cmd>lua require("persistence").load({ last = true })<cr>]],
  { desc = "Restore last session" }
)
-- stop Persistence => session won't be saved on exit
keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], { desc = "Stop persistence from saving" })

keymap("n", "<leader>F", ":Format<cr>", { desc = "Format", noremap = true })

keymap("n", "<leader>sw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word"})
