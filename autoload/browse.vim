function! browse#url() abort
  let url = expand('<cfile>')
  if url !~# '^https\?://'
    return
  end

  let open_cmd = has('mac') ? 'open' : 'xdg-open'
  call system([open_cmd, url])
endfunction
