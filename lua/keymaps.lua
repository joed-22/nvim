local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "

-- --- General mappings ---
map('n', '<leader>w', ':w<CR>', opts)  -- save
map('n', "<C-s>", ':w<CR>', opts) -- save
map('n', '<leader>w', ':w<CR>', opts)  -- save

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
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opts)
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opts)
map('n', '<leader>fa', '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>', opts)
map('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>', opts)
map('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find<cr>', opts)
map('n', '<leader>fc', '<cmd>Telescope grep_string<cr>', opts)
vim.keymap.set("n", "<leader>gt", function() require("telescope.builtin").git_status() end, { desc = "Git status diff"})

-- --- LSP ---
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "List references" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

-- --- Diagnostics ---
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show diagnostics"})

-- --- Terminal ---
local term = require("plugins.terminal")

local toggle_float = "<A-i>"
local toggle_horiz = "<A-h>"
local toggle_vert = "<A-v>"

vim.keymap.set("n", toggle_float, function() term.float_term:toggle() end, { desc = "Floating terminal" })
vim.keymap.set("n", toggle_horiz, function() term.horiz_term:toggle() end, { desc = "Horizontal terminal" })
vim.keymap.set("n", toggle_vert, function() term.vert_term:toggle() end, { desc = "Vertical terminal" })

vim.keymap.set("t", toggle_float, function() term.float_term:toggle() end, { desc = "Floating terminal" })
vim.keymap.set("t", toggle_horiz, function() term.horiz_term:toggle() end, { desc = "Horizontal terminal" })
vim.keymap.set("t", toggle_vert, function() term.vert_term:toggle() end, { desc = "Vertical terminal" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- --- Bufferline (tabs) ---
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer/tab" })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Previous buffer/tab" })
vim.keymap.set("n", "<leader>x", ":bdelete<CR>", { silent = true, desc = "Close buffer" })

-- --- Neotree ---
--vim.keymap.set("n", "<leader>n", ":Neotree toggle<CR>", { desc = "Toggle file tree" })
-- vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Toggle file tree" })

vim.keymap.set("n", "<C-n>", function()
  require("neo-tree.command").execute({
    toggle = true,
    position = "left",
    reveal = true,
  })
end, { desc = "Open Neo-tree normal" })

vim.keymap.set("n", "<leader>n", function()
  require("neo-tree.command").execute({
    toggle = true,
    position = "float",
    float = {
      relative = "editor",          -- relative to full editor
      anchor = "NW",                -- top-left corner
      width = math.floor(vim.o.columns * 0.9),
      height = math.floor(vim.o.lines * 0.9),
      border = "rounded",
    },
  })
end, { desc = "Open Neo-tree full size" })

-- --- GitSigns ---
local gs = require("gitsigns")
vim.keymap.set("n", "<leader>gb", function ()
  gs.blame_line({ full = true })
end, {desc = "full line git blame"})

vim.keymap.set("n", "<leader>gB", function ()
  gs.toggle_current_line_blame()
end, {desc = "toggle inline git blame"})

vim.keymap.set("n", "<leader>rh", gs.reset_hunk, { desc = "Reset Git Hunk" })
vim.keymap.set("n", "<leader>ph", gs.preview_hunk, { desc = "Preview Git Hunk" })

-- --- Themery ---
vim.keymap.set("n", "<leader>th", ":Themery", { desc = "Choose colorscheme" })

-- --- Comment ---
vim.keymap.set("n", "<leader>/", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle comment line" })
-- vim.keymap.set("v", "<leader>/", function() require("Comment.api").toggle.blockwise.current() end, { desc = "Toggle comment block" })
