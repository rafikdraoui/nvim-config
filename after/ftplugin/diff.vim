setlocal foldmethod=expr
setlocal foldexpr=DiffFoldExpr(v:lnum)
setlocal foldtext=DiffFoldText()

function! DiffFoldExpr(lnum) abort
  if getline(a:lnum) =~# '^#'
    " git commit preamble: do not fold
    return 0
  endif

  if getline(a:lnum) =~# '^diff --git'
    " start of new a file diff: start a new fold
    return '>1'
  else
    " in a file diff: keep fold level
    return 1
  endif
endfunction

function! DiffFoldText() abort
  let first_line = getline(v:foldstart)
  if first_line !~# '^diff --git'
    return foldtext()
  endif

  let prefix = '+' .. v:folddashes

  " first_line should be of the form:
  "     diff --git a/path/to/file b/path/to/file
  " from which we want to extract `path/to/file`
  try
    let filename = split(first_line)[-1][2:]
  catch
    return '!!! foldtext error !!! ' . foldtext()
  endtry

  let [add, remove] = [-1, -1]
  for lnum in range(v:foldstart+1, v:foldend)
    let line = getline(lnum)

    if line =~# '^Binary'
      return printf('%s %s (binary)', prefix, filename)
    endif

    if line =~# '^+'
      let add += 1
    elseif line =~# '^-'
      let remove += 1
    endif
  endfor
  return printf('%s %s: +%d -%d', prefix, filename, add, remove)
endfunction
