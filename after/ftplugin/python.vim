" Insert a pdb `breakpoint` call on the line above
nnoremap <buffer> <leader>db Obreakpoint()<esc>

nnoremap <silent> <buffer> <leader>k <cmd>PyDoc<cr>

setlocal formatoptions+=r  " insert comment leader after hitting <enter> in Insert mode

" Add various useful locations to 'path'
let s:project_root = luaeval('require("rafik.git").root()')
if !empty(s:project_root)
  execute 'setlocal path+=' . s:project_root . '/*'
endif
if has_key(environ(), 'VIRTUAL_ENV')
  setlocal path+=$VIRTUAL_ENV/src/*
  setlocal path+=$VIRTUAL_ENV/lib/*/site-packages
endif
