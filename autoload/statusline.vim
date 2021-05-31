" Set custom highlights for status line, using `hl-User{N}` for better
" interaction with StatusLineNC.
"
" `User1` is used to highlight the filename, and is set to be the same as
" StatusLine, but with the addition of the bold attribute.
"
" `User2` is used to highlight the linting status, and is set to be the same
" as StatusLine, but with reversed foreground and background, and the addition
" of the bold attribute.
function! statusline#set_highlights() abort
  let hl = hlID('StatusLine')
  let fg = synIDattr(hl, 'fg', 'gui')
  let bg = synIDattr(hl, 'bg', 'gui')

  let attrs= 'guifg='.fg.' guibg='.bg.' gui=bold'
  if synIDattr(hl, 'reverse')
    execute 'highlight User1 '.attrs.',reverse'
    execute 'highlight User2 '.attrs
  else
    execute 'highlight User1 '.attrs
    execute 'highlight User2 '.attrs.',reverse'
  endif
endfunction
