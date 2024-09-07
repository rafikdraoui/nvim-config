local M = {}

local esc = function(s) return vim.fn.escape(s, "/") end

-- Search and replace using `:substitute`
M.run = function(pattern, repl, flags, mods, range)
  flags = flags or { "g" }
  mods = mods or vim.empty_dict()
  range = range or { 1, vim.fn.line("$") }
  local cmd = string.format("/%s/%s/", esc(pattern), esc(repl))
  for _, f in ipairs(flags) do
    cmd = cmd .. f
  end

  vim.cmd.substitute({
    args = { cmd },
    range = range,
    mods = mods,
  })
end

return M
