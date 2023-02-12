-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

vim.keymap.set("i", "jk", "<ESC>", { desc = "Change to normal mode" })
vim.keymap.set("i", "kj", "<ESC>", { desc = "Change to normal mode" })

vim.keymap.set(
    "n",
    "<leader>sx",
    require("telescope.builtin").resume,
    { noremap = true, silent = true, desc = "Resume" }
)
