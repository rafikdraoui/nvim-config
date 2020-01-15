" Just like the default `flake8` ale linter, but `cd` to the root of the repo
" before running.
function! ale_linters#python#cdroot_flake8#command(buffer) abort
  let project_root = ale#python#FindProjectRoot(a:buffer)
  let cd_string = project_root isnot# ''
  \   ? ale#path#CdString(project_root)
  \   : ale#path#BufferCdString(a:buffer)
  let orig_cmd = ale_linters#python#flake8#GetCommand(a:buffer, [3,0,0])

  let cmd =  cd_string . orig_cmd

  return cmd
endfunction

call ale#linter#Define('python', {
\ 'name': 'cdroot_flake8',
\ 'executable': function('ale_linters#python#flake8#GetExecutable'),
\ 'command': function('ale_linters#python#cdroot_flake8#command'),
\ 'callback': 'ale_linters#python#flake8#Handle',
\})
