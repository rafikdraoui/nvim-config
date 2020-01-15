" ALE fixer for `fish` files
function! autofix#fish(buffer, content)
  return {
  \ 'command': 'fish_indent -w %t',
  \ 'read_temporary_file': 1,
  \ 'suggested_filetypes': ['fish']
  \ }
endfunction
