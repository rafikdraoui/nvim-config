setlocal noexpandtab
setlocal tabstop=4 shiftwidth=4
setlocal listchars+=tab:\ \  " don't display tab characters in 'list' mode

compiler go

nnoremap <silent> <buffer> <leader>k <cmd>GoDoc<cr>

" Open the online documentation link for a symbol if there is one listed in
" the LSP hover window.
function! GoDocFromLSPHover() abort

  " Open LSP hover window, or move cursor to it if already open
  lua vim.lsp.buf.hover()

  " Move cursor to hover window, in case it wasn't opened already
  lua vim.lsp.buf.hover()

  " Wait for 50ms to make sure that the async LSP request has time to complete
  sleep 50m

  if search('\[`.*` on pkg.go.dev\](\zshttps://pkg.go.dev/.*\ze)')
    lua require("rafik.browse").url()
  end

  " Close hover window
  close

endfunction
nnoremap <silent> <buffer> <leader>D <cmd>call GoDocFromLSPHover()<cr>
