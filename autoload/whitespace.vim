function! whitespace#trim() abort
  let view = winsaveview()  " Save cursor position

  " Remove trailing whitespace
  " i.e. one or more (`\+`) whitespace (`\s`) at end of line (`$`)
  silent execute '%substitute/\s\+$//e'

  " remove trailing empty lines
  " i.e. one or more (`\+`) line breaks (`\n`) and the end of the file (`\%$`)
  silent execute '%substitute/\n\+\%$//e'

  call winrestview(view)  " Restore cursor position
endfunction
