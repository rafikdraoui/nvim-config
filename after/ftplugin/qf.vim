" Display title or command of quickfix results in statusline, along with the
" number of items.
" e.g
" |[Quickfix List] rg --vimgrep packages                           4/35|
" |[Quickfix List] go build                                         1/1|
" |[Quickfix List] Language Server                                  1/4|
let &l:statusline = '%q %{exists("w:quickfix_title") ? w:quickfix_title : ""} %= %l/%L'
