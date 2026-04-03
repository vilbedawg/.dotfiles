-- Shorten function name
local keymap = vim.keymap.set
local opts = { silent = true }

keymap("", "<Space>", "<Nop>", opts)

-- Splits
keymap("n", "<leader>wv", "<C-w>v", opts)
keymap("n", "<leader>wh", "<C-w>s", opts)
keymap("n", "<leader>we", "<C-w>=", opts)
keymap("n", "<leader>wx", ":close<CR>", opts)
keymap("n", "<leader>to", ":tabnew<CR>", opts)
keymap("n", "<leader>tx", ":tabclose<CR>", opts)
keymap("n", "<leader>tl", ":tabn<CR>", opts)
keymap("n", "<leader>th", ":tabp<CR>", opts)

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
keymap("n", "<leader>bd", ":bd<CR>", opts)
keymap("n", "<leader>bD", ":bd!<CR>", opts)
keymap("n", "<S-l>", ":bNext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move Lines
keymap("n", "<M-j>", "<cmd>m .+1<cr>==", opts)
keymap("n", "<M-k>", "<cmd>m .-2<cr>==", opts)
keymap("v", "<M-j>", ":m '>+1<cr>gv=gv", opts)
keymap("v", "<M-k>", ":m '<-2<cr>gv=gv", opts)

-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better yank insert
keymap("v", "p", '"_dP', opts)

-- Substitute
keymap({ "n", "v", "x" }, "<leader>sw", [[:s/\V]], { desc = "Enter substitue mode in selection" })

-- soft reload config file
keymap({ "n", "v" }, "<leader>CU", ":update<CR> :source<CR>")

-- File explorer
keymap("n", "<leader>e", "<cmd>Oil<CR>")

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
keymap("n", "<leader>ff", "<cmd>FzfLua files<CR>")
keymap("n", "<leader>fb", "<cmd>FzfLua buffers<CR>")
keymap("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>")
keymap("n", "<leader>fD", "<cmd>FzfLua diagnostics_workspace<CR>")
keymap("n", "<leader>fo", "<cmd>FzfLua resume<CR>")

keymap("n", "<leader>fs", fzf_vertical("live_grep"))
keymap("n", "<leader>fc", fzf_vertical("grep_curbuf"))
keymap("n", "<leader>fw", fzf_vertical("grep_cword"))
keymap("n", "<leader>fW", fzf_vertical("grep_cWORD"))
keymap("n", "<leader>fk", fzf_vertical("keymaps"))

-- vim.pack
local function pack_clean()
    local active_plugins = {}
    local unused_plugins = {}

    for _, plugin in ipairs(vim.pack.get()) do
        active_plugins[plugin.spec.name] = plugin.active
    end

    for _, plugin in ipairs(vim.pack.get()) do
        if not active_plugins[plugin.spec.name] then
            table.insert(unused_plugins, plugin.spec.name)
        end
    end

    if #unused_plugins == 0 then
        print("No unused plugins.")
        return
    end

    local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
    if choice == 1 then
        vim.pack.del(unused_plugins)
    end
end

local function pack_update()
    local plugins = {}
    for _, plugin in ipairs(vim.pack.get()) do
        table.insert(plugins, plugin.spec.name)
    end

    vim.pack.update(plugins)
end

keymap("n", "<leader>pc", pack_clean)
keymap("n", "<leader>pu", pack_update)

keymap({ "n" }, "<leader>w", "<Cmd>update<CR>", { desc = "Write the current buffer." })
keymap({ "n" }, "<leader>q", "<Cmd>:quit<CR>", { desc = "Quit the current buffer." })
keymap({ "n" }, "<leader>Q", "<Cmd>:wqa<CR>", { desc = "Quit all buffers and write." })
keymap({ "n", "v", "x" }, "<leader>n", ":norm ", { desc = "ENTER NORM COMMAND." })
keymap("n", "<leader>ch", ":nohl<CR>", opts)


-- Fugitive
vim.keymap.set("n", "<leader>gg", "<cmd>leftabove vertical Git<cr>", {silent = true})
vim.keymap.set("n", "<leader>ga", "<cmd>Git add %:p<cr><cr>", {silent = true})
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiff<cr>", {silent = true})
vim.keymap.set("n", "<leader>ge", "<cmd>Gedit<cr>", {silent = true})
vim.keymap.set("n", "<leader>gw", "<cmd>Gwrite<cr>", {silent = true})
vim.keymap.set("n", "<leader>gf", "<cmd>FzfLua git_commits<cr>", {silent = true})
vim.keymap.set("n", "<leader>gb", function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "fugitiveblame" then
            vim.api.nvim_win_close(win, false)
            return
        end
    end
    vim.cmd("G blame")
end, { silent = true, desc = "Toggle git blame" })
