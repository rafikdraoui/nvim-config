local M = {}

-- Create a scratch buffer in a new tab.
-- This exists mostly for the `:Redir` user command.
M.create = function(lines)
  vim.cmd.tabnew()
  vim.fn.setline(1, lines)

  vim.opt_local.buflisted = false
  vim.opt_local.buftype = "nofile"
  vim.opt_local.bufhidden = "wipe"
  vim.opt_local.swapfile = false
end
return M
