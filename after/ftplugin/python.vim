" Insert a pdb `breakpoint` call on the line above
nnoremap <buffer> <leader>db Obreakpoint()<esc>

nnoremap <silent> <buffer> <leader>k <cmd>PyDoc<cr>

setlocal foldmethod=expr
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()

" Toggle 'treesitter' and 'indent' folding
function s:toggle_foldmethod() abort
  if &l:foldmethod ==# 'indent'
    setlocal foldmethod=expr
  else
    setlocal foldmethod=indent
  endif
  setlocal foldmethod?
endfunction
command! -buffer ToggleFoldMethod call <sid>toggle_foldmethod()

" Filter range through `isort`
command! -buffer -range=% Isort :<line1>,<line2>!isort -

" Add various useful locations to 'path'
let s:project_root = luaeval('require("lib/git").root()')
if !empty(s:project_root)
  execute 'setlocal path+=' . s:project_root . '/*'
endif
if has_key(environ(), 'VIRTUAL_ENV')
  setlocal path+=$VIRTUAL_ENV/src/*
  setlocal path+=$VIRTUAL_ENV/lib/*/site-packages
endif
