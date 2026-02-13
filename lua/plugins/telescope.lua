local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local mark_multi_open_mapping = { -- my mappings
  ["<CR>"] = function(pb)
    local picker = action_state.get_current_picker(pb) 
    local multi = picker:get_multi_selection()
    actions.select_default(pb) -- the normal enter behaviour
    for _, j in pairs(multi) do
      if j.path ~= nil then -- is it a file -> open it as well:
        vim.cmd(string.format("%s %s", "edit", j.path))
      end
    end
  end,
}

return {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        path_display = {},
        layout_config = {
          width = vim.o.columns, -- maximally available columns
          height = .60,
          preview_width = .60,
          prompt_position = "top",
          anchor = "S",
        },
        mappings = { n = mark_multi_open_mapping, },
      },
    },
}






