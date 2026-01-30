return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    require("onedark").setup {
      style = "darker",
      colors = {
        bg0 = "#201f23",
        bg1 = "#201f23",
      },
      highlights = {
        Normal = { bg = "#201f23" },
        NormalFloat = { bg = "#201f23" },
      },
    }
    require("onedark").load()
  end,
}
