-- Treesitter for parsing / syntax highlighting
--
-- The plugin's two branches target different Neovim versions and expose
-- completely different APIs:
--   * `main`   -- requires Neovim 0.12+ (uses vim.list.unique), installs its
--                 parsers *and* queries into stdpath("data")/site.
--   * `master` -- archived upstream, but the only branch that works on 0.11.x;
--                 ships its queries in-repo and uses the old configs.setup API.
-- Picking the wrong one silently breaks highlighting: the parser still loads,
-- but with no highlights.scm every buffer renders in plain Normal text (only
-- the languages Neovim bundles queries for, like c/lua, keep their colours).
-- So select the branch from the running Neovim version rather than hardcoding.
local has_012 = vim.fn.has("nvim-0.12") == 1

local languages = {
  "c", "cpp", "go", "python", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = has_012 and 'main' or 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      if has_012 then
        require("nvim-treesitter").install(languages)

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "c", "cpp", "go", "python", "lua", "vim", "help", "query", "markdown" },
          callback = function() pcall(vim.treesitter.start) end,
        })
      else
        require("nvim-treesitter.configs").setup {
          ensure_installed = languages,
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        }
      end
    end,
}
