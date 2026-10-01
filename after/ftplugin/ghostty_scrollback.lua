vim.opt_local.wrap = false

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr =
  "v:lua.require('rafik.folding').ghostty_scrollback.foldexpr(v:lnum)"
vim.opt_local.foldtext = "v:lua.require('rafik.folding').ghostty_scrollback.foldtext()"

-- highlight command lines
vim.b.minihipatterns_config = {
  highlighters = {
    command_line = { pattern = "^» .*$", group = "String" },
  },
}
