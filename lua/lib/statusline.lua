local M = {}

-- Display number of lint warnings
M.lint = function()
  local num_errors = #vim.diagnostic.get(0)
  if num_errors > 0 then
    return string.format("[lint:%d]", num_errors)
  else
    return ""
  end
end

-- Display whether the buffer is currently being formatted
M.formatting = function()
  if vim.g.is_formatting then
    return "[fmt]"
  else
    return ""
  end
end

-- Display git branch and changes.
-- This relies on the `gitsigns` plugin.
M.git = function()
  if vim.b.gitsigns_status_dict == nil then
    return ""
  end

  local branch = string.format("[⌥ %s]", vim.b.gitsigns_head)

  local stats = string.gsub(vim.b.gitsigns_status, "~", "•")
  if stats ~= "" then
    stats = string.format("[%s]", stats)
  end
  return branch .. stats
end

-- Display status of running debugging session
M.debug = function()
  local ok, dap = pcall(require, "dap")
  if not ok then
    return ""
  end
  local status = dap.status()
  if status == "" then
    return ""
  end
  return string.format("[debug: %s]", status)
end

-- Set custom highlights for status line, using `hl-User{N}` for better
-- interaction with StatusLineNC.
--
-- `User1` is used to highlight the filename, and is set to be the same as
-- StatusLine, but with the addition of the bold attribute.
--
-- `User2` is used to highlight the linting status, and is set to be the same
-- as StatusLine, but with reversed foreground and background, and the addition
-- of the bold attribute.
M.set_status_highlights = function()
  local hl = vim.api.nvim_get_hl_by_name("StatusLine", true)
  local attrs = { fg = hl.foreground, bg = hl.background, bold = true }

  local extend = function(tbl1, tbl2) return vim.tbl_extend("force", tbl1, tbl2) end
  vim.api.nvim_set_hl(0, "User1", extend(attrs, { reverse = hl.reverse }))
  vim.api.nvim_set_hl(0, "User2", extend(attrs, { reverse = not hl.reverse }))
end

return M
