setlocal shiftwidth<
nnoremap <buffer> <leader>wi :call wiki#build_index()<cr>

" Restore Dirvish mapping
unmap <buffer> -

inoremap <buffer> <tab> <c-t>
inoremap <buffer> <s-tab> <c-d>
