" Insert a pdb `breakpoint` call on the line above
nnoremap <buffer> <leader>d Obreakpoint()<esc>

nnoremap <silent> <buffer> <leader>k <cmd>PyDoc<cr>

setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

" Toggle 'treesitter' and 'indent' folding
function s:toggle_foldmethod() abort
  if &l:foldmethod ==# 'indent'
    setlocal foldmethod=expr
  else
    setlocal foldmethod=indent
  endif
  setlocal foldmethod?
endfunction
nnoremap <silent> cof :call <sid>toggle_foldmethod() <cr>

" Filter range through `isort`
command! -buffer -range=% Isort :<line1>,<line2>!isort -

" Add various useful locations to 'path'
let s:project_root = git#repo_root()
if !empty(s:project_root)
  execute 'setlocal path+=' . s:project_root . '/*'
endif
if has_key(environ(), 'VIRTUAL_ENV')
  setlocal path+=$VIRTUAL_ENV/src/*
  setlocal path+=$VIRTUAL_ENV/lib/*/site-packages
endif
