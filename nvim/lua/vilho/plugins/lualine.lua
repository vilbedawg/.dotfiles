return {
  -- Lualine
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  config = function()
    require("lualine").setup({
      options = {
        component_separators = { right = "" },
        section_separators = { left = "", right = "" },
        theme = "auto",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          {
            "filetype",
            colored = true, -- Displays filetype icon in color if set to true
            icon_only = true, -- Display only an icon for filetype
          },
          {
            "filename",
            file_status = true,
            path = 1,
            symbols = {
              modified = " ", -- Text to show when the file is modified.
              readonly = "[readonly]", -- Text to show when the file is non-modifiable or readonly.
              unnamed = "[No Name]", -- Text to show for unnamed buffers.
            },
          },
        },
        lualine_d = {},
        lualine_w = {},
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { },
        lualine_z = { "location" },
      },
    })
  end
}
