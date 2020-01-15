" Delete all buffers except current one
function! buffers#bonly() abort
  let b_current = bufnr()
  let to_delete = []
  for b_num in range(1, bufnr('$'))
    if b_num != b_current && bufexists(b_num)
      call add(to_delete, b_num)
    end
  endfor
  if !empty(to_delete)
    execute 'bwipeout ' . join(to_delete)
  end
endfunction
