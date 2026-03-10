return {
  "mikavilpas/yazi.nvim",
  version = "*", -- use the latest stable version
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>-",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      "<leader>n",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      -- Open in the current working directory
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  ---@type YaziConfig | {}
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
    floating_window_scaling_factor = 1,
    yazi_floating_window_winblend = 25,

    set_keymappings_function = function(bufnr, config, context)
      -- Map <Esc> in normal & terminal mode to exit yazi
      local opts = { buffer = bufnr, nowait = true }

      -- In terminal mode, send <C-\><C-n> then close buffer
      vim.keymap.set({ "t" }, "<Esc>", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>:bd!<CR>", true, false, true), "n", true)
      end, opts)

      -- In normal mode, just close buffer
      vim.keymap.set("n", "<Esc>", function()
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end, opts)
    end,
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- mark netrw as loaded so it's not loaded at all.
    --
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    vim.g.loaded_netrwPlugin = 1
  end,
}
