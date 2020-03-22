" Mapping to insert a pdb `breakpoint` call on the line above
nnoremap <buffer> <leader>d Obreakpoint()<esc>

" Wrap a line in a try-except block with a pdb `breakpoint`
" Eg. the line:
"   x = func()
"
" will be replaced by:
"   try:  # debug
"       x = func()
"   except Exception as exc:
"       breakpoint()
"       raise
nnoremap <silent> <buffer> <leader>e :call python#wrap_exception()<cr>

" Undo try-except wrapping
nnoremap <silent> <buffer> <leader>u :call python#unwrap_exception()<cr>

function s:toggle_foldmethod() abort
  if &l:foldmethod ==# 'expr'
    setlocal foldmethod=indent
  else
    setlocal foldmethod=expr
  endif
endfunction
nnoremap <silent> cof :call <sid>toggle_foldmethod() <cr>


let s:project_root = git#repo_root()
if !empty(s:project_root)
  execute 'setlocal path+=' . s:project_root . '/*'
endif

if has_key(environ(), 'VIRTUAL_ENV')
  setlocal path+=$VIRTUAL_ENV/src/*
  setlocal path+=$VIRTUAL_ENV/lib/*/site-packages
endif
