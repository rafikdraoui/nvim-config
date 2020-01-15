function! textobj#guillemets#in() abort
  call textobj#guillemets#around()
  if mode() !=# 'v'
      return
  endif
  normal! loho
endfunction

function! textobj#guillemets#around() abort
  let line = line('.')
  if (!search('»', 'ce', line))
    return
  endif

  normal! v

  if (!search('«', 'cb', line))
    normal! v
    return
  endif
endfunction
