" Override built-in Rust ftplugin to only set a few options

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

setlocal comments=s0:/*!,m:\ ,ex:*/,s1:/*,mb:*,ex:*/,:///,://!,://
setlocal commentstring=//\ %s

function s:IncludeExpr(fname) abort
  let mod = substitute(a:fname, '^crate::', '','g')
  return substitute(mod,'::','/','g')
endfunction
setlocal includeexpr=s:IncludeExpr(v:fname)
setlocal isfname+=:
setlocal suffixesadd=.rs

setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
