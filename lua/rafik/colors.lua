local M = {}

local toggle_highlight = function(type, target_hl, default_hl, special_hl)
  if vim.fn.empty(vim.api.nvim_get_hl(0, { name = special_hl })) == 1 then
    vim.notify(
      string.format("Missing special %s highlight %s", type, special_hl),
      vim.log.levels.WARN
    )
    return
  end

  local current_hl = vim.api.nvim_get_hl(0, { name = target_hl })
  if not current_hl.link or current_hl.link == default_hl then
    vim.api.nvim_set_hl(0, target_hl, { link = special_hl })
    vim.notify(string.format("%s highlight: on", type))
  else
    vim.api.nvim_set_hl(0, target_hl, { link = default_hl })
    vim.notify(string.format("%s highlight: off", type))
  end
end

M.toggle_definition_highlight = function()
  local target_hl = "@rafik.definition"
  local default_hl = "Identififer"
  local special_hl = "RafikDefinition"
  toggle_highlight("definition", target_hl, default_hl, special_hl)
end

M.toggle_return_highlight = function()
  local target_hl = "@keyword.return"
  local default_hl = "@keyword"
  local special_hl = "MiniCursorword"
  toggle_highlight("return", target_hl, default_hl, special_hl)
end

return M
