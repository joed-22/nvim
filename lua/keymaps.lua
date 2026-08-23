local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "

-- --- General mappings ---
map('n', '<leader>w', ':w<CR>', opts)  -- save
map('n', "<C-s>", ':w<CR>', opts) -- save
map('n', '<leader>w', ':w<CR>', opts)  -- save

map('n', '<ESC>', ':nohl<CR>', opts)  -- clear highlight

vim.keymap.set("n", "<leader>pp", function() --copy file path name
  vim.fn.setreg("+", vim.fn.expand("%:."))
  print(vim.fn.expand("%:."))
end, { desc = "Copy file path (relative to cwd)" })

map('n', 'vs', ':vsplit<CR>', opts)  -- open a new vertical tab

vim.keymap.set("n", "<leader>f/", "/<C-r><C-w><Cr>", { silent = false, desc = "Search word in file" })

-- --- window navigation ---
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Move to left window from terminal" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Move to below window from terminal" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Move to above window from terminal" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Move to right window from terminal" })

-- --- Telescope ---
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts)
map('n', '<leader>fw', '<cmd>Telescope live_grep<cr>', opts)
map('n', '<leader>fb', '<cmd>Telescope buffers initial_mode=normal<cr>', opts)
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opts)
map('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>', opts)
map('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>', opts)
map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<cr>', opts)
map('n', '<leader>fc', '<cmd>Telescope grep_string initial_mode=normal<cr>', opts)
map('n', '<leader>gt', '<cmd>Telescope git_status initial_mode=normal<cr>', opts)

-- --- LSP ---
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "List references" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

vim.keymap.set('n', 'K', function() require('hoverdoc').hover() end, { desc = "Hover Documentation" })
vim.api.nvim_create_user_command('Doc', function(o) require('hoverdoc').lookup(o.args) end, { nargs = '?' })

-- --- Diagnostics via Tiny-inline-diagnostics ---
vim.keymap.set("n", "<leader>dd", ":TinyInlineDiag toggle<CR>", { silent = true, desc = "Show diagnostics"})

-- --- Terminal ---
local term = require("plugins.terminal")

local toggle_float = "<A-i>"
local toggle_horiz = "<A-h>"

vim.keymap.set("n", toggle_float, function() term.float_term:toggle() end, { desc = "Floating terminal" })
vim.keymap.set("n", toggle_horiz, function() term.horiz_term:toggle() end, { desc = "Horizontal terminal" })
vim.keymap.set("t", toggle_float, function() term.float_term:toggle() end, { desc = "Floating terminal" })
vim.keymap.set("t", toggle_horiz, function() term.horiz_term:toggle() end, { desc = "Horizontal terminal" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- --- Bufferline (tabs) ---
-- vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer/tab" })
-- vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Previous buffer/tab" })
-- vim.keymap.set("n", "<leader>x", ":Bdelete<CR>", { silent = true, desc = "Close buffer" })
--
-- vim.keymap.set("n", "<leader>X", ":BufferLineCloseOthers<CR>", { silent = true, desc = "Close buffer" })
-- vim.keymap.set("n", "<leader>b", ":BufferLinePick<CR>", { silent = true, desc = "Select buffer" })

-- --- GitSigns ---
local gs = require("gitsigns")
vim.keymap.set("n", "<leader>gb", function ()
  gs.blame_line({ full = true })
end, {desc = "full line git blame"})

vim.keymap.set("n", "<leader>gB", function ()
  gs.toggle_current_line_blame()
end, {desc = "toggle inline git blame"})

vim.keymap.set('n', '<leader>sh', gs.stage_hunk, { desc = " Stage Git Hunk" })
vim.keymap.set("n", "<leader>rh", gs.reset_hunk, { desc = "Reset Git Hunk" })
vim.keymap.set("n", "<leader>ph", gs.preview_hunk, { desc = "Preview Git Hunk" })
vim.keymap.set('n', '<leader>Ph', gs.preview_hunk_inline, { desc = "Preview Git Hunk Inline" })

vim.keymap.set("n", "]c", function()
  require("gitsigns").next_hunk()
end, { desc = "Next git hunk" })

vim.keymap.set("n", "[c", function()
  require("gitsigns").prev_hunk()
end, { desc = "Previous git hunk" })

-- --- Themery ---
vim.keymap.set("n", "<leader>th", "<cmd>Themery<CR>", { desc = "Choose colorscheme" })

-- --- Comment ---
require("Comment").setup(opts)

local api = require("Comment.api")
local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

vim.keymap.set("n", "<leader>//", function()
      api.toggle.linewise.current()
    end, { desc = "Toggle comment (line)" })

vim.keymap.set("x", "<leader>//", function()
  vim.api.nvim_feedkeys(esc, "nx", false)
  api.toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment (visual)" })

-- --- AutoSession ---
vim.keymap.set("n", "<leader>as", ":AutoSession restore<CR>", { desc = "Restore AutoSession" })



-- --- TmuxNavigator ---
vim.keymap.set("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate Tmux Pane" })
vim.keymap.set("n", "<c-left>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate Tmux Pane" })
vim.keymap.set("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate Tmux Pane" })
vim.keymap.set("n", "<c-down>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate Tmux Pane" })
vim.keymap.set("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate Tmux Pane" })
vim.keymap.set("n", "<c-up>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate Tmux Pane" })
vim.keymap.set("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate Tmux Pane" })
vim.keymap.set("n", "<c-right>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate Tmux Pane" })

-- --- Buffers ---
vim.keymap.set("n", "<leader>X", ":bufdo bd<cr>", { silent = true, desc = "Close all buffers" })

