function! git#browse_hash() abort
  normal! gg0
  call search('\x\{6,\}')
  normal! yiW
  execute 'Gbrowse ' . @@
endfunction

function! git#next_conflict(direction) abort
  " direction = 0 -> forward, direction = 1 -> backward
  let flags = a:direction == 1 ? 'Wb' : 'W'
  let pattern = '<<<<<<<\_.\{-\}\zs=======\ze\_.\{-\}>>>>>>>'
  call search(pattern, flags)
endfunction

function! git#repo_root() abort
  let git_dir = fugitive#extract_git_dir(expand('%:p:h'))
  return empty(git_dir) ? '' : fnamemodify(git_dir, ':h')
endfunction
