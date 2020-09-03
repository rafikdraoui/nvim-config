" Generate index of all files within the directory of the index file
function! wiki#build_index() abort
  if expand('%:p:t') !=? 'index.md'
    return
  endif

  let relative_file_dir = substitute(expand('%:p:h'), expand('$NOTES_DIR') , '', '')
  if !empty(relative_file_dir)
    let pattern = trim(relative_file_dir, '/') . '/*'
    1put='# Generated Links'
    execute 'VimwikiGenerateLinks ' . pattern
    silent g/^# Generated Links$/d
    silent g/^- \[.*\](index)$/d
  endif
endfunction
