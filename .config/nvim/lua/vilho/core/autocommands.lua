local fn = vim.fn

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- General Settings
local general = augroup("General", { clear = true })

autocmd("BufReadPost", {
  callback = function()
    if fn.line("'\"") > 1 and fn.line("'\"") <= fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
  group = general,
  desc = "Go To The Last Cursor Position",
})

autocmd("TextYankPost", {
  callback = function()
    require("vim.highlight").on_yank({ higroup = "Visual", timeout = 200 })
  end,
  group = general,
  desc = "Highlight when yanking",
})

-- autocmd("FileType", {
--   pattern = { "c", "cpp", "py", "java", "cs" },
--   callback = function()
--     vim.bo.shiftwidth = 4
--   end,
--   group = general,
--   desc = "Set shiftwidth to 4 in these filetypes",
-- })
