setlocal shiftwidth<
setlocal nowrap
nnoremap <buffer> <leader>wi :call wiki#build_index()<cr>

" Restore dirbuf mapping
silent! unmap <buffer> -

inoremap <buffer> <tab> <c-t>
inoremap <buffer> <s-tab> <c-d>
