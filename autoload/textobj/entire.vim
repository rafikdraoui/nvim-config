function! textobj#entire#in() abort
  let start = search('\%^\n*.', 'enw')
  let end = search('.\n*\%$', 'nw')
  execute 'normal! ' . string(start) . 'GV' . string(end) . 'G'
endfunction

function! textobj#entire#around() abort
  normal! VggoG
endfunction
