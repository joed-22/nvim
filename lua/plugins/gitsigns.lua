return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 400, -- ms
    },
    preview_config = {
      -- Options passed to nvim_open_win
      style = 'minimal',
      -- border = 'rounded',      -- defaults to vim.o.winborder
      relative = 'cursor',
      row = 0,
      col = 5,
    },
  },
}
