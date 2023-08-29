return {
  'mrcjkb/haskell-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim', -- Optional
  },
  branch = '2.x.x', -- Recommended
  -- init = function() -- Optional, see Advanced configuration
  --   vim.g.haskell_tools = {
  --     -- ...
  --   },
  -- end,
  ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
  
}
