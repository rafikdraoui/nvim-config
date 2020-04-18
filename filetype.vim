augroup filetypedetect
  autocmd BufRead,BufNewFile .envrc setfiletype sh
  autocmd BufRead,BufNewFile poetry.lock setfiletype toml
augroup END
