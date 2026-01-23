return {
  "zaldih/themery.nvim",
  lazy = false,
  priority = 900,
  config = function()
    -- Discover all colorschemes available on runtimepath
    local function discover_colorschemes()
      local all = vim.fn.getcompletion("", "color")
      local exclude = {
        default = true, blue = true, darkblue = true, delek = true, desert = true, elflord = true, evening = true,
        habamax = false, industry = true, koehler = true, lunaperche = true, morning = true, murphy = true,
        pablo = true, peachpuff = true, quiet = true, retrobox = true, ron = true, shine = true, slate = true,
        torte = true, vim = true, wildcharm = true, zaibatsu = true, zellner = true,
      }
      local out = {}
      for _, name in ipairs(all) do
        if not exclude[name] then
          table.insert(out, name)
        end
      end
      table.sort(out)
      return out
    end

    require("themery").setup({
      themes = discover_colorschemes(),
      livePreview = true,
    })
  end,
}
