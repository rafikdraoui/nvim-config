function! git#browse_hash() abort
  normal! gg0
  call search('\x\{6,\}')
  normal! yiW
  execute 'GBrowse ' . @@
endfunction

function! git#repo_root() abort
  let git_dir = ''
  if exists('*FugitiveExtractGitDir')
    let git_dir = FugitiveExtractGitDir(expand('%:p:h'))
  endif
  return empty(git_dir) ? '' : fnamemodify(git_dir, ':h')
endfunction

function! git#cd_root() abort
  let root = git#repo_root()
  if !empty(root)
    execute 'cd ' . root
  endif
endfunction

function! git#statusline() abort
  if empty(get(b:, 'gitsigns_status_dict', {}))
    return ''
  endif

  let branch = printf('[⌥ %s]', b:gitsigns_head)

  let stats = tr(b:gitsigns_status, '~', '•')
  if !empty(stats)
    let stats = printf('[%s]', stats)
  endif

  return branch . stats
endfunction

function! git#jump(...) abort
  if v:count > 0
    if v:count == 1
      let cmd = 'diff'
    elseif v:count == 2
      let cmd = 'diff --cached'
    elseif v:count == 3
      let cmd = 'merge'
    else
      echohl WarningMsg | echo 'Invalid count for :Jump' | echohl None
      return
    endif
  else
    if a:0 == 0
      let cmd = 'diff'
    elseif a:1 ==? 'staged'
      let cmd = 'diff --cached'
    else
      let cmd = join(a:000)
    endif
  endif
  cexpr system('git jump ' . cmd)
endfunction
