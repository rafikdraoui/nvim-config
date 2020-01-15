" Inspired by https://vimways.org/2018/transactions-pending/
"
" Select the next number on the line.
" This can handle decimal and hexadecimal numbers.

function! textobj#number#in() abort
  " need magic for this to work properly
  let magic = &magic
  set magic

  let lineNr = line('.')
  let pat = '0x\x\+\|\d\+'

  " move cursor to end of number
  if (!search(pat, 'ce', lineNr))
    " if it fails, there was no match on the line, so return prematurely
    return
  endif

  " start visually selecting from end of number
  normal! v

  " move cursor to beginning of number
  call search(pat, 'cb', lineNr)

  " restore magic
  let &magic = magic
endfunction

function! textobj#number#around() abort
  " need magic for this to work properly
  let magic = &magic
  set magic

  let lineNr = line('.')
  let pat = '0x\x\+\|\d\+'

  " move cursor to end of number
  if (!search(pat, 'ce', lineNr))
    " if it fails, there was not match on the line, so return prematurely
    return
  endif

  " move cursor to end of any trailing white-space (if there is any)
  call search('\%'.(virtcol('.')+1).'v\s*', 'ce', lineNr)

  " start visually selecting from end of number + potential trailing whitspace
  normal! v

  " move cursor to beginning of number
  call search(pat, 'cb', lineNr)

  " move cursor to beginning of any white-space preceding number (if any)
  call search('\s*\%'.virtcol('.').'v', 'b', lineNr)

  " restore magic
  let &magic = magic
endfunction
