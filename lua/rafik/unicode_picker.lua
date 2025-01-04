local M = {}
local h = {}

local UNICODE_RAW_DATA_URL = "https://www.unicode.org/Public/UNIDATA/UnicodeData.txt"
local UNICODE_RAW_DATA_PATH = vim.fs.joinpath(vim.fn.stdpath("cache"), "UnicodeData.txt")
local UNICODE_DATA_DIR = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "lua", "rafik")

M.pick = function()
  local ok, data = pcall(require, "rafik.unicode_data")
  if not ok then
    if not M.configure() then
      return
    end
    data = require("rafik.unicode_data")
  end

  vim.ui.select(data, {
    prompt = "Unicode",
    format_item = function(item)
      return string.format("%s  %s [%s]", item.glyph, item.name, item.codepoint)
    end,
  }, function(choice)
    if choice then
      if vim.fn.mode() == "i" then
        vim.api.nvim_input(choice.glyph)
      else
        vim.api.nvim_put({ choice.glyph }, "c", true, true)
      end
    end
  end)
end

M.configure = function()
  local is_configured = false

  vim.ui.input({
    prompt = "The Unicode data is missing. Download from unicode.org (y/n)? ",
  }, function(input)
    if input ~= "y" then
      return
    end

    if not vim.uv.fs_stat(UNICODE_RAW_DATA_PATH) then
      h.download()
    end
    local data = h.parse(UNICODE_RAW_DATA_PATH)
    h.write_unicode_data(data)

    -- required to make new Lua module available immediately
    vim.loader.disable()
    require("rafik.unicode_data")
    vim.loader.enable()

    is_configured = true
  end)

  return is_configured
end

-- Helpers --------------------------------------------------------------------

h.download = function()
  if vim.fn.executable("curl") == 0 then
    error("curl is missing")
  end
  local obj = vim
    .system({
      "curl",
      "--fail",
      "--no-progress-meter",
      "--output",
      UNICODE_RAW_DATA_PATH,
      UNICODE_RAW_DATA_URL,
    })
    :wait()
  if obj.code ~= 0 then
    error(string.format("error downloading Unicode data: %s", obj.stderr))
  end
end

h.parse = function(filename)
  local data = {}
  for line in io.lines(filename) do
    local parts = vim.split(line, ";", true)
    local codepoint, name = parts[1], parts[2]
    if not vim.startswith(name, "<") then
      table.insert(data, { codepoint = codepoint, name = string.lower(name) })
    end
  end
  return data
end

h.write_unicode_data = function(data)
  vim.fn.mkdir(UNICODE_DATA_DIR, "p")
  local filename = vim.fs.joinpath(UNICODE_DATA_DIR, "unicode_data.lua")
  local f = io.open(filename, "w")

  f:write("return {\n")
  for _, entry in ipairs(data) do
    f:write(
      string.format(
        [[{ codepoint=%q, glyph="\u{%s}", name=%q },]],
        entry.codepoint,
        entry.codepoint,
        entry.name
      )
    )
    f:write("\n")
  end
  f:write("}\n")
  io.close(f)
end

return M
