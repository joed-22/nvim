return {
  "kemiller/vim-ir_black",
  lazy = false,
  priority = 1000,
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "ir_black",
      callback = function()
        vim.api.nvim_set_hl(0, "@punctuation", { link = "Normal" })
        vim.api.nvim_set_hl(0, "@function.call", { link = "Normal" })
      end,
    })
  end,
}

