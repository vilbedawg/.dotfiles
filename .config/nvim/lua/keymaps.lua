-- Shorten function name
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("", "<Space>", "<Nop>", opts)

-- Splits
keymap("n", "<leader>wv", "<C-w>v", opts)
keymap("n", "<leader>wh", "<C-w>s", opts)
keymap("n", "<leader>we", "<C-w>=", opts)
keymap("n", "<leader>wx", ":close<CR>", opts)
keymap("n", "<leader>to", ":tabnew<CR>", opts)
keymap("n", "<leader>tx", ":tabclose<CR>", opts)
keymap("n", "<leader>tn", ":tabn<CR>", opts)
keymap("n", "<leader>tp", ":tabp<CR>", opts)
keymap("n", "<leader>nh", ":nohl<CR>", opts)

-- delete single character without copying to register
keymap("n", "x", '"_x', opts)

-- better up/down
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, noremap = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, noremap = true })

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
keymap("n", "<leader>bd", ":bd<CR>", opts)
keymap("n", "<leader>bD", ":bd!<CR>", opts)
keymap("n", "<S-l>", ":bNext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
-- keymap("n", "<leader>bda", ":%bd|e#<CR>", opts) -- Delete all except this buffer

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

-- restore the session for the current directory
keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], opts)

-- restore the last session
keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], opts)
-- stop Persistence => session won't be saved on exit
keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], opts)

-- Replace word
keymap("n", "<leader>sw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)

-- soft reload config file
keymap({ 'n', 'v' }, '<leader>CU', ':update<CR> :source<CR>')

-- File explorer
keymap("n", "<leader>e", [[<cmd>lua require("oil").toggle_float()<CR>]], { noremap = true, silent = true })

local function fzf_vertical(command)
    return function()
        require("fzf-lua")[command]({
            winopts = {
                preview = {
                    layout = "vertical",
                },
            },
        })
    end
end

-- fzf
keymap("n", "<leader>ff", '<cmd>FzfLua files<CR>')
keymap("n", "<leader>fb", '<cmd>FzfLua buffers<CR>')
keymap("n", "<leader>fd", '<cmd>FzfLua diagnostics_document<CR>')
keymap("n", "<leader>fD", '<cmd>FzfLua diagnostics_workspace<CR>')
keymap("n", "<leader>fs", '<cmd>FzfLua spell_suggest<CR>')
keymap("n", "<leader>fo", '<cmd>FzfLua resume<CR>')

keymap("n", "<leader>fg", fzf_vertical('live_grep'))
keymap("n", "<leader>fc", fzf_vertical('grep_curbuf'))
keymap("n", "<leader>fr", fzf_vertical('lsp_references'))
keymap("n", "<leader>fw", fzf_vertical('grep_cword'))
keymap("n", "<leader>fW", fzf_vertical('grep_cWORD'))
keymap("n", "<leader>fk", fzf_vertical('keymaps'))

-- LSP
keymap('n', '<leader>F', vim.lsp.buf.format)
keymap("i", "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
keymap({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
keymap({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
