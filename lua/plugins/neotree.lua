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
        width = "25",
        popup = {
          size = {
            width = "80%",
            height = "87%",
          },
          position = { row = "40%", col = "50%" },
          border = "rounded",
          relative = "editor",
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,       -- auto-focus/unfold to the current file
          leave_dirs_open = true, -- keep dirs expanded when switching files
        },
        use_libuv_file_watcher = true, -- live updates when files change
        filtered_items = {
          visible = true,        -- show filtered items instead of hiding them
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,   -- Windows hidden files
          hide_by_name = {},     -- keep empty to avoid hiding anything by name
          hide_by_pattern = {},  -- keep empty to avoid pattern hiding
        },
        group_empty_dirs = false,
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
