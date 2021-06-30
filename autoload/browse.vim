function! browse#url(...) abort
  if a:0 == 0
    " include `@` character in URLs
    let isf_save = &isfname
    set isfname+=@-@
    let url = expand('<cfile>')
    let &isfname = isf_save
  else
    let url = a:1
  endif

  if url !~# '^https\?://'
    return
  end

  let open_cmd = has('mac') ? 'open' : 'xdg-open'
  call jobstart([open_cmd, url], {'detach': 1})
endfunction
