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


function! GoDoc(...) abort
  if a:0 == 0
    let package = expand('<cfile>')
  else
    let package = a:1
  endif

  let url = 'https://pkg.go.dev/' . package
  if a:0 > 1
    let url .= '#' . a:2
  endif
  call browse#url(url)
endfunction
command -nargs=* GoDoc call GoDoc(<f-args>)
nnoremap <silent> <buffer> <leader>k <cmd>GoDoc<cr>


" Open the online documentation link for a symbol if there is one listed in
" the LSP hover window.
" This assumes that a LSP hover window is currently opened.
function! GoDocFromLSPHover() abort
  wincmd w
  if search('https://pkg.go.dev/')
    call browse#url()
  end
  wincmd w
endfunction
nnoremap <silent> <buffer> <leader>D <cmd>call GoDocFromLSPHover()<cr>


iabbrev <buffer> testf! func TestF(t *testing.T) {<cr>// TODO<cr>}

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
t.Errorf("mismatch (-want +got):\n%s", diff)
}]]
.
iabbrev <buffer> tcmp! <c-r>=b:tcmp<cr>
