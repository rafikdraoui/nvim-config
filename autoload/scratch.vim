function! scratch#create(lines) abort
  tabnew
  setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
  nnoremap <buffer> <silent> q :quit<cr>
  call setline(1, a:lines)
endfunction

" Redirect output of a command to a scratch buffer.
" Useful when there is a lot of output, and the vim pager gets in the way.
" Eg: `Redir map <leader>`, `Redis !ls -l`
" Inspired by https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! scratch#redir(cmd) abort
  let output = execute(a:cmd)
  call scratch#create(split(output, "\n"))
endfunction

function! scratch#edit_register(reg) abort
  if len(a:reg) != 1
    echom 'Invalid register: ' . a:reg
    return
  end
  let g:reg_to_edit = a:reg
  call scratch#redir('echo @' . a:reg)
  augroup scratch_register
    autocmd!
    autocmd QuitPre <buffer> call <sid>write_back_to_register()
  augroup END
endfunction

function! s:write_back_to_register() abort
  let reg = g:reg_to_edit
  call whitespace#trim()
  execute 'silent %yank ' . reg
  echo 'Scratch buffer copied to register ' . reg
  unlet g:reg_to_edit
endfunction
