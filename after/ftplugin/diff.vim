setlocal foldmethod=expr
setlocal foldexpr=v:lua.require('rafik.folding').diff.foldexpr(v:lnum)
setlocal foldtext=v:lua.require('rafik.folding').diff.foldtext()
