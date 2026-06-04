local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Download latest stable relase from lazy.nvim if it does not exist
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Configs
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

vim.opt.expandtab = true        -- use spaces instead of tabs
vim.opt.shiftwidth = 2          -- spaces per tab
vim.opt.tabstop = 2             -- number of spaces a tab counts for
vim.opt.smartindent = true      -- auto-indent new lines

vim.opt.ignorecase = true       -- ignore case in search
vim.opt.smartcase = true        -- but case-sensitive if uppercase used
vim.opt.incsearch = true        -- show search matches as you type
vim.opt.hlsearch = true         -- highlight search matches

vim.opt.termguicolors = true    -- enable 24-bit colors
vim.opt.cursorline = true       -- highlight current line
vim.opt.signcolumn = "yes"      -- show gutter signs (git, LSP diagnostics)
vim.opt.scrolloff = 8           -- keep cursor away from edges
vim.opt.updatetime = 300        -- faster updates for LSP / CursorHold
vim.opt.splitright = true       -- vertical splits open to the right
vim.opt.splitbelow = true       -- horizontal splits open below
vim.opt.hidden = true           -- allow buffer switching without saving
vim.opt.wrap = false             -- no line wrap

vim.opt.mouse = "a"             -- enable mouse in all modes
vim.opt.showmode = false        -- lualine already shows mode

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

vim.opt.fillchars = { eob = " " }
-- vim.opt.list = true
-- vim.opt.listchars = { tab = "│ ", trail = "·" }
vim.opt.lazyredraw = true

-- From auto-session
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Enable per project scripts
vim.o.exrc = true
vim.o.secure = true

vim.opt.undofile = true -- persistant undo

vim.o.winborder='rounded' -- border style

vim.opt.showtabline = 2
-- vim.opt.tabline="%t"

vim.opt.cmdheight = 0

function leave_snippet()
    if
        ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
        and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require('luasnip').session.jump_active
    then
        require('luasnip').unlink_current()
    end
end

-- stop snippets when you leave to normal mode
vim.api.nvim_command([[
    autocmd ModeChanged * lua leave_snippet()
]])

require("lazy").setup({

   { import = "plugins.treesitter" },
   { import = "plugins.mason" },
   { import = "plugins.lsp" },
   { import = "plugins.cmp" },
   { import = "plugins.telescope" },
   { import = "plugins.toggleterm" },
   { import = "plugins.lualine" },
   { import = "plugins.autopairs" },
   { import = "plugins.comment" },
   { import = "plugins.indentblankline" },
   { import = "plugins.autosession" },
   { import = "plugins.gitsigns" },
   { import = "plugins.whichkey" },
   { import = "plugins.tiny-inline-diag" },
   { import = "plugins.incline" },
   { import = "plugins.yazi" },
   { import = "plugins.bufdelete" },
   { import = "plugins.vim-tmux-navigator" },
   { import = "plugins.colorizer" },
   { import = "plugins.yazi" },
   { import = "plugins.markdown" },
   { import = "plugins.render-markdown" },

   { import = "themes" },
   { import = "plugins.themery" }
})

-- Override lualine's laststatus
vim.opt.laststatus = 3
vim.cmd([[set laststatus=3]])
