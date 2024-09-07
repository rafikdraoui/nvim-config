local M = {}

-- Display number of lint warnings
M.lint = function()
  local counts = vim.diagnostic.count(0)
  -- Wrapping `counts` in `pairs` to ensure that it is always treated as a map
  -- and not as a list.
  local num_errors = vim.iter(pairs(counts)):fold(0, function(acc, _k, v)
    acc = acc + v
    return acc
  end)
  if num_errors > 0 then
    return string.format("[lint:%d]", num_errors)
  else
    return ""
  end
end

-- Display git branch and changes.
-- This relies on the mini.nvim plugin
M.git = function()
  local git_info = vim.b.minigit_summary
  if not git_info then
    return ""
  end

  local branch = git_info.head_name
  if branch == "HEAD" then
    branch = string.sub(git_info.head, 1, 7)
  end
  branch = string.format("[⌥ %s]", branch)

  local stats = vim.b.minidiff_summary_string or ""
  if stats ~= "" then
    stats = string.gsub(stats, "~", "•")
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
