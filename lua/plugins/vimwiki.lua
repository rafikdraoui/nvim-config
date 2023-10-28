-- no 'packadd' here, because this plugin is lazy-loaded

local main_wiki = {
  path = vim.env.NOTES_DIR,
  syntax = "markdown",
  ext = ".md",
  links_space_char = "-",
  auto_tags = 1,
}
vim.g.vimwiki_list = { main_wiki }
vim.g.vimwiki_folding = "expr"
vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_key_mappings = {
  headers = 1,
  links = 1,
  lists = 1,

  global = 0,
  html = 0,
  mouse = 0,
  table_format = 0,
  table_mappings = 0,
  text_objs = 0,
}
vim.keymap.set("n", "<leader>ww", function()
  local index = vim.env.NOTES_DIR .. "/index.md"
  vim.cmd.edit(index)
end, { desc = "Open vimwiki index" })
