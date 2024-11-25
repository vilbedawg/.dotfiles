return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    cond = vim.fn.getcwd():find(vim.fn.expand("~/Obsidian-notes"), 1, true) == 1, -- only enabled if in Obsidian notes directory
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required.
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      workspaces = {
        {
          name = "buf-parent",
          path = function()
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
        },
      },
      templates = {
        folder = "~/Obsidian-notes/templates",
      },

      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "telescope.nvim",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
      require("which-key").add({
        mode = { "n", "v" },
        { "<leader>o", group = "obsidian" },
        { "<leader>on", "<cmd>ObsidianNewFromTemplate<cr>", desc = "New note" },
        { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Apply template" },
        { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch workspace" },
        { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search" },
      })
    end,
  },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "toggle preview" },
    },
  },
}
