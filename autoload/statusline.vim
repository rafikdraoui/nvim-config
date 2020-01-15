function! statusline#filename() abort
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let readonly = &readonly ? '🔒 ' : ''
  let modified = &modified ? ' *' : ''
  return readonly . filename . modified
endfunction

function! statusline#spell() abort
  return &spell ? 'spell[' . &spelllang . ']' : ''
endfunction

function! statusline#git() abort
  let branch = ''
  if exists('*fugitive#head')
    let branch_name = fugitive#head(6)
    let branch = empty(branch_name) ? '' : '⌥ '. branch_name
  endif

  let stats = ''
  if exists('*sy#repo#get_stats_decorated')
    let stats = tr(sy#repo#get_stats_decorated(), '~', '•')
  endif

  return branch . stats
endfunction
