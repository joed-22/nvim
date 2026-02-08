return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "auto",        -- automatically adapts to your colorscheme
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
      globalstatus = true,   -- single statusline for all windows (Neovim 0.7+)
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = { {"filename", path = 3}, "diagnostics" },
      lualine_x = { "lsp_status", "fileformat", "filetype" },
      lualine_y = { "progress", "filesize" },
      lualine_z = { "location" },
    },

  },
}
