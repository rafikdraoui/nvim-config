setlocal noexpandtab
setlocal tabstop=4 shiftwidth=4
setlocal listchars+=tab:\ \  " don't display tab characters in 'list' mode

compiler go

nnoremap <silent> <buffer> <leader>db <cmd>DlvToggleBreakpoint<cr>
nnoremap <silent> <buffer> <leader>dt <cmd>DlvToggleTracepoint<cr>
nnoremap <silent> <buffer> <leader>dd <cmd>DlvDebug<cr>
nnoremap <silent> <buffer> <leader>dc <cmd>DlvClearAll<cr>

nnoremap <silent> <buffer> t<C-d> <cmd>DlvTestCurrent<cr>

nnoremap <silent> <buffer> <leader>k <cmd>GoDoc<cr>

" Open the online documentation link for a symbol if there is one listed in
" the LSP hover window.
" This assumes that a LSP hover window is currently opened.
function! GoDocFromLSPHover() abort
  wincmd w
  if search('https://pkg.go.dev/')
    lua require("lib/browse").url()
  end
  wincmd w
endfunction
nnoremap <silent> <buffer> <leader>D <cmd>call GoDocFromLSPHover()<cr>

function! GoplsFormat() abort
  if get(g:, 'enable_formatting', v:false)
    lua vim.lsp.buf.format()
  endif
endfunction
augroup goformat
  autocmd! * <buffer>
augroup END
autocmd goformat BufWritePre <buffer> call GoplsFormat()

iabbrev <buffer> testf! func TestF(t *testing.T) {<cr>// TODO<cr>}

iabbrev <buffer> fmt! fmt.Printf("%+v\n", _)

lua <<
vim.b.testt = [[
testCases := []struct {
name string
}{
{
name: "NAME",
},
}

for _, tc := range testCases {
t.Run(tc.name, func(t *testing.T) {
// TODO
})
}]]
.
iabbrev <buffer> testt! <c-r>=b:testt<cr>

lua <<
vim.b.tcmp = [[
if diff := cmp.Diff(want, got); diff != "" {
t.Fatalf("mismatch (-want +got):\n%s", diff)
}]]
.
iabbrev <buffer> tcmp! <c-r>=b:tcmp<cr>
