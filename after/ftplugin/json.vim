function! ToggleJSONPath() abort
  if &l:winbar != ''
    setlocal winbar=
  else
    setlocal winbar=%{v:lua.require'jsonpath'.get()}
  endif
endfunction
nnoremap <buffer> coj <cmd>call ToggleJSONPath()<cr>
