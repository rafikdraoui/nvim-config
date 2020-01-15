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
nnoremap <buffer> <leader>e :call python#wrap_exception()<cr>

" Undo try-except wrapping
nnoremap <buffer> <leader>u :call python#unwrap_exception()<cr>

let s:project_root = git#repo_root()
if !empty(s:project_root)
  execute 'setlocal path+=' . s:project_root . '/*'
endif

if has_key(environ(), 'VIRTUAL_ENV')
  setlocal path+=$VIRTUAL_ENV/src/*
  setlocal path+=$VIRTUAL_ENV/lib/*/site-packages
endif
