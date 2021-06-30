function! scratch#create(lines) abort
  tabnew
  setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
  nnoremap <buffer> <silent> gq :quit<cr>
  call setline(1, a:lines)
endfunction

" Redirect output of a command to a scratch buffer.
" Useful when there is a lot of output, and the vim pager gets in the way.
" Eg: `Redir map <leader>`, `Redir !ls -l`
" Inspired by https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! scratch#redir(cmd) abort
  let output = execute(a:cmd)
  call scratch#create(split(output, "\n"))
endfunction
