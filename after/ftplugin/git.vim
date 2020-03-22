setlocal foldmethod=syntax

if !exists('*fugitive#Foldtext')
  runtime autoload/fugitive.vim
endif
if exists('*fugitive#Foldtext')
  setlocal foldtext=fugitive#Foldtext()
endif
