-- Modified from https://github.com/kristijanhusak/neovim-config/blob/ccb5eb7b02a227030b0c302981855226d531c1c9/nvim/lua/ts_statusline.lua
-- c.f. https://github.com/nvim-treesitter/nvim-treesitter/issues/545

local ts_utils = require'nvim-treesitter.ts_utils'
local parsers = require'nvim-treesitter.parsers'

local valid_rgx = {'class', 'function', 'method'}

local get_line_for_node = function(node)
  local node_type = node:type()
  local is_valid = false
  for _, rgx in ipairs(valid_rgx) do
    if node_type:find(rgx) then
      is_valid = true
      break
    end
  end
  if not is_valid then return '' end
  local range = {node:range()}
  local line = vim.fn.getline(range[1] + 1)
  return vim.trim(line:gsub('[%[%(%{]*%s*$', ''))
end

local get_ts_location = function()
  if not parsers.has_parser() then return end

  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then return "" end

  local lines = {}
  local expr = current_node
  local prefix = " -> "

  while expr do
    local line = get_line_for_node(expr)
    if line ~= '' and not vim.tbl_contains(lines, line) then
      table.insert(lines, 1, line)
    end
    expr = expr:parent()
  end

  local text = table.concat(lines, prefix):gsub('%%', '%%%%')
  local text_len = #text

  return text
end

local print_ts_location = function ()
  print(get_ts_location())
end

return {
  print_ts_location = print_ts_location
}
