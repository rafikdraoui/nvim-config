function! s:BrowseCommit() abort
  normal! gg0
  call search('\x\{6,\}')
  normal! yiW
  silent execute 'GBrowse ' . @@
endfunction

nnoremap <buffer> <silent> go <cmd>call <sid>BrowseCommit()<cr>
