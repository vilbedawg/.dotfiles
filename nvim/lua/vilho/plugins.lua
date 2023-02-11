-- Auto install packer if not installed 
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
  return
end

return packer.startup(function(use)

    use('wbthomason/packer.nvim')

    -- lua functions that many plugins use
    use('nvim-lua/plenary.nvim')

    -- Gruvbox theme
    use('ellisonleao/gruvbox.nvim')

    -- tmux & split window navigation
    use('christoomey/vim-tmux-navigator')

    -- maximizes and restores current window
    use('szw/vim-maximizer')
   
    -- essential plugins 
    use('tpope/vim-surround')
    use('vim-scripts/ReplaceWithRegister') 
    
    -- commenting with gc
    use('numToStr/Comment.nvim')

    -- file explorer
    use('nvim-tree/nvim-tree.lua')
    -- icons
    use('nvim-tree/nvim-web-devicons') 
    -- statusline
    use('nvim-lualine/lualine.nvim')  

    -- fuzzy finding w/telescope
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })  -- dependency for better sorting performance
    use({ 'nvim-telescope/telescope.nvim', branch = '0.1.x' })
    -- Remember to install ripgrep as well!
    
    -- autocompletion
    use('hrsh7th/nvim-cmp')     -- completion plugin
    use('hrsh7th/cmp-buffer')   -- source for text in buffer
    use('hrsh7th/cmp-path')     -- source for file system paths

    -- snippets
    use({
        'L3MON4D3/LuaSnip',
        -- follow latest release.
        tag = 'v1.*',
        -- install jsregexp (optional!:).
        run = 'make install_jsregexp'
    })
    use('saadparwaiz1/cmp_luasnip')     -- for autocompletion
    use('rafamadriz/friendly-snippets') -- useful snippets
        
    -- managing & installing lsp servers
    use('williamboman/mason.nvim')
    use('williamboman/mason-lspconfig.nvim')
    
    -- configuring lsp servers
    use('neovim/nvim-lspconfig')

    -- Automatically set up your configuration after cloning packer.nvim
    if packer_bootstrap then
        require('packer').sync()
    end
end)

