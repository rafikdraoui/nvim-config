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
