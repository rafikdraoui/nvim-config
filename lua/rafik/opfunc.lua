local M = {}

-- Operator function that can be used to search for the selection with
-- `rafik.grep.run`
M.search = function(type)
  local reg_save = vim.fn.getreginfo("@")

  local normal_bang = function(cmd) vim.cmd.normal({ args = { cmd }, bang = true }) end
  if type == "v" or type == "V" then
    normal_bang("gvy")
  elseif type == "line" then
    normal_bang("'[V']y")
  else
    normal_bang("`[v`]y")
  end

  local query = vim.fn.getreg("@")
  if query ~= "" then
    require("rafik.grep").run({ string.format("%q", query) })
    vim.fn.histadd("cmd", string.format("Grep %q", query))
  end

  vim.fn.setreg("@", reg_save)
end

-- Operator function that can be used to sort the selection with `:sort`
M.sort = function(type)
  local range
  if type == "v" or type == "V" then
    range = { vim.fn.line("'<"), vim.fn.line("'>") }
  else
    range = { vim.fn.line("'["), vim.fn.line("']") }
  end
  vim.cmd.sort({ range = range })
end

return M
