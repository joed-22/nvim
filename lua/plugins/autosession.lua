return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    pre_save_cmds = { 'Neotree close' },
    -- post_restore_cmds = { 'Neotree filesystem show' },
    -- log_level = 'debug',
  },
}
