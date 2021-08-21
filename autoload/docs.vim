function! s:Doc(url_pattern, get_fragment_fn, args) abort
  if len(a:args) == 0
    let package = expand('<cfile>')
  else
    let package = a:args[0]
  endif
  let url = printf(a:url_pattern, package)

  if len(a:args) > 1
    let url .=  a:get_fragment_fn(a:args)
  endif
  call browse#url(url)
endfunction

function! docs#golang(...) abort
  let url_pattern = 'https://pkg.go.dev/%s'
  let GetFragmentFn = {args -> printf('#%s', args[1])}
  call s:Doc(url_pattern, GetFragmentFn, a:000)
endfunction

function! docs#python(...) abort
  let url_pattern = 'https://docs.python.org/3/library/%s.html'
  let GetFragmentFn = {args -> printf('#%s.%s', args[0], args[1])}
  call s:Doc(url_pattern, GetFragmentFn, a:000)
endfunction
