-- Treesitter for parsing / syntax highlighting
return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
	ensure_installed = { "c","cpp", "go", "python", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
}
