local colors_status_ok, colors = pcall(require, "lsp-colors")

if (not colors_status_ok) then
  print("LSP colors not installed!")
  return
end

colors.setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#10bbbb",
  Hint = "#906fbb"
})
