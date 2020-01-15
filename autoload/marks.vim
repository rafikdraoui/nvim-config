" vim-signature isn't loaded by default, since it adds too much latency to the
" loading time of neovim (given that it is rarely used)
function! marks#toggle() abort
  if !exists('b:sig_enabled')
    packadd vim-signature
    let b:sig_enabled = 0
  endif
  SignatureToggleSigns
endfunction
