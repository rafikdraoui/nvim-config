" Run ripgrep with the given arguments. If bang is used, then the search
" is based in the current working directory, otherwise it is based at the root
" of the git repository (if any).
"
" The query is added to vim's search history, after being transformed from
" ripgrep to vim regexp.
function! grep#run(bang, ...) abort
  if a:0 == 0
    echoerr 'Argument required'
    return
  endif

  if a:bang
    let path = '.'
  else
    let path = fnamemodify(git#repo_root(), ':p:~:.')
  endif

  let vim_query = call('grep#ripgrep_to_vimsearch', a:000)
  let @/ = vim_query
  call histadd('search', @/)

  execute join(['silent grep', join(a:000), path])
endfunction

" Convert a ripgrep query to a vim search regexp.
" The query is assumed to be the last of the given arguments. This isn't
" foolproof, but it handles the most common use cases (if not, `q/` is there
" to easily amend it once it gets saved to the search history).
function! grep#ripgrep_to_vimsearch(...) abort
  if a:0 == 0
    echoerr 'Argument required'
    return
  endif

  let query = a:000[-1]

  " trim quotes
  let first = query[0]
  let last = query[-1:-1]
  if first == last && (first == "'" || first == '"')
    let query = query[1:-2]
  endif

  " unescape \$
  let query = substitute(query, '\\\$', '$', '')

  " add word boundary markers if `-w` was passed
  if index(a:000, '-w') >= 0
    let query = '\<' . query . '\>'
  endif

  " replace word boundary marker
  let query = substitute(query, '^\\b', '\\<', '')
  let query = substitute(query, '\\b$', '\\>', '')

  " add case-sensitivity marker if `-s` was passed
  if index(a:000, '-s') >= 0
    let query = '\C' . query
  endif

  return query
endfunction
