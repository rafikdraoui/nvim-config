function! opfunc#sort(type) abort
  if a:type ==# 'V'
    execute "'<,'>sort"
  elseif a:type ==# 'v'
    normal! V
    execute "'<,'>sort"
    execute "normal! \<esc>"
  elseif a:type ==# 'line'
    execute "'[,']sort"
  endif
endfunction

function! opfunc#search(type) abort
  let regsave = @@

  if a:type =~? 'v'
    silent execute 'normal! gvy'
  elseif a:type ==# 'line'
    silent execute "normal! '[V']y"
  else
    silent execute 'normal! `[v`]y'
  endif

  call grep#run(0, @@)
  call histadd('cmd', 'Grep ' . @@)

  let @@ = regsave
endfunction
