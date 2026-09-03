return
{
    'fei6409/log-highlight.nvim',
    opts = {
      pattern = {
          '.*%.log%.[0-9]+',
          '.*%.txt%.*',
          'Downloads%/logs%/*'
      },
    },
    init = function()
      -- :Log -- force log highlighting on the current buffer
      vim.api.nvim_create_user_command('LogColor', function()
        vim.bo.filetype = 'log'
      end, { desc = 'Highlight current buffer as a log file' })

      -- anything piped in on stdin (journalctl -b | nvim -) gets it automatically
      vim.api.nvim_create_autocmd('StdinReadPost', {
        callback = function()
          if vim.bo.filetype == '' then
            vim.bo.filetype = 'log'
          end
        end,
      })
    end,
}
