local M = {}
local h = {}

-- `indent` is a text object ai-spec for an indented block of lines.
M.indent = function()
  return function()
    local lnum = vim.fn.line(".")
    local reference_line = h.find_reference_line(lnum)
    local indent = vim.fn.indent(reference_line)
    if indent == 0 then
      return h.lines(1, vim.fn.line("$"))
    end

    local top = h.find_border(lnum, "up", indent)
    local bottom = h.find_border(lnum, "down", indent)
    return h.lines(top, bottom)
  end
end

-- `url` is a text object ai-spec for a URL with scheme `http` or `https`.
M.url = function()
  return function()
    -- Patterns of valid URL characters. This isn't an exhaustive list, but is
    -- good enough for the purpose of matching most URLs.
    -- stylua: ignore
    local url_chars = table.concat({
      "%%", "%-", "%.", "%[", "%]", "%w", "#", "&", "+", "/", ":", "=", "?", "@", "_", "~",
    })

    return { string.format("%%f[%s]https?://[%s]+", url_chars, url_chars) }
  end
end

-- `treesitter` is the same as `MiniAi.gen_spec.treesitter`, except that it
-- uses the whole buffer as its search region.
M.treesitter = function(ai_captures)
  local ai_spec = require("mini.ai").gen_spec
  return function(ai_type, id, opts)
    opts.n_lines = math.huge
    local spec = ai_spec.treesitter(ai_captures)
    return spec(ai_type, id, opts)
  end
end

-- Helpers --------------------------------------------------------------------

-- `lines` returns a MiniAi region for everything between the `first` and
-- `last` line numbers (inclusive).
h.lines = function(first, last)
  return {
    from = { line = first, col = 1 },
    to = { line = last, col = math.max(vim.fn.getline(last):len(), 1) },
  }
end

-- `find_reference_line` returns the line number of the line that should be
-- used as a reference to compute indent for line number `lnum`.
--
-- In most cases, the reference line will be `lnum` itself. The only times we
-- need to find another one is when line `lnum` is empty. When this happens, we
-- look at the previous and next non-empty lines from position `lnum`, and use
-- the most indented one as the reference line.
h.find_reference_line = function(lnum)
  local prev = vim.fn.prevnonblank(lnum)
  local next = vim.fn.nextnonblank(lnum)
  if prev == next then
    return lnum
  end

  if next == 0 then
    return prev
  elseif prev == 0 then
    return next
  end

  local indent_above = vim.fn.indent(prev)
  local indent_below = vim.fn.indent(next)
  if indent_below >= indent_above then
    return next
  else
    return prev
  end
end

-- `find_border` returns the line number of the first (if `dir` is "up") or the
-- last (if `dir` is "down") line of the indented block with the given `indent`
-- containing line number `from`.
h.find_border = function(from, dir, indent)
  local limit, step, get_next
  if dir == "up" then
    limit = 1
    step = -1
    get_next = vim.fn.prevnonblank
  elseif dir == "down" then
    limit = vim.fn.line("$")
    step = 1
    get_next = vim.fn.nextnonblank
  else
    error("Unexpected argument for direction: " .. dir, 2)
  end

  local result = from
  for n = from, limit, step do
    n = get_next(n)
    if n == 0 or vim.fn.indent(n) < indent then
      break
    end
    result = n
  end
  return result
end

return M
