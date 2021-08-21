augroup filetypedetect
  autocmd BufRead,BufNewFile .envrc setfiletype sh
  autocmd BufRead,BufNewFile poetry.lock setfiletype toml
  autocmd BufRead,BufNewFile $NOTES_DIR/*.md setfiletype vimwiki
augroup END
