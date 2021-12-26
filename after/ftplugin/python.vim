" Insert a pdb `breakpoint` call on the line above
nnoremap <buffer> <leader>d Obreakpoint()<esc>

nnoremap <silent> <buffer> <leader>k <cmd>PyDoc<cr>

" Toggle 'coiled-snake' and treesitter folding
function s:toggle_foldmethod() abort
  if &l:foldexpr =~# 'coiledsnake#'
    setlocal foldexpr=nvim_treesitter#foldexpr()
  else
    setlocal foldexpr=coiledsnake#FoldExpr(v:lnum)
  endif
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
