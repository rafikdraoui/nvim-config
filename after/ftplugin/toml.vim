" Custom fold text for table arrays.
" For example, the fold text for the following table array:
"
"     [[package]]
"     name = hello
"     version = 1.2.3
"
" will be: 'package: hello'
function TableArrayFoldText()
  let lines = getline(v:foldstart, v:foldend)
  let header = trim(get(lines, 0), '[]')

  " use the `name` key as the label for the folded section
  let idx = match(lines, '^name =')
  if idx == -1
    let label = '<unknown>'
  else
    let label = substitute(get(lines, idx), 'name = ', '', '')
    let label = trim(label, '"')
  endif

  return header . ': ' . label
endfunction

setlocal foldmethod=syntax
setlocal foldtext=TableArrayFoldText()
