local colorscheme = "gruvbox"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  print("colorscheme not found!")
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end
