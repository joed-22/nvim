return {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        path_display = {},
        layout_config = {
          width = vim.o.columns, -- maximally available columns
          height = .60,
          preview_width = .60,
          prompt_position = "top",
          anchor = "S",
        },
      },
    },
}


