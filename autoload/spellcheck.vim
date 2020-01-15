function! spellcheck#toggle() abort
  setlocal spell!
  call lightline#update()
endfunction

function! spellcheck#switch() abort
  let lang = &spelllang ==? 'en' ? 'fr' : 'en'
  execute 'setlocal spelllang=' . lang
  call lightline#update()
endfunction
