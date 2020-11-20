setlocal noexpandtab
setlocal tabstop=4 shiftwidth=4
setlocal listchars+=tab:\ \  " don't display tab characters in 'list' mode

compiler go

nnoremap <silent> <buffer> <leader>db <cmd>DlvToggleBreakpoint<cr>
nnoremap <silent> <buffer> <leader>dt <cmd>DlvToggleTracepoint<cr>
nnoremap <silent> <buffer> <leader>dd <cmd>DlvDebug<cr>
nnoremap <silent> <buffer> <leader>dc <cmd>DlvClearAll<cr>

nnoremap <silent> <buffer> t<C-d> <cmd>DlvTest<cr>

" Disable trailing space highlighting in LSP hover windows
highlight! link goSpaceError NONE

" Open the online documentation link for a symbol if there is one listed in
" the LSP hover window.
" This assumes that a LSP hover window is currently opened.
function! BrowseGoDocs() abort
  wincmd w
  if search('https://pkg.go.dev/')
    call browse#url()
  end
  wincmd w
endfunction
nnoremap <silent> <buffer> <leader>D <cmd>call BrowseGoDocs()<cr>
