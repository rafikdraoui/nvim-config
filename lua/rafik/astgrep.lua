local M = {}

-- Run `ast-grep run --pattern` with the given pattern
M.run = function(pattern)
  if pattern == nil or pattern == "" then
    vim.notify("astgrep.run: Argument required", vim.log.levels.ERROR)
    return
  end

  -- Run command
  local cmd = { "ast-grep", "run", "--json=compact", "--pattern", pattern }
  local result = vim.system(cmd):wait()
  if result.code >= 2 then
    vim.notify(result.stderr, vim.log.levels.ERROR)
    return
  end

  -- Parse output
  local ok, matches = pcall(vim.json.decode, result.stdout)
  if not ok then
    vim.notify(
      "astgrep.run: Failed to parse ast-grep output: " .. result.stdout,
      vim.log.levels.ERROR
    )
    return
  end

  -- Populate quickfix list with results
  local items = vim.tbl_map(
    function(match)
      return {
        filename = match.file,
        lnum = match.range.start.line + 1,
        col = match.range.start.column + 1,
        end_lnum = match.range["end"].line + 1,
        end_col = match.range["end"].column + 1,
        text = vim.split(match.lines, "\n")[1],
      }
    end,
    matches
  )
  vim.fn.setqflist({}, " ", {
    title = "ast-grep: " .. pattern,
    items = items,
  })

  -- Display results
  if #items > 0 then
    vim.cmd.copen()
    vim.cmd.cfirst()
  else
    vim.notify("astgrep.run: No matches")
  end
end

return M
