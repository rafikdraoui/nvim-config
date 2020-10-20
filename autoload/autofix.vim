" ALE fixer for `fish` files
function! autofix#fish(buffer, content)
  return {
  \ 'command': 'fish_indent -w %t',
  \ 'read_temporary_file': 1,
  \ 'suggested_filetypes': ['fish']
  \ }
endfunction

function! autofix#toggle() abort
  if exists('b:ale_fix_on_save')
    let b:ale_fix_on_save = !b:ale_fix_on_save
    let b:ale_fix_on_save
  else
    let g:ale_fix_on_save = !g:ale_fix_on_save
    let g:ale_fix_on_save
  endif
endfunction
