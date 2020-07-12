" Buffers
nnoremap <silent> [b :bprevious <cr>
nnoremap <silent> ]b :bnext <cr>

" Argument list
nnoremap <silent> [a :previous <cr>
nnoremap <silent> ]a :next <cr>
nnoremap <silent> [A :first <cr>
nnoremap <silent> ]A :last <cr>

" Quickfix list
nnoremap <silent> [q :cprevious <cr>
nnoremap <silent> ]q :cnext <cr>
nnoremap <silent> [Q :cfirst <cr>
nnoremap <silent> ]Q :clast <cr>

" Location list
nnoremap <silent> [z :lprevious <cr>
nnoremap <silent> ]z :lnext <cr>
nnoremap <silent> [Z :lfirst <cr>
nnoremap <silent> ]Z :llast <cr>

" Tag matchlist
nnoremap <silent> [t :tprevious <cr>
nnoremap <silent> ]t :tnext <cr>
nnoremap <silent> [T :tfirst <cr>
nnoremap <silent> ]T :tlast <cr>

" Git conflicts markers
nnoremap <silent> [c :call git#next_conflict(1)<cr>
nnoremap <silent> ]c :call git#next_conflict(0)<cr>
