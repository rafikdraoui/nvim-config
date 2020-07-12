" Delete other buffers
function! buffers#bonly(bang) abort
  if a:bang
    " match every other buffers
    let predicate = 'v:val.bufnr != bufnr("%")'
  else
    " match buffers not in a visible window
    let predicate = 'empty(v:val.windows)'
  end

  let other_buffers = filter(getbufinfo({'buflisted': 1}), predicate)
  let to_delete = map(other_buffers, 'v:val.bufnr')
  if !empty(to_delete)
    execute 'bdelete ' . join(to_delete)
  end
endfunction

" Switch to terminal buffer, creating a new one if none exists
function! buffers#get_terminal() abort
  let terminal_buffers = getbufinfo('term://')
  if empty(terminal_buffers)
    terminal
  else
    execute 'buffer ' . terminal_buffers[0].bufnr
  endif
endfunction
