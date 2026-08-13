-- Treesitter for parsing / syntax highlighting
return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'main',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install {
        "c", "cpp", "go", "python", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "go", "python", "lua", "vim", "help", "query", "markdown" },
        callback = function() vim.treesitter.start() end,
      })
    end,
}
