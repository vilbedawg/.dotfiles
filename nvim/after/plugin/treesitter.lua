local ensure_installed = {
    "c",
    "markdown",
    "markdown_inline",
    "vim",
    "vimdoc",
    "query",
    "bash",
    "diff",
    "comment",
    "editorconfig",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "javascript",
    "typescript",
    "tsx",
    "jsdoc",
    "yaml",
    "toml",
    "json",
    "lua",
    "luadoc",
    "python",
    "html",
    "css",
    "cpp",
    "dockerfile",
    "python",
    "tsx",
    "make",
    "cmake",
    "c_sharp",
    "markdown_inline",
    "tinymist",
}

require("nvim-treesitter").install(ensure_installed)

local filetypes = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable()

-- Enable treesitter for all installed languages
vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(ev)
        vim.treesitter.start(ev.buf)
    end,
})
