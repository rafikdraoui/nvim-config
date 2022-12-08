local parts = {
  -- filename, modified flag, preview flag, and filetype
  "%1*%f%*%m%w %y",

  -- git branch and change stats
  "%{v:lua.require'lib.statusline'.git()}",

  -- spell checking
  "%{&spell ? printf('[spell=%s]', &spelllang) : ''}",

  -- linting
  "%2*%{v:lua.require'lib.statusline'.lint()}%*",

  -- formatting
  "%2*%{v:lua.require'lib.statusline'.formatting()}%*",

  -- debugging
  "%#QuickFixLine#%{v:lua.require'lib.statusline'.debug()}%*",

  -- line/column numbers
  "%= %p%% %4l/%L:%-2c",
}

-- Set statusline
vim.o.statusline = table.concat(parts, " ")

-- Set appropriate User highlights for colorscheme (c.f. `:help hl-User1..9`)
require("lib/statusline").set_status_highlights()

-- Define autocommands needed to make `lib.statusline.formatting` work. The
-- User events are defined in the `mhartington/formatter.nvim` plugin.
local g = vim.api.nvim_create_augroup("statusline", { clear = true })
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "FormatterPre",
  desc = "Set g:is_formatting to true when buffer is being formatted",
  group = g,
  callback = function() vim.g.is_formatting = true end,
})
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "FormatterPost",
  desc = "Set g:is_formatting to false after buffer has been formatted",
  group = g,
  callback = function() vim.g.is_formatting = false end,
})
