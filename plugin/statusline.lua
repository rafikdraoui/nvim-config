local parts = {
  -- filename, modified flag, preview flag, and filetype
  "%1*%f%*%m%w %y",

  -- git branch and change stats
  "%{v:lua.require'rafik.statusline'.git()}",

  -- spell checking
  "%{&spell ? printf('[spell=%s]', &spelllang) : ''}",

  -- linting
  "%2*%{v:lua.require'rafik.statusline'.lint()}%*",

  -- debug mode
  "%2*%{v:lua.require'rafik.statusline'.debugmode()}%*",

  -- debugging
  "%#QuickFixLine#%{v:lua.require'rafik.statusline'.debug()}%*",

  -- line/column numbers
  "%= %p%% %4l/%L:%-2c",
}

-- Set statusline
vim.o.statusline = table.concat(parts, " ")

-- Set appropriate User highlights for colorscheme (c.f. `:help hl-User1..9`)
require("rafik.statusline").set_status_highlights()
