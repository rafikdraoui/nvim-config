function! pack#init() abort
  packadd minpac

  let packpath = stdpath('data') . '/site'

  if !exists('*minpac#init')
    if input('Missing `minpac` package manager. Install `minpac` (y/N)? ') ==? 'y'
      let minpac_repo_path = packpath . '/pack/minpac/opt/minpac'
      call system('git clone https://github.com/k-takata/minpac.git ' . minpac_repo_path)
      packadd minpac
    else
      throw '`minpac` is not installed'
    endif
  endif

  call minpac#init({'dir': packpath })
  execute 'source ' . stdpath('config') . '/plugins.vim'
endfunction
