return {
  "sainnhe/gruvbox-material",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000,
  config = function()
    vim.cmd([[
      " https://github.com/sainnhe/gruvbox-material/blob/master/doc/gruvbox-material.txt
      " Important!!
      " For dark version.
      set background=dark
      " Set contrast.
      " This configuration option should be placed before `colorscheme gruvbox-material`.
      " Available values: 'hard', 'medium'(default), 'soft'
      let g:gruvbox_material_background = "medium"
      let g:gruvbox_material_foreground = "material"

      " For better performance
      let g:gruvbox_material_better_performance = 1

      let g:gruvbox_material_diagnostic_text_highlight = 1
      let g:gruvbox_material_diagnostic_line_highlight = 1
      let g:gruvbox_material_diagnostic_virtual_text = "colored"
      let g:gruvbox_material_sign_column_background = "none"

      colorscheme gruvbox-material
      ]])
  end,
}
