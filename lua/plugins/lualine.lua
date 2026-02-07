local function has_multiple_real_buffers()
  local count = 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    local bt = vim.bo[bufnr].buftype
    if bt == "" then
      count = count + 1
    end
  end
  return count > 1
end

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
      lualine_c = { "filename", "diagnostics" },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },

    winbar = {
      lualine_c = {
        {
          function()

            -- Show 3 dirs back...


            local max_dirs = 3
            local sep = "  "

            local path = vim.fn.expand("%:p:h")
            local file = vim.fn.expand("%:t")
            -- if no path or not a file nothing...
            if path == "" or vim.bo.buftype ~= "" or not has_multiple_real_buffers() then
              return ""
            end

            local parts = vim.split(path, "/", { trimempty = true })
            parts = vim.list_slice(parts, math.max(#parts - max_dirs + 1, 1))

            table.insert(parts, file)
            return table.concat(parts, sep)
          end,
          color = "StatusLine",
        },
      },
    },
    
    inactive_winbar = {
      lualine_c = {
        {
          'filename',
          cond = is_real_file,
        },
      },
    },

  },
}
