local parts = {
  -- filename, modified flag, preview flag, and filetype
  "%1*%f%*%m%w %y",

  -- git branch and change stats
  "%{v:lua.require'lib.statusline'.git()}",

  -- spell checking
  "%{&spell ? printf('[spell=%s]', &spelllang) : ''}",

  -- linting
  "%2*%{v:lua.require'lib.statusline'.lint()}%*",

  -- debugging
  "%#QuickFixLine#%{v:lua.require'lib.statusline'.debug()}%*",

  -- line/column numbers
  "%= %p%% %4l/%L:%-2c",
}

-- Set statusline
vim.o.statusline = table.concat(parts, " ")

-- Set appropriate User highlights for colorscheme (c.f. `:help hl-User1..9`)
require("lib/statusline").set_status_highlights()
