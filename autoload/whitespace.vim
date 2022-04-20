function! whitespace#trim() abort
  " Save cursor position
  let view = winsaveview()

  " Remove trailing whitespace
  " i.e. one or more (`\+`) whitespace (`\s`) at end of line (`$`)
  silent execute '%substitute/\s\+$//e'

  " remove trailing empty lines
  " i.e. one or more (`\+`) line breaks (`\n`) and the end of the file (`\%$`)
  silent execute '%substitute/\n\+\%$//e'

  " Restore cursor position
  call winrestview(view)
endfunction
