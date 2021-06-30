" this is the value used by `fish_indent`
setlocal shiftwidth=4

" Don't run fixer when editing interactive command
if bufname() =~# '/tmp/.*\.fish'
  let b:ale_fix_on_save = 0
endif
