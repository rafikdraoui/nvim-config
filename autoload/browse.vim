function! browse#url() abort
  let url = expand('<cfile>')
  if url !~# '^https\?://'
    return
  end

  let open_cmd = has('mac') ? 'open' : 'xdg-open'
  call jobstart([open_cmd, url], {'detach': 1})
endfunction
