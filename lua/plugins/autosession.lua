return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    auto_restore = false,
    -- session_lens = {
    --   picker = "telescope",
    --   mappings = {
    --     delete_session = { "i", "<C-d>" },
    --     alternate_session = { "i", "<C-s>" },
    --     copy_session = { "i", "<C-y>" },
    --   },
    -- },
    -- pre_save_cmds = { 'Neotree close' },
    -- post_restore_cmds = { 'Neotree filesystem show' },
    -- log_level = 'debug',
  },
}
