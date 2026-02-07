return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    require("onedark").setup {
      style = "darker",
      colors = {
        bg0 = "#1e1e1e",
      },
      highlights = {
        Normal = { bg = "#1e1e1e" },
        NormalFloat = { bg = "#1e1e1e" },
      },
    }
    require("onedark").load()
  end,
}
