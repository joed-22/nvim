return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      always_show_bufferline = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      numbers = "ordinal",
      diagnostics = "nvim_lsp",
      separator_style = "thick",
    },
    
    highlights = {
      buffer_selected = {
        italic = false,
        bold = true,
      },
      close_button_selected = {
        italic = false,
      },
      indicator_selected = {
        italic = false,
      },
      numbers_selected = {
        italic = false,
      }
    },
  },
}
