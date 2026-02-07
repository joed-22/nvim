return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      mode = "buffers",
      always_show_bufferline = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      numbers = "ordinal",
      show_buffer_icons = false,
      color_icons = false,
      diagnostics = "false",
      separator_style = "thin",
      sort_by = 'id',

      offsets = {
        {
          filetype = "neo-tree",
          text = "neo-tree",
          highlight = "Directory",
          separator = true -- use a "true" to enable the default, or set your own character
        }
      },


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
