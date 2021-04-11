" Display title or command of quickfix results in statusline, along with the
" number of items.
" e.g
" |[Quickfix List] rg --vimgrep packages                           4/35|
" |[Quickfix List] go build                                         1/1|
" |[Quickfix List] Language Server                                  1/4|
let &l:statusline = '%t '
let &l:statusline .= '%{exists("w:quickfix_title") ? fnamemodify(w:quickfix_title, ":~:.") : ""} '
let &l:statusline .= '%= %l/%L'

let s:filename_pat = '^[^|]*'

function! s:is_concealed_match(idx, match)
   return a:match['group'] ==# 'Conceal' && a:match['pattern'] ==# s:filename_pat
endfunction

function! s:add_conceal_match()
  if exists('b:qf_isLoc') && b:qf_isLoc == 1
        \ && empty(filter(getmatches(), function('s:is_concealed_match')))
    call matchadd('Conceal', s:filename_pat, 10, -1, {'conceal': ''})
  end
endfunction

function s:toggle_filename_conceal()
  if &l:conceallevel > 0
    setlocal conceallevel& concealcursor&
  else
    setlocal conceallevel=2 concealcursor=nc
  endif
endfunction

autocmd vimrc BufWinEnter quickfix call s:add_conceal_match()
nnoremap <buffer> <silent> <leader><space> :call <sid>toggle_filename_conceal()<cr>

" from vim-qf plugin
nmap <buffer> <left> <plug>(qf_older)
nmap <buffer> <right> <plug>(qf_newer)
nmap <buffer> { <plug>(qf_previous_file)
nmap <buffer> } <plug>(qf_next_file)
