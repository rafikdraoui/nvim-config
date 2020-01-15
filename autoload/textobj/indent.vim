" Inspired by https://vimways.org/2018/transactions-pending/

" Select all text in current indentation level
"
" the current implementation is pretty fast, since it uses "search()" with
" "\%v" to find the unindented levels.
"
" NOTE: if the current level of indentation is 1 (ie in virtual column 1),
"       then the entire buffer will be selected.

" excludes emtpy lines that precede or follow the current indentation level
function! textobj#indent#in() abort
  " magic is needed for this (/\v doesn't seem to work)
  let magic = &magic
  set magic

  " move to beginning of line and get virtcol (current indentation level)
  normal! ^
  let vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')

  " pattern matching anything except empty lines and lines with recorded
  " indentation level
  let pat = '^\(\s*\%'.vCol.'v\|^$\)\@!'

  " find first match (backwards & don't wrap or move cursor)
  let start = search(pat, 'bWn') + 1

  " next, find first match (forwards & don't wrap or move cursor)
  let end = search(pat, 'Wn')

  if (end !=# 0)
    " if search succeeded, it went too far, so subtract 1
    let end -= 1
  endif

  " go to start (this includes empty lines) and, importantly, column 0
  execute 'normal! '.start.'G0'

  " skip empty lines (unless already on one, need to be in column 0)
  call search('^[^\n\r]', 'Wc')

  " go to end (this includes empty lines)
  execute 'normal! Vo'.end.'G'

  " skip backwards to last selected non-empty line
  call search('^[^\n\r]', 'bWc')

  " select to end-of-line, and put cursor at beginning of selection
  normal! $o

  " restore magic
  let &magic = magic
endfunction

" includes emtpy lines that precede or follow the current indentation level
function! textobj#indent#around() abort

  " magic is needed for this (/\v doesn't seem to work)
  let magic = &magic
  set magic

  " move to beginning of line and get virtcol (current indentation level)
  normal! ^
  let vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')

  " pattern matching anything except empty lines and lines with recorded
  " indentation level
  let pat = '^\(\s*\%'.vCol.'v\|^$\)\@!'

  " find first match (backwards & don't wrap or move cursor)
  let start = search(pat, 'bWn') + 1

  " NOTE: if start is 0, then search() failed; otherwise search() succeeded
  "       and start does not equal line('.')
  " FORMER: start is 0; so, if we add 1 to start, then it will match
  "         everything from beginning of the buffer since this will be the
  "         equivalent of "norm! 1G" below
  " LATTER: start is not 0 but is also not equal to line('.'); therefore,
  "         we want to add one to start since it will always match one
  "         line too high if search() succeeds

  " next, find first match (forwards & don't wrap or move cursor)
  let end = search(pat, 'Wn')

  " NOTE: if end is 0, then search() failed; otherwise, if end is not
  "       equal to line('.'), then the search succeeded.
  " FORMER: end is 0; we want this to match until the end-of-buffer if it
  "         fails to find a match for same reason as mentioned above;
  "         therefore, keep 0. See "NOTE:" below inside the if block comment
  " LATTER: end is not 0, so the search() must have succeeded, which means
  "         that end will match a different line than line('.')

  if (end !=# 0)
    " if end is 0, then the search() failed; if we subtract 1, then it
    " will effectively do "norm! -1G" which is definitely not what is
    " desired for probably every circumstance; therefore, only subtract one
    " if the search() succeeded since this means that it will match at least
    " one line too far down
    " NOTE: exec "norm! 0G" still goes to end-of-buffer just like "norm! G",
    "       so it's ok if end is kept as 0.
    let end -= 1
  endif

  " finally, select from start to end
  execute 'normal! '.start.'G0V'.end.'G$o'

  " restore magic
  let &magic = magic
endfunction
