" Inspired by https://github.com/justinmk/vim-highlightedyank
function! highlight_yank#highlight(operator, regtype, inclusive) abort
  if a:operator !=# 'y' || a:regtype ==# ''
    return
  endif

  let buffer = bufnr('%')
  let ns = nvim_create_namespace('')
  call s:clear_highlight(buffer, ns)

  let [_, lin1, col1, off1] = getpos("'[")
  let [lin1, col1] = [lin1 - 1, col1 - 1]
  let [_, lin2, col2, off2] = getpos("']")
  let [lin2, col2] = [lin2 - 1, col2 - (a:inclusive ? 0 : 1)]
  for l in range(lin1, lin1 + (lin2 - lin1))
    let is_first = (l == lin1)
    let is_last = (l == lin2)
    let c1 = is_first || a:regtype[0] ==# "\<C-v>" ? (col1 + off1) : 0
    let c2 = is_last || a:regtype[0] ==# "\<C-v>" ? (col2 + off2) : -1
    call nvim_buf_add_highlight(buffer, ns, 'TextYank', l, c1, c2)
  endfor
  call timer_start(500, {-> s:clear_highlight(buffer, ns)})
endfunction

function! s:clear_highlight(buffer, namespace) abort
  call nvim_buf_clear_namespace(a:buffer, a:namespace, 0, -1)
endfunction
