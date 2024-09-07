local M = {}

-- Convert a ripgrep query to a vim search regexp. The query is assumed to be
-- the last of the given arguments.
--
-- This isn't foolproof, but it handles the most common use cases: if not, `q/`
-- is there to easily amend it once it gets saved to the search history.
local ripgrep_to_vimsearch = function(args)
  if #args == 0 then
    return nil
  end
  local query = args[#args]

  -- trim surrounding quotes
  local first, last = string.sub(query, 1, 1), string.sub(query, -1, -1)
  if #query > 2 and first == last and (first == [[']] or first == [["]]) then
    query = string.sub(query, 2, -2)
  end

  -- unescape \(  and \)
  query = string.gsub(query, [[\%(]], "(")
  query = string.gsub(query, [[\%)]], ")")

  -- add word boundary markers if `-w` was used
  if vim.list_contains(args, "-w") then
    query = string.format([[\<%s\>]], query)
  end

  -- convert word boundary markers
  query = string.gsub(query, [[^\b]], [[\<]])
  query = string.gsub(query, [[\b$]], [[\>]])

  -- add case-sensitivity marker if `-s` was used
  if vim.list_contains(args, "-s") then
    query = [[\C]] .. query
  end
  return query
end

-- Run ripgrep with the given arguments.
--
-- If the `path` options is provided, then it is used as the directory to
-- search in. If omitted, the search is based at the root of the git repository
-- of the file of the current buffer, falling back to the current directory if
-- not in a git repository.
--
-- The query is added to Vim's search history, after being transformed from
-- ripgrep to Vim regexp.
M.run = function(args, opts)
  opts = opts or {}

  if #args == 0 then
    vim.notify("grep.run: Argument required", vim.log.levels.ERROR)
    return
  end

  local vim_query = ripgrep_to_vimsearch(args)
  if not vim_query then
    return
  end
  vim.fn.setreg("/", vim_query)
  vim.fn.histadd("search", vim_query)

  local path = opts.path or require("rafik.git").root() or "."
  table.insert(args, path)

  -- escape command-line special characters `%` and `#`
  args = vim.tbl_map(function(x) return vim.fn.escape(x, "%#") end, args)

  -- escape empty string literals, as a convenience for the special case of
  -- searching for empty string without having to escape the quotes
  args = vim.tbl_map(function(x)
    if x == [['']] or x == [[""]] then
      return vim.fn.escape(x, [['"]])
    end
    return x
  end, args)

  -- Use default shell to ensure consistent handling of special characters
  local sh_save = vim.o.shell
  vim.o.shell = "sh"

  vim.cmd.grep({
    args = args,
    mods = { silent = true },
  })

  vim.o.shell = sh_save
end
return M
