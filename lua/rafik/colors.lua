local M = {}

M.toggle_definition_highlight = function()
  local current_hl = vim.api.nvim_get_hl(0, { name = "@rafik.definition" })
  if not current_hl.link then
    return
  end

  if current_hl.link == "RafikDefinition" then
    vim.cmd("hi! link @rafik.definition Identifier")
  else
    vim.cmd("hi! link @rafik.definition RafikDefinition")
  end
end

return M
