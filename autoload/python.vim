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
function! python#wrap_exception() abort
  normal! m'
  normal! Otry:  # debug
  normal! j>>
  normal! oexcept Exception as exc:
  normal! obreakpoint()
  normal! oraise
  normal! g''
endfunction

" Undo try-except wrapping
function! python#unwrap_exception() abort
  if (!search('^\s*\zstry:  # debug$', 'c'))
    return
  endif

  if (!search('^\s*\zsexcept Exception as exc:$', 'cs'))
    return
  endif

  normal! g''dd
  normal! <<
  normal! j3ddk
endfunction
