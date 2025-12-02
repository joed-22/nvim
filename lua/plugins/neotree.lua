return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = {
      window = {
        width = "25"
      },
      default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1,
      },
      icon = {
        folder_closed = " ",
        folder_open   = " ",
        folder_empty  = "",
        folder_empty_open = "",
      },
    },
    }
  }
}
