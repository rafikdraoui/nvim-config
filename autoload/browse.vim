function! browse#url(...) abort
  if a:0 == 0
    let url = expand('<cfile>')
  else
    let url = a:1
  endif

  if url !~# '^https\?://'
    return
  end

  let open_cmd = has('mac') ? 'open' : 'xdg-open'
  call jobstart([open_cmd, url], {'detach': 1})
endfunction
