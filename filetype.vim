augroup filetypedetect
  autocmd BufRead,BufNewFile .envrc setfiletype sh
  autocmd BufRead,BufNewFile *.toml,poetry.lock setfiletype toml
  autocmd BufRead,BufNewFile *.fish setfiletype fish
  autocmd BufRead,BufNewFile go.mod setfiletype gomod
augroup END
